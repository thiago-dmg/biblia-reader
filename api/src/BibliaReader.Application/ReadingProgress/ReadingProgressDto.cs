namespace BibliaReader.Application.ReadingProgress;

public sealed class ReadingProgressDto
{
    public required string SelectedPlanId { get; init; }
    public required DateTimeOffset PlanStartedAt { get; init; }
    public required IReadOnlyList<string> CompletedChapterIds { get; init; }
    public required DateTimeOffset UpdatedAt { get; init; }
}
