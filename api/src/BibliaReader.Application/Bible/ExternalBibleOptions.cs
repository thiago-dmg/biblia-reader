namespace BibliaReader.Application.Bible;

/// <summary>Configuração da API externa de texto bíblico (ex.: ABíblia Digital).</summary>
public sealed class ExternalBibleOptions
{
    public const string SectionName = "ExternalBible";

    /// <summary>URL base, ex.: https://www.abibliadigital.com.br</summary>
    public string BaseUrl { get; set; } = "https://www.abibliadigital.com.br";

    /// <summary>Código da versão padrão na API externa (ex.: acf, nvi).</summary>
    public string DefaultVersionCode { get; set; } = "acf";

    /// <summary>Timeout por requisição HTTP.</summary>
    public int TimeoutSeconds { get; set; } = 25;

    /// <summary>Token opcional se o provedor exigir (não usado pela ABíblia Digital pública).</summary>
    public string? ApiToken { get; set; }

    /// <summary>Duração do cache em memória para capítulos/livros.</summary>
    public int CacheDurationMinutes { get; set; } = 360;
}
