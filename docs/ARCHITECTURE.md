# Arquitetura — Biblia Reader (Flutter)

## Visão geral

App modular em **Clean Architecture pragmática**:

- **Domain**: entidades, contratos de repositório, serviços puros (ex.: cálculo de plano de leitura).
- **Data**: DTOs, datasources (remoto/local), implementações de repositório.
- **Presentation**: telas, widgets, `Provider` / `FutureProvider` (Riverpod).
- **Core**: tema, roteamento, DI leve, utilitários, cliente HTTP abstrato.
- **Shared**: widgets reutilizáveis.

## Gerenciamento de estado

**Riverpod** (`flutter_riverpod`): providers para repositórios e dados assíncronos; `StateProvider` para preferências simples (tema).

Alternativas aceitáveis: Bloc/Cubit em features mais complexas (ex.: feed com paginação + cache).

## Navegação

**go_router** com:

- `StatefulShellRoute.indexedStack` para bottom navigation (Início, Bíblia, Planos, Comunidade, Perfil).
- Rotas filhas com `parentNavigatorKey` para fluxos full-screen (leitor, detalhe de plano, estudos, configurações).

## Plano de leitura dinâmico

Lógica em `features/reading_plans/domain/services/reading_plan_progress_calculator.dart`:

- Modos: capítulos/dia fixos, prazo final, duração em dias.
- Recalcula sugestão diária, dias estimados, percentual e “atraso leve” vs progresso ideal.
- `markChaptersRead` atualiza conjunto de capítulos e sessões (base para streak).

O **backend** deve persistir eventos de leitura e estado do plano; o app pode pré-calcular para UX offline e reconciliar com a API.

## Fluxo de telas (resumo)

1. **Splash** → onboarding (primeira vez) ou **Home**.
2. **Onboarding** → marca `SharedPreferences` → Home.
3. **Shell**: Dashboard, lista Bíblia, Planos, Comunidade, Perfil.
4. Atalhos no dashboard: Estudos, Metas, Suporte (rotas sob `/home/...`).
5. **Perfil** → Configurações (tema claro/escuro/sistema).

## Próximos passos (app)

- Implementar `ApiClient` concreto (Dio + interceptors JWT).
- Mapear DTO ↔ entidades nos repositórios.
- Offline: Hive/Isar/SQLite no `ReadingPlanLocalDataSource`.
- Testes de unidade no `ReadingPlanProgressCalculator`.
- Licenciamento e fonte do texto bíblico (bundle vs API).
