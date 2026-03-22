# Repositório GitHub — [thiago-dmg/biblia-reader](https://github.com/thiago-dmg/biblia-reader)

Repositório **apenas Flutter** (app mobile).

## Backend e deploy da API

A API .NET **não** fica neste repositório.

| O quê | Onde |
|-------|------|
| Código da API (.NET 8), EF, migrations, deploy VPS | **[thiago-dmg/BibleReader.Api.Vps](https://github.com/thiago-dmg/BibleReader.Api.Vps)** |
| Pasta local típica | `C:\backend` (clone do repositório acima) |
| CI/CD da API | GitHub Actions **no repositório da API** |

Este repo pode ter workflows só para **Flutter** (build APK/IPA, etc.) se você adicionar depois.

## Primeiro push (Flutter)

```bash
cd c:\front\biblia_reader
git init
git branch -M main
git remote add origin https://github.com/thiago-dmg/biblia-reader.git
git add .
git status
git commit -m "chore: app Flutter Biblia Reader"
git push -u origin main
```

## Secrets

Secrets de **SSH / deploy da VPS** pertencem ao repositório **BibleReader.Api.Vps**, não a este.
