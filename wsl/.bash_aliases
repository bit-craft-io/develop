_is_file() {
  if [ ! -f "$1" ]; then
    return 1
  fi
  return 0
}

_update_ps1() {
  if [[ -z "$_GIT_PROMPT_LOADED" ]]; then
    local target="$_WSL_SLINK_DIR/wsl/git-prompt.sh"
    if _is_file "$target"; then
      source "$target"
      _GIT_PROMPT_LOADED=1
    fi
  fi
  PS1="\[\033[01;34m\]\u@wsl:\w\$\[\033[1;31m\]$(__git_ps1)\[\033[00m\] \$ "
}
PROMPT_COMMAND=_update_ps1

info() {
    echo "_WSL_SLINK_DIR  : "$_WSL_SLINK_DIR
    echo "_WSL_DOCKER_DIR : "$_WSL_DOCKER_DIR
}
