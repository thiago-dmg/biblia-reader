using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class BibleChapter : BaseEntity
{
    public Guid BibleBookId { get; set; }
    public BibleBook BibleBook { get; set; } = null!;
    public int Number { get; set; }
    /// <summary>Texto licenciado ou referência a blob/CDN.</summary>
    public string? ContentHtml { get; set; }
}
