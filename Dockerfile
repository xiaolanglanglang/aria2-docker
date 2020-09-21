FROM alpine:3.12 as builder

WORKDIR /

RUN wget https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.gz \ 
    && tar zxvf aria2-1.35.0.tar.gz

RUN apk update \ 
    && apk add musl-dev gnutls-dev libgcrypt-dev libssh2-dev c-ares-dev \ 
    libxml2-dev zlib-dev cppunit-dev gcc g++ sqlite-libs pkgconf autoconf automake libtool make

WORKDIR /aria2-1.35.0

RUN ./configure && make -j4 && make check -j4

FROM alpine:3.12 as prod

RUN mkdir -p /aria2/data && mkdir -p /aria2/conf && mkdir -p /aria2/download && mkdir -p /aria2/bin

COPY aria2.conf /aria2/conf
COPY aria2.session /aria2/data
COPY start.sh /aria2
COPY --from=0 /aria2-1.35.0/src/aria2c /aria2/bin

WORKDIR /aria2/

RUN apk update \ 
    && apk add libstdc++ gnutls libssh2 c-ares libxml2

EXPOSE 6800
EXPOSE 36881
EXPOSE 36881/udp

CMD ["sh", "start.sh"]