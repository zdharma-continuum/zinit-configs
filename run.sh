#!/usr/bin/env zsh

set -o errexit   # exit on fail
set -o pipefail  # catch errors in pipelines
set -o nounset   # exit on undeclared variable
# set -o xtrace    # trace execution

# Folders containing `.zshrc`
FOLDERS_WITH_ZSHRC=$(cd "${0:a:h}"; find * \( -name .zshrc -o -name zshrc.zsh \) -type f -exec dirname {} \;)

# A fuzzy finder available
if command -v fzy > /dev/null; then
    FUZZY_FINDER=fzy
elif command -v fzf > /dev/null; then
    FUZZY_FINDER=fzf
else
    echo 'No supported fuzzy finder found. Exiting!'
    exit 1
fi

# Folder to load, chosen by user
FOLDER=$(${FUZZY_FINDER} <<< ${FOLDERS_WITH_ZSHRC})

# Create a Dockerfile
DOCKERFILE="Dockerfile"
cat > "${0:a:h}/${DOCKERFILE}" <<END
FROM ubuntu:18.04
RUN apt update && \
    apt install --yes ncurses-dev unzip zsh git subversion curl build-essential python \
                        vim htop sudo golang-go cmake 

RUN adduser --disabled-password --gecos '' user
RUN adduser user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user

RUN sh -c "\$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"

COPY --chown=user ${FOLDER} /home/user
# Conditional copy of a possible .zshrc named differently
COPY --chown=user ${FOLDER}/zshrc.zsh* /home/user/.zshrc

RUN TERM=${TERM} SHELL=/bin/zsh zsh -i -c -- '-zplg-scheduler burst || true'
CMD zsh
END

# Build an image
FOLDER_LOWERCASE="${(L)FOLDER}"
docker build -t "zplg-configs/${FOLDER_LOWERCASE}" "${0:a:h}"

# Run a container
docker run -ti "zplg-configs/${FOLDER_LOWERCASE}" env TERM="${TERM}" zsh