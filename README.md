# Biblia Reader

[![Repo](https://img.shields.io/badge/GitHub-thiago--dmg%2Fbiblia--reader-8B5CF6)](https://github.com/thiago-dmg/biblia-reader)

App **Flutter** para **leitura da Bíblia**, **planos de leitura dinâmicos**, **metas**, **estudos**, **comunidade** e **suporte**.

Este repositório contém **somente o front-end** (Flutter). A API .NET está em outro repositório (ver abaixo).

## Backend (API .NET)

| | |
|--|--|
| **Repositório** | [thiago-dmg/BibleReader.Api.Vps](https://github.com/thiago-dmg/BibleReader.Api.Vps) |
| **Pasta local (exemplo)** | `C:\backend` |

Qualquer alteração em controllers, banco, deploy da API, migrations, etc. deve ser feita **nesse repositório**, com commit e push para a esteira da VPS — **não** neste repo.

Contrato REST resumido para o app: [`docs/BACKEND_CSHARP.md`](docs/BACKEND_CSHARP.md).

## Estrutura deste repositório

- **Raiz** — projeto Flutter (`lib/`, `pubspec.yaml`, `android/`, `ios/`, …).
- **`docs/`** — arquitetura do app, notas de integração com a API.

### Pastas em `lib/`

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── config/          # bootstrap, prefs (onboarding)
│   ├── di/              # Riverpod providers
│   ├── auth/            # sessão + cliente HTTP + progresso canônico
│   ├── api/             # DTOs + BibliaReaderApi (cliente HTTP)
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
│   ├── reading_plans/
│   ├── settings/
│   ├── shell/
│   ├── studies/
│   └── support/
└── shared/
    └── widgets/
```

Documentação: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## API (consumo pelo app)

O app chama a **Biblia Reader API** por HTTP. URL padrão: `http://72.61.35.190:5001` (em `lib/core/config/api_config.dart`).

Override em build:

```bash
flutter run --dart-define=BIBLIA_API_BASE_URL=https://seu-dominio.com
```

- **Auth**: `authProvider` — login, registro, logout; token em `SharedPreferences`.
- **HTTP**: `BibliaHttpClient` + `BibliaReaderApi` — endpoints `/v1/*`.
- **Bíblia**: `GET /v1/bible/*` (versões, livros, capítulos, versículos) — detalhes no backend e em `docs/BACKEND_CSHARP.md` / `docs/BIBLE_EXTERNAL_API.md`.

Android/iOS permitem HTTP claro para a VPS em dev; em produção com HTTPS, ajuste conforme necessário.

## Como rodar

```bash
cd biblia_reader
flutter pub get
flutter run
```

**Onboarding**: na primeira execução o fluxo de boas-vindas aparece; depois fica salvo em `SharedPreferences`.

## Tema e UX

Tipografia: **Cormorant Garamond** (títulos) + **Plus Jakarta Sans** (corpo) via `google_fonts`. Tema claro/escuro em **Configurações**.
