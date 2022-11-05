FROM ubuntu:18.04

# Update && install common dependencies
ARG ZINIT_CONFIG
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt install -yq \
    autoconf \
    automake  \
    curl  \
    git  \
    golang-go \
    htop \
    locales \
    make \
    man \
    ncurses-dev \
    python \
    subversion \
    sudo \
    telnet \
    unzip \
    vim \
    zsh

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add user
RUN adduser --disabled-password --gecos '' user \
 && adduser user sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && usermod --shell /bin/zsh user
USER user

# Install zinit
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# Copy configs into home directory
COPY --chown=user "${ZINIT_CONFIG}" /home/user/
RUN mv /home/user/zshrc /home/user/.zshrc

WORKDIR /home/user
ENTRYPOINT ["zsh"]
CMD ["-i", "-l"]

