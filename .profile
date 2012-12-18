#/bin/sh

#---------------------------------
# Environment variables
#---------------------------------
LS_COLORS="no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32::*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31::*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31::*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"
export LSCOLORS=exfxcxdxbxegedabagacad
export PS1="\[\e[1;38m\][\u@Mac:\w]\$\[\e[00m\] "       #ユーザ@Mac:カレントディレクトリ 
#export PS1="\[\e[1;32m\][\u@\h:\w]\$\[\e[00m\] "       #ユーザ@ホスト名:カレントディレクトリ
TERM=xterm; export TERM


#---------------------------------
# alias
#---------------------------------
alias ls='ls -aG'
alias ll='ls -lGa'
alias la="ls -GaF"
alias lta="ls -GlthraF"
#alias ls='ls --color=auto'
#alias ls="ls -aFh --color=auto"
#alias la='ls -alg --color=auto'
#alias lh='ls -lh --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
#alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
#alias dir='ls --color=auto --format=vertical'
#alias vdir='ls --color=auto --format=long'
alias grep='grep --color'                               # show differences in colour
alias vi='/usr/local/bin/vim'
alias vim='/usr/local/bin/vim'
#alias vi='vim'
alias view='/usr/local/bin/vim -R'
alias rvim='/usr/local/bin/vim -R'
#alias view='vim -R'
alias svi='sudo /usr/local/bin/vim'
alias svim='sudo /usr/local/bin/vim'
#alias svi="sudo vim"
#alias svim="sudo vim"
alias less='less -cr -x4 -RM'
# alias whence='type -a'                                # where, of a sort
alias sedd='sed -e '/^$/d' -e '/^#/d''                  #ファイルの空行/コメント行を除いて表示
alias psa='ps auxww'
alias dirs='dirs -p'
alias pd='pushd'
alias ppd='popd'
alias cvs='svn'
alias ssh='ssh -A'
alias scr='screen -UxR'
alias tm='tmux'
alias pathlist='echo -e ${PATH//:/\\n}'                 # display PATH List
alias ka='killall'
alias df='df -h'
alias du='du -h'
alias sum="awk '{sum+=\$1} END {print sum}'"
alias mcpan='sudo perl -MCPAN -e shell'
#alias bell="echo '\a'"
#alias h='head'
#alias t='tail'
#alias g='grep'
#alias c='cat'
#alias j='jobs'
alias cdd='cd ~/Desktop'
alias cdp='cd /Volumes/Pogoplug'                        #My Mac
alias cdh='cd /Volumes/My\ Book\ Thunderbolt\ Duo'      #My Mac


#---------------------------------
# set,shopt options
#---------------------------------
#set -o vi
set -o notify                           # バックグラウンドのジョブが終了したらその時点で通知
set -o noclobber                        # リダイレクト(>, >&, <>)で既存ファイルを上書きしない
shopt -s cdspell                        # directory移動時の小さなtypoを修正
shopt -s checkhash                      # ハッシュ表にあるコマンドについて実際に存在するかを確認
shopt -s checkwinsize           		# 端末のウィンドウサイズを${COLUMNS}と${LINES}に反映
shopt -s cmdhist                        # 複数行のコマンドの全ての行を1つの履歴エントリに保存
shopt -s histappend                     # 履歴を上書きせず追加のみ行う(手元の環境ではデフォルト)
shopt -s histverify                     # 実行するまえに必ず展開結果を確認できるようにする
shopt -s histreedit                     # 履歴の置換に失敗したときやり直せるようにする
shopt -s dotglob                        # ワイルドカード「*」で「.」で始まるファイル名にもヒットするようになる
shopt -s no_empty_cmd_completion        # 入力が空の状態では補完・PATH検索をしない
shopt -s nocaseglob                     # 「*」などのパス名展開で大文字小文字を区別しない
shopt -u sourcepath                     # "." コマンドでシェルスクリプトを実行するときは混乱するので PATH を検索させない


#---------------------------------
# history
#---------------------------------
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S  '
export HISTIGNORE=ls:history
export HISTCONTROL=ignoreboth

# h: 直前の履歴 30件を表示する。引数がある場合は過去 1000件を検索
function h {
if [ "$1" ]; then history 1000 | grep -i "$@"; else history 30; fi
		    }

# H: 直前の履歴 30件を表示する。引数がある場合は過去のすべてを検索
function H {
if [ "$1" ]; then history | grep -i "$@"; else history 30; fi
}


#---------------------------------
# functions 
#---------------------------------

# 現在実行中のジョブを表示。
function j { jobs -l; }


# CPU 使用率の高いプロセス10個
function psc() {
  ps auxww | head -n 1
  ps auxww | sort -r -n -k3,3 | grep -v "ps auxww" | grep -v grep | head
}


# メモリ占有率の高いプロセス10個
function psm() {
  ps auxww | head -n 1
  ps auxww | sort -r -n -k4,4 | grep -v "ps auxww" | grep -v grep | head
}


# プロセスをgrepする
function psg() {
  ps auxww | head -n 1
  ps auxww | grep $* | grep -v "ps auxww" | grep -v grep
}


# awk '{print $n}' awkで指定した引数をprint  
# ex. awp $n files
function awp() {
	col=$1
	shift 1
	files=$*
	if [ "$files" = "" ]; then
		awk "{print \$$col}"
	else
		cat $files | awk "{print \$$col}"
	fi
}


# cdしたらlsしないと気がすまない人用
#function cd() { builtin cd $@ && ls; }


# pushd-dirsを表示して番号を入力するとcdする
function gd() {
	builtin dirs -v
	builtin echo -n "select number: "
	builtin read newdir
	builtin cd +"$newdir"
}


# jobsを表示して番号を入力するとfgする
function gj() {
	builtin jobs
	builtin echo -n "select number: "
	builtin read newjob
	builtin fg %"$newjob"
}


# リモートサーバ上のファイルとdiff
#function rdiff() {
#	local arg1 arg2 tmp1 tmp2
#	arg1=$1
#	arg2=$2
#	if [ "" != "$(echo $arg1 | grep ":")" ]; then
#		tmp1=`mktemp "/tmp/rdiffXXXXXXX"`
#		scp $arg1 $tmp1
#		arg1=$tmp1
#	fi
#	if [ "" != "$(echo $arg2 | grep ":")" ]; then
#		tmp2=`mktemp "/tmp/rdiffXXXXXXX"`
#		scp $arg2 $tmp2
#		arg2=$tmp2
#	fi
#	diff $arg1 $arg2 | $PAGER
#	if [ -n "$tmp1" ]; then
#		rm -f $tmp1;
#	fi
#	if [ -n "$tmp2" ]; then
#		rm -f $tmp2;
#	fi
#}


# ssh-agent
function ssha() {
	eval `ssh-agent`;
	ssh-add;
}


# SSHのForwardAgentを有効にした際にログイン先でscreen/tmuxを使用後detacheするとSSH_AUTH_SOCKの値は更新されない→都度設定するのが手間
# SSH_AUTH_SOCKが直接UNIXドメインソケットを指し示すのではなく、UNIXドメインソケットを指し示すシンボリックリンクを作成しておいて、
# SSH_AUTH_SOCKにはこのシンボリックリンクのパス名を設定する
agent="$HOME/tmp/ssh-agent-$USER"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
        /tmp/*/agent.[0-9]*)
            ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "no ssh-agent"
fi


# exit (kill ssh-agent)
function exit() {
	if [ -n "$SSH_AGENT_PID" ]; then
		eval `ssh-agent -k`
	fi
	builtin exit
}


# 半角カナへ変換
#function zh() {
#	php -d open_basedir=/ -r 'array_shift($argv);foreach($argv as $f){$c=file_get_contents($f);$c=mb_convert_kana($c,"ak");file_put_contents($f,$c);}' $*
#}


#ssh-agent実行
#ssha
