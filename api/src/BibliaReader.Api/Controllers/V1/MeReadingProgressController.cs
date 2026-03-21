using System.Security.Claims;
using BibliaReader.Application.ReadingProgress;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BibliaReader.Api.Controllers.V1;

[ApiController]
[Authorize]
[Route("v1/me/reading-progress")]
public sealed class MeReadingProgressController : ControllerBase
{
    private readonly IReadingProgressService _readingProgress;

    public MeReadingProgressController(IReadingProgressService readingProgress) =>
        _readingProgress = readingProgress;

    private Guid UserId => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    [HttpGet]
    public async Task<ActionResult<ReadingProgressDto>> Get(CancellationToken cancellationToken)
        => Ok(await _readingProgress.GetAsync(UserId, cancellationToken));

    [HttpPut]
    public async Task<ActionResult<ReadingProgressDto>> Put(
        [FromBody] PutReadingProgressRequest body,
        CancellationToken cancellationToken)
        => Ok(await _readingProgress.PutAsync(UserId, body, cancellationToken));

    [HttpPatch]
    public async Task<ActionResult<ReadingProgressDto>> Patch(
        [FromBody] PatchReadingProgressRequest body,
        CancellationToken cancellationToken)
        => Ok(await _readingProgress.PatchAsync(UserId, body, cancellationToken));
}
