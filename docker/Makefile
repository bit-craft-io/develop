MAKEFLAGS += --no-print-directory

# ==============================================================================
# 共通マクロ（関数）の定義
# ==============================================================================
define print_headline
	@echo "----------------------------------------------------------------"
	@echo ">>> 実行中: [ $(1) ]"
	@echo "----------------------------------------------------------------"
endef

# ========================================
# laravel
# ----------------------------------------
.PHONY: laravel-init
laravel-init:
	$(call print_headline,${@})
	@$(MAKE) composer install
	@$(MAKE) laravel-reset
	@$(MAKE) laravel-clean

.PHONY: laravel-clean
laravel-clean:
	$(call print_headline,${@})
	chown -R 1000:1000 /var/www/source
	chmod -R 755 /var/www/source
	rm -rf storage/framework/cache/*

	@$(MAKE) artisan config:clear
	@$(MAKE) artisan cache:clear
	@$(MAKE) artisan view:clear
	@$(MAKE) artisan optimize:clear
	@$(MAKE) composer dump-autoload
	@$(MAKE) job-restart

.PHONY: laravel-reset
laravel-reset:
	$(call print_headline,${@})
	@$(MAKE) migrate-fresh-all
	@$(MAKE) migrate-all
	@$(MAKE) migrate-seeder-dev

# ========================================
# composer
# ----------------------------------------
COMPOSER_ARGS := $(filter-out composer,$(MAKECMDGOALS))

.PHONY: composer
composer:
	$(call print_headline,${@})
	composer $(COMPOSER_ARGS)

# 必須のおなじない
%:
	@:

# ========================================
# artisan
# ----------------------------------------
ARTISAN_ARGS := $(filter-out artisan,$(MAKECMDGOALS))

.PHONY: artisan
artisan:
	$(call print_headline,${@})
	php artisan $(ARTISAN_ARGS)

# 必須のおなじない
%:
	@:

# ========================================
# migrate
# ----------------------------------------
.PHONY: migrate-all
migrate-all:
	$(call print_headline,${@})
	@$(MAKE) migrate-app
	@$(MAKE) migrate-log
	@$(MAKE) migrate-test

.PHONY: migrate-app
migrate-app:
	$(call print_headline,${@})
	@$(MAKE) migrate DB_NAME=app_db DB_PATH=database/migrations

.PHONY: migrate-test
migrate-test:
	$(call print_headline,${@})
	@$(MAKE) migrate DB_NAME=test_db DB_PATH=database/migrations

.PHONY: migrate-log
migrate-log:
	$(call print_headline,${@})
	@$(MAKE) migrate DB_NAME=log_db	DB_PATH=database/migrations/log

.PHONY: migrate
migrate:
	$(call print_headline,${@})
	DB_DATABASE=$(DB_NAME) php artisan migrate --path=$(DB_PATH)

# ========================================
# seeder
# ----------------------------------------
.PHONY: migrate-seeder-dev
migrate-seeder-dev:
	$(call print_headline,${@})
	@$(MAKE) migrate-seeder DB_NAME=app_db SD_NAME=DevMaster
	@$(MAKE) migrate-seeder DB_NAME=app_db SD_NAME=DevUser
	@$(MAKE) migrate-seeder DB_NAME=log_db SD_NAME=DevLog

.PHONY: migrate-seeder
migrate-seeder:
	$(call print_headline,${@})
	DB_DATABASE=$(DB_NAME) php artisan db:seed $(SD_NAME)

# ========================================
# migrate:reset
# ----------------------------------------
.PHONY: migrate-reset-all
migrate-reset-all:
	$(call print_headline,${@})
	@$(MAKE) migrate-reset-app
	@$(MAKE) migrate-reset-log
	@$(MAKE) migrate-reset-test

.PHONY: migrate-reset-app
migrate-reset-app:
	$(call print_headline,${@})
	@$(MAKE) migrate-reset DB_NAME=app_db DB_PATH=database/migrations

.PHONY: migrate-reset-test
migrate-reset-test:
	$(call print_headline,${@})
	@$(MAKE) migrate-reset DB_NAME=test_db DB_PATH=database/migrations

.PHONY: migrate-reset-log
migrate-reset-log:
	$(call print_headline,${@})
	@$(MAKE) migrate-reset DB_NAME=log_db DB_PATH=database/migrations/log

.PHONY: migrate-reset
migrate-reset:
	$(call print_headline,${@})
	DB_DATABASE=$(DB_NAME) php artisan migrate:reset --path=$(DB_PATH)

# ========================================
# migrate-fresh
# ----------------------------------------
DB_NAME_ARGS := $(filter-out migrate-fresh,$(MAKECMDGOALS))

.PHONY: migrate-fresh
migrate-fresh:
	$(call print_headline,${@})
	DB_DATABASE=$(DB_NAME_ARGS) php artisan migrate:fresh

# 必須のおなじない
%:
	@:

.PHONY: migrate-fresh-all
migrate-fresh-all:
	$(call print_headline,${@})
	@$(MAKE) migrate-fresh app_db
	@$(MAKE) migrate-fresh test_db
	@$(MAKE) migrate-fresh log_db

# ========================================
# migrate:reset
# ----------------------------------------
# @note 【開発用】Job変更時にソースコードを自動で再読み込みする（queue:restart不要）
.PHONY: job-restart-dev
job-restart-dev:
	$(call print_headline,${@})
	php artisan queue:listen

.PHONY: job-restart
job-restart:
	$(call print_headline,${@})
	php artisan queue:restart

.PHONY: job-work
job-work:
	$(call print_headline,${@})
	php artisan queue:work
