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
│   ├── network/         # ApiClient (contrato)
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
- [docs/BACKEND_CSHARP.md](docs/BACKEND_CSHARP.md) — API REST, entidades, PostgreSQL, auth.

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

1. Implementar cliente HTTP real e mapear DTOs nos repositórios.
2. Persistir planos e eventos com a API descrita em `BACKEND_CSHARP.md`.
3. Conteúdo bíblico conforme licença (API ou bundle).
4. Testes unitários em `ReadingPlanProgressCalculator`.
