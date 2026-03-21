using BibliaReader.Domain.Enums;

namespace BibliaReader.Application.ReadingPlans;

public sealed class ReadingPlanResponseDto
{
    public Guid Id { get; init; }
    public string Title { get; init; } = null!;
    public ReadingScopeType ScopeType { get; init; }
    public ReadingPaceMode PaceMode { get; init; }
    public int? ChaptersPerDay { get; init; }
    public DateOnly? TargetEndDate { get; init; }
    public int TotalChapters { get; init; }
    public int CompletedChapters { get; init; }
    public DateOnly StartedOn { get; init; }
    public bool Paused { get; init; }
    public DateTimeOffset CreatedAt { get; init; }
}
