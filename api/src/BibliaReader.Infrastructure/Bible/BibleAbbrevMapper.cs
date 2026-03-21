namespace BibliaReader.Infrastructure.Bible;

/// <summary>Mapeia abreviações canônicas da API interna (GEN) para slugs da ABíblia Digital (gn).</summary>
internal static class BibleAbbrevMapper
{
    private static readonly IReadOnlyDictionary<string, string> CanonicalToExternal =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["GEN"] = "gn", ["EXO"] = "ex", ["LEV"] = "lv", ["NUM"] = "nm", ["DEU"] = "dt",
            ["JOS"] = "js", ["JDG"] = "jz", ["RUT"] = "rt", ["1SA"] = "1sm", ["2SA"] = "2sm",
            ["1KI"] = "1rs", ["2KI"] = "2rs", ["1CH"] = "1cr", ["2CH"] = "2cr", ["EZR"] = "ed",
            ["NEH"] = "ne", ["EST"] = "et", ["JOB"] = "jb", ["PSA"] = "sl", ["PRO"] = "pv",
            ["ECC"] = "ec", ["SNG"] = "ct", ["ISA"] = "is", ["JER"] = "jr", ["LAM"] = "lm",
            ["EZK"] = "ez", ["DAN"] = "dn", ["HOS"] = "os", ["JOE"] = "jl", ["AMO"] = "am",
            ["OBA"] = "ob", ["JON"] = "jn", ["MIC"] = "mq", ["NAM"] = "na", ["HAB"] = "hc",
            ["ZEP"] = "sf", ["HAG"] = "ag", ["ZEC"] = "zc", ["MAL"] = "ml", ["MAT"] = "mt",
            ["MRK"] = "mc", ["LUK"] = "lc", ["JHN"] = "jo", ["ACT"] = "at", ["ROM"] = "rm",
            ["1CO"] = "1co", ["2CO"] = "2co", ["GAL"] = "gl", ["EPH"] = "ef", ["PHP"] = "fp",
            ["COL"] = "cl", ["1TH"] = "1ts", ["2TH"] = "2ts", ["1TI"] = "1tm", ["2TI"] = "2tm",
            ["TIT"] = "tt", ["PHM"] = "fm", ["HEB"] = "hb", ["JAS"] = "tg", ["1PE"] = "1pe",
            ["2PE"] = "2pe", ["1JN"] = "1jo", ["2JN"] = "2jo", ["3JN"] = "3jo", ["JUD"] = "jd",
            ["REV"] = "ap",
        };

    public static string? ToExternalSlug(string bookAbbrevUpper)
    {
        var k = bookAbbrevUpper.Trim().ToUpperInvariant();
        return CanonicalToExternal.TryGetValue(k, out var slug) ? slug : null;
    }
}
