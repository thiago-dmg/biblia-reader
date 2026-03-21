using Microsoft.AspNetCore.Identity;

namespace BibliaReader.Infrastructure.Identity;

public sealed class ApplicationUser : IdentityUser<Guid>
{
    public string DisplayName { get; set; } = null!;
    public string? Bio { get; set; }
    public DateTimeOffset CreatedAt { get; set; }
}
