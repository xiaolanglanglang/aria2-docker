FROM alpine:3.20

COPY aria2/ /aria2/

WORKDIR /aria2/

RUN apk add --no-cache aria2

EXPOSE 6800
EXPOSE 6881
EXPOSE 6881/udp

CMD ["sh", "start.sh"]