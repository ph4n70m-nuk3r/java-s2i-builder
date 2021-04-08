FROM 172.30.1.1:5000/investments-nexus-d00/ubi

RUN whoami
RUN ls -1 /opt | sort

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

RUN yum upgrade -y
RUN yum install yum-utils maven java-11-openjdk-devel -y
RUN yum clean all
RUN repoquery --list java-11-openjdk-devel

RUN /usr/sbin/alternatives --set java java-11.0.0-openjdk.x86_64
RUN /usr/sbin/alternatives --set javac javac-11.0.0-openjdk.x86_64

RUN mvn -version
RUN java -version

RUN mkdir -p '/opt/app'
RUN chown -R 1001:1001 '/opt/app'

RUN chown -R 1001:1001 '/usr/libexec/s2i'
RUN chmod +x '/usr/libexec/s2i/assemble'
RUN chmod +x '/usr/libexec/s2i/run'

RUN ls -la '/usr/libexec/s2i'

USER 1001
EXPOSE 8080
