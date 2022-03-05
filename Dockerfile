FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
ENV PYENV_ROOT="/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims/:$PATH"

ARG DJANGO_MODULE="django-module"

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
 && apt-get -qq update \
 && apt-get install -y \
    build-essential \
    libssl-dev \
    wget \
    ca-certificates \
    curl \
    llvm \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libffi-dev \
    liblzma-dev \
    python-openssl \
    python3-distutils \
    python3-pip \
    git \
    zlibc \
    zlib1g \
    zlib1g-dev \
 && git clone https://github.com/pyenv/pyenv.git .pyenv

RUN eval "$(pyenv init --path)"

COPY tox.py.versions tox.py.versions
RUN for V in $(cat tox.py.versions | xargs); do pyenv install "$V"; pyenv global "$V"; done

RUN pip3 install tox pytest

WORKDIR "/${DJANGO_MODULE}"
CMD "tox"
