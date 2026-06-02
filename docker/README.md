# Commands

## env value
```
_PROJECT_DIR=/var/www/bc.develop
```

## setup wsl
```
# setup direnv
sudo apt update
sudo apt install direnv
cp -a $_PROJECT_DIR/wsl/envrc $_PROJECT_DIR/.envrc
direnv allow

cat << 'EOF' >> ~/.bashrc
# add $(date +'%Y.%m.%d') direnv settings
# add 2026.04.17 direnv
eval "$(direnv hook bash)"
export DIRENV_LOG_FORMAT=""
EOF

# setup bash_aliases
sudo cp -a $_PROJECT_DIR/wsl/bash_aliases ~/.bash_aliases
. ~/.bashrc

info

ll $_PROJECT_DIR/.git/info/exclude
cat << 'EOF' >> $_PROJECT_DIR/.git/info/exclude
.envrc
EOF
```

## container up / down
```
cd $_PROJECT_DIR/docker
docker-compose up -d
# docker-compose down -v
# docker-compose stop
# docker-compose start
```

## aliases command
```
dokr -h
comp -h
arts -h
stan -h
frmt -h
cler

dokr nginx
date "+%Y-%m-%d %H:%M:%S"
```

### send command to container
```
dokr app
dokr mysql_master
comp install
comp update
comp dump-autoload
arts migrate
arts migrate:rollback
arts config:clear
arts cache:clear
arts view:clear
arts optimize:clear
arts key:generate
arts ide-helper:generate

arts migrate:refresh --seed
arts db:seed DatabaseSeeder
arts optimize:clear

arts db:wipe
arts migrate:install
arts migrate

arts config:clear
arts cache:clear
arts migrate:reset
arts migrate
arts db:seed --class=DevelopSeeder
arts db:seed --class=MasterSeeder

arts make:migration create_m_items_table
arts make:migration create_u_items_table
arts make:controller Api/AccountController

arts route:list
```

## git commands
```
git cherry-pick -n e5bfc168
```
