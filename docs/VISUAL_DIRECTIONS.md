# Exploração: 3 direções visuais (reset)

Este documento cumpre a fase de exploração **antes** da implementação única. Nenhuma direção copia apps de referência; apenas define matizes de produto distintos.

---

## 1. Warm premium editorial

**Personalidade:** revista devocional, papel de alta gramatura, silêncio e autoridade suave.

| Token | Hex (light) | Uso |
|--------|-------------|-----|
| Canvas | `#FAF7F2` | fundo geral |
| Papel | `#FFFFFF` | cartões |
| Areia | `#E8E0D4` | blocos secundários |
| Tinta | `#1A1A1A` | títulos |
| Cobre | `#9A6B45` | acento principal |
| Grafite suave | `#5C5855` | texto secundário |

**Tipografia:** *Literata* (títulos) + *IBM Plex Sans* (UI) — leitura longa e tom editorial.

**Bottom navigation:** barra **encostada** ao fundo, fundo papel, **linha superior** 1px areia; item ativo com **texto em cobre** e **traço inferior** 2px (sem pílula flutuante).

**Cartões:** borda 1px areia, **sem sombra** ou sombra mínima; opcional **tarja superior** cobre 3px (não lateral).

**Risco:** muito próximo de “devocional tradicional” se o bronze dominar — precisa contraste forte no tipo.

---

## 2. Minimal premium dark–light hybrid *(spiritual-tech)*

**Personalidade:** produto digital contemporâneo, clínico, foco em dados e ritmo.

| Token | Hex (light) | Uso |
|--------|-------------|-----|
| Canvas | `#F4F4F5` | fundo |
| Superfície | `#FFFFFF` | cartões |
| Grafite | `#18181B` | texto |
| **Acento** | `#0D9488` *(teal, não índigo)* | CTAs, links *(substitui roxo/azul)* |
| Névoa | `#A1A1AA` | muted |

**Tipografia:** *Space Grotesk* (headlines) + *Inter* (corpo) — start-up calma, não bancária.

**Bottom navigation:** **monoline**: ícones 24px traço fino, ativo = **preenchimento teal 8%** + ícone teal; labels em caps 10px.

**Cartões:** só **contorno** `#E4E4E7`, radius 12px, **zero** sombra.

**Risco:** pode parecer “genérico SaaS” sem textura emocional suficiente para fé/wellness.

---

## 3. Sophisticated warm modern *(implementada como “Terracota”)*

**Personalidade:** wellness espiritual **maduro**, contraste **mais alto** que o editorial puro, calor sem nostalgia barata.

| Token | Hex (light) | Uso |
|--------|-------------|-----|
| Canvas | `#F5F0E8` | fundo |
| Superfície | `#FFFFFF` | cartões |
| Tinta | `#0F0F0F` | títulos |
| **Terracota** | `#C24B2A` | primário, energia contida |
| **Ouro seco** | `#B8892E` | progresso, badges, links secundários |
| Linha | `#E0D9CE` | divisores e bordas |
| Muted | `#737373` | texto de apoio |

**Tipografia:** *Newsreader* (display/headline) + *Inter* (UI) — contraste claro serif/sans, distinto de Fraunces + Source Sans já usados antes.

**Bottom navigation:** **full-bleed** (largura total), **hairline** superior; item ativo = **círculo** com fundo terracota ~12% + ícone **Lucide peso 500** vs 200 inativo; labels 10px sem pílula externa.

**Cartões:** radius **16px**, sombra **única** suave só em Y; **sem** faixa lateral; hierarquia por tipografia e grid.

**Por que recomendamos esta:** maior **afastamento** da identidade anterior (oliva/pedra/pílula flutuante), **sem roxo**, acento **terracota + ouro** comunica calor premium atual (wellness 2024+), e o layout **claro + anel de progresso** no dashboard muda a composição, não só o tema.

---

## Recomendação

**Implementar a direção 3 — Sophisticated warm modern (“Terracota”).**  
Equilibra emoção (fé/wellness) e **produto digital forte**, com sistema de cor e tipografia **claramente novos** em relação às versões anteriores do app.

---

## Implementação

Código alinhado a esta direção: `lib/core/theme/` (cores, tipografia, tokens), `AppBottomBar` (dock full-width), ícones **Lucide** (`lucide_icons_flutter`), telas Home, Bíblia, Planos, Criar plano e Comunidade recompostas.

Documento de tokens de componentes atualizado: `DESIGN_SYSTEM.md`.
