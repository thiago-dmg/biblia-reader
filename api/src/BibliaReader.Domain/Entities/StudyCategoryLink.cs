namespace BibliaReader.Domain.Entities;

public class StudyCategoryLink
{
    public Guid StudyId { get; set; }
    public Study Study { get; set; } = null!;
    public Guid StudyCategoryId { get; set; }
    public StudyCategory StudyCategory { get; set; } = null!;
}
