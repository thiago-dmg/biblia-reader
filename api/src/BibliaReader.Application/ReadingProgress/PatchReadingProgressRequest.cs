namespace BibliaReader.Application.ReadingProgress;

public sealed class PatchReadingProgressRequest
{
    public string? SelectedPlanId { get; init; }
    public DateTimeOffset? PlanStartedAt { get; init; }
    public IReadOnlyList<string>? CompletedChapterIds { get; init; }
}
