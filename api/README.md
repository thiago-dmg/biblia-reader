# Biblia Reader — Backend (.NET 8)

Solução em camadas alinhada ao contrato documentado no frontend em  
**`C:\front\biblia_reader\docs\BACKEND_CSHARP.md`** (inclui roadmap `GET/PATCH /v1/me/reading-progress` e IDs de plano canônicos).

Repositório API: **`C:\backend`** (esta pasta).

## Estrutura

| Projeto | Responsabilidade |
|---------|------------------|
| **BibliaReader.Domain** | Entidades, enums |
| **BibliaReader.Application** | DTOs, validação FluentValidation, interfaces (`IReadingPlanService`) |
| **BibliaReader.Infrastructure** | EF Core + PostgreSQL, Identity, implementação dos serviços |
| **BibliaReader.Api** | Controllers `v1`, JWT, Swagger |

## Pré-requisitos

- .NET 8 SDK  
- PostgreSQL em execução (ajuste `ConnectionStrings:DefaultConnection` em `appsettings.json`)

## Banco de dados

```bash
cd C:\backend
dotnet ef database update --project src\BibliaReader.Infrastructure --startup-project src\BibliaReader.Api
```

> A primeira migração está em `Infrastructure/Persistence/Migrations`.

## Executar a API

```bash
cd src\BibliaReader.Api
dotnet run
```

Swagger: `https://localhost:{port}/swagger`

## Docker (VPS / produção)

Arquivos na raiz do backend: `Dockerfile`, `docker-compose.yml`, `.env.example`.

```bash
cp .env.example .env   # preencher POSTGRES_PASSWORD e JWT_KEY (≥32 caracteres)
docker compose up -d
```

Guia para **vários projetos na mesma VPS** (Nginx, DNS, convivência com MySQL de outro app):  
`C:\front\biblia_reader\docs\VPS_HOSTINGER_MULTI_APPS.md` (ou copie esse arquivo para o repositório do front).

## CI/CD — deploy com systemd (igual Minha Rotina Kids)

Workflow: `.github/workflows/deploy.yml`

- **Push em `main`** ou **workflow_dispatch** → `dotnet publish` → `tar.gz` → **systemd** na VPS.
- **Secrets** (mesmos do outro projeto): `VPS_SSH_HOST`, `VPS_SSH_USER`, `VPS_SSH_KEY`.
- Na VPS: **porta `5001`** (Minha Rotina costuma usar `5000`); serviço `bibliareader-api`; pasta `/var/www/bibliareader-api/current`.
- **Produção**: após o primeiro deploy, configure connection string e JWT **na VPS** (não no repositório), por exemplo:

```bash
sudo systemctl edit bibliareader-api
```

Exemplo de variáveis (ajuste host/senha do PostgreSQL):

```ini
[Service]
Environment=ConnectionStrings__DefaultConnection=Host=SEU_HOST;Port=5432;Database=bibliareader;Username=...;Password=...
Environment=Jwt__Key=sua-chave-com-pelo-menos-32-caracteres
```

Depois: `sudo systemctl daemon-reload && sudo systemctl restart bibliareader-api`

**Nginx**: `proxy_pass` para `http://127.0.0.1:5001` no `server_name` do subdomínio da API.

## Fluxo rápido

1. `POST /v1/auth/register` — cria usuário e devolve JWT  
2. Authorize no Swagger com `Bearer {token}`  
3. `POST /v1/reading-plans` — cria plano  
4. `POST /v1/reading-plans/{id}/events` — registra capítulos lidos  
5. `GET /v1/reading-plans/{id}/snapshot` — progresso calculado  
6. `GET|PUT|PATCH /v1/me/reading-progress` — sync do app (plano canônico + `chapterKey`, ver `docs/BACKEND_CSHARP.md`)  

## Segurança

- Troque `Jwt:Key` por um segredo forte (≥ 32 caracteres) e use cofre em produção.  
- `POST /v1/auth/refresh` está como stub (501) — implementar com tabela `RefreshTokens`.

## Próximos passos

- Seed de `BibleVersion` / `BibleBook` / `BibleChapter` e `FaqItem`  
- Endpoints restantes (metas, estudos, comunidade, tickets)  
- Refresh token + revogação  
- Testes de integração com WebApplicationFactory  
