using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class UserStudyProgress : BaseEntity
{
    public Guid UserId { get; set; }
    public Guid StudyId { get; set; }
    public Study Study { get; set; } = null!;
    public Guid? LastCompletedLessonId { get; set; }
    public bool Completed { get; set; }
    public bool Favorite { get; set; }
}
