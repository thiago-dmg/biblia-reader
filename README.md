# Biblia Reader

[![Repo](https://img.shields.io/badge/GitHub-thiago--dmg%2Fbiblia--reader-8B5CF6)](https://github.com/thiago-dmg/biblia-reader)

App Flutter premium para **leitura da Bíblia**, **planos de leitura dinâmicos**, **metas**, **estudos**, **comunidade** e **suporte**.

**Estrutura do repositório**

- **Raiz** — projeto Flutter (`lib/`, `pubspec.yaml`, …).
- **`api/`** — backend **.NET 8** (BibliaReader), contrato em [`docs/BACKEND_CSHARP.md`](docs/BACKEND_CSHARP.md).
- **`.github/workflows/deploy-api.yml`** — deploy da API na VPS (systemd), como no Minha Rotina Kids.

Primeiro push e secrets: [`docs/GITHUB_REPO.md`](docs/GITHUB_REPO.md).

## Estrutura de pastas (`lib/`)

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── config/          # bootstrap, prefs (onboarding)
│   ├── di/              # Riverpod providers
│   ├── auth/            # sessão + cliente HTTP + progresso canônico
│   ├── api/             # DTOs + BibliaReaderApi
│   ├── network/         # BibliaHttpClient, ApiException
│   ├── router/          # go_router
│   └── theme/           # cores, tipografia, tema claro/escuro
├── features/
│   ├── auth/
│   ├── bible/
│   ├── community/
│   ├── goals/
│   ├── home/
│   ├── onboarding/
│   ├── profile/
│   ├── reading_plans/   # domain + data + presentation + calculadora dinâmica
│   ├── settings/
│   ├── shell/
│   ├── studies/
│   └── support/
└── shared/
    └── widgets/
```

Documentação detalhada:

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — arquitetura Flutter, navegação, plano dinâmico.
- [docs/BACKEND_CSHARP.md](docs/BACKEND_CSHARP.md) — API REST, entidades, SQL Server, auth.

## API (VPS)

O app usa a **Biblia Reader API** por HTTP. URL padrão: `http://72.61.35.190:5001` (definida em `lib/core/config/api_config.dart`).

Override em build:

```bash
flutter run --dart-define=BIBLIA_API_BASE_URL=https://seu-dominio.com
```

- **Auth**: `authProvider` (`lib/core/auth/biblia_auth.dart`) — login, registro, logout; token em `SharedPreferences`.
- **HTTP**: `BibliaHttpClient` + `BibliaReaderApi` — endpoints `/v1/*` alinhados ao Swagger.
- **Progresso canônico**: `canonicalReadingProgressProvider` → `GET /v1/me/reading-progress`.
- **Planos**: `readingPlanRepositoryProvider` lista planos remotos quando há sessão; sem login, mantém plano demo local.
- **Bíblia NVI**: lista de livros e capítulos vêm de `GET /v1/bible/books` e `GET /v1/bible/chapters` (backend em `C:\\backend` + seed `NviBibleSeeder`). O texto completo da NVI não é incluído no repositório (licença); veja `C:\\backend\\docs\\IMPORTAR_NVI.md`.
- **Login**: rota `/auth/login`; cartão na home e “Entrar ou criar conta” no perfil quando não há sessão.

Android/iOS permitem HTTP claro para essa VPS (`usesCleartextTraffic` / ATS); em produção com HTTPS, remova ou restrinja.

## Como rodar

```bash
cd biblia_reader
flutter pub get
flutter run
```

**Onboarding**: na primeira execução, o fluxo de boas-vindas aparece; depois fica salvo em `SharedPreferences`.

## Tema e UX

- Tipografia: **Cormorant Garamond** (títulos) + **Plus Jakarta Sans** (corpo) via `google_fonts`.
- Tema claro/escuro em **Configurações** (Perfil → Configurações).

## Próximos passos

1. Sincronizar progresso canônico com telas de leitura (PUT/PATCH) e `addReadingEvents` ao marcar capítulos.
2. Conteúdo bíblico conforme licença (API ou bundle).
3. Testes unitários em `ReadingPlanProgressCalculator` e mappers.
4. Refresh token quando o backend expor além do 501 atual.
