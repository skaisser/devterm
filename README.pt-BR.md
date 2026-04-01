# DevTerm

> Um comando. Terminal de desenvolvedor perfeito no macOS.

**Opinativo. Dark. Inteligente.** Uma configuracao completa de terminal para macOS que instala em minutos e simplesmente funciona.
Escolha o que precisa — terminal, editor, IA, PHP, Node, DevOps — tudo configurado e pronto pra usar.

[![Instalar](https://img.shields.io/badge/Instalar-bash_%3C(curl_devterm.skaisser.dev)-blue?style=for-the-badge)](#instalar) [![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-green?style=for-the-badge)](LICENSE) [![macOS](https://img.shields.io/badge/macOS-12%2B-lightgrey?style=for-the-badge&logo=apple)](https://github.com/skaisser/devterm) [![Shell](https://img.shields.io/badge/Shell-Zsh-informational?style=for-the-badge&logo=gnu-bash)](https://github.com/skaisser/devterm)

[![GitHub stars](https://img.shields.io/github/stars/skaisser/devterm?style=social)](https://github.com/skaisser/devterm/stargazers) [![GitHub forks](https://img.shields.io/github/forks/skaisser/devterm?style=social)](https://github.com/skaisser/devterm/network/members) [![GitHub issues](https://img.shields.io/github/issues/skaisser/devterm)](https://github.com/skaisser/devterm/issues) [![GitHub last commit](https://img.shields.io/github/last-commit/skaisser/devterm)](https://github.com/skaisser/devterm/commits/main) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/skaisser/devterm/pulls)

> macOS 12+ · Apple Silicon + Intel · Funciona em qualquer terminal

[:us: Read in English](README.md)

![devterm installer com banner colorido em gradiente](imgs/dev-terminal-installer.png)

---

## Por que o DevTerm?

Configurar um Mac novo pra desenvolver significa horas instalando ferramentas, configurando shell, escolhendo fontes e conectando plugins. O DevTerm faz tudo isso em um comando:

- **Tema inteligente por janela** — abra 4 terminais e sempre saiba qual e qual
- **Modo perigo SSH** — a janela fica vermelha quando voce esta num servidor remoto
- **Prompt Oh My Posh** — branch do git, versoes PHP/Node, horario — so quando relevante
- **50+ atalhos** — git, Laravel, navegacao, sistema — tudo pre-configurado
- **Instalador idempotente** — rode de novo a qualquer momento, so instala o que falta
- **Zero dependencias** — funciona num Mac zerado direto da caixa

---

## Instalar

### Passo 1: Abra o Terminal

Abra o **Terminal** no seu Mac. Voce encontra em:
- `Aplicativos > Utilitarios > Terminal`
- Ou aperte `Cmd + Espaco`, digite **Terminal** e aperte Enter

### Passo 2: Copie e cole esse comando

```bash
bash <(curl -fsSL devterm.skaisser.dev)
```

Copie a linha acima, cole no Terminal e aperte **Enter**.

### Passo 3: Siga o assistente

1. Vai pedir sua **senha do Mac** (voce nao vai ver enquanto digita — e normal, so digite e aperte Enter)
2. O assistente aparece — aperte **Enter** pra instalar tudo (recomendado), ou digite **n** pra escolher categoria por categoria
3. Espere terminar — a primeira vez leva ~15 minutos num Mac zerado, muito mais rapido nas proximas vezes

### Passo 4: Configure o iTerm2

Depois da instalacao, uma janela do Finder abre com os arquivos do tema.

1. **De dois cliques em `skaisser.itermcolors`** — isso importa o tema de cores
2. Abra o **iTerm2** (acabou de ser instalado — esta na pasta Aplicativos)
3. Va em `Settings > Profiles > Colors > Color Presets` e escolha **skaisser**
4. Va em `Settings > Profiles > Text > Font` e escolha **MesloLGS Nerd Font**, tamanho **18**
5. Abra uma **nova aba** — pronto! Tudo funciona agora

### Outras formas de instalar

```bash
# Clonar e rodar localmente (se voce ja tem git)
git clone https://github.com/skaisser/devterm && cd devterm && ./install.sh

# Ver o que esta instalado sem mudar nada
./install.sh --check

# Remover o devterm e restaurar seu .zshrc anterior
./install.sh --uninstall
```

> **Primeira vez num Mac zerado?** O Xcode Command Line Tools e o Homebrew sao instalados automaticamente. O instalador cuida de tudo — nenhum passo manual necessario.

---

## Funcionalidades

### O Tema Inteligente

Cada janela do terminal ganha uma cor de fundo escura unica baseada no TTY — sem configuracao. Abra varias janelas e sempre saiba qual e qual de relance.

<table>
  <tr>
    <td align="center"><img src="imgs/navy-theme.png" alt="Tema Navy"/></td>
    <td align="center"><img src="imgs/green-theme.png" alt="Tema Verde"/></td>
    <td align="center"><img src="imgs/violet-theme.png" alt="Tema Violeta"/></td>
  </tr>
  <tr>
    <td align="center">Indigo <code>#1a1a38</code></td>
    <td align="center">Verde floresta <code>#1a2a1a</code></td>
    <td align="center">Violeta profundo <code>#261426</code></td>
  </tr>
</table>

| Janela | Cor                          |
| ------ | ---------------------------- |
| 1      | Azul marinho `#1e2040`       |
| 2      | Verde floresta `#1a2a1a`     |
| 3      | Borgonha `#2a1818`           |
| 4      | Indigo `#1a1a38`             |
| 5      | Azul-petróleo `#0f2828`      |
| 6      | Ameixa escuro `#1a0e2a`      |
| 7      | Violeta profundo `#261426`   |
| 8      | Esmeralda `#0e2a1a`          |

### Modo Perigo SSH

```bash
ssh usuario@servidor  # a janela inteira fica vermelha pra voce nunca esquecer que esta em producao
```

![Terminal SSH com fundo vermelho](imgs/ssh-terminal-red.png)

Restaura a cor original automaticamente quando a sessao encerra.

### O Prompt

![Prompt do terminal mostrando versao PHP, versao Node, horario e branch do git](imgs/dev-terminal-php-node-time-branch.png)

```
 myapp   feat/login ~2 +1 ↑1      8.3.0   20.11.0   03:14:22
>>
```

| Segmento        | Descricao                                                          |
| --------------- | ------------------------------------------------------------------ |
| **Caminho**     | Encurtado: `~/Sites/myapp` → `myapp`                               |
| **Git**         | Branch, modificados (`~`), staged (`+`), a frente (`↑`), atras (`↓`) |
| **PHP**         | So aparece dentro de projetos PHP                                   |
| **Node**        | So aparece quando tem `package.json`                                |
| **Go / Python** | Aparece quando relevante                                            |
| **Horario**     | Alinhado a direita                                                  |

### Statusline do Claude Code

![Statusline do Claude Code mostrando modelo, barra de contexto, tokens e pasta](imgs/claude-code-status-line.png)

Contexto ao vivo direto no seu prompt — modelo, barra de progresso visual (verde pra amarelo pra vermelho), contagem de tokens, projeto atual.

---

## O que e Instalado

O instalador mostra um **seletor de categorias** — aperte Enter pra instalar tudo (recomendado) ou digite **n** pra escolher individualmente. As ferramentas core sao sempre instaladas.

### Core (sempre instalado)

| Ferramenta             | O que faz                                                                                           |
| ---------------------- | --------------------------------------------------------------------------------------------------- |
| **iTerm2**             | Emulador de terminal moderno pro macOS — suporta temas inteligentes, cores por janela e modo SSH.   |
| **Nerd Fonts**         | MesloLGS NF + Fira Code NF — fontes com icones necessarios pro prompt e listagem de arquivos.       |
| **Oh My Posh + tema**  | Motor de prompt com o tema customizado skaisser — mostra caminho, branch git, versoes e horario.    |
| **zoxide**             | Substituto inteligente do `cd` — aprende seus diretorios mais usados. Digite `z myapp` pra pular.   |
| **Configuracao zshrc** | Configuracao completa do shell com 50+ atalhos, funcoes, cores inteligentes e plugins. Seu `.zshrc` existente e salvo automaticamente. |

### Categorias opcionais

Todas pre-selecionadas por padrao — so aperte Enter pra instalar tudo.

| Categoria | Ferramentas |
| --------- | ----------- |
| **Editor** | VS Code (app desktop + CLI `code`) |
| **Ferramentas CLI** | eza (`ls` moderno), fzf (buscador fuzzy), gh (GitHub CLI), htop, lazygit, wget |
| **Plugins Zsh** | zsh-completions, zsh-autosuggestions, fast-syntax-highlighting, zsh-history-substring-search |
| **Claude Code** | Assistente de codigo com IA + statusline ao vivo |
| **PHP / Laravel** | Composer, Laravel Herd (serve `projeto.test` com HTTPS, inclui PHP + MySQL) |
| **JavaScript** | nvm, Node 22 + 18, Bun, Yarn (pulado se Laravel Herd gerencia o Node) |
| **DevOps** | rclone (sincronizacao de arquivos na nuvem — S3, Google Drive, Backblaze, 70+ provedores) |
| **Extras** | tmux (multiplexador de terminal), cmatrix (chuva Matrix) |

---

## Referencia Rapida

<details>
<summary><strong>Navegacao</strong></summary>

| Comando          |                                |
| ---------------- | ------------------------------ |
| `..` `..2` `..3` | Subir 1–3 niveis               |
| `-`              | Diretorio anterior             |
| `sites`          | Pular pra `~/Sites`            |
| `z myapp`        | Pular pra qualquer lugar       |
| `mkcd mydir`     | Criar + entrar no diretorio    |
| `cl`             | Limpar                         |

</details>

<details>
<summary><strong>Git</strong></summary>

| Comando        |                                           |
| -------------- | ----------------------------------------- |
| `gst`          | `git status`                              |
| `gd` / `gds`   | diff / diff staged                        |
| `gco` / `gcb`  | checkout / nova branch                    |
| `gadd`         | Add interativo por hunk                   |
| `gp` / `gpush` | pull / push                               |
| `glog`         | Log bonito em grafo                       |
| `lazygit`      | TUI completa — stage, resolve conflitos   |

</details>

<details>
<summary><strong>Listagem de Arquivos</strong></summary>

| Comando       |                                  |
| ------------- | -------------------------------- |
| `ls`          | Icones + status do git           |
| `l` / `ll`    | Lista longa / com permissoes     |
| `lt` / `la`   | Arvore 2 niveis / arvore completa |
| `dud` / `duf` | Uso de disco                     |

</details>

<details>
<summary><strong>PHP / Laravel</strong></summary>

| Comando      |                              |
| ------------ | ---------------------------- |
| `art`        | `php artisan`                |
| `pt` / `ptp` | Pest / Pest paralelo         |
| `tc` / `tcq` | Coverage / coverage paralelo |
| `cda`        | `composer dump-autoload`     |
| `hfix`       | Reiniciar Laravel Herd       |

</details>

<details>
<summary><strong>Claude Code</strong></summary>

| Comando  |                                    |
| -------- | ---------------------------------- |
| `claude` | Iniciar Claude Code                |
| `claudd` | Pular confirmacao de permissoes    |

</details>

<details>
<summary><strong>Sistema</strong></summary>

| Comando                 |                                    |
| ----------------------- | ---------------------------------- |
| `ports`                 | Todas as portas em uso             |
| `psg nginx`             | Buscar processos rodando           |
| `killp nginx`           | Matar por nome (com confirmacao)   |
| `memusage` / `cpuusage` | Maiores consumidores               |
| `extract file.tar.gz`   | Extrair qualquer arquivo           |
| `weather "Paris"`       | Clima atual                        |

</details>

<details>
<summary><strong>Buscador Fuzzy (fzf)</strong></summary>

| Atalho   |                               |
| -------- | ----------------------------- |
| `Ctrl+R` | Buscar historico de comandos  |
| `Ctrl+T` | Buscar arquivos               |
| `Alt+C`  | Entrar em qualquer diretorio  |

</details>

---

## Personalizacao

### Mudar cores das janelas

Edite `bg_colors` no `~/.zshrc`:

```bash
local bg_colors=(
    "1e2040"    # janela 1 — qualquer cor hex
    "1a2a1a"    # janela 2
    ...
)
```

### Configuracao da sua maquina

O arquivo `~/.zshrc.local` e criado automaticamente na primeira instalacao com exemplos comentados.
Ele e carregado no final do `.zshrc` e nunca e sobrescrito em reinstalacoes.

Use pra: chaves de API, atalhos do trabalho, agente SSH, atalhos Docker, PATH customizado.

---

## Requisitos

- macOS 12+ (Monterey ou posterior)
- Apple Silicon ou Intel
- Conexao com a internet
- Qualquer terminal (Terminal.app funciona — iTerm2 e instalado automaticamente)

Todo o resto e instalado automaticamente. Nenhum pre-requisito manual.

---

## Contribuindo

Contribuicoes sao bem-vindas! Fique a vontade pra abrir issues ou enviar pull requests.

1. Faca um fork do repositorio
2. Crie sua branch (`git checkout -b feat/minha-feature`)
3. Faca seus commits
4. Faca push pra branch (`git push origin feat/minha-feature`)
5. Abra um Pull Request

---

## Licenca

[Apache 2.0](LICENSE) — use livremente, compartilhe abertamente.

---

Feito por [Shirleyson Kaisser](https://github.com/skaisser)
