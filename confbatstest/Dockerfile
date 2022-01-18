# Builder image for go
FROM registry.access.redhat.com/ubi8/go-toolset:1.16.12 AS go-builder
RUN GOBIN=/tmp/go-bin go install github.com/plexsystems/konstraint@latest && \
    /tmp/go-bin/konstraint --help

# Builder image
FROM registry.access.redhat.com/ubi8/ubi:8.5 AS builder

RUN export HELM_VERSION=3.7.2 && \
    curl -L -o /tmp/helm-v${HELM_VERSION}-linux-amd64.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -C /tmp -xzf /tmp/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    /tmp/linux-amd64/helm version

RUN export JQ_VERSION=1.6 && \
    curl -L -o /tmp/jq-linux64 https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /tmp/jq-linux64 && \
    /tmp/jq-linux64 --version

RUN export OC_VERSION=4.9.0 && \
    curl -L -o /tmp/openshift-client-linux.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz && \
    tar -C /tmp -xzf /tmp/openshift-client-linux.tar.gz && \
    /tmp/oc version && \
    /tmp/kubectl version

RUN export OPA_VERSION=v0.36.1 && \
    curl -L -o /tmp/opa_linux_amd64 https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64 && \
    chmod +x /tmp/opa_linux_amd64 && \
    /tmp/opa_linux_amd64 --help

RUN export CONFTEST_VERSION=0.30.0 && \
    curl -L -o /tmp/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    tar -C /tmp -xzf /tmp/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    /tmp/conftest --version

RUN export KUBEVAL_VERSION=latest && \
    curl -L -o /tmp/kubeval-linux-amd64.tar.gz https://github.com/instrumenta/kubeval/releases/${KUBEVAL_VERSION}/download/kubeval-linux-amd64.tar.gz && \
    tar -C /tmp -xzf /tmp/kubeval-linux-amd64.tar.gz && \
    /tmp/kubeval --version

# Runnable image
FROM registry.access.redhat.com/ubi8/python-39:1

LABEL version="1.8.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/confbatstest"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="confbatstest"
LABEL "com.github.actions.description"="Run conftest using BATS"
LABEL "com.github.actions.branding.icon"="monitor"
LABEL "com.github.actions.branding.color"="purple"

COPY --from=builder /tmp/linux-amd64/helm /usr/local/bin/helm
RUN helm version

COPY --from=builder /tmp/jq-linux64 /usr/local/bin/jq
RUN jq --version

COPY --from=builder /tmp/oc /usr/local/bin/oc
COPY --from=builder /tmp/kubectl /usr/local/bin/kubectl
RUN oc version && \
    kubectl version

COPY --from=builder /tmp/opa_linux_amd64 /usr/local/bin/opa
RUN opa --help

COPY --from=builder /tmp/conftest /usr/local/bin/conftest
RUN conftest --version

COPY --from=builder /tmp/kubeval /usr/local/bin/kubeval
RUN kubeval --version

COPY --from=go-builder /tmp/go-bin/konstraint /usr/local/bin/konstraint
RUN konstraint --help

USER root

RUN dnf install --assumeyes --nodocs findutils diffutils bc && \
    dnf clean all && \
    git --version && \
    diff --version && \
    bc --version

RUN export BATS_VERSION=master && \
    curl -L -o /tmp/${BATS_VERSION}.tar.gz https://github.com/bats-core/bats-core/archive/${BATS_VERSION}.tar.gz && \
    tar -C /tmp -xzf /tmp/${BATS_VERSION}.tar.gz && \
    /tmp/bats-core-${BATS_VERSION}/install.sh /tmp/bats && \
    ln -s /tmp/bats/bin/bats /usr/local/bin/bats && \
    bats --version

USER 1001

COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt && \
    yq --version

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
