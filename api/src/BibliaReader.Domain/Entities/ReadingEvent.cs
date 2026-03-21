using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class ReadingEvent : BaseEntity
{
    public Guid ReadingPlanId { get; set; }
    public ReadingPlan ReadingPlan { get; set; } = null!;
    public Guid UserId { get; set; }
    public DateTimeOffset OccurredAt { get; set; }
    /// <summary>Ex.: MAT:5</summary>
    public string ChapterKey { get; set; } = null!;
}
