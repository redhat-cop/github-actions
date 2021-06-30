FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

LABEL version="1.7.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/confbatstest"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="confbatstest"
LABEL "com.github.actions.description"="Run conftest using BATS"
LABEL "com.github.actions.branding.icon"="monitor"
LABEL "com.github.actions.branding.color"="purple"

RUN microdnf install --assumeyes --nodocs tar wget python3 git findutils diffutils && \
    microdnf clean all && \
    tar --version && \
    wget --version && \
    python3 --version && \
    git --version && \
    diff --version

RUN export OPA_VERSION=v0.29.4 && \
    wget --no-verbose --directory-prefix=/tmp https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64 && \
    chmod +x /tmp/opa_linux_amd64 && \
    ln -s /tmp/opa_linux_amd64 /usr/local/bin/opa && \
    opa --help

RUN export CONFTEST_VERSION=0.23.0 && \
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

RUN export HELM_VERSION=3.5.3 && \
    wget --no-verbose https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -C /tmp -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    ln -s /tmp/linux-amd64/helm /usr/local/bin/helm && \
    helm version

RUN export JQ_VERSION=1.6 && \
    wget --no-verbose --directory-prefix=/tmp https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /tmp/jq-linux64 && \
    ln -s /tmp/jq-linux64 /usr/local/bin/jq && \
    jq --version

RUN export OC_VERSION=4.7.0 && \
    wget --no-verbose https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz && \
    tar -C /tmp -xzf openshift-client-linux.tar.gz && \
    ln -s /tmp/oc /usr/local/bin/oc && \
    ln -s /tmp/kubectl /usr/local/bin/kubectl && \
    oc version && \
    kubectl version

RUN export GO_VERSION=1.16.1 && \
    wget --no-verbose https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /tmp -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    ln -s /tmp/go/bin/go /usr/local/bin/go && \
    go version

RUN export KUBEVAL_VERSION=latest && \
    wget --no-verbose https://github.com/instrumenta/kubeval/releases/${KUBEVAL_VERSION}/download/kubeval-linux-amd64.tar.gz && \
    tar -C /tmp -xzf kubeval-linux-amd64.tar.gz && \
    ln -s /tmp/kubeval /usr/local/bin/kubeval && \
    kubeval --version

RUN GO111MODULE=on go get github.com/plexsystems/konstraint && \
    ln -s ~/go/bin/konstraint /usr/local/bin/konstraint && \
    konstraint --help

RUN pip3 install yq && \
    yq --version

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
