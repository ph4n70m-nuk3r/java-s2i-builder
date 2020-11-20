FROM team8/openjdk-11:1.3-6

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
  sudo dnf makecache          && \
  sudo dnf update    --nodocs && \
  sudo dnf install   maven    && \
  sudo dnf clean     all

COPY ./s2i/bin/ $S2I_HOME/.

RUN \
  chown -R 1001:1001 /opt && \
  chown -R 1001:1001 $S2I_HOME && \
  chmod +x $S2I_HOME/*

USER 1001
EXPOSE 8080

