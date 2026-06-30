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
---
### WSLの設定
- sudo パスワードなし
```
sudo visudo
```
```
# add this last row:
guest ALL=(ALL) NOPASSWD:ALL
```
```
ctrl+X, Enter
```

- ssh
```
mkdir ~/.ssh
vim ~/.ssh/config
```
```
Host bc
  HostName github.com
  User git
  IdentityFile ~/.ssh/bit-craft-io
  IdentitiesOnly yes
```
```
chmod 600 ~/.ssh/bit-craft-io
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
_DEV_WSL=/var/www/bc.develop/wsl
sudo cp -a ${_DEV_WSL}/.bash_aliases ~/.bash_aliases
sudo cp -a ${_DEV_WSL}/.git-prompt ~/.git-prompt
. ~/.bashrc
```
```
info
```

### インストール
- direnv
  - ディレクトリ毎に環境変数を自動設定
  - .bash_aliases と併用して使用
```
sudo apt update
sudo apt install direnv
```
```
echo '# add $(date +'%Y.%m.%d') direnv' >> ~/.bashrc
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
echo 'export DIRENV_LOG_FORMAT=""' >> ~/.bashrc
```
```
source ~/.bashrc
direnv version
```
```
# .envrc のあるディレクトリでコマンドを実行
direnv allow
```

- nodejs
```
sudo apt purge nodejs npm
sudo snap install node --classic --channel=22/stable
```
```
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
sudo apt install php8.4-cli
sudo apt install php-xdebug
```
```
php -v
```

- Go
```
cd /tmp
wget https://go.dev/dl/go1.26.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.26.3.linux-amd64.tar.gz
```
```
echo '# add $(date +'%Y.%m.%d') golang' >> ~/.bashrc
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc
```
```
source ~/.bashrc
go version
```

- .bashrc
```
echo '# add $(date +'%Y.%m.%d') history' >> ~/.bashrc
echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' >> ~/.bashrc
echo 'export HISTIGNORE="history:history *:ls:exit"' >> ~/.bashrc
echo 'export HISTCONTROL=ignoreboth' >> ~/.bashrc
```
```
source ~/.bashrc
history
```

- make
```
sudo apt install make
make -v
```

- claude
```
curl -fsSL https://claude.ai/install.sh | bash
```
```
echo '# add $(date +'%Y.%m.%d') claude' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```
```
source ~/.bashrc
claude -v
```

### Gitの設定
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

### 作業用に環境変数を設定
```
_DEVELOP_DIR=/var/www/bc.develop
_PROJECT_DIR=/var/www/bc.draft
```

### Dockerの操作
- コンテナを生成・破棄
```
pushd $_DEVELOP_DIR/docker
docker-compose up -d
docker-compose down -v
docker-compose build redoc
docker-compose up -d redoc
popd
```
- Makefile のコマンドからコンテナ操作
```
pushd $_DEVELOP_DIR/docker
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
make dc-make NAME=app CMD="composer update"

make dc-make NAME=redoc CMD="openapi-build"
popd
```

### その他
- direnvの設定
```
cp -a $_DEVELOP_DIR/wsl/envrc $_PROJECT_DIR/.envrc

cd $_PROJECT_DIR
echo '.envrc' >> .git/info/exclude
cat .git/info/exclude
```
- Zone.Identifier 削除
  - Windwos から WSL にドラッグコピーでできたゴミファイル（Zone.Identifier）を削除
```
FIND_DIR=/var/www
find $FIND_DIR -name "*Zone.Identifier" -type f -print

sudo find $FIND_DIR -name "*Zone.Identifier" -type f -delete
find $FIND_DIR -name "*Zone.Identifier" -type f | wc -l
```

- ファイル・ディレクトリの権限変更
```
USER=guest
sudo chown -R $USER:$USER $FIND_DIR/*
```