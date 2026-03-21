using System.Net.Http.Headers;
using BibliaReader.Application.Bible;
using BibliaReader.Application.ReadingPlans;
using BibliaReader.Application.ReadingProgress;
using BibliaReader.Infrastructure.Bible;
using BibliaReader.Infrastructure.Identity;
using BibliaReader.Infrastructure.Persistence;
using BibliaReader.Infrastructure.ReadingPlans;
using BibliaReader.Infrastructure.ReadingProgress;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

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

        services.Configure<ExternalBibleOptions>(configuration.GetSection(ExternalBibleOptions.SectionName));
        services.AddMemoryCache();
        services.AddHttpClient(AbibliadigitalBibleTextProvider.HttpClientName, (sp, client) =>
        {
            var o = sp.GetRequiredService<IOptions<ExternalBibleOptions>>().Value;
            var baseUrl = o.BaseUrl.TrimEnd('/').Trim() + "/";
            client.BaseAddress = new Uri(baseUrl);
            client.Timeout = TimeSpan.FromSeconds(Math.Clamp(o.TimeoutSeconds, 5, 120));
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        });
        services.AddSingleton<IBibleTextProvider, AbibliadigitalBibleTextProvider>();

        services.AddScoped<IReadingPlanService, ReadingPlanService>();
        services.AddScoped<IReadingProgressService, ReadingProgressService>();

        return services;
    }
}
