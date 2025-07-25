# https://github.com/casey/just

set shell := ["bash", "-cu"]

# Use bash, and exit on unset variables (c for command, u for unset)

# Default recipe, it's run when just is invoked without a recipe
default:
    just --list --unsorted

# Sync dev dependencies
dev-sync:
    uv sync --all-extras --cache-dir .uv_cache

# Sync production dependencies (excludes dev dependencies)
prod-sync:
    uv sync --all-extras --no-dev --cache-dir .uv_cache

# Install pre commit hooks
install-hooks:
    uv run pre-commit install

# Run ruff formatting
format:
    uv run ruff format

# Run ruff linting and mypy type checking
lint:
    uv run ruff check --fix
    uv run mypy --ignore-missing-imports --install-types --non-interactive --package src

# Run tests using pytest
test:
    uv run pytest --verbose --color=yes tests

# Run all checks: format, lint, and test
validate: format lint test

# Build docker image
dockerize:
    docker build -t python-repo-template .

# Use it like: just run 10
run number:
    uv run main.py --number {{ number }}

# Export requirements.txt
export:
    uv export --locked > requirements.txt

# Install packages use pip
pip:
    pip install -r requirements.txt

# Docker build
docker-proxy-build proxy:
    docker compose -f docker-compose.yaml build --build-arg "https_proxy=${proxy}"

docker-build:
    docker compose -f docker-compose.yaml build
