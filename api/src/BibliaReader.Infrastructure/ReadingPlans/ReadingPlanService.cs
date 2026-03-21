using BibliaReader.Application.ReadingPlans;
using BibliaReader.Domain.Entities;
using BibliaReader.Domain.Enums;
using BibliaReader.Infrastructure.Persistence;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace BibliaReader.Infrastructure.ReadingPlans;

public sealed class ReadingPlanService : IReadingPlanService
{
    private readonly AppDbContext _db;
    private readonly IValidator<CreateReadingPlanRequest> _createValidator;

    public ReadingPlanService(AppDbContext db, IValidator<CreateReadingPlanRequest> createValidator)
    {
        _db = db;
        _createValidator = createValidator;
    }

    public async Task<IReadOnlyList<ReadingPlanResponseDto>> ListAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var plans = await _db.ReadingPlans.AsNoTracking()
            .Include(p => p.Events)
            .Where(p => p.UserId == userId)
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync(cancellationToken);
        return plans.Select(Map).ToList();
    }

    public async Task<ReadingPlanResponseDto?> GetAsync(Guid userId, Guid planId, CancellationToken cancellationToken = default)
    {
        var plan = await _db.ReadingPlans.AsNoTracking()
            .Include(p => p.Events)
            .FirstOrDefaultAsync(p => p.Id == planId && p.UserId == userId, cancellationToken);
        return plan == null ? null : Map(plan);
    }

    public async Task<ReadingPlanResponseDto> CreateAsync(Guid userId, CreateReadingPlanRequest request, CancellationToken cancellationToken = default)
    {
        await _createValidator.ValidateAndThrowAsync(request, cancellationToken);

        var bookIds = request.BookIds?.ToList();
        var total = await ChapterScopeResolver.ResolveTotalChaptersAsync(_db, request.ScopeType, bookIds, cancellationToken);

        var plan = new ReadingPlan
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            Title = request.Title,
            ScopeType = request.ScopeType,
            ScopeBookIdsJson = bookIds is { Count: > 0 } ? System.Text.Json.JsonSerializer.Serialize(bookIds) : null,
            PaceMode = request.PaceMode,
            ChaptersPerDay = request.ChaptersPerDay,
            TargetEndDate = request.TargetEndDate,
            DurationDays = request.DurationDays,
            StartedOn = DateOnly.FromDateTime(DateTime.UtcNow),
            Paused = false,
            TotalChaptersInScope = total,
            BibleVersionId = request.BibleVersionId,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _db.ReadingPlans.Add(plan);
        await _db.SaveChangesAsync(cancellationToken);
        return Map(plan);
    }

    public async Task<ReadingPlanSnapshotDto> AddEventsAsync(
        Guid userId,
        Guid planId,
        AddReadingEventsRequest request,
        CancellationToken cancellationToken = default)
    {
        var plan = await _db.ReadingPlans
            .Include(p => p.Events)
            .FirstOrDefaultAsync(p => p.Id == planId && p.UserId == userId, cancellationToken)
            ?? throw new KeyNotFoundException("Plano não encontrado.");

        var existing = plan.Events.Select(e => e.ChapterKey).ToHashSet(StringComparer.OrdinalIgnoreCase);
        foreach (var key in request.ChapterKeys.Distinct(StringComparer.OrdinalIgnoreCase))
        {
            if (existing.Contains(key)) continue;
            var ev = new ReadingEvent
            {
                Id = Guid.NewGuid(),
                ReadingPlanId = plan.Id,
                UserId = userId,
                OccurredAt = request.OccurredAt,
                ChapterKey = key,
                CreatedAt = DateTimeOffset.UtcNow
            };
            plan.Events.Add(ev);
            existing.Add(key);
        }

        await _db.SaveChangesAsync(cancellationToken);

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        return ReadingPlanProgressHelper.Build(plan, plan.Events.ToList(), today);
    }

    public async Task<ReadingPlanSnapshotDto> GetSnapshotAsync(Guid userId, Guid planId, CancellationToken cancellationToken = default)
    {
        var plan = await _db.ReadingPlans.AsNoTracking()
            .Include(p => p.Events)
            .FirstOrDefaultAsync(p => p.Id == planId && p.UserId == userId, cancellationToken)
            ?? throw new KeyNotFoundException("Plano não encontrado.");

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        return ReadingPlanProgressHelper.Build(plan, plan.Events.ToList(), today);
    }

    private static ReadingPlanResponseDto Map(ReadingPlan p)
    {
        var completed = p.Events.Select(e => e.ChapterKey).Distinct(StringComparer.OrdinalIgnoreCase).Count();
        return new ReadingPlanResponseDto
        {
            Id = p.Id,
            Title = p.Title,
            ScopeType = p.ScopeType,
            PaceMode = p.PaceMode,
            ChaptersPerDay = p.ChaptersPerDay,
            TargetEndDate = p.TargetEndDate,
            TotalChapters = p.TotalChaptersInScope,
            CompletedChapters = completed,
            StartedOn = p.StartedOn,
            Paused = p.Paused,
            CreatedAt = p.CreatedAt
        };
    }
}
