namespace BibliaReader.Application.ReadingProgress;

public static class CanonicalReadingPlanIds
{
    public const string OneYear = "one-year";
    public const string SixMonths = "six-months";
    public const string NinetyDays = "ninety-days";

    public static readonly HashSet<string> All = new(StringComparer.Ordinal)
    {
        OneYear,
        SixMonths,
        NinetyDays
    };

    public static bool IsValid(string? id) =>
        id != null && All.Contains(id);
}
