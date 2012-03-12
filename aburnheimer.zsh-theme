# ------------------------------------------------------------------------------
#          FILE:  aburnheimer.zsh-theme
#   DESCRIPTION:  oh-my-zsh theme file.
#        AUTHOR:  Andrew Burnheimer (aburnheimer@gmail.com)
#       VERSION:  1.0.0
#    SCREENSHOT:  N/A
#   INSPIRED BY:  {sorin,smt,nicoulaj}.zsh-theme
# ------------------------------------------------------------------------------

# Customizable parameters.
PROMPT_PATH_MAX_LENGTH=20

if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
  local return_status="%{$fg[red]%}%(?..⏎ %?)%{$reset_color%}"
  
  #PROMPT='%{$fg[cyan]%}%c$(git_prompt_info) %(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}❯)%{$reset_color%} '
  PROMPT='%{$fg[cyan]%}%$PROMPT_PATH_MAX_LENGTH<..<%/%<<$(svn_prompt_info)$(git_prompt_info) %(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}❯)%{$reset_color%} '

  ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}git%{$reset_color%}:%{$fg[red]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY=""
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  RPROMPT='${return_status} $(rbenv_prompt_info) $(git_time_since_commit)$(git_prompt_status)%{$reset_color%}'

  ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
  ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}✹"
  ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
  ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜"
  ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭"

  # Colors vary depending on time lapsed.
  ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
  ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
  ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
  ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

  ZSH_THEME_SVN_PROMPT_PREFIX=" %{$fg[blue]%}svn%{$reset_color%}:%{$fg[red]%}"
  ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_REPO_NAME_COLOR="%{$fg[cyan]%}"
  ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%}✖"
  ZSH_THEME_SVN_PROMPT_CLEAN=""

  # Determine the time since last commit. If branch is clean,
  # use a neutral color, otherwise colors will vary according to time.
  function git_time_since_commit() {
      if git rev-parse --git-dir > /dev/null 2>&1; then
          # Only proceed if there is actually a commit.
          if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
              # Get the last commit.
              last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
              now=`date +%s`
              seconds_since_last_commit=$((now-last_commit))

              # Totals
              MINUTES=$((seconds_since_last_commit / 60))
              HOURS=$((seconds_since_last_commit/3600))

              # Sub-hours and sub-minutes
              DAYS=$((seconds_since_last_commit / 86400))
              SUB_HOURS=$((HOURS % 24))
              SUB_MINUTES=$((MINUTES % 60))

              # Clossify long, medium, short
              if [[ -n $(git status -s 2> /dev/null) ]]; then
                  if [ "$MINUTES" -gt 45 ]; then
                      COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                  elif [ "$MINUTES" -gt 15 ]; then
                      COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                  else
                      COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                  fi
              else
                  COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
              fi

              if [ "$HOURS" -gt 24 ]; then
                  echo "[$COLOR${DAYS}d${SUB_HOURS}h%{$reset_color%}]"
              elif [ "$MINUTES" -gt 60 ]; then
                  echo "[$COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}]"
              else
                  echo "[$COLOR${MINUTES}m%{$reset_color%}]"
              fi
          else
              COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
              echo "[$COLOR~]"
          fi
      fi
  }

else 
  MODE_INDICATOR="❮❮❮"
  local return_status="%(?::⏎)"
  
  PROMPT='%c$(git_prompt_info) %(!.#.❯) '

  ZSH_THEME_GIT_PROMPT_PREFIX=" git:"
  ZSH_THEME_GIT_PROMPT_SUFFIX=""
  ZSH_THEME_GIT_PROMPT_DIRTY=""
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  RPROMPT="${return_status} $(rbenv_prompt_info) $(git_prompt_status)"

  ZSH_THEME_GIT_PROMPT_ADDED="✚"
  ZSH_THEME_GIT_PROMPT_MODIFIED="✹"
  ZSH_THEME_GIT_PROMPT_DELETED="✖"
  ZSH_THEME_GIT_PROMPT_RENAMED="➜"
  ZSH_THEME_GIT_PROMPT_UNMERGED="═"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="✭"

  ZSH_THEME_SVN_PROMPT_PREFIX=" svn:"
  ZSH_THEME_SVN_PROMPT_SUFFIX=""
  ZSH_THEME_REPO_NAME_COLOR=""
  ZSH_THEME_SVN_PROMPT_DIRTY=" ✖"
  ZSH_THEME_SVN_PROMPT_CLEAN=""
fi
