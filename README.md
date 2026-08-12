dotfiles
========

Este repositorio guarda meus dotfiles de usuario para Debian, `startx` e o
desktop que montei para o meu fluxo diario.

Nao e uma instalacao generica de Linux. A ideia e deixar uma maquina nova
parecida com a minha, com backups antes de sobrescrever arquivos existentes.

Arquivos
--------
- `.xinitrc`: sessao X iniciada por `startx`.
- `.zshrc`: shell sem framework, historico em XDG e prompt gruvbox.
- `.Xresources`: recursos X usados por clientes antigos.
- `.config/nvim`, `.config/tmux` e `.config/git`: editor, tmux e git.
- `.config/lf`: file manager com preview.
- `.config/picom`, `.config/dunst` e `.config/feh`: compositor, notificacoes
  e wallpaper.
- `.config/mutt`, `.config/newsboat` e `.config/irssi`: configuracoes
  publicas de mail, feeds e IRC. Credenciais e listas privadas ficam fora.
- `.config/keynav`: configuracao XDG do keynav.
- `.config/mpv`: atalhos do MPV.
- `.config/firefox-gruvwood`: tema de interface do Firefox, instalado no perfil
  ativo sem versionar dados pessoais do navegador.
- `.config/aseprite`: tema, atalhos, layouts, pinceis, paleta e scripts pessoais.
- `.config/Renoise`: tema Gruvwood e aplicador das preferencias de janela.
- `.themes/Gruvbox`, `.gtkrc-2.0` e `.config/gtk-3.0`: tema GTK.
- `.nethackrc` e `.nethackrcx11`: configuracao do NetHack.

Dependencias Debian
-------------------
O script `install` instala X, shell, terminal, editor, utilitarios, PipeWire
JACK e as bibliotecas de desenvolvimento necessarias para compilar o desktop.

Ele tambem clona, valida, compila e instala `dwm`, `st`, `dmenu`,
`slstatus`, `slock` e `keynav`. Por padrao o codigo fica em:

    ~/Documentos/c/suckless

Outro destino pode ser escolhido com `SUCKLESS_DIR=/caminho ./install`.

Como instalar
-------------
Clone este repositorio e rode:

    ./install

O script:

- instala pacotes Debian e aplicativos opcionais disponiveis;
- copia os arquivos versionados para `$HOME`;
- salva backups antes de sobrescrever qualquer destino;
- clona e compila as ferramentas do desktop.

Os backups ficam em:

    ~/.dotfiles-backup/<timestamp>/

No Firefox, o script descobre o perfil ativo, instala `userChrome.css` e
`userContent.css` e habilita o carregamento desses arquivos. Feche e abra o
navegador por completo para aplicar o tema. No Aseprite, o tema Gruvwood e
selecionado quando ja existe um `aseprite.ini`.

Aplicativos externos
--------------------
`chatgpt`, `spotify-client` e `aseprite` sao instalados apenas quando o
APT ja conhece os pacotes. Em uma maquina nova, instale primeiro os pacotes ou
repositorios oficiais correspondentes e rode `./install` novamente.

O ChatGPT usa o repositorio APT configurado pelo pacote oficial em
`persistent.oaistatic.com`. O Spotify usa `repository.spotify.com`.

O Renoise nao e distribuido pelo APT desta maquina. Instale-o manualmente,
abra uma vez, feche e aplique as preferencias reproduziveis com:

    ~/.config/Renoise/apply-desktop-settings

Depois escolha `Gruvwood.xrnc` na tela de temas.

Atalhos principais
------------------
- `Alt+'`: abre o dmenu.
- `Alt+1..6`: vai para o aplicativo se estiver aberto; caso contrario, abre.
- `Super+1..6`: muda diretamente de tag.
- `Super+Shift+1..6`: move a janela atual para outra tag.

Sessao X
--------
O fluxo normal e iniciar com:

    startx

Por padrao, `.xinitrc` sobe o `dwm`.

Depois do install
-----------------
- Restaure localmente `.config/mutt/.mbsyncrc`,
  `.config/newsboat/urls` e `.config/irssi/config`; eles sao ignorados pelo
  Git por conterem credenciais ou dados privados.
- Revise configuracoes locais de SSH e VPN.
- Garanta que o shell do usuario seja `zsh`.
