FROM debian:11-slim

ENV BASEDIR=/opt/calibre
ENV LIBRARY=$BASEDIR/library
ENV APP=$BASEDIR/app

RUN mkdir -p $BASEDIR && mkdir -p $LIBRARY && mkdir -p $APP

WORKDIR $APP

RUN apt update && apt install -y --no-install-recommends \
	 curl \
	 ca-certificates \
	 xz-utils \
	 libfontconfig1 \
	 libxkbcommon0 \
	 libglx0 \
	 libopengl0 \
	 libegl1 \
	 expect

ARG VERSION=6.7.1

RUN curl -s --output - https://download.calibre-ebook.com/$VERSION/calibre-$VERSION-arm64.txz | tar Jxv

ADD adduser.ex .

ADD start-server.sh .

CMD ["sh", "-c", "./start-server.sh $LIBRARY"]
