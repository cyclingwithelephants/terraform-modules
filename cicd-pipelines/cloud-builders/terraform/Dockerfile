FROM alpine:3.9

ARG TERRAFORM_VERSION
ARG TERRAFORM_VERSION_SHA256SUM


COPY terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN echo "${TERRAFORM_VERSION_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > checksum && sha256sum -c checksum
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip


FROM google/cloud-sdk:alpine

COPY --from=0 terraform /usr/bin/terraform

# change default shell from ash to bash
RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

# install binaries
RUN apk update && \
    apk upgrade && \
    apk add \
      jq \
      git \
      bash \
    && rm -rf /var/cache/*/* \
    && echo "" > /root/.ash_history

# copy pipeline files if they exist
ADD ./scripts/ /commands/terraform/

# not too sure what this is for. A little worried I need it set for bash
ENV LC_ALL=en_US.UTF-8

WORKDIR /
