FROM quay.io/skopeo/stable:v1.2.0

LABEL version="1.0.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/disconnected-csv"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="disconnected-csv"
LABEL "com.github.actions.description"="Run disconnected-csv to prepare a ClusterServiceVersion for disconnected environments."
LABEL "com.github.actions.branding.icon"="monitor"
LABEL "com.github.actions.branding.color"="purple"

COPY ./attach_image_digests.sh /attach_image_digests.sh
COPY ./add_related_image.py /add_related_image.py

RUN curl -sL https://github.com/mikefarah/yq/releases/download/v4.7.1/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq && \
    curl -sL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/bin/jq && chmod +x /usr/bin/jq && \
    dnf install -qy python3-pip && \
    pip3 install ruamel.yaml && \
    chmod +x /attach_image_digests.sh

ENTRYPOINT ["/attach_image_digests.sh"]
