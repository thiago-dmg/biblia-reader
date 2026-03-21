namespace BibliaReader.Application.ReadingPlans;

public sealed class AddReadingEventsRequest
{
    public DateTimeOffset OccurredAt { get; init; }
    public IReadOnlyList<string> ChapterKeys { get; init; } = Array.Empty<string>();
}
