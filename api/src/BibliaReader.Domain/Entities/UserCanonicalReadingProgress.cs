namespace BibliaReader.Domain.Entities;

/// <summary>
/// Estado único por usuário alinhado ao app (planos canônicos + chapterKey tipo gn-1).
/// </summary>
public sealed class UserCanonicalReadingProgress
{
    public Guid UserId { get; set; }

    /// <summary>Ex.: one-year, six-months, ninety-days</summary>
    public string SelectedPlanId { get; set; } = null!;

    public DateTimeOffset PlanStartedAt { get; set; }

    /// <summary>JSON array de strings (chapterKey).</summary>
    public string CompletedChapterIdsJson { get; set; } = null!;

    public DateTimeOffset UpdatedAt { get; set; }
}
