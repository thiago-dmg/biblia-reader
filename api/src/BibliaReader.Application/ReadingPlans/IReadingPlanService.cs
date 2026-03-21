namespace BibliaReader.Application.ReadingPlans;

public interface IReadingPlanService
{
    Task<IReadOnlyList<ReadingPlanResponseDto>> ListAsync(Guid userId, CancellationToken cancellationToken = default);
    Task<ReadingPlanResponseDto?> GetAsync(Guid userId, Guid planId, CancellationToken cancellationToken = default);
    Task<ReadingPlanResponseDto> CreateAsync(Guid userId, CreateReadingPlanRequest request, CancellationToken cancellationToken = default);
    Task<ReadingPlanSnapshotDto> AddEventsAsync(Guid userId, Guid planId, AddReadingEventsRequest request, CancellationToken cancellationToken = default);
    Task<ReadingPlanSnapshotDto> GetSnapshotAsync(Guid userId, Guid planId, CancellationToken cancellationToken = default);
}
