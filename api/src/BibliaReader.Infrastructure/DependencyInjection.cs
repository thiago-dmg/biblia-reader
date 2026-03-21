using BibliaReader.Application.ReadingPlans;
using BibliaReader.Application.ReadingProgress;
using BibliaReader.Infrastructure.Identity;
using BibliaReader.Infrastructure.Persistence;
using BibliaReader.Infrastructure.ReadingPlans;
using BibliaReader.Infrastructure.ReadingProgress;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace BibliaReader.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        var cs = configuration.GetConnectionString("DefaultConnection")
                 ?? throw new InvalidOperationException("ConnectionStrings:DefaultConnection não configurada.");

        services.AddDbContext<AppDbContext>(options =>
            options.UseNpgsql(cs));

        services
            .AddIdentity<ApplicationUser, IdentityRole<Guid>>(options =>
            {
                options.Password.RequireDigit = true;
                options.Password.RequiredLength = 8;
                options.User.RequireUniqueEmail = true;
            })
            .AddEntityFrameworkStores<AppDbContext>()
            .AddDefaultTokenProviders();

        services.AddScoped<IReadingPlanService, ReadingPlanService>();
        services.AddScoped<IReadingProgressService, ReadingProgressService>();

        return services;
    }
}
