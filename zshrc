export LANG=ja_JP.UTF-8

## 履歴の保存先
HISTFILE=$HOME/.zsh-history
## メモリに展開する履歴の数
HISTSIZE=100000
## 保存する履歴の数
SAVEHIST=100000

## 補完機能の強化
autoload -U compinit
compinit

## コアダンプサイズを制限
limit coredumpsize 102400
## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr
## Emacsライクキーバインド設定
bindkey -e

## 色を使う
setopt prompt_subst
## ビープを鳴らさない
setopt nobeep
## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs
## 補完候補一覧でファイルの種別をマーク表示
setopt list_types
## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume
## 補完候補を一覧表示
setopt auto_list
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups
## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob
## TAB で順に補完候補を切り替える
setopt auto_menu
## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## =command を command のパス名に展開する
setopt equals
## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify
## ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort
## 出力時8ビットを通す
setopt print_eight_bit
## ヒストリを共有
setopt share_history
## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1
## 補完候補の色づけ
#eval `dircolors`
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## 補完の大文字小文字を区別しない
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
## ディレクトリ名だけで cd
setopt auto_cd
## カッコの対応などを自動的に補完
setopt auto_param_keys
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
## スペルチェック
setopt correct
## {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl
## Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt NO_flow_control
## コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space
## コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments
## ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
## history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
## 補完候補を詰めて表示
setopt list_packed
## 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash

## プロンプトの設定
autoload colors
colors
PROMPT="%{${fg[green]}%}[%n@%m] %(!.#.$) %{${reset_color}%}"
PROMPT2="%{${fg[green]}%}%_> %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
RPROMPT="%{${fg[green]}%}[%~]%{${reset_color}%}"

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

alias vi=vim

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'

if [ -f ~/.dircolors ]; then
    eval $(gdircolors ~/.dircolors)
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ngrep="grep -nrI"

export LANG=ja_JP.UTF-8

[ -f ~/.zshrc.include ] && source ~/.zshrc.include

#alias currbr='git rev-parse --abbrev-ref @'
#alias cu='git rev-parse --abbrev-ref @'
alias currbr="git branch --show-current"
alias cu="git branch --show-current"

__git_ps1_fast() {
    if [ -d $PWD/.git ]; then
        echo $(cu)
    fi
}

if [ -f ~/.zsh/git-prompt.sh ]; then
    source ~/.zsh/git-prompt.sh
    setopt PROMPT_SUBST
    setopt TRANSIENT_RPROMPT
    precmd() {
        #PROMPT="%{${fg[green]}%}[%n@%m:$(__git_ps1 "%s")] %(!.#.$) %{${reset_color}%}"
        PROMPT="%{${fg[green]}%}[%n@%m:$(__git_ps1_fast)] %(!.#.$) %{${reset_color}%}"
    }
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=0
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_DESCRIBE_STYLE="default"
    GIT_PS1_SHOWCOLORHINTS=1
fi

[ -f ~/.zshrc.plenv ] && source ~/.zshrc.plenv
#alias perl=$HOME/localperl/bin/perl5.31.10
#export PATH=$PATH:$HOME/localperl/bin

export EDITOR=vim

fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit -C

[ -f ~/.zshrc.plenv ] && source ~/.zshrc.plenv

# cg (repo name pattern) で ghq 管理下のリポジトリのディレクトリに移動
function cg() {
    local opts=()
    local pat=
    local e_i='-i'
    for arg in $@; do
        if [[ $arg = '-e' ]]; then
            e_i='-e'
        elif [[ $arg =~ ^- ]]; then
            opts=($opts $arg)
        else
            pat=$arg
        fi
    done

    local repo_list=`ghq list ${opts} ${e_i} --full-path ${pat}`

    local num_cand=`echo -n $repo_list | grep -c '^'`
    if [ $num_cand -eq 0 ]; then
        echo "No repository found: $pat"
        return
    elif [ $num_cand -eq 1 ]; then
        cd $repo_list
        echo "Moved to $repo_list"
    else
        local selected=`echo $repo_list | fzf`
        if [ $selected ]; then
            cd $selected
            echo "Moved to $selected"
        fi
    fi
}

# FZF の検索対象を git ls-files の対象ファイルに制限する
export FZF_DEFAULT_COMMAND='rg --files'

# 現在のコマンドラインを vim で編集する
# ctrl-x + e で起動
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
