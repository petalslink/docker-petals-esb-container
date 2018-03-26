
# FIXME: try Alpine!!!!
FROM openjdk:8u151-jre

# Expose ports
# See https://doc.petalslink.com/display/petalsesbsnapshot/Topology+Configuration
# FIXME: there may be an issue with JMX / RMI (see https://ptmccarthy.github.io/2014/07/24/remote-jmx-with-docker)
EXPOSE 7700 7800

# Add tags
LABEL \
	maintainer="The Petals team" \
	contributors="Maxime Robert (Linagora), Pierre Souquet (Linagora), Vincent Zurczak (Linagora)" \
	github="https://github.com/petalslink"

# Build arguments
ARG PETALS_VERSION="LATEST"
ARG MAVEN_POLICY="releases"
ARG BASE_URL="https://repository.ow2.org/nexus/service/local/artifact/maven/redirect"

# Copy the script (first)
COPY docker-wrapper.sh /opt/petals-esb/docker-wrapper.sh

# FIXME: only works for a single node.
# If a node has to be tailored / customized ("node-0" instead of "default"), deal with it inside a script
# to be launched along with the container. The script will customize the settings before launching the ESB.
# Important: temporary system packages are deleted at the end.
RUN apt-get update -y && \
  apt-get install curl -y && \
  apt-get upgrade -y && \
  curl -L "${BASE_URL}?g=org.ow2.petals&r=${MAVEN_POLICY}&a=petals-esb-minimal-zip&v=${PETALS_VERSION}&p=zip" -o /tmp/petals-esb-minimal.zip --silent && \
  curl -L "${BASE_URL}?g=org.ow2.petals&r=${MAVEN_POLICY}&a=petals-esb-minimal-zip&v=${PETALS_VERSION}&p=zip.sha1" -o /tmp/petals-esb-minimal.zip.sha1 --silent && \
  [ `sha1sum /tmp/petals-esb-minimal.zip | cut -d" " -f1` = `cat /tmp/petals-esb-minimal.zip.sha1` ] && \
  unzip /tmp/petals-esb-minimal.zip -d /opt/petals-esb && \
  rm -rf /tmp/petals-esb-minimal.* && \
  chmod 775 /opt/petals-esb/docker-wrapper.sh && \
  apt-get purge curl -y && \
  apt-get autoremove -y && \
  apt-get clean -y

# Set the working directory
WORKDIR /opt/petals-esb

# Indicate the default script
CMD /opt/petals-esb/docker-wrapper.sh
