# prompt — shared between users (no secrets, no user-specific paths)

git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    if [[ -n $branch ]]; then
        printf "%%K{magenta}%%F{white}  %s %%K{yellow}%%F{magenta}%%k%%f" "$branch"
    else
        printf "%%K{magenta}%%F{white} no git repo %%K{yellow}%%F{magenta}%%k%%f"
    fi
}

exit_status() {
    local last=$?
    if [[ $last -eq 0 ]]; then
        printf "%F{green}%K{green}%F{black} ✓ %K{green}%F{green}"
    else
        printf "%F{red}%K{red}%F{white} ✘ %K{red}%F{red}"
    fi
}

INFO_PROMPT="\
%F{blue}%K{blue}%F{red} %n@%m %K{cyan}%F{blue}\
%F{cyan}%K{cyan}%F{black} %~ %K{magenta}%F{cyan}\
\$(git_branch)\
%F{yellow}%K{yellow}%F{black} %* %K{yellow}%F{yellow}%k%f\
"
# exit status? \$(exit_status)

WORK_PROMPT="%F{black}%K{gray}%F{green} %n@%m  %1~ %K{black}%F{green}%k  %# %F{white} "

PROMPT="${INFO_PROMPT}"$'\n'"${WORK_PROMPT}"
RPROMPT=""

# echo ""

# PROMPT='%n@%m %1~ %# '
# RPROMPT="%F{magenta}%* \$(git_branch) %f"
