FROM ubuntu:latest
WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget vim

# install hadoop 2.7.2
RUN wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz && \
    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz

# install spark
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz && \
    tar -xvf spark-2.2.0-bin-hadoop2.7.tgz && \
    mv spark-2.2.0-bin-hadoop2.7 /usr/local/spark && \
    rm spark-2.2.0-bin-hadoop2.7.tgz

# set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV SPARK_HOME=/usr/local/spark
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native:$LD_LIBRARY_PATH
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/spark/bin 

COPY config/* /tmp/

RUN mkdir -p ~/.ssh && \
    mv /tmp/id_rsa.hadoop-master.pub ~/.ssh/authorized_keys

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''

RUN mkdir -p ~/hdfs/namenode && \
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs && \
    mkdir -p ~/examples

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/start-hadoop.sh /usr/local/bin/start-hadoop.sh && \
    mv /tmp/start-wordcount.sh ~/examples/start-wordcount.sh && \
    mv /tmp/file-wordcount.txt ~/examples/file-wordcount.txt && \
    mv /tmp/wordcount.jar ~/examples/wordcount.jar && \
    mv /tmp/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

RUN chmod +x /usr/local/bin/start-hadoop.sh && \
    chmod +x ~/examples/start-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]
