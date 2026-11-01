#!/bin/bash
# Run build_ipa_from_nsp.py with its Python packages from uv (https://docs.astral.sh/uv/) instead of a pip install into the system Python: uv builds the environment once,
# caches it and reuses it. The build's shell steps call python3 by name, and uv run puts the environment's python3 first on PATH, so they get the same packages.
# --no-project: the repository's pyproject.toml configures the lint only and is not a package. Set UV_PYTHON to pick another Python (3.12 or later).
# Usage: build_ipa_uv.sh <NSP folder> -k <prod.keys> [any other option of build_ipa_from_nsp.py]
set -eu
command -v uv > /dev/null || { echo "uv not found: brew install uv" >&2; exit 1; }
exec uv run --no-project --python "${UV_PYTHON:->=3.12}" \
    --with lz4 --with capstone --with fonttools --with nsz --with "backports.zstd; python_version < '3.14'" \
    python3 "$(dirname "$0")/build_ipa_from_nsp.py" "$@"
