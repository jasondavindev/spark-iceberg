FROM openjdk:8-jre-slim

ARG SPARK_VERSION=3.2.1

ENV SPARK_VERSION ${SPARK_VERSION}
ENV HADOOP_VERSION 3.2
ENV TAR_FILE spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
ENV SPARK_HOME /opt/spark
ENV PATH "${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin"
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/conf

RUN apt update; \
    apt upgrade -y; \
    apt install -y \
    python3-pip \
    wget \
    procps \
    curl

# download spark
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${TAR_FILE}

RUN tar -xzvf ${TAR_FILE} -C /opt; \
    ln -sL /opt/${TAR_FILE%.tgz} ${SPARK_HOME}; \
    rm /${TAR_FILE}

# Install Apache Icebert

RUN wget https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.2_2.12/0.13.1/iceberg-spark-runtime-3.2_2.12-0.13.1.jar \
    -O ${SPARK_HOME}/jars/iceberg-spark-runtime-3.2_2.12-0.13.1.jar

WORKDIR ${SPARK_HOME}

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]