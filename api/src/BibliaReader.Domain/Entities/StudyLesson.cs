using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class StudyLesson : BaseEntity
{
    public Guid StudyId { get; set; }
    public Study Study { get; set; } = null!;
    public int Order { get; set; }
    public string Title { get; set; } = null!;
    public string ContentMarkdown { get; set; } = null!;
}
