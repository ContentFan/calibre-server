FROM debian:12-slim

RUN apt update && apt install -y --no-install-recommends \
    python3 \
    curl \
    ca-certificates \
    xz-utils \
    libegl1 \
    libfontconfig1 \
    libxkbcommon0 \
    libglx0 \
    libopengl0 \
    expect

ENV USER=calibre
ENV BASE_DIR=/home/$USER
ENV APP_DIR=$BASE_DIR/app
ENV LIBS_ROOT=$BASE_DIR/libraries

RUN useradd -ms /bin/bash $USER

USER $USER

RUN mkdir -p $BASE_DIR && mkdir -p $LIBS_ROOT && mkdir -p $APP_DIR

WORKDIR $APP_DIR

ARG VERSION=6.22.0

RUN curl -s --output - https://download.calibre-ebook.com/$VERSION/calibre-$VERSION-arm64.txz | tar Jxv

ADD --chown=$USER:$USER adduser.ex .

ADD --chown=$USER:$USER start-server.py .

CMD ["python3", "start-server.py"]
