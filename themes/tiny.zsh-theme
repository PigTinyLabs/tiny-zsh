# =============================================================================
# THEMES/TINY.ZSH-THEME
# =============================================================================

PIGTINYLABS_COLOR_PATH="cyan"          
PIGTINYLABS_COLOR_GIT_WRAP="blue"
PIGTINYLABS_COLOR_GIT_BRANCH="red"
PIGTINYLABS_COLOR_DIRTY="yellow"       

PIGTINYLABS_GIT_DIRTY=" ✗"             
PIGTINYLABS_GIT_CLEAN=""               

_pigtinylabs_git_prompt() {
    pigtinylabs_is_git_repo || return

    local branch
    branch=$(pigtinylabs_git_branch)
    [[ -z "$branch" ]] && return

    local status_symbol
    status_symbol=$(pigtinylabs_git_status)

    if [[ -n "$status_symbol" ]]; then
        status_symbol="%B%F{$PIGTINYLABS_COLOR_DIRTY}${status_symbol}%f%b"
    fi

    echo -n " %B%F{$PIGTINYLABS_COLOR_GIT_WRAP}git:(%f%F{$PIGTINYLABS_COLOR_GIT_BRANCH}${branch}%f%F{$PIGTINYLABS_COLOR_GIT_WRAP})%f%b${status_symbol}"
}

_pigtinylabs_precmd_prompt() {
    local prompt_str=""

    prompt_str+="%B%(?.%F{green}.%F{red})➜%f%b  "
    prompt_str+="%B%F{$PIGTINYLABS_COLOR_PATH}%c%f%b"
    prompt_str+=$(_pigtinylabs_git_prompt)
    prompt_str+=" "
    PROMPT="${prompt_str}"
    RPROMPT="🐷%F{magenta}〰️💕〰️%f🦆 %B%(?.%F{green}.%F{red})[%D{%H:%M:%S}]%f%b"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _pigtinylabs_precmd_prompt