FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

LABEL version="1.0.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/kyverno-cli"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="kyverno-cli"
LABEL "com.github.actions.description"="Run kyverno using BATS"
LABEL "com.github.actions.branding.icon"="monitor"
LABEL "com.github.actions.branding.color"="purple"

RUN microdnf upgrade --assumeyes && \
    microdnf install --assumeyes --nodocs tar wget python3 git findutils diffutils bc && \
    microdnf clean all && \
    tar --version && \
    wget --version && \
    python3 --version && \
    git --version && \
    diff --version && \
    bc --version

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

RUN export KYVERNO_VERSION=v1.4.2 && \
    wget --no-verbose https://github.com/kyverno/kyverno/releases/download/${KYVERNO_VERSION}/kyverno-cli_${KYVERNO_VERSION}_linux_x86_64.tar.gz && \
    tar -C /tmp -xzf kyverno-cli_${KYVERNO_VERSION}_linux_x86_64.tar.gz && \
    ln -s /tmp/kyverno /usr/local/bin/kyverno && \
    kyverno --help

RUN pip3 install yq && \
    yq --version

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
