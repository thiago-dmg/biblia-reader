using BibliaReader.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace BibliaReader.Infrastructure.Persistence;

/// <summary>
/// Estrutura canônica protestante (66 livros) para a versão NVI.
/// O texto completo da NVI deve ser importado com licença (Biblica) em <see cref="BibleChapter.ContentHtml"/>.
/// </summary>
public static class NviBibleSeeder
{
    /// <summary>Id estável para o app usar como padrão.</summary>
    public static readonly Guid NviVersionId = Guid.Parse("e5f6a7b8-9c0d-4e1f-a2b3-c4d5e6f7a8b9");

    private static readonly (string Abbrev, string Name, int Chapters)[] ProtestantCanon =
    [
        ("GEN", "Gênesis", 50),
        ("EXO", "Êxodo", 40),
        ("LEV", "Levítico", 27),
        ("NUM", "Números", 36),
        ("DEU", "Deuteronômio", 34),
        ("JOS", "Josué", 24),
        ("JDG", "Juízes", 21),
        ("RUT", "Rute", 4),
        ("1SA", "1 Samuel", 31),
        ("2SA", "2 Samuel", 24),
        ("1KI", "1 Reis", 22),
        ("2KI", "2 Reis", 25),
        ("1CH", "1 Crônicas", 29),
        ("2CH", "2 Crônicas", 36),
        ("EZR", "Esdras", 10),
        ("NEH", "Neemias", 13),
        ("EST", "Ester", 10),
        ("JOB", "Jó", 42),
        ("PSA", "Salmos", 150),
        ("PRO", "Provérbios", 31),
        ("ECC", "Eclesiastes", 12),
        ("SNG", "Cânticos", 8),
        ("ISA", "Isaías", 66),
        ("JER", "Jeremias", 52),
        ("LAM", "Lamentações", 5),
        ("EZK", "Ezequiel", 48),
        ("DAN", "Daniel", 12),
        ("HOS", "Oséias", 14),
        ("JOE", "Joel", 3),
        ("AMO", "Amós", 9),
        ("OBA", "Obadias", 1),
        ("JON", "Jonas", 4),
        ("MIC", "Miquéias", 7),
        ("NAM", "Naum", 3),
        ("HAB", "Habacuque", 3),
        ("ZEP", "Sofonias", 3),
        ("HAG", "Ageu", 2),
        ("ZEC", "Zacarias", 14),
        ("MAL", "Malaquias", 4),
        ("MAT", "Mateus", 28),
        ("MRK", "Marcos", 16),
        ("LUK", "Lucas", 24),
        ("JHN", "João", 21),
        ("ACT", "Atos", 28),
        ("ROM", "Romanos", 16),
        ("1CO", "1 Coríntios", 16),
        ("2CO", "2 Coríntios", 13),
        ("GAL", "Gálatas", 6),
        ("EPH", "Efésios", 6),
        ("PHP", "Filipenses", 4),
        ("COL", "Colossenses", 4),
        ("1TH", "1 Tessalonicenses", 5),
        ("2TH", "2 Tessalonicenses", 3),
        ("1TI", "1 Timóteo", 6),
        ("2TI", "2 Timóteo", 4),
        ("TIT", "Tito", 3),
        ("PHM", "Filemom", 1),
        ("HEB", "Hebreus", 13),
        ("JAS", "Tiago", 5),
        ("1PE", "1 Pedro", 5),
        ("2PE", "2 Pedro", 3),
        ("1JN", "1 João", 5),
        ("2JN", "2 João", 1),
        ("3JN", "3 João", 1),
        ("JUD", "Judas", 1),
        ("REV", "Apocalipse", 22),
    ];

    private const string PlaceholderNotice =
        "<p><em>Texto NVI:</em> importe o conteúdo licenciado em <code>BibleChapters.ContentHtml</code> " +
        "(veja <code>docs/IMPORTAR_NVI.md</code>). Este capítulo serve para validar o fluxo app ↔ API.</p>";

    public static async Task EnsureSeedAsync(AppDbContext db, CancellationToken cancellationToken = default)
    {
        if (await db.BibleVersions.AsNoTracking().AnyAsync(v => v.Code == "nvi", cancellationToken))
            return;

        var now = DateTimeOffset.UtcNow;
        var version = new BibleVersion
        {
            Id = NviVersionId,
            Code = "nvi",
            Name = "Nova Versão Internacional (NVI)",
            CreatedAt = now
        };

        var order = 0;
        foreach (var (abbrev, name, chapterCount) in ProtestantCanon)
        {
            order++;
            var book = new BibleBook
            {
                Id = Guid.NewGuid(),
                BibleVersionId = version.Id,
                CanonicalOrder = order,
                Abbreviation = abbrev,
                Name = name,
                ChapterCount = chapterCount,
                CreatedAt = now
            };
            for (var n = 1; n <= chapterCount; n++)
            {
                book.Chapters.Add(new BibleChapter
                {
                    Id = Guid.NewGuid(),
                    Number = n,
                    ContentHtml = null,
                    CreatedAt = now
                });
            }

            version.Books.Add(book);
        }

        db.BibleVersions.Add(version);
        await db.SaveChangesAsync(cancellationToken);

        var gen = await db.BibleBooks.Include(b => b.Chapters)
            .FirstAsync(b => b.BibleVersionId == NviVersionId && b.Abbreviation == "GEN", cancellationToken);
        gen.Chapters.First(c => c.Number == 1).ContentHtml = PlaceholderNotice;

        var jhn = await db.BibleBooks.Include(b => b.Chapters)
            .FirstAsync(b => b.BibleVersionId == NviVersionId && b.Abbreviation == "JHN", cancellationToken);
        jhn.Chapters.First(c => c.Number == 1).ContentHtml = PlaceholderNotice;

        await db.SaveChangesAsync(cancellationToken);
    }
}
