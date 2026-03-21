using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class StudyCategory : BaseEntity
{
    public string Name { get; set; } = null!;
    public string? Slug { get; set; }
    public ICollection<StudyCategoryLink> StudyLinks { get; set; } = new List<StudyCategoryLink>();
}
