dotfiles
========

Este repositorio guarda meus dotfiles de usuario para Debian, `startx` e o
desktop suckless que uso no dia a dia.

Nao e uma instalacao generica de Linux. A ideia e deixar uma maquina nova
parecida com a minha, com backups antes de sobrescrever arquivos existentes.

Arquivos
--------
- `.xinitrc`: sessao X iniciada por `startx`.
- `.zshrc`: shell sem framework, historico em XDG e prompt gruvbox.
- `.Xresources`: recursos X usados por clientes antigos.
- `.config/nvim`, `.config/tmux` e `.config/git`: editor, tmux e git.
- `.config/lf`: file manager com preview.
- `.config/picom`, `.config/dunst` e `.config/feh`: compositor, notificacoes e wallpaper.
- `.config/mutt`, `.config/newsboat` e `.config/irssi`: mail, feeds e IRC sem senhas.
- `.config/keynav`: configuracao XDG do keynav.
- `.themes/Gruvbox`, `.gtkrc-2.0` e `.config/gtk-3.0`: tema GTK.
- `.nethackrc` e `.nethackrcx11`: configuracao do NetHack.

Dependencias Debian
-------------------
O script `install` instala o baseline que estes dotfiles esperam: X, zsh,
tmux, neovim, lf, picom, dunst, feh, mail/news/IRC, utilitarios de desktop e
fontes.

As ferramentas suckless ficam em outro repositorio:

    git clone git@github.com:vtr88/suckless.git ~/Documentos/c/suckless

Como instalar
-------------
Clone este repositorio e rode:

    ./install

O script copia os arquivos versionados para `$HOME` e salva backups em:

    ~/.dotfiles-backup/<timestamp>/

Sessao X
--------
O fluxo normal e iniciar com:

    startx

Por padrao, `.xinitrc` sobe o `dwm`. Para usar Openbox em uma emergencia:

    WM=openbox startx

Depois do install
-----------------
- Compile e instale `dwm`, `st`, `dmenu`, `slstatus`, `slock` e `keynav` pelo
  repositorio `suckless`.
- Restaure localmente o `.config/mutt/.mbsyncrc`, que nao e versionado.
- Revise placeholders pessoais em mail, feeds, IRC, SSH e VPN.
- Garanta que o shell do usuario seja `zsh`.
