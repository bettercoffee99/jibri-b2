ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Broadcasting Infrastructure (jibri)"
LABEL org.opencontainers.image.description="Components for recording and/or streaming a conference."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jibri"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ENV RCLONE_VER=1.56.2 \
    BUILD_DATE=20220325T013603 \
    ARCH=amd64 \
    SUBCMD="" \
    CONFIG="--config /config/rclone/rclone.conf" \
    PARAMS=""

LABEL build_version="Version:- ${RCLONE_VER} Build-date:- ${BUILD_DATE}"

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y jibri libgl1-mesa-dri procps jitsi-upload-integrations jq && \
    apt-cleanup

RUN curl -O https://downloads.rclone.org/v${RCLONE_VER}/rclone-v${RCLONE_VER}-linux-${ARCH}.zip && \
    unzip rclone-v${RCLONE_VER}-linux-${ARCH}.zip && \
    cd rclone-*-linux-${ARCH} && \
    cp rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone && \
    cd ../ && \
    rm -f rclone-v${RCLONE_VER}-linux-${ARCH}.zip && \
    rm -r rclone-*-linux-${ARCH} && \
    mkdir -p /home/jibri/.config/pulse && \
    mkdir -p /home/jibri/.config/rclone/ && \
    chown -R jibri:jibri /home/jibri/.config/

#ARG CHROME_RELEASE=latest
#ARG CHROMEDRIVER_MAJOR_RELEASE=latest
ARG CHROME_RELEASE=96.0.4664.45
ARG CHROMEDRIVER_MAJOR_RELEASE=96
COPY build/install-chrome.sh /install-chrome.sh
RUN /install-chrome.sh && \
    rm /install-chrome.sh

COPY rootfs/ /

VOLUME /config
