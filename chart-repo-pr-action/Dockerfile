FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1731604394@sha256:46f77b7dfba47b041de4c9d8516c24081fc92cc7743fca4a353e7f1c2a4beb19

## According to the GH Actions doc, the user must run as root
## https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions#user
USER root

# renovate: datasource=github-releases depName=cli/cli
ARG GH_VERSION=v2.53.0

## Install git and diff
RUN microdnf install --assumeyes --nodocs tar git diffutils && \
    microdnf clean all && \
    tar --version && \
    git --version && \
    diff --version

## Install gh cli
RUN curl -L -O https://github.com/cli/cli/releases/download/${GH_VERSION}/gh_${GH_VERSION//v}_linux_amd64.tar.gz && \
    tar -xzf gh_${GH_VERSION}_linux_amd64.tar.gz && \
    mv gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin && \
    rm -rf gh gh.tar.gz && \
    gh --version

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
