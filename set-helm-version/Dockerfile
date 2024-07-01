FROM registry.access.redhat.com/ubi9/python-39:1-186.1719562233@sha256:c949cb81a6f72ca157501949d07095e87b3c8f1a9ff5a69ff0a858faac21217b

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
