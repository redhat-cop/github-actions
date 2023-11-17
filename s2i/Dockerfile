FROM registry.access.redhat.com/ubi9/ubi-minimal:9.3-1361.1699548032@sha256:c77792b8084ce5946c68f39024fa460ef7769c0eef3fce995e70299e21a7e166

LABEL version="1.0.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/s2i"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="Source2Image build"
LABEL "com.github.actions.description"="Runs source2image build"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="purple"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
