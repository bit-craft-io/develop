#.envrc
#export _WSL_SLINK_DIR=~/_bc.develop
#export _WSL_DOCKER_DIR="$_WSL_SLINK_DIR/docker"

_exist_dir() {
  if [ ! -d "$1" ]; then
    echo "not exist $1"
    return 1
  fi
}

_is_file() {
  if [ ! -f "$1" ]; then
    return 1
  fi
  return 0
}

update_ps1() {
  if [[ -z "$_GIT_PROMPT_LOADED" ]]; then
    local target="$_WSL_SLINK_DIR/wsl/git-prompt.sh"
    if _is_file "$target"; then
      source "$target"
      _GIT_PROMPT_LOADED=1
    fi
  fi
  PS1="\[\033[01;34m\]\u@wsl:\w\$\[\033[1;31m\]$(__git_ps1)\[\033[00m\] \$ "
}
PROMPT_COMMAND=update_ps1

make() {
  if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ]; then
    echo -e "\033[1mUsage:\033[0m ${FUNCNAME[0]} <container> <make-command>"
    echo "  Example:"
    echo "    ${FUNCNAME[0]} app migrate-all  # exec 'make migrate-all' in 'app' container"
    echo "    ${FUNCNAME[0]} -h               # Show this help"
    return 1
  fi

  _exist_dir "$_WSL_DOCKER_DIR" || return 1

  pushd "$_WSL_DOCKER_DIR" > /dev/null || return 0
  docker-compose exec -u 1000:1000 -it "$1" make "${@:2}"
  popd > /dev/null || return 0
}

dokr() {
  if [ -z "$1" ] || [ "$1" = "-h" ]; then
    echo -e "\033[1mUsage:\033[0m ${FUNCNAME[0]} <container>"
    echo "  Example:"
    echo "    ${FUNCNAME[0]} app            # Open bash shell in 'app' container"
    echo "    ${FUNCNAME[0]} -h             # Show this help"
    return 1
  fi

  _exist_dir "$_WSL_DOCKER_DIR" || return 1

  pushd "$_WSL_DOCKER_DIR" > /dev/null || return 0
  docker-compose exec "$@" bash --login
  popd > /dev/null || return 0
}

stan() {
  if [ -z "$1" ] || [ "$1" = "-h" ]; then
    echo -e "\033[1mUsage:\033[0m ${FUNCNAME[0]} [unit|-h]"
    echo "  Example:"
    echo "    ${FUNCNAME[0]}                # Run static analysis only (--stan-only)"
    echo "    ${FUNCNAME[0]} unit           # Run unit test fixes only (--unit-only)"
    echo "    ${FUNCNAME[0]} -h             # Show this help"
    return 1
  fi

  _exist_dir "$_WSL_DOCKER_DIR" || return 1

  pushd "$_WSL_DOCKER_DIR" || return 0
  if [ "$1" = "unit" ]; then
    _current=$(pwd)
    docker-compose exec -it app php artisan cmd:fix --unit-only
    popd > /dev/null
    return 1
  fi

  docker-compose exec -it app php artisan cmd:fix --stan-only
  popd > /dev/null
}

frmt() {
  if [ -z "$1" ] || [ "$1" = "-h" ]; then
    echo -e "\033[1mUsage:\033[0m ${FUNCNAME[0]} [commit|-h]"
    echo "  Example:"
    echo "    ${FUNCNAME[0]}                # Format file and not update (--dry-run)"
    echo "    ${FUNCNAME[0]} commit         # Format file and update"
    echo "    ${FUNCNAME[0]} -h             # Show this help"
    return 1
  fi

  _exist_dir "$_WSL_DOCKER_DIR" || return 1

  pushd "$_WSL_DOCKER_DIR" || return 0
  if [ "$1" = "commit" ]; then
    docker-compose exec -it app php artisan cmd:format --run
    popd > /dev/null
    return 1
  fi

  docker-compose exec -it app php artisan cmd:format --dry-run
  popd > /dev/null
}

api() {
  _exist_dir "$_WSL_SLINK_DIR" || return 1

  if [ -f "$_WSL_SLINK_DIR/wsl/build-openapi.sh" ]; then
    source "$_WSL_SLINK_DIR/wsl/build-openapi.sh"
  fi
}

info() {
    echo "_WSL_SLINK_DIR  : "$_WSL_SLINK_DIR
    echo "_WSL_DOCKER_DIR : "$_WSL_DOCKER_DIR
}
