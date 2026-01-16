# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# cd $brainstormr
#
alias cm="chezmoi"
alias asd="git add . && git commit -m 'asd' && git push"
alias apps="cd $HOME/dev/apps"
alias core="cd $HOME/dev/core"
alias common="cd $HOME/dev/common"
alias appsc="apps && code ."
alias corec="core && code ."
alias socket-server="cd $HOME/dev/socket-server"
alias reload="source $HOME/.zshrc"
alias config="vim $HOME/.zshrc"
alias aa="vim $HOME/.oh-my-zsh/custom/aliases.zsh"
alias ls="exa --icons -a --group-directories-first"
alias lsa="ls -l --git -g"
alias tree="lsa --tree --level=3"
alias buildserver="ssh buildserver"
alias staging="ssh staging"
alias prod="ssh prod"
alias gitlab="ssh gitlab"
alias code="codium"
alias upgrade="yay -Syyu && rustup update"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias cat="/usr/bin/bat --theme=Dracula --tabs 2"
alias cp="/usr/bin/xcp"
alias vm_ware_services="sudo systemctl start vmware-networks.service && sudo systemctl start vmware-usbarbitrator.service && sudo modprobe -a vmw_vmci vmmon"