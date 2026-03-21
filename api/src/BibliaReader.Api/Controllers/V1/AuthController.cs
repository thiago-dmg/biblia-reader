using System.Security.Claims;
using BibliaReader.Api.Authentication;
using BibliaReader.Infrastructure.Identity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace BibliaReader.Api.Controllers.V1;

[ApiController]
[Route("v1/auth")]
public sealed class AuthController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _users;
    private readonly JwtTokenGenerator _jwt;

    public AuthController(UserManager<ApplicationUser> users, JwtTokenGenerator jwt)
    {
        _users = users;
        _jwt = jwt;
    }

    public sealed record RegisterRequest(string Email, string Password, string DisplayName);
    public sealed record LoginRequest(string Email, string Password);
    public sealed record TokenResponse(string AccessToken, Guid UserId, string DisplayName);

    [HttpPost("register")]
    [AllowAnonymous]
    public async Task<ActionResult<TokenResponse>> Register([FromBody] RegisterRequest body, CancellationToken cancellationToken)
    {
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            UserName = body.Email,
            Email = body.Email,
            DisplayName = body.DisplayName,
            CreatedAt = DateTimeOffset.UtcNow,
            EmailConfirmed = true
        };

        var result = await _users.CreateAsync(user, body.Password);
        if (!result.Succeeded)
            return BadRequest(result.Errors);

        var token = _jwt.CreateAccessToken(user);
        return Ok(new TokenResponse(token, user.Id, user.DisplayName));
    }

    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<ActionResult<TokenResponse>> Login([FromBody] LoginRequest body, CancellationToken cancellationToken)
    {
        var user = await _users.FindByEmailAsync(body.Email);
        if (user == null) return Unauthorized();
        if (!await _users.CheckPasswordAsync(user, body.Password)) return Unauthorized();

        var token = _jwt.CreateAccessToken(user);
        return Ok(new TokenResponse(token, user.Id, user.DisplayName));
    }

    [HttpPost("logout")]
    [Authorize]
    public IActionResult Logout() => NoContent();

    [HttpPost("refresh")]
    [AllowAnonymous]
    public IActionResult Refresh() => StatusCode(501, "Implementar refresh token com tabela RefreshTokens.");
}
