using BibliaReader.Domain.Common;
using BibliaReader.Domain.Enums;

namespace BibliaReader.Domain.Entities;

public class ReadingPlan : BaseEntity
{
    public Guid UserId { get; set; }
    public string Title { get; set; } = null!;
    public ReadingScopeType ScopeType { get; set; }
    /// <summary>JSON: lista de bookIds quando SingleBook / CustomList.</summary>
    public string? ScopeBookIdsJson { get; set; }
    public ReadingPaceMode PaceMode { get; set; }
    public int? ChaptersPerDay { get; set; }
    public DateOnly? TargetEndDate { get; set; }
    public int? DurationDays { get; set; }
    public DateOnly StartedOn { get; set; }
    public bool Paused { get; set; }
    public int TotalChaptersInScope { get; set; }
    public Guid? BibleVersionId { get; set; }
    public BibleVersion? BibleVersion { get; set; }
    public ICollection<ReadingEvent> Events { get; set; } = new List<ReadingEvent>();
}
