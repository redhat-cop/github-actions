FROM registry.access.redhat.com/ubi8/ubi-minimal:8.2

LABEL version="1.2.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/confbatstest"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="confbatstest"
LABEL "com.github.actions.description"="Run conftest using BATS"
LABEL "com.github.actions.branding.icon"="monitor"
LABEL "com.github.actions.branding.color"="purple"

RUN microdnf install --assumeyes --nodocs tar wget python3 git findutils && \
    microdnf clean all

RUN export CONFTEST_VERSION=0.19.0 && \
    wget --no-verbose https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    tar -C /tmp -xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    ln -s /tmp/conftest /usr/local/bin/conftest && \
    conftest --version

RUN export BATS_VERSION=master && \
    wget --no-verbose https://github.com/bats-core/bats-core/archive/${BATS_VERSION}.tar.gz && \
    tar -C /tmp -xzf ${BATS_VERSION}.tar.gz && \
    /tmp/bats-core-${BATS_VERSION}/install.sh /opt/bats && \
    ln -s /opt/bats/bin/bats /usr/local/bin/bats && \
    bats --version

RUN export HELM_VERSION=3.2.1 && \
    wget --no-verbose https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -C /tmp -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    ln -s /tmp/linux-amd64/helm /usr/local/bin/helm && \
    helm version

RUN export JQ_VERSION=1.6 && \
    wget --no-verbose --directory-prefix=/tmp https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /tmp/jq-linux64 && \
    ln -s /tmp/jq-linux64 /usr/local/bin/jq && \
    jq --version

RUN pip3 install yq && \
    yq --version

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]