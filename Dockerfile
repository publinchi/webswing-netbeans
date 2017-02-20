FROM ubuntu:16.04

MAINTAINER Publio Estupiñán <publio.estupinan@cobiscorp.com>


RUN echo 'Acquire::http::Proxy "http://pestupinan:Omega2017@192.168.65.253:8080";' >> /etc/apt/apt.conf
RUN apt-get update && apt-get install -y openjdk-8-jdk xvfb curl unzip

ADD state.xml /tmp/state.xml
ADD netbeans.sh /tmp/netbeans.sh

RUN chmod +x /tmp/netbeans.sh
RUN echo 'Installing netbeans'
RUN /tmp/netbeans.sh --silent --state /tmp/state.xml
RUN rm -rf /tmp/*

COPY resources-netbeans /tmp

COPY resources-webswing /tmp

COPY webswing-2.4 /webswing-2.4

RUN mv /tmp/nbplatform.jar /usr/local/netbeans-8.2/platform/lib/nbplatform.jar && \
    mv /tmp/nbexec-pre /usr/local/netbeans-8.2/platform/lib/nbexec-pre && \
    mv /tmp/nbexec-post /usr/local/netbeans-8.2/platform/lib/nbexec-post && \
    mv /tmp/netbeans-ext /usr/local/netbeans-8.2/bin/netbeans-ext && \
    mv /tmp/webswing.config /webswing-2.4/webswing.config && \
    mv /tmp/webswing.sh /webswing-2.4/webswing.sh && \
    rm -rf /tmp/*

WORKDIR /webswing-2.4

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ENV PATH $PATH:$JAVA_HOME/bin

EXPOSE 8080

CMD ["/webswing-2.4/webswing.sh","start"]
