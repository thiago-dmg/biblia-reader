namespace BibliaReader.Application.Bible;

/// <summary>Provedor externo de texto bíblico (troca de implementação sem alterar controllers).</summary>
public interface IBibleTextProvider
{
    Task<IReadOnlyList<BibleVersionInfo>> GetVersionsAsync(CancellationToken cancellationToken = default);

    Task<IReadOnlyList<BibleBookInfo>> GetBooksAsync(string versionCode, CancellationToken cancellationToken = default);

    Task<BibleChapterPayload?> GetChapterAsync(
        string versionCode,
        string bookAbbrevUpper,
        int chapterNumber,
        CancellationToken cancellationToken = default);

    Task<BibleVersePayload?> GetVerseAsync(
        string versionCode,
        string bookAbbrevUpper,
        int chapterNumber,
        int verseNumber,
        CancellationToken cancellationToken = default);
}
