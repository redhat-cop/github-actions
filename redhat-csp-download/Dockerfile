FROM registry.access.redhat.com/ubi8/ubi-minimal:8.2

LABEL version="1.0.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/redhat-csp-download"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="redhat-csp-download"
LABEL "com.github.actions.description"="Run redhat-csp-download to download resources from the Red Hat Customer Portal."
LABEL "com.github.actions.branding.icon"="monitor"
LABEL "com.github.actions.branding.color"="purple"

COPY ansible /ansible
RUN microdnf install --assumeyes --nodocs python3 && \
    microdnf clean all && \
    python3 --version

RUN pip3 install -r /ansible/requirements.txt && \
    ansible --version && \
    ansible-galaxy --version && \
    ansible-playbook --version

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]