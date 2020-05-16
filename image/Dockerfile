FROM alpine/helm:3.2.1

ARG HELM_CHART=flux
ARG HELM_REPO=https://charts.fluxcd.io/

# kpt gets used as a convenience by the script
ADD https://storage.googleapis.com/kpt-dev/latest/linux_amd64/kpt /usr/local/bin/
ADD https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_amd64 /usr/local/bin/yq
RUN chmod a+x /usr/local/bin/kpt /usr/local/bin/yq

# kpt wants git to be present, even if it doesn't use it
RUN apk add git

COPY ./run-helm.sh .
ENTRYPOINT ["/bin/sh", "./run-helm.sh"]

RUN helm pull $HELM_CHART --repo $HELM_REPO
