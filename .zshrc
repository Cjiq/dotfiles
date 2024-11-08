# zplug
source ~/.zplug/init.zsh
zplug "supercrabtree/k"
zplug "zsh-users/zsh-autosuggestions"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

# Show hidden files
setopt globdots

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="bira"
ZSH_THEME="af-magic"

# Fix "Insecure completion-dependent directories detected"
ZSH_DISABLE_COMPFIX=true

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

#export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Random comment
#
# Load shortcut aliases
if test -d "~/.shortcuts"; then
    source ~/.shortcuts
fi

# Golang :)
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# npm
export PATH=$PATH:/usr/lib/node_modules

# Composer
export PATH=$PATH:$HOME/.config/composer/vendor/bin

# Snap
export PATH=$PATH:/var/lib/snapd/snap/bin

# Other stuff
if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls="ls -G"
	alias lsblk="diskutil list"
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	# export TERM=xterm-256color
else
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	alias ls="ls --color=auto"
	alias svi="sudo vim"
	alias mp="modpoll"
	alias sctl="sudo systemctl"
	alias hgrep="history |grep"
	alias dc="docker container"
	alias di="docker images"
	alias d="docker"
	alias gis="git status"
	alias gia="git add"
	alias gopath="cd ~/go/src/"
	export PATH="$PATH:$(go env GOPATH)/bin"
  # export TERM=xterm-256color
	if [[ $TERM == "xterm-termite" ]]; then
		alias ssh="TERM='xterm-color' ssh"
	fi
	alias termite="alacritty"
fi

alias hgrep="history |grep"
alias lsm="ls -lat | more"
alias tmux='tmux -2'
project_find() {
    grep $1 --color='always' * -r --exclude-dir=node_modules --exclude-dir=.next | egrep -v 'yarn|package.json' --color='always'
}
alias projf="project_find"

if uname -r | grep -iqF "arch"; then
	if [ ! "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
		exec startx
	fi
    export ANDROID_HOME=$HOME/Android/Sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:$ANDROID_HOME/tools/bin
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi



# bun completions
[ -s "/home/cjiq/.bun/_bun" ] && source "/home/cjiq/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
