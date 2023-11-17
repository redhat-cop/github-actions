FROM registry.access.redhat.com/ubi9/ubi-minimal:9.1@sha256:95413c8dacaac773421428947a431c1cb099d19b4b1125df77d5d1cd2f463ab8

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
