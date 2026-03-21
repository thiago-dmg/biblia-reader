using BibliaReader.Domain.Enums;
using BibliaReader.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace BibliaReader.Infrastructure.ReadingPlans;

internal static class ChapterScopeResolver
{
    public static async Task<int> ResolveTotalChaptersAsync(
        AppDbContext db,
        ReadingScopeType scopeType,
        IReadOnlyList<Guid>? bookIds,
        CancellationToken cancellationToken)
    {
        switch (scopeType)
        {
            case ReadingScopeType.WholeBible:
                return 1189;
            case ReadingScopeType.NewTestament:
                return 260;
            case ReadingScopeType.OldTestament:
                return 929;
            case ReadingScopeType.SingleBook:
            case ReadingScopeType.CustomList when bookIds is { Count: > 0 }:
                var sum = await db.BibleBooks.AsNoTracking()
                    .Where(b => bookIds!.Contains(b.Id))
                    .SumAsync(b => b.ChapterCount, cancellationToken);
                return sum > 0 ? sum : bookIds!.Count * 50;
            default:
                return 50;
        }
    }
}
