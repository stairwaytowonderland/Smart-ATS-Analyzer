MAKEFLAGS += --no-print-directory

UNAME := $(shell uname -s)
AWS_PROFILE := $(shell echo $${AWS_PROFILE:-$$AWS_DEFAULT_PROFILE})

.PHONY: all
all: init ## Entrypoint

.PHONY: help
help: ## Show this help.
	@echo "Please use \`make <target>' where <target> is one of"
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | \
    sort | \
    awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-26s\033[0m %s\n", $$1, $$2}'

.list-targets:
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort

.PHONY: list
list: ## List public targets
	@LC_ALL=C $(MAKE) .list-targets | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs -n3 printf "%-26s%-26s%-26s%s\n"

.PHONY: init
init: .init .venv_reminder ## Ensure pip and Initialize venv

.PHONY: install
install: .install .venv_reminder .streamlit_command ## Install dependencies

.PHONY: install-dev
install-dev: .install-dev .venv_reminder .streamlit_command ## Install development dependencies

.PHONY: uninstall
uninstall: .uninstall .venv_reminder .streamlit_command ## Uninstall dependencies

.PHONY: uninstall-dev
uninstall-dev: .uninstall-dev .venv_reminder .streamlit_command ## Uninstall development dependencies

.PHONY: clean
clean: .uninstall-dev ## Clean up
	( \
  rm -rf .venv; \
)

.PHONY: check
check: ## Run linters but don't reformat
	( \
  . .venv/bin/activate; \
  autoflake --remove-all-unused-imports --remove-unused-variables ./*.py; \
  isort --check-only --diff ./*.py; \
  black --check --diff --line-length 88 ./*.py; \
)

.PHONY: lint
lint: ## Run linters and reformat
	( \
  . .venv/bin/activate; \
  autoflake --in-place --remove-all-unused-imports --remove-unused-variables ./*.py; \
  isort ./*.py; \
  black --line-length 88 ./*.py; \
)

.PHONY: run
run: .streamlit_command ## Run the streamlit app
	( \
  . .venv/bin/activate; \
  printf "\n\033[1m%s\033[0m ...\n  \033[1;92m\`%s\`\033[0m\n\n" "Running the streamlit app" "streamlit run app.py"; \
  streamlit run app.py; \
)

.venv_reminder:
	@printf "\n\t📝 \033[1m%s\033[0m: %s\n\t   %s\n\t   %s\n\t   %s.\n\n\t🏄 %s \033[1;92m\`%s\`\033[0m\n\t   %s.\n" "NOTE" "The dependencies are installed" "in a virtual environment which needs" "to be manually activated to run the" "Python command" "Please run" ". .venv/bin/activate" "to activate the virtual environment"

.streamlit_command:
	@printf "\n\033[1m%s\033[0m ...\n\t\033[1;92m\`%s\`\033[0m\n... or just use ...\n\t\033[1;92m\`%s\`\033[0m\n\n" "The streamlit command" "streamlit run app.py" "make run"

.init:
	@deactivate 2>/dev/null || true
	@test -d .venv || python3 -m venv .venv
	( \
  . .venv/bin/activate; \
  python3 -m ensurepip; \
)
	@printf "\nIf this is your \033[1m%s\033[0m running this (in this directory),\nplease \033[4m%s\033[0m\033[1m\033[0m run \033[1;92m\`%s\`\033[0m to install dependencies 🚀\n" "first time" "next" "make install"

.install:
	( \
  . .venv/bin/activate; \
  pip install --no-cache-dir -r requirements.txt; \
)

.install-dev:
	( \
  . .venv/bin/activate; \
  pip install --no-cache-dir -r requirements-dev.txt; \
  pre-commit install; \
)

.uninstall:
	( \
  . .venv/bin/activate; \
  pip uninstall -y -r requirements.txt; \
)

.uninstall-dev:
	( \
  . .venv/bin/activate; \
  pre-commit uninstall; \
  pip uninstall -y -r requirements-dev.txt; \
)
