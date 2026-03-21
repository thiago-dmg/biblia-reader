# Backend recomendado — .NET (C#)

## 0. Implementação no repositório (`C:\backend`)

A API **BibliaReader** já existe na pasta **`C:\backend`** (solução `BibliaReader.sln`, .NET 8, PostgreSQL, JWT). Este documento descreve o **contrato alvo**; nem todos os endpoints abaixo estão implementados — compare com os controllers em `src/BibliaReader.Api/Controllers/V1/`.

| Área | Status típico hoje |
|------|---------------------|
| `POST /v1/auth/register`, `POST /v1/auth/login`, `POST /v1/auth/logout` | Implementados |
| `POST /v1/auth/refresh` | Stub **501** (refresh token pendente) |
| `GET /v1/bible/versions`, `GET /v1/bible/books` | Implementados (respostas mínimas / seed) |
| `GET /v1/support/faq` | Implementado |
| `GET/POST … /v1/reading-plans`, `…/events`, `…/snapshot` | Implementados (plano com **Guid** por usuário) |
| `GET/PUT/PATCH /v1/me/reading-progress` | **Implementado** — tabela `UserCanonicalReadingProgress` (JSONB `CompletedChapterIdsJson`, planos `one-year` / `six-months` / `ninety-days`) |
| Comunidade, metas, estudos (corpo amplo do §4) | **Roadmap** |

**Rodar localmente:** ver `C:\backend\README.md` (`dotnet run` em `src/BibliaReader.Api`, Swagger, EF migrations).

---

## 1. Arquitetura sugerida

- **ASP.NET Core 8+ Web API** (minimal APIs ou controllers).
- Camadas:
  - **Api**: controllers, filtros, auth, validação (FluentValidation).
  - **Application**: casos de uso, DTOs de comando/consulta, orquestração.
  - **Domain**: entidades, enums, domain services (ex.: recálculo de plano — espelhar regras do Flutter ou centralizar aqui).
  - **Infrastructure**: EF Core, repositórios, integrações (e-mail, push), armazenamento de mídia.
- **PostgreSQL** como banco principal (JSONB para metadados flexíveis se necessário).
- **Redis** (opcional): cache de feed, rate limiting.
- **Hangfire / Quartz** (opcional): lembretes, fechamento de metas diárias.

## 2. Entidades principais (domínio)

| Entidade | Descrição |
|----------|-----------|
| `User` | Conta, perfil público, configurações. |
| `RefreshToken` | Rotação de tokens. |
| `BibleVersion` | Versão da tradução (ACF, NVI, etc.). |
| `BibleBook`, `BibleChapter` | Catálogo (ou referência estática + IDs). |
| `ReadingPlan` | Plano do usuário: escopo, modo de ritmo, datas, estado. |
| `ReadingPlanDay` / `ReadingEvent` | Evento atômico: usuário leu capítulo X em Y. |
| `Goal` | Meta (diária, semanal, livro até data, streak). |
| `Study`, `StudyCategory`, `StudyLesson` | Conteúdo editorial. |
| `UserStudyProgress` | Lição concluída, favoritos. |
| `Post` | Publicação na comunidade. |
| `PostLike`, `PostComment` | Engajamento. |
| `Follow` | Seguir usuário. |
| `SavedPost` | Salvar publicação. |
| `SupportTicket`, `TicketMessage` | Chamados. |
| `FaqItem` | FAQ administrável. |

## 3. Relacionamentos (resumo)

- `User` 1:N `ReadingPlan`, `Goal`, `Post`, `SupportTicket`, `ReadingEvent`.
- `ReadingPlan` 1:N `ReadingEvent` (ou agregação por dia em `ReadingPlanDay`).
- `Study` N:M `StudyCategory` (tabela de junção).
- `UserStudyProgress` N:1 `User`, N:1 `StudyLesson`.
- `Post` N:1 `User`; `PostComment` N:1 `Post`, opcional self-reference para respostas.
- `Follow` (followerId, followingId) unique.

## 4. Endpoints (REST v1) — contrato inicial

### Auth
- `POST /v1/auth/register`
- `POST /v1/auth/login`
- `POST /v1/auth/refresh`
- `POST /v1/auth/logout`

### Usuário / perfil
- `GET /v1/me`
- `PATCH /v1/me`
- `GET /v1/users/{id}` (perfil público)
- `POST /v1/users/{id}/follow`
- `DELETE /v1/users/{id}/follow`

### Bíblia (catálogo + texto)
- `GET /v1/bible/versions`
- `GET /v1/bible/books?versionId=`
- `GET /v1/bible/chapters/{chapterId}` (texto, notas — conforme licença)

### Planos de leitura
- `GET /v1/reading-plans`
- `POST /v1/reading-plans`
- `GET /v1/reading-plans/{id}`
- `PATCH /v1/reading-plans/{id}` (pausar, ajustar ritmo/prazo)
- `DELETE /v1/reading-plans/{id}`
- `POST /v1/reading-plans/{id}/events` (registrar capítulos lidos)
- `GET /v1/reading-plans/{id}/snapshot` (opcional: servidor devolve progresso calculado)

### Progresso de leitura (alinhado ao app Flutter *divine_insight_compass*)
Modelo único por usuário, espelhando `ReadingProgressController` + `reading_plan_logic.dart` (regras do web `readingPlans.ts`):

- **`GET /v1/me/reading-progress`** — devolve snapshot para sync e outras telas.
- **`PUT /v1/me/reading-progress`** — substitui o estado (ex.: primeiro login no dispositivo).
- **`PATCH /v1/me/reading-progress`** — merge parcial (ex.: só `completedChapterIds` ou troca de plano).

**IDs de plano fixos** (não usar UUID para o catálogo pré-definido):

| `selectedPlanId` | Nome | Dias | Caps/dia |
|------------------|------|------|----------|
| `one-year` | Bíblia em 1 ano | 365 | 4 |
| `six-months` | Bíblia em 6 meses | 180 | 7 |
| `ninety-days` | Bíblia em 90 dias | 90 | 13 |

**Catálogo canônico**: 1189 capítulos na mesma ordem do app (AT completo + NT completo, por livro). Cada capítulo é identificado por **`chapterKey`** = `{abbrev}-{n}` em minúsculas (ex.: `gn-1`, `sl-3`, `mt-5`), onde `abbrev` coincide com o catálogo de livros da API/app.

**Regras**:
- **Progresso global**: `completedChapterIds` é um conjunto de `chapterKey` (sem duplicar). O percentual exibido pode ser `count / 1189` (como na UI atual) ou, em planos futuros, restrito ao escopo do plano — documentar a regra escolhida no backend.
- **Troca de plano**: ao mudar `selectedPlanId`, o app cliente define **`planStartedAt`** = agora (UTC) e **mantém** `completedChapterIds` (mesma regra do Flutter: progresso por capítulo não some).
- **Dia do calendário**: `dayNumber = clamp(diffDias(planStartedAt, dataLocal) + 1, 1, totalDaysDoPlano)`; a lista do dia vem de fatiar o array canônico em blocos de `chaptersPerDay` (implementação espelhada em `generateReadings`).

Ver exemplo JSON abaixo na seção 5.

### Metas
- `GET /v1/goals`
- `POST /v1/goals`
- `PATCH /v1/goals/{id}`
- `DELETE /v1/goals/{id}`

### Estudos (fora do escopo do app atual; reservado)
- `GET /v1/studies?category=&theme=`
- `GET /v1/studies/{id}`
- `POST /v1/studies/{id}/progress` (lição concluída)
- `GET /v1/studies/favorites`
- `POST /v1/studies/{id}/favorite`

### Comunidade
- `GET /v1/community/feed?cursor=`
- `POST /v1/community/posts`
- `GET /v1/community/posts/{id}`
- `POST /v1/community/posts/{id}/like`
- `DELETE /v1/community/posts/{id}/like`
- `GET /v1/community/posts/{id}/comments`
- `POST /v1/community/posts/{id}/comments`
- `POST /v1/community/posts/{id}/save`
- `DELETE /v1/community/posts/{id}/save`

### Suporte
- `GET /v1/support/faq`
- `POST /v1/support/tickets`
- `GET /v1/support/tickets`
- `GET /v1/support/tickets/{id}`
- `POST /v1/support/tickets/{id}/messages`

## 5. Exemplos JSON

### POST /v1/reading-plans
```json
{
  "title": "NT em 120 dias",
  "scopeType": "NewTestament",
  "bookIds": [],
  "paceMode": "FinishByDate",
  "chaptersPerDay": null,
  "targetEndDate": "2025-08-01",
  "durationDays": null,
  "bibleVersionId": "nvi-2011"
}
```

### Resposta 201
```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "title": "NT em 120 dias",
  "totalChapters": 260,
  "completedChapters": 0,
  "paceMode": "FinishByDate",
  "targetEndDate": "2025-08-01",
  "createdAt": "2025-03-21T12:00:00Z"
}
```

### GET /v1/me/reading-progress — resposta 200
```json
{
  "selectedPlanId": "one-year",
  "planStartedAt": "2026-01-01T00:00:00.000Z",
  "completedChapterIds": ["gn-1", "gn-2", "gn-3", "gn-4"],
  "updatedAt": "2026-03-20T18:00:00.000Z"
}
```

### PATCH /v1/me/reading-progress — corpo (exemplo)
```json
{
  "selectedPlanId": "six-months",
  "planStartedAt": "2026-03-20T12:00:00.000Z",
  "completedChapterIds": ["gn-1", "gn-2"]
}
```
Troca só de capítulos concluídos:
```json
{
  "completedChapterIds": ["gn-1", "gn-2", "gn-3", "gn-4", "gn-5"]
}
```

### POST /v1/reading-plans/{id}/events
```json
{
  "occurredAt": "2025-03-21T22:30:00Z",
  "chapterKeys": ["mt-5", "mt-6"]
}
```
*(Preferir o mesmo formato `chapterKey` `{abbrev}-{n}` que o app Flutter; chaves tipo `MAT:5` são legado genérico — normalizar no backend.)*

### Resposta 200 (snapshot)
```json
{
  "planId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "percentComplete": 0.12,
  "remainingChapters": 229,
  "suggestedChaptersToday": 3,
  "estimatedDaysRemaining": 98,
  "effectiveTargetEnd": "2025-08-01",
  "isBehindSchedule": false,
  "streakDays": 5
}
```

## 6. Regras de negócio principais

- **Plano**: escopo resolve para conjunto finito de `chapterKey`; progresso = cardinalidade lida / total.
- **Ritmo**: se `FinishByDate`, capítulos/dia sugeridos = ceil(restante / dias úteis até prazo); se usuário atrasa, backend pode registrar `scheduleDeviation` opcional.
- **Eventos idempotentes**: mesmo capítulo não conta duas vezes no mesmo plano.
- **Comunidade**: moderação (report), limite de caracteres, anti-spam.
- **Streak**: sequência de dias com ≥1 evento de leitura (timezone do usuário).

## 7. Backend vs frontend

| Responsabilidade | Preferência |
|------------------|-------------|
| Fonte da verdade de leitura, ACL, moderação | Backend |
| Cálculo de preview offline, animações, tema | Frontend |
| Texto bíblico licenciado | Backend/CDN com controle de acesso |
| Feed timeline curada + paginação | Backend |
| Validação final de regras | Backend |

## 8. Autenticação

- **JWT** (access short-lived + refresh) ou **OpenIddict** / **IdentityServer** pattern.
- Opcional: login social (Google/Apple) via external providers no ASP.NET Identity.
- Mobile: armazenar refresh em **secure storage** (Flutter).

## 9. Banco de dados

- **PostgreSQL** + **EF Core**.
- Índices: `(UserId, OccurredAt)` em `ReadingEvents`; `(PostId, CreatedAt)` em `Comments`; `(FollowerId, FollowingId)` unique.
- Migrações versionadas; dados de catálogo bíblico podem ser **seed** ou tabela somente leitura.

## 10. Evolução

- Versionamento de API `/v1`, `/v2`.
- Feature flags para módulos (comunidade beta).
- Event sourcing opcional para planos (auditoria de remarcações).
