FROM ubi8/openjdk-11:1.3-10

RUN whoami
RUN mkdir opt || ls opt || true

ENV S2I_HOME='/usr/libexec/s2i'
ENV SUMMARY="java-s2i-builder"
ENV DESCRIPTION="An S2I builder for java apps."
ENV M2_ARCHIVE='deps/apache-maven-3.6.3-bin.tar.gz'

LABEL description="$DESCRIPTION"
LABEL summary="$SUMMARY"
LABEL io.k8s.description="$DESCRIPTION"
LABEL io.k8s.display-name="$SUMMARY"
LABEL io.openshift.expose-services="8080:http"
LABEL io.openshift.tags="s2i,builder,java,jdk"
LABEL io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

COPY ./s2i/bin/ '/usr/libexec/s2i'

RUN ls -la / || true
RUN ls -la ~ || true
RUN pwd
RUN ls -la $(pwd) || true
RUN tar xzvf 'deps/apache-maven-3.6.3-bin.tar.gz' -C /opt 
RUN rm 'deps/apache-maven-3.6.3-bin.tar.gz'
RUN ls -R /opt
RUN chown -R 1001:1001 /opt
RUN chown -R 1001:1001 '/usr/libexec/s2i'
RUN chmod +x '/usr/libexec/s2i'*

USER 1001
EXPOSE 8080

