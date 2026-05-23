# dotfiles

Meus dotfiles para Debian usando `startx` e o desktop suckless que eu uso no dia
a dia. Isto nao tenta ser uma instalacao generica de Linux; e a configuracao de
usuario que deixa uma maquina nova parecida com a minha.

O codigo dos programas suckless fica separado:

```sh
git clone git@github.com:vtr88/suckless.git ~/Documentos/c/suckless
```

## Sessao

O X sobe por `.xinitrc`. Por padrao ele inicia `dwm`; se eu precisar voltar para
Openbox em alguma emergencia, uso:

```sh
WM=openbox startx
```

Servicos que a sessao inicia:

- `picom`, `dunst`, `feh`, `keynav`, `flameshot`
- `slstatus` para texto da barra do `dwm`
- `nm-applet`, `volumeicon`, `diodon`
- `xfce4-power-manager` e agente de policykit

## Programas Base

O desktop principal vem do repo suckless:

- `dwm`: window manager
- `st`: terminal
- `dmenu`: launcher
- `slstatus`: status da barra
- `slock`: lock screen
- `keynav`: navegacao do mouse pelo teclado

Neste repo ficam os arquivos ao redor disso: `zsh`, `tmux`, `lf`, `nvim`,
`picom`, `dunst`, `feh`, `git`, mail/news/irc e temas.

## O Que E Versionado

- `.zshrc`: zsh sem framework, historico em `~/.config/zsh/history` e prompt gruvbox com estado de git
- `.xinitrc`: inicializacao da sessao X
- `.Xresources`: recursos de X ainda usados por clientes como NetHack
- `.config/lf/`: `lf` com tema gruvbox e preview por `ueberzug`
- `.config/keynav/keynavrc`: config do keynav em caminho XDG
- `.config/feh/`: wallpaper
- `.config/picom/`, `.config/dunst/`: compositor e notificacoes
- `.config/nvim/`, `.config/tmux/`, `.config/git/`: editor, tmux e git
- `.config/mutt/`, `.config/newsboat/`, `.config/irssi/`: configs publicas, sem senhas
- `.themes/Gruvbox/`, `.gtkrc-2.0`, `.config/gtk-3.0/`: tema GTK
- `.nethackrc` e `.nethackrcx11`

## Install

O script instala um baseline de pacotes Debian e copia os arquivos versionados
para `$HOME`, fazendo backup do que seria sobrescrito em
`~/.dotfiles-backup/<timestamp>/`.

```sh
./install
```

Depois do `install`, ainda falta o que nao pertence a este repo:

- compilar e instalar `dwm`, `st`, `dmenu`, `slstatus`, `slock` e `keynav` pelo repo suckless
- restaurar localmente o `.config/mutt/.mbsyncrc` privado
- revisar qualquer placeholder pessoal em mail, newsboat, IRC, SSH e VPN
- garantir que o shell do usuario seja `zsh`
