_WSL_SLINK_DIR=~/_draft
_WSL_DOCKER_DIR="$_WSL_SLINK_DIR/docker"

source "$_WSL_SLINK_DIR/wsl/git-prompt.sh"
PROMPT_COMMAND='PS1="\[\033[01;34m\]\u@wsl:\w\$\[\033[1;31m\]$(__git_ps1)\[\033[00m\] \$ "'

dokr() {
  if [ -z "$1" ] || [ "$1" = "-h" ]; then
    echo -e "\033[1mUsage:\033[0m ${FUNCNAME[0]} <service-name>"
    echo "  Example:"
    echo "    ${FUNCNAME[0]} app            # Open bash shell in 'app' container"
    echo "    ${FUNCNAME[0]} -h             # Show this help"
    return
  fi

  pushd "$_WSL_DOCKER_DIR" || return
  docker-compose exec "$@" bash --login
  popd > /dev/null
}
comp() {
  if [ -z "$1" ] || [ "$1" = "-h" ]; then
    echo -e "\033[1mUsage:\033[0m ${FUNCNAME[0]} <composer-command>"
    echo "  Example:"
    echo "    ${FUNCNAME[0]} install        # Install dependencies"
    echo "    ${FUNCNAME[0]} update         # Update dependencies"
    echo "    ${FUNCNAME[0]} dump-autoload  # Regenerate autoload files"
    echo "    ${FUNCNAME[0]} -h             # Show this help"
    return
  fi

  pushd "$_WSL_DOCKER_DIR" || return
  docker-compose exec -u 1000:1000 -it app composer "$@"
  popd > /dev/null
}
arts() {
  if [ -z "$1" ] || [ "$1" = "-h" ]; then
    echo -e "\033[1mUsage:\033[0m ${FUNCNAME[0]} <artisan-command>"
    echo "  Example:"
    echo "    ${FUNCNAME[0]} migrate        # Run migrations"
    echo "    ${FUNCNAME[0]} optimize:clear # Clear all Laravel caches"
    echo "    ${FUNCNAME[0]} -h             # Show this help"
    return
  fi

  pushd "$_WSL_DOCKER_DIR" || return
  docker-compose exec -u 1000:1000 -it app php artisan "$@"
  popd > /dev/null
}
stan() {
  if [ -z "$1" ] || [ "$1" = "-h" ]; then
    echo -e "\033[1mUsage:\033[0m ${FUNCNAME[0]} [unit|-h]"
    echo "  Example:"
    echo "    ${FUNCNAME[0]}                # Run static analysis only (--stan-only)"
    echo "    ${FUNCNAME[0]} unit           # Run unit test fixes only (--unit-only)"
    echo "    ${FUNCNAME[0]} -h             # Show this help"
    return
  fi

  pushd "$_WSL_DOCKER_DIR" || return
  if [ "$1" = "unit" ]; then
    _current=$(pwd)
    docker-compose exec -it app php artisan cmd:fix --unit-only
    popd > /dev/null
    return
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
    return
  fi

  pushd "$_WSL_DOCKER_DIR" || return
  if [ "$1" = "commit" ]; then
    docker-compose exec -it app php artisan cmd:format --run
    popd > /dev/null
    return
  fi

  docker-compose exec -it app php artisan cmd:format --dry-run
  popd > /dev/null
}
cler() {
  pushd "$_WSL_DOCKER_DIR" || return
  docker-compose exec              -it app chown -R www-data:www-data /var/www/source/bootstrap/cache
  docker-compose exec              -it app chmod -R 777 /var/www/source/bootstrap/cache
  docker-compose exec              -it app chown -R www-data:www-data /var/www/source/storage
  docker-compose exec              -it app chmod -R 777 /var/www/source/storage
  docker-compose exec -u root:root -it app php artisan config:clear
  docker-compose exec -u root:root -it app php artisan cache:clear
  docker-compose exec -u root:root -it app php artisan view:clear
  docker-compose exec -u root:root -it app php artisan optimize:clear
  docker-compose exec -u 1000:1000 -it app composer dump-autoload
  docker-compose exec -u root:root -it app rm -rf storage/framework/cache/*
  popd > /dev/null
}
