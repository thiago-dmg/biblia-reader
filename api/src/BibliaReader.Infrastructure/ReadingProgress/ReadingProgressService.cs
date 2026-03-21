using System.Text.Json;
using BibliaReader.Application.ReadingProgress;
using BibliaReader.Domain.Entities;
using BibliaReader.Infrastructure.Persistence;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace BibliaReader.Infrastructure.ReadingProgress;

public sealed class ReadingProgressService : IReadingProgressService
{
    private readonly AppDbContext _db;
    private readonly IValidator<PutReadingProgressRequest> _putValidator;
    private readonly IValidator<PatchReadingProgressRequest> _patchValidator;

    public ReadingProgressService(
        AppDbContext db,
        IValidator<PutReadingProgressRequest> putValidator,
        IValidator<PatchReadingProgressRequest> patchValidator)
    {
        _db = db;
        _putValidator = putValidator;
        _patchValidator = patchValidator;
    }

    public async Task<ReadingProgressDto> GetAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var row = await _db.UserCanonicalReadingProgresses.AsNoTracking()
            .FirstOrDefaultAsync(x => x.UserId == userId, cancellationToken);
        return row == null ? DefaultDto() : Map(row);
    }

    public async Task<ReadingProgressDto> PutAsync(Guid userId, PutReadingProgressRequest request,
        CancellationToken cancellationToken = default)
    {
        await _putValidator.ValidateAndThrowAsync(request, cancellationToken);

        var ids = NormalizeIds(request.CompletedChapterIds);
        var json = JsonSerializer.Serialize(ids);
        var now = DateTimeOffset.UtcNow;

        var row = await _db.UserCanonicalReadingProgresses
            .FirstOrDefaultAsync(x => x.UserId == userId, cancellationToken);

        if (row == null)
        {
            row = new UserCanonicalReadingProgress
            {
                UserId = userId,
                SelectedPlanId = request.SelectedPlanId,
                PlanStartedAt = request.PlanStartedAt,
                CompletedChapterIdsJson = json,
                UpdatedAt = now
            };
            _db.UserCanonicalReadingProgresses.Add(row);
        }
        else
        {
            row.SelectedPlanId = request.SelectedPlanId;
            row.PlanStartedAt = request.PlanStartedAt;
            row.CompletedChapterIdsJson = json;
            row.UpdatedAt = now;
        }

        await _db.SaveChangesAsync(cancellationToken);
        return Map(row);
    }

    public async Task<ReadingProgressDto> PatchAsync(Guid userId, PatchReadingProgressRequest request,
        CancellationToken cancellationToken = default)
    {
        await _patchValidator.ValidateAndThrowAsync(request, cancellationToken);

        if (request.SelectedPlanId == null && request.PlanStartedAt == null &&
            request.CompletedChapterIds == null)
            return await GetAsync(userId, cancellationToken);

        var row = await _db.UserCanonicalReadingProgresses
            .FirstOrDefaultAsync(x => x.UserId == userId, cancellationToken);

        if (row == null)
        {
            row = new UserCanonicalReadingProgress
            {
                UserId = userId,
                SelectedPlanId = CanonicalReadingPlanIds.OneYear,
                PlanStartedAt = DefaultPlanStartUtc(),
                CompletedChapterIdsJson = "[]",
                UpdatedAt = DateTimeOffset.UtcNow
            };
            _db.UserCanonicalReadingProgresses.Add(row);
            await _db.SaveChangesAsync(cancellationToken);
        }

        var now = DateTimeOffset.UtcNow;

        if (request.SelectedPlanId != null)
            row.SelectedPlanId = request.SelectedPlanId;

        if (request.PlanStartedAt != null)
            row.PlanStartedAt = request.PlanStartedAt.Value;

        if (request.CompletedChapterIds != null)
            row.CompletedChapterIdsJson = JsonSerializer.Serialize(NormalizeIds(request.CompletedChapterIds));

        row.UpdatedAt = now;
        await _db.SaveChangesAsync(cancellationToken);
        return Map(row);
    }

    private static ReadingProgressDto Map(UserCanonicalReadingProgress row)
    {
        var ids = ParseIds(row.CompletedChapterIdsJson);
        return new ReadingProgressDto
        {
            SelectedPlanId = row.SelectedPlanId,
            PlanStartedAt = row.PlanStartedAt,
            CompletedChapterIds = ids,
            UpdatedAt = row.UpdatedAt
        };
    }

    private static ReadingProgressDto DefaultDto() => new()
    {
        SelectedPlanId = CanonicalReadingPlanIds.OneYear,
        PlanStartedAt = DefaultPlanStartUtc(),
        CompletedChapterIds = Array.Empty<string>(),
        UpdatedAt = DateTimeOffset.UtcNow
    };

    private static DateTimeOffset DefaultPlanStartUtc()
    {
        var y = DateTime.UtcNow.Year;
        return new DateTimeOffset(y, 1, 1, 0, 0, 0, TimeSpan.Zero);
    }

    private static List<string> ParseIds(string json)
    {
        try
        {
            var list = JsonSerializer.Deserialize<List<string>>(json);
            return NormalizeIds(list ?? new List<string>());
        }
        catch (JsonException)
        {
            return new List<string>();
        }
    }

    private static List<string> NormalizeIds(IReadOnlyList<string> ids) =>
        ids
            .Where(x => !string.IsNullOrWhiteSpace(x))
            .Select(x => x.Trim().ToLowerInvariant())
            .Distinct(StringComparer.Ordinal)
            .OrderBy(x => x, StringComparer.Ordinal)
            .ToList();
}
