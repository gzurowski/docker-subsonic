FROM alpine:3.7

MAINTAINER Gregor Zurowski "gregor@zurowski.org"

ENV SUBSONIC_VERSION=6.1.3
ENV SUBSONIC_UID=2000
ENV SUBSONIC_GID=2000
ENV SUBSONIC_BIN=/opt/subsonic
ENV SUBSONIC_HOME=/var/subsonic

# Install Java and audio tools
RUN apk --update add openjdk8-jre ffmpeg lame && \
    rm -rf /var/cache/apk/*

# Download Subsonic
ADD https://s3-eu-west-1.amazonaws.com/subsonic-public/download/subsonic-${SUBSONIC_VERSION}-standalone.tar.gz /tmp/subsonic.tar.gz

# Set up user and Subsonic binaries
RUN addgroup -g ${SUBSONIC_GID} subsonic && \
    adduser -D -H -h ${SUBSONIC_BIN} -u ${SUBSONIC_UID} -G subsonic -g "Subsonic User" subsonic && \
    mkdir -p ${SUBSONIC_BIN} && \
    tar zxvf /tmp/subsonic.tar.gz -C ${SUBSONIC_BIN} && \
    chown -R subsonic:subsonic ${SUBSONIC_BIN} && \
    chmod -R 0770 ${SUBSONIC_BIN} && \
    rm -rf /tmp/*

# Create data directory
RUN mkdir ${SUBSONIC_HOME} && \
    chown subsonic:subsonic ${SUBSONIC_HOME} && \
    chmod 0770 ${SUBSONIC_HOME}

# Modify startup script
## Don't redirect logs and don't fork main process
RUN sed -i "s/ > \${LOG} 2>&1 &//" ${SUBSONIC_BIN}/subsonic.sh
## Create symlinks for transcoding tools (because Subsonic has hard-coded paths for these)
RUN sed -i '/# Create Subsonic home directory./i \
mkdir -p ${SUBSONIC_BIN}/transcode && ln -fs /usr/bin/ffmpeg /usr/bin/lame ${SUBSONIC_BIN}/transcode\n' ${SUBSONIC_BIN}/subsonic.sh

VOLUME ${SUBSONIC_HOME}
VOLUME /var/music

EXPOSE 4040

USER subsonic

ENTRYPOINT ["/bin/sh", "-c", "/opt/subsonic/subsonic.sh", "--home=${SUBSONIC_HOME}"]
