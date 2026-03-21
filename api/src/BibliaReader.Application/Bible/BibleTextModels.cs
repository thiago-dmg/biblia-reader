namespace BibliaReader.Application.Bible;

public sealed record BibleVersionInfo(Guid StableId, string Code, string Name);

public sealed record BibleBookInfo(
    string Id,
    string Abbreviation,
    string Name,
    int ChapterCount,
    int CanonicalOrder);

public sealed record BibleVersePayload(int Number, string Text);

public sealed record BibleChapterPayload(
    string VersionCode,
    string VersionName,
    Guid VersionStableId,
    string BookAbbreviation,
    string BookName,
    int ChapterNumber,
    IReadOnlyList<BibleVersePayload> Verses);
