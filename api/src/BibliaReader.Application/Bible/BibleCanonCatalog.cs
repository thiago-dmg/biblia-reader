namespace BibliaReader.Application.Bible;

/// <summary>66 livros — ordem protestante; usado para metadados sem persistir texto em banco.</summary>
public static class BibleCanonCatalog
{
    public sealed record Entry(string Abbreviation, string Name, int Chapters, int Order);

    public static readonly IReadOnlyList<Entry> All =
    [
        new("GEN", "Gênesis", 50, 1),
        new("EXO", "Êxodo", 40, 2),
        new("LEV", "Levítico", 27, 3),
        new("NUM", "Números", 36, 4),
        new("DEU", "Deuteronômio", 34, 5),
        new("JOS", "Josué", 24, 6),
        new("JDG", "Juízes", 21, 7),
        new("RUT", "Rute", 4, 8),
        new("1SA", "1 Samuel", 31, 9),
        new("2SA", "2 Samuel", 24, 10),
        new("1KI", "1 Reis", 22, 11),
        new("2KI", "2 Reis", 25, 12),
        new("1CH", "1 Crônicas", 29, 13),
        new("2CH", "2 Crônicas", 36, 14),
        new("EZR", "Esdras", 10, 15),
        new("NEH", "Neemias", 13, 16),
        new("EST", "Ester", 10, 17),
        new("JOB", "Jó", 42, 18),
        new("PSA", "Salmos", 150, 19),
        new("PRO", "Provérbios", 31, 20),
        new("ECC", "Eclesiastes", 12, 21),
        new("SNG", "Cânticos", 8, 22),
        new("ISA", "Isaías", 66, 23),
        new("JER", "Jeremias", 52, 24),
        new("LAM", "Lamentações", 5, 25),
        new("EZK", "Ezequiel", 48, 26),
        new("DAN", "Daniel", 12, 27),
        new("HOS", "Oséias", 14, 28),
        new("JOE", "Joel", 3, 29),
        new("AMO", "Amós", 9, 30),
        new("OBA", "Obadias", 1, 31),
        new("JON", "Jonas", 4, 32),
        new("MIC", "Miquéias", 7, 33),
        new("NAM", "Naum", 3, 34),
        new("HAB", "Habacuque", 3, 35),
        new("ZEP", "Sofonias", 3, 36),
        new("HAG", "Ageu", 2, 37),
        new("ZEC", "Zacarias", 14, 38),
        new("MAL", "Malaquias", 4, 39),
        new("MAT", "Mateus", 28, 40),
        new("MRK", "Marcos", 16, 41),
        new("LUK", "Lucas", 24, 42),
        new("JHN", "João", 21, 43),
        new("ACT", "Atos", 28, 44),
        new("ROM", "Romanos", 16, 45),
        new("1CO", "1 Coríntios", 16, 46),
        new("2CO", "2 Coríntios", 13, 47),
        new("GAL", "Gálatas", 6, 48),
        new("EPH", "Efésios", 6, 49),
        new("PHP", "Filipenses", 4, 50),
        new("COL", "Colossenses", 4, 51),
        new("1TH", "1 Tessalonicenses", 5, 52),
        new("2TH", "2 Tessalonicenses", 3, 53),
        new("1TI", "1 Timóteo", 6, 54),
        new("2TI", "2 Timóteo", 4, 55),
        new("TIT", "Tito", 3, 56),
        new("PHM", "Filemom", 1, 57),
        new("HEB", "Hebreus", 13, 58),
        new("JAS", "Tiago", 5, 59),
        new("1PE", "1 Pedro", 5, 60),
        new("2PE", "2 Pedro", 3, 61),
        new("1JN", "1 João", 5, 62),
        new("2JN", "2 João", 1, 63),
        new("3JN", "3 João", 1, 64),
        new("JUD", "Judas", 1, 65),
        new("REV", "Apocalipse", 22, 66),
    ];

    public static Entry? FindByAbbrev(string abbrevUpper)
    {
        var a = abbrevUpper.Trim().ToUpperInvariant();
        foreach (var e in All)
        {
            if (e.Abbreviation.Equals(a, StringComparison.Ordinal))
                return e;
        }

        return null;
    }
}
