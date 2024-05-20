FROM registry.access.redhat.com/ubi9/python-39:1-182.1715774360@sha256:24a03d125e857440f74b445d8deb2c18775dd7c3c4373ce1662a00cf97ef8e25

LABEL version="1.1.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/set-helm-version"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="set-helm-version"
LABEL "com.github.actions.description"="Sets the Helm chart version and appVersion in preparation for a release"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="purple"

WORKDIR /
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY entrypoint.py /entrypoint.py
ENTRYPOINT [ "python", "/entrypoint.py" ]
