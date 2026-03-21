# Repositório GitHub — [thiago-dmg/biblia-reader](https://github.com/thiago-dmg/biblia-reader)

Monorepo:

| Pasta | Conteúdo |
|-------|----------|
| Raiz (`lib/`, `pubspec.yaml`, …) | App **Flutter** |
| `api/` | API **.NET 8** (BibliaReader), espelho da solução em `C:\backend` |
| `.github/workflows/deploy-api.yml` | CI/CD: publish + deploy na VPS (systemd) |

## Primeiro push (na sua máquina)

```bash
cd c:\front\biblia_reader
git init
git branch -M main
git remote add origin https://github.com/thiago-dmg/biblia-reader.git
git add .
git status
git commit -m "chore: Flutter app + API .NET + GitHub Actions deploy"
git push -u origin main
```

Se o remoto já existir com README vazio:

```bash
git pull origin main --allow-unrelated-histories
# resolva conflito se houver, depois:
git push -u origin main
```

## Atualizar só a API localmente

Se você continua editando em `C:\backend`, sincronize para o monorepo antes do commit:

```powershell
robocopy C:\backend c:\front\biblia_reader\api /E /XD bin obj .vs .git .github
```

## Secrets no GitHub

No repositório: **Settings → Secrets and variables → Actions**, adicione (iguais ao Minha Rotina):

- `VPS_SSH_HOST`
- `VPS_SSH_USER`
- `VPS_SSH_KEY`

O workflow **Deploy API to VPS** roda em push em `main` quando há mudanças em `api/**` ou manualmente em **Actions → Run workflow**.

## App Flutter

O workflow atual **não** gera APK/IPA; só publica a API. Build mobile continua local ou adicione outro workflow depois.
