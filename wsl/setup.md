## 概要
- 開発環境の作成

### ディストリビューションをインストール
```
wsl --list --online
wsl --install Ubuntu-24.04 --name server

wsl -l -v
wsl --set-default server
wsl -d server
wsl -d server -u guest
wsl --shutdown
```

### WSLの設定
- sudo パスワードなし
```
sudo visudo
```
```
# Add this below:
guest   ALL=(ALL)       NOPASSWD:ALL
```
```
ctrl+X, Enter
```

- ssh
```
vim ~/.ssh/config

Host bc
  HostName github.com
  User git
  IdentityFile /mnt/d/self/projects/bit-craft/.ssh/bit-craft-io
  IdentitiesOnly yes
```

- symbolic link
```
cd ~
ln -s /var/www/bc.draft _bc.draft
ln -s /var/www/bc.develop _bc.develop
ln -s /var/www/bc.sandbox _bc.sandbox
ll
```

- alias
```
sudo cp -a /var/www/bc.develop/wsl/.bash_aliases ~/.bash_aliases
. ~/.bashrc

info
```

## インストール
- direnv
  - ディレクトリ毎に環境変数を自動設定 
  - .bash_aliases と併用して使用
```
sudo apt update
sudo apt install direnv
direnv allow

echo '# add 2026.05.27 direnv' >> ~/.bashrc
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
echo 'export DIRENV_LOG_FORMAT=""' >> ~/.bashrc
source ~/.bashrc

direnv version
```

- nodejs
```
sudo apt purge nodejs npm
sudo snap install node --classic --channel=22/stable

sudo nano /etc/wsl.conf
```
```
[interop]
appendWindowsPath = false
```
```
ctrl+X, Enter
```

- php
```
sudo apt install php8.3-cli
php -v
```

- Go
```
cd /tmp
wget https://go.dev/dl/go1.26.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.26.3.linux-amd64.tar.gz

echo '# add 2026.05.27 golang' >> ~/.bashrc
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

go version
```

- .bashrc
```
echo '# add 2026.05.28 history' >> ~/.bashrc
echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' >> ~/.bashrc
echo 'export HISTIGNORE="history:history *:ls:exit"' >> ~/.bashrc
echo 'export HISTCONTROL=ignoreboth' >> ~/.bashrc
source ~/.bashrc

history
```

- make
```
sudo apt install make
make -v
```

- aqua
```
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.2/aqua-installer | bash

echo '# add 2026.05.28 aqua' >> ~/.bashrc
echo 'export PATH=${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

aqua version
```

- claude code
```
curl -fsSL https://claude.ai/install.sh | bash

echo '# add 2026.05.28 claude' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

# git
- clone
```
cd /tmp
git clone git@bc:bit-craft-io/ddd_nukui.git bc.draft
sudo mv bc.draft /var/www/
```
- config
```
cd /var/www/bc.draft
vim .git/config
```
```
[user]
+	email = bit.craft@outlook.com
+	name  = bit-craft-io
[core]
+	autocrlf = input
+	eol = lf
```
```
git config --global --add safe.directory *
```
# docker
- コンテナを起動、破棄するコマンド
```
docker-compose up -d
docker-compose down -v
docker-compose build redoc
docker-compose up -d redoc
```
- .bash_aliases に設定されているコマンド
- コンテナにコマンドを送信
```

info

make dc-login NAME=app
make dc-make NAME=app CMD="laravel-init"
make dc-make NAME=app CMD="laravel-clean"
make dc-make NAME=app CMD="laravel-reset"
make dc-make NAME=app CMD="migrate-seeder-dev"
make dc-make NAME=app CMD="job-restart"
make dc-make NAME=app CMD="php-fix-dry"
make dc-make NAME=app CMD="php-fix"
make dc-make NAME=app CMD="php-stan"
make dc-make NAME=app CMD="artisan make:migration create_u_dummies_table"

make dc-make NAME=redoc CMD="openapi-build"
```

### その他
- remove Zone.Identifier
  - Windwos から WSL にドラッグコピーでできたゴミファイル（Zone.Identifier）を削除
```
FIND_DIR=/var/www
find $FIND_DIR -name "*Zone.Identifier" -type f -print

sudo find $FIND_DIR -name "*Zone.Identifier" -type f -delete
find $FIND_DIR -name "*Zone.Identifier" -type f | wc -l
```

- permission
```
USER=guest
sudo chown -R $USER:$USER $FIND_DIR/*
```
