using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class BibleBook : BaseEntity
{
    public Guid BibleVersionId { get; set; }
    public BibleVersion BibleVersion { get; set; } = null!;
    public int CanonicalOrder { get; set; }
    public string Abbreviation { get; set; } = null!;
    public string Name { get; set; } = null!;
    public int ChapterCount { get; set; }
    public ICollection<BibleChapter> Chapters { get; set; } = new List<BibleChapter>();
}
