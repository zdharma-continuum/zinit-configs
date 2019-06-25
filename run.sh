#!/usr/bin/env zsh

set -o errexit   # exit on fail
set -o pipefail  # catch errors in pipelines
set -o nounset   # exit on undeclared variable
# set -o xtrace    # trace execution

# Directory of the script
CURRENT_DIR=${0:a:h}

# Choose folder with configuration
# to test in docker
if command -v fzy > /dev/null; then
    FOLDER=$(set -- */; printf "%s\n" "${@%/}" | fzy)
elif command -v fzf > /dev/null; then
    FOLDER=$(set -- */; printf "%s\n" "${@%/}" | fzf)
else
    echo 'No supported fuzzy finder found. Exiting!'
    exit 1
fi

# Create a Dockerfile
DOCKERFILE="Dockerfile"
cat > "${CURRENT_DIR}/${DOCKERFILE}" <<END
FROM ubuntu:18.04
RUN apt update && \
    apt install --yes zsh git curl python vim htop sudo

RUN adduser --disabled-password --gecos '' user
RUN adduser user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user

COPY ${FOLDER} /home/user
RUN TERM=${TERM} zsh -i -c -- '-zplg-scheduler burst || true'
CMD zsh
END


# Build an image
FOLDER_LOWERCASE=$( tr '[A-Z]' '[a-z]' <<< ${FOLDER})
docker build -t "zplg-configs/${FOLDER_LOWERCASE}" .

# Run a container
docker run -ti "zplg-configs/${FOLDER_LOWERCASE}" env TERM="${TERM}" zsh
