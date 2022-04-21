FROM registry.access.redhat.com/ubi8/python-39:1

LABEL version="1.1.0"
LABEL repository="http://github.com/redhat-cop/github-actions"
LABEL homepage="http://github.com/redhat-cop/github-actions/set-helm-version"
LABEL maintainer="Red Hat CoP"
LABEL "com.github.actions.name"="set-helm-version"
LABEL "com.github.actions.description"="Sets the Helm chart version and appVersion in preparation for a release"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="purple"

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ADD entrypoint.py /entrypoint.py
ENTRYPOINT [ "python", "/entrypoint.py" ]