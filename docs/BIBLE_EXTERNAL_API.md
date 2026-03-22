# Bíblia no app — integração com a API

Este ficheiro resume o comportamento **do ponto de vista do Flutter**. A **implementação** (EF Core, ABíblia Digital, cache em SQL Server, `BibleController`) está apenas no repositório da API:

**[thiago-dmg/BibleReader.Api.Vps](https://github.com/thiago-dmg/BibleReader.Api.Vps)** (pasta local típica: `C:\backend`).

## Comportamento esperado

- Primeira leitura de um capítulo (ex. ACF): a API pode buscar na [ABíblia Digital](https://www.abibliadigital.com.br/) e **gravar** versículos no banco.
- Leituras seguintes: o texto vem do **banco**, sem depender da API externa a cada request.
- Endpoints usados pelo app: `GET /v1/bible/versions`, `books`, `chapters` (query ou `books/{livro}/chapters/{n}`), `…/verses/{v}`.

## Configuração

`ExternalBible`, `OnlineLazyVersionCodes`, etc. são definidos no **`appsettings`** do projeto da API (não neste repo).

Para detalhes de camadas (`IBibleExternalProvider`, `PersistentBibleTextProvider`, migrations), consulte o código e o `README`/docs no **BibleReader.Api.Vps**.
