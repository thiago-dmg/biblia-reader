using System.Security.Claims;
using BibliaReader.Application.ReadingPlans;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BibliaReader.Api.Controllers.V1;

[ApiController]
[Authorize]
[Route("v1/reading-plans")]
public sealed class ReadingPlansController : ControllerBase
{
    private readonly IReadingPlanService _plans;

    public ReadingPlansController(IReadingPlanService plans) => _plans = plans;

    private Guid UserId => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<ReadingPlanResponseDto>>> List(CancellationToken cancellationToken)
        => Ok(await _plans.ListAsync(UserId, cancellationToken));

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<ReadingPlanResponseDto>> Get(Guid id, CancellationToken cancellationToken)
    {
        var p = await _plans.GetAsync(UserId, id, cancellationToken);
        return p == null ? NotFound() : Ok(p);
    }

    [HttpPost]
    public async Task<ActionResult<ReadingPlanResponseDto>> Create(
        [FromBody] CreateReadingPlanRequest body,
        CancellationToken cancellationToken)
    {
        var created = await _plans.CreateAsync(UserId, body, cancellationToken);
        return CreatedAtAction(nameof(Get), new { id = created.Id }, created);
    }

    [HttpPost("{id:guid}/events")]
    public async Task<ActionResult<ReadingPlanSnapshotDto>> AddEvents(
        Guid id,
        [FromBody] AddReadingEventsRequest body,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _plans.AddEventsAsync(UserId, id, body, cancellationToken));
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpGet("{id:guid}/snapshot")]
    public async Task<ActionResult<ReadingPlanSnapshotDto>> Snapshot(Guid id, CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _plans.GetSnapshotAsync(UserId, id, cancellationToken));
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
}
