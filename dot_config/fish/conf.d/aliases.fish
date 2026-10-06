# Converted from ~/.oh-my-zsh/custom/aliases.zsh
# Auto-loaded by fish on startup (files in conf.d/ are sourced automatically).

alias cm chezmoi
alias apps "cd $HOME/dev/apps"
alias core "cd $HOME/dev/core"
alias common "cd $HOME/dev/common"
alias appsc "apps; and code ."
alias corec "core; and code ."
alias socket-server "cd $HOME/dev/socket-server"
alias reload "exec fish"
alias config "vim $HOME/.config/fish/config.fish"
alias aa "vim $HOME/.config/fish/conf.d/aliases.fish"
alias ls "exa --icons -a --group-directories-first"
alias lsa "ls -l --git -g"
alias tree "lsa --tree --level=3"
alias buildserver "ssh buildserver"
alias staging "ssh staging"
alias prod "ssh prod"
alias gitlab "ssh gitlab"
alias code "env GTK_THEME=Sweet:dark codium"
alias upgrade "yay -Syyu; and rustup update"
alias dps "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias cat "/usr/bin/bat --theme=Dracula --tabs 2"
alias cp "/usr/bin/xcp"
alias vm_ware_services "sudo systemctl start vmware-networks.service; and sudo systemctl start vmware-usbarbitrator.service; and sudo modprobe -a vmw_vmci vmmon"
alias zed "zeditor"
alias azstart "az vm start --resource-group rg-wvd-01 --name win11ms-0"
alias gpr "git pull --rebase"

# asd and rebase used a zsh `&&`/`(...||...)` chain that doesn't translate
# cleanly to a one-line fish alias, so they're functions instead.
function asd
    git add .
    if not git diff --cached --quiet
        git commit -m 'asd'
    end
    git push
end

function rebase
    asd
    and git checkout develop
    and git pull
    and git checkout -
    and git rebase develop
end
