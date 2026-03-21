using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class Study : BaseEntity
{
    public string Title { get; set; } = null!;
    public string? Subtitle { get; set; }
    public string? Theme { get; set; }
    public ICollection<StudyLesson> Lessons { get; set; } = new List<StudyLesson>();
    public ICollection<StudyCategoryLink> CategoryLinks { get; set; } = new List<StudyCategoryLink>();
}
