namespace BibliaReader.Application.ReadingPlans;

public sealed class ReadingPlanSnapshotDto
{
    public Guid PlanId { get; init; }
    public double PercentComplete { get; init; }
    public int RemainingChapters { get; init; }
    public int SuggestedChaptersToday { get; init; }
    public int EstimatedDaysRemaining { get; init; }
    public DateOnly EffectiveTargetEnd { get; init; }
    public bool IsBehindSchedule { get; init; }
    public int StreakDays { get; init; }
}
