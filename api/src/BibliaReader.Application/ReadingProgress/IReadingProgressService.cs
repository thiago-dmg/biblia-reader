namespace BibliaReader.Application.ReadingProgress;

public interface IReadingProgressService
{
    Task<ReadingProgressDto> GetAsync(Guid userId, CancellationToken cancellationToken = default);

    Task<ReadingProgressDto> PutAsync(Guid userId, PutReadingProgressRequest request,
        CancellationToken cancellationToken = default);

    Task<ReadingProgressDto> PatchAsync(Guid userId, PatchReadingProgressRequest request,
        CancellationToken cancellationToken = default);
}
