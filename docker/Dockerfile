FROM alpine AS build

ARG SYMLINKS_VERSION

RUN wget -q https://github.com/brandt/symlinks/archive/refs/tags/v${SYMLINKS_VERSION}.tar.gz && \
    mkdir -p /symlinks && \
    tar -xzf v${SYMLINKS_VERSION}.tar.gz --strip-components=1 -C /symlinks

FROM alpine

COPY --from=build /symlinks /tmp/symlinks
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY symlinks/symlinks-chroot.sh /usr/local/bin/symlinks-chroot.sh

RUN apk update && \
    apk add --no-cache busybox-suid tzdata && \
    apk add --no-cache --virtual .build-deps build-base git && \
    cd /tmp/symlinks && \
    make clean && \
    make CC="gcc -static" INSTALL=install MANDIR=/usr/share/man install && \
    apk del .build-deps && \
    rm -rf /root/.cache /tmp/* /var/cache/apk/* /var/tmp/*

RUN rm -rf /var/spool/cron/crontabs && \
    mkdir -p /var/spool/cron/crontabs && \
    cat <<EOF > /var/spool/cron/crontabs/root
0 0 * * * /usr/local/bin/symlinks-chroot.sh >> /var/log/cron/cron.log 2>&1
EOF

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["crond", "-f"]
