ARG ATLANTIS_VER="v0.27.0"
FROM ghcr.io/runatlantis/atlantis:${ATLANTIS_VER}
ENV TERRAFORM_ATLANTIS_CONFIG_VER="1.17.4"
ENV TERRAGRUNT_VER="0.55.7"

USER 0
RUN mkdir /tmp/prep
WORKDIR /tmp/prep
RUN apk --update add jq yq direnv aws-cli curl

# terragrunt
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VER}/terragrunt_linux_amd64 \
 && mv terragrunt_linux_amd64 terragrunt \
 && install terragrunt /usr/local/bin


# terragrunt-atlantis-config
RUN wget https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAFORM_ATLANTIS_CONFIG_VER}/terragrunt-atlantis-config_${TERRAFORM_ATLANTIS_CONFIG_VER}_linux_amd64.tar.gz \
 && tar xzf terragrunt-atlantis-config_${TERRAFORM_ATLANTIS_CONFIG_VER}_linux_amd64.tar.gz \
 && mv terragrunt-atlantis-config_${TERRAFORM_ATLANTIS_CONFIG_VER}_linux_amd64/terragrunt-atlantis-config_${TERRAFORM_ATLANTIS_CONFIG_VER}_linux_amd64 terragrunt-atlantis-config \
 && install terragrunt-atlantis-config /usr/local/bin 

ADD repos.yaml /home/atlantis/repos.yaml
# tfswitch
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
RUN chmod a+rwx /usr/local/bin/

# cleanup
WORKDIR /
RUN rm -rf /tmp/prep /usr/local/bin/terraform
USER 100

RUN tfswitch -u
ENV PATH=$PATH:/home/atlantis/bin:.
