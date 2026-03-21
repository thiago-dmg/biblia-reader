# Vários projetos na mesma VPS (Hostinger / Ubuntu)

Guia prático para conviver **Minha Rotina Kids** (MySQL + app que você já tem) com **novos projetos** (ex.: API **BibliaReader** em .NET + **PostgreSQL**) no mesmo servidor `72.61.35.190`.

## Ideia central

- **Um IP, vários serviços**: cada app escuta em **porta interna** (ex.: Kids em `3000`, API Biblia em `5001`, MySQL em `3306`, Postgres em `5432` só na rede Docker).
- **Nginx (ou Caddy)** na frente: recebe `https://kids.seudominio.com` e `https://api.seudominio.com`, termina SSL e **encaminha** para `127.0.0.1:porta`.
- **Docker** (Hostinger tem *Gerenciador Docker*): isola dependências; o projeto Kids pode continuar como está; o BibliaReader pode subir com o `docker-compose.yml` do repositório `C:\backend`.

## O que não misturar

| Projeto        | Banco típico | Observação |
|----------------|--------------|------------|
| Minha Rotina Kids | **MySQL**    | Mantém como está. |
| BibliaReader API  | **PostgreSQL** | Outro motor; outro container ou instalação. |

Não é obrigatório migrar o Kids para Docker só para adicionar o BibliaReader.

## Passo a passo (alto nível)

### 1. DNS (Hostinger)

- Crie **subdomínios** apontando para o IP da VPS (A record), por exemplo:
  - `kids.seudominio.com` → app existente
  - `api.seudominio.com` → nova API
- Propagação pode levar alguns minutos.

### 2. Firewall (UFW) na VPS

Abra só o necessário:

```bash
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

Não exponha **3306** (MySQL) nem **5432** (Postgres) para a internet; só **localhost** ou rede Docker.

### 3. Nginx como proxy reverso

Instale Nginx e um **server block** por site:

- `server_name kids.seudominio.com` → `proxy_pass http://127.0.0.1:PORTA_DO_KIDS;`
- `server_name api.seudominio.com` → `proxy_pass http://127.0.0.1:5001;` (se a API Biblia estiver em `5001` como no `docker-compose`).

Exemplo mínimo (HTTPS depois do Certbot):

```nginx
server {
    listen 80;
    server_name api.seudominio.com;
    location / {
        proxy_pass http://127.0.0.1:5001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Depois: `sudo certbot --nginx -d api.seudominio.com`.

### 4. Subir o BibliaReader com Docker (na VPS)

No servidor (via SSH):

```bash
cd /caminho/para/backend   # clone do repositório
cp .env.example .env       # preencha POSTGRES_PASSWORD e JWT_KEY
docker compose up -d
```

- A API fica em **`127.0.0.1:5001`** → só o Nginx na porta 443 acessa de fora.
- **Migrações EF** (uma vez, com a connection string do Postgres que está no `.env`):

```bash
# Na sua máquina de desenvolvimento OU na VPS com SDK instalado:
dotnet ef database update --project src/BibliaReader.Infrastructure --startup-project src/BibliaReader.Api
```

(Configure `ConnectionStrings__DefaultConnection` temporariamente para o host/porta do Postgres na VPS, ou use túnel SSH.)

### 5. Projeto Kids (já em produção)

- Se já roda com **systemd + Node/PHP/etc.**, mantenha.
- Se quiser padronizar tudo em Docker no futuro, migre aos poucos; não é requisito para “subir outro projeto”.

## Capacidade da sua VPS

Pelo painel: CPU e RAM com folga, disco **~94 GB livres**. Vários containers + Nginx costumam caber bem; monitore com `docker stats` e `htop`.

## Checklist rápido

- [ ] Subdomínio apontando para o IP  
- [ ] Nginx (ou Caddy) com `proxy_pass` para cada app  
- [ ] Certbot (Let’s Encrypt) para HTTPS  
- [ ] UFW: 22, 80, 443 — sem abrir bancos  
- [ ] Senhas fortes em `.env` e `Jwt:Key` ≥ 32 caracteres  
- [ ] Migrações aplicadas no Postgres antes de ir a produção  

## Arquivos no repositório

- `C:\backend\Dockerfile` — imagem da API .NET 8  
- `C:\backend\docker-compose.yml` — API + Postgres (exemplo)  
- `C:\backend\.env.example` — variáveis necessárias  

Ajuste portas e nomes de container se já existirem conflitos com o Kids.
