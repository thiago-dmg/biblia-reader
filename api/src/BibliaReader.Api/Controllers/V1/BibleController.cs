using System.Net;
using System.Text;
using BibliaReader.Application.Bible;
using BibliaReader.Infrastructure.Bible;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;

namespace BibliaReader.Api.Controllers.V1;

[ApiController]
[AllowAnonymous]
[Route("v1/bible")]
public sealed class BibleController : ControllerBase
{
    private readonly IBibleTextProvider _bible;
    private readonly IMemoryCache _cache;
    private readonly ExternalBibleOptions _opt;

    public BibleController(
        IBibleTextProvider bible,
        IMemoryCache cache,
        IOptions<ExternalBibleOptions> options)
    {
        _bible = bible;
        _cache = cache;
        _opt = options.Value;
    }

    private TimeSpan CacheTtl => TimeSpan.FromMinutes(Math.Clamp(_opt.CacheDurationMinutes, 1, 10080));

    [HttpGet("versions")]
    public async Task<IActionResult> Versions(CancellationToken cancellationToken)
    {
        const string key = "bible:versions:v1";
        if (_cache.TryGetValue(key, out object? cached))
            return Ok(cached);

        var list = await _bible.GetVersionsAsync(cancellationToken);
        var payload = list.Select(v => new { id = v.StableId, code = v.Code, name = v.Name }).ToList();
        _cache.Set(key, payload, CacheTtl);
        return Ok(payload);
    }

    /// <summary>Livros da versão. Use <c>versionCode=acf</c> ou omita para o padrão em config.</summary>
    [HttpGet("books")]
    public async Task<IActionResult> Books(
        [FromQuery] string? versionCode,
        [FromQuery] Guid? versionId,
        CancellationToken cancellationToken)
    {
        var vc = ResolveVersionCode(versionCode, versionId);
        var key = $"bible:books:{vc}";
        if (_cache.TryGetValue(key, out object? cached))
            return Ok(cached);

        var books = await _bible.GetBooksAsync(vc, cancellationToken);
        var payload = books.Select(b => new
        {
            id = b.Id,
            abbreviation = b.Abbreviation,
            name = b.Name,
            chapterCount = b.ChapterCount,
            canonicalOrder = b.CanonicalOrder,
        }).ToList();
        _cache.Set(key, payload, CacheTtl);
        return Ok(payload);
    }

    /// <summary>Compatível com o app: query <c>bookAbbrev</c> + <c>number</c>.</summary>
    [HttpGet("chapters")]
    public Task<IActionResult> ChaptersLegacy(
        [FromQuery] string? versionCode,
        [FromQuery] Guid? versionId,
        [FromQuery] string bookAbbrev = "",
        [FromQuery] int number = 0,
        CancellationToken cancellationToken = default)
        => GetChapterCore(versionCode, versionId, bookAbbrev, number, cancellationToken);

    [HttpGet("books/{book}/chapters/{chapter:int}")]
    public Task<IActionResult> ChapterByPath(
        string book,
        int chapter,
        [FromQuery] string? versionCode,
        [FromQuery] Guid? versionId,
        CancellationToken cancellationToken)
        => GetChapterCore(versionCode, versionId, book, chapter, cancellationToken);

    [HttpGet("books/{book}/chapters/{chapter:int}/verses/{verse:int}")]
    public async Task<IActionResult> VerseByPath(
        string book,
        int chapter,
        int verse,
        [FromQuery] string? versionCode,
        [FromQuery] Guid? versionId,
        CancellationToken cancellationToken)
    {
        var vc = ResolveVersionCode(versionCode, versionId);
        var abbrev = NormalizeAbbrev(book);
        var key = $"bible:verse:{vc}:{abbrev}:{chapter}:{verse}";
        if (_cache.TryGetValue(key, out object? cached))
            return Ok(cached);

        BibleVersePayload? vPayload;
        try
        {
            vPayload = await _bible.GetVerseAsync(vc, abbrev, chapter, verse, cancellationToken);
        }
        catch (HttpRequestException)
        {
            return StatusCode(StatusCodes.Status502BadGateway,
                new { message = "Falha ao consultar a API externa de Bíblia." });
        }

        if (vPayload == null)
            return NotFound(new { message = "Versículo não encontrado." });

        var bookInfo = BibleCanonCatalog.FindByAbbrev(abbrev);
        var versions = await _bible.GetVersionsAsync(cancellationToken);
        var vin = versions.FirstOrDefault(x => x.Code.Equals(vc, StringComparison.OrdinalIgnoreCase));

        var response = new
        {
            versionCode = vc,
            versionName = vin?.Name ?? vc,
            versionId = vin?.StableId ?? AbibliadigitalBibleTextProvider.AcfStableId,
            bookAbbreviation = abbrev,
            bookName = bookInfo?.Name ?? abbrev,
            chapterNumber = chapter,
            verseNumber = vPayload.Number,
            text = vPayload.Text,
        };
        _cache.Set(key, response, CacheTtl);
        return Ok(response);
    }

    private async Task<IActionResult> GetChapterCore(
        string? versionCode,
        Guid? versionId,
        string bookAbbrev,
        int number,
        CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(bookAbbrev))
            return BadRequest(new { message = "Informe bookAbbrev (ex.: GEN)." });
        if (number < 1)
            return BadRequest(new { message = "number deve ser >= 1." });

        var vc = ResolveVersionCode(versionCode, versionId);
        var abbrev = NormalizeAbbrev(bookAbbrev);
        var key = $"bible:chapter:{vc}:{abbrev}:{number}";
        if (_cache.TryGetValue(key, out object? cached))
            return Ok(cached);

        BibleChapterPayload? payload;
        try
        {
            payload = await _bible.GetChapterAsync(vc, abbrev, number, cancellationToken);
        }
        catch (HttpRequestException)
        {
            return StatusCode(StatusCodes.Status502BadGateway,
                new { message = "Falha ao consultar a API externa de Bíblia." });
        }
        catch (Exception)
        {
            return StatusCode(StatusCodes.Status502BadGateway,
                new { message = "Erro ao obter capítulo." });
        }

        if (payload == null)
            return NotFound(new { message = "Capítulo não encontrado." });

        var contentHtml = BuildChapterHtml(payload);
        var response = new
        {
            versionId = payload.VersionStableId,
            versionCode = payload.VersionCode,
            versionName = payload.VersionName,
            bookId = payload.BookAbbreviation,
            bookAbbreviation = payload.BookAbbreviation,
            bookName = payload.BookName,
            chapterNumber = payload.ChapterNumber,
            contentHtml,
        };
        _cache.Set(key, response, CacheTtl);
        return Ok(response);
    }

    private static string BuildChapterHtml(BibleChapterPayload ch)
    {
        var sb = new StringBuilder();
        foreach (var v in ch.Verses.OrderBy(x => x.Number))
        {
            sb.Append("<p><sup>");
            sb.Append(v.Number);
            sb.Append("</sup> ");
            sb.Append(WebUtility.HtmlEncode(v.Text));
            sb.Append("</p>");
        }

        return sb.ToString();
    }

    private static string NormalizeAbbrev(string book) => book.Trim().ToUpperInvariant();

    private string ResolveVersionCode(string? versionCode, Guid? versionId)
    {
        if (!string.IsNullOrWhiteSpace(versionCode))
            return versionCode.Trim().ToLowerInvariant();
        if (versionId is { } gid && gid == AbibliadigitalBibleTextProvider.AcfStableId)
            return "acf";
        return _opt.DefaultVersionCode.Trim().ToLowerInvariant();
    }
}
