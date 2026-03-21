using System.Net;
using System.Net.Http.Headers;
using System.Text.Json;
using BibliaReader.Application.Bible;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace BibliaReader.Infrastructure.Bible;

/// <summary>Integração com a API pública ABíblia Digital (versões acf, nvi, etc.).</summary>
public sealed class AbibliadigitalBibleTextProvider : IBibleTextProvider
{
    public const string HttpClientName = "ExternalBible";

    /// <summary>Id estável para a versão ACF (não persiste em banco).</summary>
    public static readonly Guid AcfStableId = Guid.Parse("a0000000-0000-4000-8000-000000000acf");

    private readonly IHttpClientFactory _httpFactory;
    private readonly IOptions<ExternalBibleOptions> _options;
    private readonly ILogger<AbibliadigitalBibleTextProvider> _logger;

    public AbibliadigitalBibleTextProvider(
        IHttpClientFactory httpFactory,
        IOptions<ExternalBibleOptions> options,
        ILogger<AbibliadigitalBibleTextProvider> logger)
    {
        _httpFactory = httpFactory;
        _options = options;
        _logger = logger;
    }

    public Task<IReadOnlyList<BibleVersionInfo>> GetVersionsAsync(CancellationToken cancellationToken = default)
    {
        IReadOnlyList<BibleVersionInfo> list =
        [
            new BibleVersionInfo(AcfStableId, "acf", "Almeida Corrigida Fiel (ACF)"),
        ];
        return Task.FromResult(list);
    }

    public Task<IReadOnlyList<BibleBookInfo>> GetBooksAsync(string versionCode, CancellationToken cancellationToken = default)
    {
        _ = versionCode;
        var books = BibleCanonCatalog.All.Select(e => new BibleBookInfo(
            e.Abbreviation,
            e.Abbreviation,
            e.Name,
            e.Chapters,
            e.Order)).ToList();
        return Task.FromResult<IReadOnlyList<BibleBookInfo>>(books);
    }

    public async Task<BibleChapterPayload?> GetChapterAsync(
        string versionCode,
        string bookAbbrevUpper,
        int chapterNumber,
        CancellationToken cancellationToken = default)
    {
        var book = BibleCanonCatalog.FindByAbbrev(bookAbbrevUpper);
        if (book == null)
            return null;
        if (chapterNumber < 1 || chapterNumber > book.Chapters)
            return null;

        var slug = BibleAbbrevMapper.ToExternalSlug(book.Abbreviation);
        if (slug == null)
            return null;

        var vc = string.IsNullOrWhiteSpace(versionCode)
            ? _options.Value.DefaultVersionCode
            : versionCode.Trim().ToLowerInvariant();

        var client = _httpFactory.CreateClient(HttpClientName);
        var path = $"api/verses/{Uri.EscapeDataString(vc)}/{Uri.EscapeDataString(slug)}/{chapterNumber}";
        using var req = new HttpRequestMessage(HttpMethod.Get, path);
        req.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        if (!string.IsNullOrWhiteSpace(_options.Value.ApiToken))
            req.Headers.TryAddWithoutValidation("Authorization", $"Bearer {_options.Value.ApiToken}");

        HttpResponseMessage res;
        try
        {
            res = await client.SendAsync(req, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Falha HTTP ao buscar capítulo {Book} {Chapter}", bookAbbrevUpper, chapterNumber);
            throw;
        }

        if (res.StatusCode == HttpStatusCode.NotFound)
            return null;
        if (!res.IsSuccessStatusCode)
        {
            var body = await res.Content.ReadAsStringAsync(cancellationToken);
            _logger.LogWarning("API externa retornou {Code}: {Body}", (int)res.StatusCode, body);
            throw new HttpRequestException($"API externa: {(int)res.StatusCode}");
        }

        var json = await res.Content.ReadAsStringAsync(cancellationToken);
        using var doc = JsonDocument.Parse(json);
        var root = doc.RootElement;

        var verses = ParseVerses(root);
        if (verses.Count == 0)
            return null;

        var bookName = TryReadBookName(root) ?? book.Name;
        var versionName = vc == "acf" ? "Almeida Corrigida Fiel (ACF)" : vc.ToUpperInvariant();

        var stableId = vc == "acf" ? AcfStableId : Guid.NewGuid();

        return new BibleChapterPayload(
            vc,
            versionName,
            stableId,
            book.Abbreviation,
            bookName,
            chapterNumber,
            verses);
    }

    public async Task<BibleVersePayload?> GetVerseAsync(
        string versionCode,
        string bookAbbrevUpper,
        int chapterNumber,
        int verseNumber,
        CancellationToken cancellationToken = default)
    {
        var ch = await GetChapterAsync(versionCode, bookAbbrevUpper, chapterNumber, cancellationToken);
        if (ch == null)
            return null;
        return ch.Verses.FirstOrDefault(v => v.Number == verseNumber);
    }

    private static string? TryReadBookName(JsonElement root)
    {
        if (!root.TryGetProperty("book", out var bookEl))
            return null;
        if (bookEl.ValueKind == JsonValueKind.String)
            return bookEl.GetString();
        if (bookEl.TryGetProperty("name", out var name))
            return name.GetString();
        return null;
    }

    private static List<BibleVersePayload> ParseVerses(JsonElement root)
    {
        var list = new List<BibleVersePayload>();
        if (!root.TryGetProperty("verses", out var arr) || arr.ValueKind != JsonValueKind.Array)
            return list;

        foreach (var v in arr.EnumerateArray())
        {
            int num = 0;
            if (v.TryGetProperty("number", out var n))
                num = n.GetInt32();
            else if (v.TryGetProperty("verse", out var vv))
                num = vv.GetInt32();

            var text = "";
            if (v.TryGetProperty("text", out var t))
                text = t.GetString() ?? "";

            if (num > 0 && !string.IsNullOrWhiteSpace(text))
                list.Add(new BibleVersePayload(num, text.Trim()));
        }

        return list;
    }
}
