namespace BibliaReader.Application.ReadingProgress;

public sealed class PutReadingProgressRequest
{
    public required string SelectedPlanId { get; init; }
    public required DateTimeOffset PlanStartedAt { get; init; }
    public required IReadOnlyList<string> CompletedChapterIds { get; init; }
}
