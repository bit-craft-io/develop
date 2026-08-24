# git-prompt
_update_ps1() {
  if [[ -z "$_GIT_PROMPT_LOADED" ]]; then
    local target="$HOME/.git-prompt"
    if [ -f "$target" ]; then
      source "$target"
      _GIT_PROMPT_LOADED=1
    fi
  fi
  PS1="\[\033[01;34m\]\u@wsl:\w\$\[\033[1;31m\]$(__git_ps1)\[\033[00m\] \$ "
}
PROMPT_COMMAND=_update_ps1

# trash-cli
if command -v trash-put >/dev/null 2>&1; then
  rm() {
    case "$1" in
      -l|--list)  trash-list ;;
      -e|--empty) trash-empty ;;
      -u|--undo)  restore-trash ;;
      -h|--help)
        command trash-put --help
        cat << 'EOF'

Custom Options:
  -l, --list            list trash contents (trash-list)
  -e, --empty           empty trash bin (trash-empty)
  -u, --undo            restore trash files (restore-trash)
EOF
    ;;
      *) command trash-put "$@" ;;
    esac
  }
else
  rm() {
    echo "trash-cli is not installed. Please run: sudo apt update && sudo apt install trash-cli" >&2
    return 1
  }
fi