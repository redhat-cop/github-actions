FROM registry.access.redhat.com/ubi8/ubi-minimal:8.2

LABEL version="1.0.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/github-dispatches"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="github-dispatches"
LABEL "com.github.actions.description"="Triggers a GitHub CI dispatches event."
LABEL "com.github.actions.branding.icon"="monitor"
LABEL "com.github.actions.branding.color"="purple"

RUN microdnf install --assumeyes --nodocs curl && \
    microdnf clean all && \
    curl --version

RUN export JQ_VERSION=1.6 && \
    curl -L -o /tmp/jq-linux64 https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /tmp/jq-linux64 && \
    ln -s /tmp/jq-linux64 /usr/local/bin/jq && \
    jq --version

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]