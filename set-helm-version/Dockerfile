FROM registry.access.redhat.com/ubi9/python-39:1-1731645406@sha256:84c028923cd3c8554c9b5c1423a553a4cb8f3ee88c17a3d87756c9b08f5e8fe7

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
RUN pip install --require-hashes --no-deps --no-cache-dir -r requirements.txt

COPY entrypoint.py /entrypoint.py
ENTRYPOINT [ "python", "/entrypoint.py" ]
