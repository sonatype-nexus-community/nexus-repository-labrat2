# declaration of NEXUS_VERSION must appear before first FROM command
# see: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG NEXUS_VERSION=latest

FROM maven:3-jdk-8-alpine AS build

COPY . /nexus-repository-labrat2/
RUN cd /nexus-repository-labrat2/; \
    mvn clean package -PbuildKar;

FROM sonatype/nexus3:$NEXUS_VERSION

ARG DEPLOY_DIR=/opt/sonatype/nexus/deploy/
USER root
COPY --from=build /nexus-repository-labrat2/nexus-repository-labrat2/target/nexus-repository-labrat2-*-bundle.kar ${DEPLOY_DIR}
USER nexus
