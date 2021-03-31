FROM 172.30.1.1:5000/investments-nexus-d00/ubi

RUN whoami
RUN mkdir /opt || ls /opt

ENV S2I_HOME='/usr/libexec/s2i' \
    SUMMARY="java-s2i-builder" \
    DESCRIPTION="An S2I builder for java apps." \
    M2_ARCHIVE='deps/apache-maven-3.6.3-bin.tar.gz'

LABEL description="$DESCRIPTION" \
      summary="$SUMMARY" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$SUMMARY" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="s2i,builder,java,jdk" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

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

