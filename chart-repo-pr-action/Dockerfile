FROM registry.access.redhat.com/ubi8/ubi-minimal:8.2

## According to the GH Actions doc, the user must run as root
## https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions#user
USER root

ARG GH_VERSION=1.0.0

## Install git and diff
RUN microdnf install --assumeyes --nodocs tar git diffutils && \
    microdnf clean all && \
    tar --version && \
    git --version && \
    diff --version

## Install gh cli
RUN curl -L -O https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz && \
    tar -xzf gh_${GH_VERSION}_linux_amd64.tar.gz && \
    mv gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin && \
    rm -rf gh gh.tar.gz && \
    gh --version

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]