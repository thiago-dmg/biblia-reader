# Bíblia externa (ACF) — Biblia Reader API

## Visão geral

O texto bíblico **não** é armazenado no PostgreSQL. A API atua como **BFF**: busca conteúdo na [ABíblia Digital](https://www.abibliadigital.com.br/), versão padrão **ACF** (Almeida Corrigida Fiel), com **cache em memória** e contrato interno estável.

## Arquitetura

| Camada | Responsabilidade |
|--------|------------------|
| `BibliaReader.Application` | `IBibleTextProvider`, DTOs (`BibleVersionInfo`, `BibleBookInfo`, `BibleChapterPayload`), `ExternalBibleOptions`, catálogo canônico `BibleCanonCatalog` |
| `BibliaReader.Infrastructure` | `AbibliadigitalBibleTextProvider`, `HttpClient` nomeado `ExternalBible`, mapeamento de abreviações |
| `BibliaReader.Api` | `BibleController`, `IMemoryCache`, binding de opções |

## Configuração (`appsettings.json`)

```json
"ExternalBible": {
  "BaseUrl": "https://www.abibliadigital.com.br",
  "DefaultVersionCode": "acf",
  "TimeoutSeconds": 25,
  "CacheDurationMinutes": 360,
  "ApiToken": null
}
```

- **BaseUrl**: sem barra final no JSON; o código normaliza.
- **DefaultVersionCode**: `acf` por padrão; pode evoluir para `nvi` se o provedor suportar.
- **ApiToken**: reservado para APIs que exijam chave (a API pública atual não usa).

## Endpoints internos

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/v1/bible/versions` | Versões expostas (hoje: ACF). |
| GET | `/v1/bible/books?versionCode=acf` | Livros (metadados do catálogo canônico). |
| GET | `/v1/bible/chapters?bookAbbrev=GEN&number=1&versionCode=acf` | Capítulo (HTML montado a partir dos versículos). |
| GET | `/v1/bible/books/GEN/chapters/1` | Mesmo conteúdo, REST. |
| GET | `/v1/bible/books/GEN/chapters/1/verses/1` | Um versículo. |

Compatibilidade: `versionId` (GUID da versão ACF estável) ainda pode ser enviado; o controller resolve para `acf`.

## Exemplos de chamada

```http
GET /v1/bible/books?versionCode=acf
GET /v1/bible/chapters?bookAbbrev=GEN&number=1&versionCode=acf
GET /v1/bible/books/GEN/chapters/1/verses/1?versionCode=acf
```

## Limitações

- Depende da disponibilidade e formato da API pública.
- Rate limit / indisponibilidade retornam **502** com mensagem amigável.
- Traduções adicionais exigem outro `IBibleTextProvider` ou extensão do atual.

## Trocar de provedor

Implemente `IBibleTextProvider` e registre no `DependencyInjection` da Infrastructure no lugar de `AbibliadigitalBibleTextProvider`.
