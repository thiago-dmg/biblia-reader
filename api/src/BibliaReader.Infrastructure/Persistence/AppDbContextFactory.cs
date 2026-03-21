using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace BibliaReader.Infrastructure.Persistence;

/// <summary>Factory para dotnet ef migrations (CLI).</summary>
public sealed class AppDbContextFactory : IDesignTimeDbContextFactory<AppDbContext>
{
    public AppDbContext CreateDbContext(string[] args)
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseNpgsql("Host=localhost;Port=5432;Database=bibliareader;Username=postgres;Password=postgres")
            .Options;
        return new AppDbContext(options);
    }
}
