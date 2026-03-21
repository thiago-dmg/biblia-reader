using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class FaqItem : BaseEntity
{
    public string Question { get; set; } = null!;
    public string AnswerMarkdown { get; set; } = null!;
    public int SortOrder { get; set; }
}
