FROM team8/s2i-base:1

ENV \
  S2I_HOME='/usr/libexec/s2i' \
  SUMMARY="java-s2i-builder" \
  DESCRIPTION="An S2I builder for java apps."

LABEL \
  description="$DESCRIPTION" \
  summary="$SUMMARY" \
  io.k8s.description="$DESCRIPTION" \
  io.k8s.display-name="$SUMMARY" \
  io.openshift.expose-services="8080:http" \
  io.openshift.tags="s2i,builder,java,jdk" \
  io.openshift.s2i.scripts-url="image://$S2I_HOME"

RUN \
  yum -y update && \
  yum -y upgrade && \
  yum -y install yum-utils maven java-11-openjdk && \
  yum -y clean all && \
  rm -fr /var/cache/yum

COPY ./s2i/bin/ $S2I_HOME/.

RUN \
  chown -R 1001:1001 /opt && \
  chown -R 1001:1001 $S2I_HOME && \
  chmod +x $S2I_HOME/*

USER 1001
EXPOSE 8080

