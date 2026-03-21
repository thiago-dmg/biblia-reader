using BibliaReader.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BibliaReader.Api.Controllers.V1;

[ApiController]
[AllowAnonymous]
[Route("v1/support")]
public sealed class SupportController : ControllerBase
{
    private readonly AppDbContext _db;

    public SupportController(AppDbContext db) => _db = db;

    [HttpGet("faq")]
    public async Task<IActionResult> Faq(CancellationToken cancellationToken)
    {
        var items = await _db.FaqItems.AsNoTracking()
            .OrderBy(x => x.SortOrder)
            .Select(x => new { x.Id, x.Question, x.AnswerMarkdown })
            .ToListAsync(cancellationToken);
        return Ok(items);
    }
}
