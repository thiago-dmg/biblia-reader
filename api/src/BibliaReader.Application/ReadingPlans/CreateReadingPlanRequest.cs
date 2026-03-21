using BibliaReader.Domain.Enums;

namespace BibliaReader.Application.ReadingPlans;

public sealed class CreateReadingPlanRequest
{
    public string Title { get; init; } = null!;
    public ReadingScopeType ScopeType { get; init; }
    public IReadOnlyList<Guid>? BookIds { get; init; }
    public ReadingPaceMode PaceMode { get; init; }
    public int? ChaptersPerDay { get; init; }
    public DateOnly? TargetEndDate { get; init; }
    public int? DurationDays { get; init; }
    public Guid? BibleVersionId { get; init; }
}
