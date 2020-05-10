FROM busybox

ENV HUGO_VERSION=0.65.3

RUN wget -O- https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz | tar zx


FROM google/cloud-sdk:alpine

COPY --from=0 /hugo /usr/local/bin/hugo

ADD ./scripts/ /builder/hugo/
