using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BibliaReader.Api.Controllers.V1;

[ApiController]
[AllowAnonymous]
[Route("v1/bible")]
public sealed class BibleController : ControllerBase
{
    [HttpGet("versions")]
    public IActionResult Versions() =>
        Ok(new[] { new { id = Guid.Empty, code = "demo", name = "Versão demo (seed)" } });

    [HttpGet("books")]
    public IActionResult Books([FromQuery] Guid? versionId) =>
        Ok(Array.Empty<object>());
}
