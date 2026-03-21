using BibliaReader.Application.ReadingPlans;
using BibliaReader.Domain.Entities;
using BibliaReader.Domain.Enums;

namespace BibliaReader.Infrastructure.ReadingPlans;

internal static class ReadingPlanProgressHelper
{
    public static ReadingPlanSnapshotDto Build(
        ReadingPlan plan,
        IReadOnlyCollection<ReadingEvent> events,
        DateOnly todayUtc)
    {
        var distinctKeys = events.Select(e => e.ChapterKey).Distinct().ToHashSet(StringComparer.OrdinalIgnoreCase);
        var completed = distinctKeys.Count;
        var total = plan.TotalChaptersInScope;
        var remaining = Math.Max(0, total - completed);
        var pct = total <= 0 ? 1d : (double)completed / total;

        DateOnly targetEnd;
        switch (plan.PaceMode)
        {
            case ReadingPaceMode.ChaptersPerDay:
                var perDay = Math.Clamp(plan.ChaptersPerDay ?? 1, 1, 999);
                var daysNeeded = perDay == 0 ? 0 : (int)Math.Ceiling(remaining / (double)perDay);
                targetEnd = todayUtc.AddDays(daysNeeded);
                break;
            case ReadingPaceMode.FinishByDate:
                targetEnd = plan.TargetEndDate ?? todayUtc;
                if (targetEnd < todayUtc) targetEnd = todayUtc;
                break;
            case ReadingPaceMode.DurationDays:
                targetEnd = plan.StartedOn.AddDays(plan.DurationDays ?? 1);
                break;
            default:
                targetEnd = todayUtc;
                break;
        }

        var daysLeftInclusive = DaysBetween(todayUtc, targetEnd) + 1;
        int suggestedToday = plan.PaceMode == ReadingPaceMode.ChaptersPerDay
            ? Math.Clamp(plan.ChaptersPerDay ?? 1, 1, 999)
            : daysLeftInclusive <= 0
                ? remaining
                : Math.Max(1, (int)Math.Ceiling(remaining / (double)daysLeftInclusive));

        var ideal = IdealProgressFraction(plan, todayUtc, targetEnd, total);
        var isBehind = pct + 1e-6 < ideal && remaining > 0;

        var estDays = plan.PaceMode == ReadingPaceMode.ChaptersPerDay
            ? (plan.ChaptersPerDay is > 0 ? (int)Math.Ceiling(remaining / (double)plan.ChaptersPerDay.Value) : 0)
            : Math.Max(0, daysLeftInclusive - 1);

        var streak = ComputeStreakForPlan(events, todayUtc);

        return new ReadingPlanSnapshotDto
        {
            PlanId = plan.Id,
            PercentComplete = pct,
            RemainingChapters = remaining,
            SuggestedChaptersToday = Math.Min(suggestedToday, remaining),
            EstimatedDaysRemaining = estDays,
            EffectiveTargetEnd = targetEnd,
            IsBehindSchedule = isBehind,
            StreakDays = streak
        };
    }

    private static double IdealProgressFraction(ReadingPlan plan, DateOnly today, DateOnly targetEnd, int total)
    {
        var start = plan.StartedOn;
        var end = targetEnd < start ? start : targetEnd;
        var totalDays = DaysBetween(start, end) + 1;
        if (totalDays <= 0) return 1;
        var passed = DaysBetween(start, today) + 1;
        var clamped = Math.Clamp(passed, 0, totalDays);
        return clamped / (double)totalDays;
    }

    private static int DaysBetween(DateOnly a, DateOnly b) => b.DayNumber - a.DayNumber;

    private static int ComputeStreakForPlan(IReadOnlyCollection<ReadingEvent> events, DateOnly today)
    {
        var daysWithReads = events
            .Select(e => DateOnly.FromDateTime(e.OccurredAt.UtcDateTime))
            .Where(d => d <= today)
            .Distinct()
            .ToHashSet();

        var streak = 0;
        var cursor = today;
        while (daysWithReads.Contains(cursor))
        {
            streak++;
            cursor = cursor.AddDays(-1);
        }

        return streak;
    }
}
