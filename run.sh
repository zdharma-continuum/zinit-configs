#!/usr/bin/env zsh

set -o errexit -o nounset -o pipefail

# Folders containing `.zshrc`
FOLDERS_WITH_ZSHRC=$( find . -name 'zshrc' -maxdepth 3 -type f -exec dirname {} \; )

# A fuzzy finder available
if command -v fzy > /dev/null 2>&1; then
    FUZZY_FINDER=fzy
elif command -v fzf > /dev/null 2>&1; then
    FUZZY_FINDER=fzf
else
    echo 'No supported fuzzy finder found. Exiting!'
    exit 1
fi
# Folder to load, chosen by user
FOLDER=$(${FUZZY_FINDER} <<< ${FOLDERS_WITH_ZSHRC})

# Build an image
FOLDER_LOWERCASE="${(L)FOLDER}"
docker build \
    --build-arg ZINIT_CONFIG="${FOLDER}" \
    --build-arg TERM="${TERM}" \
    --tag "zinit-configs/$(basename ${FOLDER_LOWERCASE})" \
    "${0:a:h}"

# Run a container
docker run --interactive --tty zinit-configs/$(basename "${FOLDER_LOWERCASE}")
