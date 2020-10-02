FROM alpine

## According to the GH Actions doc, the user must run as root
## https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions#user
USER root

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --no-cache git github-cli

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]