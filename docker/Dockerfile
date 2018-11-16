FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
MAINTAINER comafire <comafire@gmail.com>

# Bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
apt-utils \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Lang
ARG locale="ko_KR.UTF-8"
ENV LOCALE ${locale}
RUN echo "LOCALE: $LOCALE"
RUN if [[ $LOCALE = *ko* ]] \
; then \
apt-get update && apt-get install -y --no-install-recommends \
locales language-pack-ko \
; else \
apt-get update && apt-get install -y --no-install-recommends \
locales language-pack-en \
; fi
RUN echo "$LOCALE UTF-8" > /etc/locale.gen && locale-gen
ENV LC_ALL ${LOCALE}
ENV LANG ${LOCALE}
ENV LANGUAGE ${LOCALE}
ENV LC_MESSAGES POSIX

# Common
RUN apt-get update && apt-get install -y --no-install-recommends \
build-essential vim curl wget git cmake bzip2 sudo unzip net-tools \
libffi-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm \
libfreetype6-dev libxft-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
software-properties-common libjpeg-dev libpng-dev ncurses-dev imagemagick \
libgraphicsmagick1-dev libzmq-dev gfortran gnuplot gnuplot-x11 libsdl2-dev \
openssh-client htop iputils-ping

# Docker
RUN apt-get update && apt-get install -y --no-install-recommends \
apt-transport-https ca-certificates
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y --no-install-recommends \
docker-ce

# Python2
RUN apt-get update && apt-get install -y --no-install-recommends \
python python-dev python-pip python-virtualenv python-software-properties
RUN pip2 install --upgrade pip
RUN pip2 install --cache-dir /tmp/pip2 --upgrade setuptools wheel

# Python3
RUN apt-get update && apt-get install -y --no-install-recommends \
python3 python3-dev python3-pip python3-virtualenv python3-software-properties
RUN pip3 install --upgrade pip
RUN pip3 install --cache-dir /tmp/pip3 --upgrade setuptools wheel

# JAVA
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN add-apt-repository ppa:webupd8team/java \
&& apt-get update \
&& apt-get install -y oracle-java8-installer 
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre/
ENV PATH $PATH:$JAVA_HOME/bin
RUN apt-get update && apt-get install -y --no-install-recommends \
maven

# R
RUN apt-get update && apt-get --allow-unauthenticated install -y --no-install-recommends \
r-base r-base-dev

# Database
RUN apt-get update && apt-get install -y --no-install-recommends \
libmysqlclient-dev libpq-dev postgresql-client

# FUSE file system
RUN apt-get update && apt-get install -y --no-install-recommends \
automake autotools-dev g++ git libcurl4-gnutls-dev libssl-dev libxml2-dev make pkg-config \
fuse libfuse-dev

# FUSE-SSHFS
RUN apt-get update && apt-get install -y --no-install-recommends \
sshfs

# FUSE-S3
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git;cd s3fs-fuse;./autogen.sh;./configure;make;make install

# FUSE-BLOB
RUN wget https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get update && apt-get install -y --no-install-recommends \
blobfuse

# SPARK
ENV SPARK_VERSION 2.3.2
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-hadoop2.7
ENV SPARK_HOME /usr/local/spark-${SPARK_VERSION}
ENV PY4J_VERSION 0.10.7

ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
"http://www-us.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
| gunzip | tar x -C /usr/local \
&& mv /usr/local/$SPARK_PACKAGE $SPARK_HOME \
&& ln -s $SPARK_HOME /usr/local/spark \
&& chown -R root:root $SPARK_HOME
ENV PYTHONPATH $SPARK_HOME/python/:$PYTHONPATH
ENV PYTHONPATH $SPARK_HOME/python/lib/py4j-$PY4J_VERSION-src.zip:$PYTHONPATH

RUN pip2 install --cache-dir /tmp/pip2 --timeout 600 py4j==$PY4J_VERSION
RUN pip3 install --cache-dir /tmp/pip3 --timeout 600 py4j==$PY4J_VERSION

# for Airflow (don't use GPL dependency library)
ENV SLUGIFY_USES_TEXT_UNIDECODE yes

# Python2 Deps
RUN pip2 install --cache-dir /tmp/pip2 --timeout 600 numpy scipy scikit-learn matplotlib pandas pandas_ml pandas-datareader quandl h5py
RUN pip2 install --cache-dir /tmp/pip2 --timeout 600 statsmodels imblearn awscli seaborn xgboost nbformat boto3 xlrd pyarrow
RUN pip2 install --cache-dir /tmp/pip2 --timeout 600 docker fabric pytest pycrypto
RUN pip2 install --cache-dir /tmp/pip2 --timeout 600 mysql-python mysql-connector-python-rf
RUN pip2 install --cache-dir /tmp/pip2 --timeout 600 pymysql psycopg2 sqlalchemy

# Python3 Deps
RUN pip3 install --cache-dir /tmp/pip3 --timeout 600 numpy scipy sklearn matplotlib pandas pandas_ml pandas-datareader quandl h5py
RUN pip3 install --cache-dir /tmp/pip3 --timeout 600 statsmodels imblearn awscli seaborn xgboost nbformat boto3 xlrd pyarrow
RUN pip3 install --cache-dir /tmp/pip3 --timeout 600 docker fabric pytest pycrypto
RUN pip3 install --cache-dir /tmp/pip3 --timeout 600 mysqlclient mysql-connector-python-rf
RUN pip3 install --cache-dir /tmp/pip3 --timeout 600 pymysql psycopg2 sqlalchemy
RUN pip3 install --cache-dir /tmp/pip3 --timeout 600 ghp-import2 nikola[extras]

# DeepLearning
ARG gpu="FALSE"
ENV GPU ${gpu}
ENV TENSORFLOW_VER 1.11.0
ENV PYTORCH_VER 0.4.0
RUN echo "GPU: $GPU"
RUN if [[ $GPU = *TRUE* ]] \
; then \
# For Tensorflow GPU
apt-get update && apt-get install -y --no-install-recommends \
libcupti-dev nvidia-modprobe \
&& pip2 install --cache-dir /tmp/pip2 --timeout 600 tensorflow-gpu==$TENSORFLOW_VER keras \
http://download.pytorch.org/whl/cu90/torch-$PYTORCH_VER-cp27-cp27mu-linux_x86_64.whl \
torchvision \
&& pip3 install --cache-dir /tmp/pip3 --timeout 600 tensorflow-gpu==$TENSORFLOW_VER keras \
http://download.pytorch.org/whl/cu90/torch-$PYTORCH_VER-cp35-cp35m-linux_x86_64.whl \
torchvision \
; else \
pip2 install --cache-dir /tmp/pip2 --timeout 600 tensorflow==$TENSORFLOW_VER keras \
http://download.pytorch.org/whl/cpu/torch-$PYTORCH_VER-cp27-cp27mu-linux_x86_64.whl \
torchvision \
&& pip3 install --cache-dir /tmp/pip3 --timeout 600 tensorflow==$TENSORFLOW_VER keras \
http://download.pytorch.org/whl/cpu/torch-$PYTORCH_VER-cp35-cp35m-linux_x86_64.whl \
torchvision \
; fi

# Jupyter Deps
RUN apt-get update && apt-get install -y --no-install-recommends \
texlive-xetex

# Jupyter
RUN pip3 install -v --no-cache-dir --timeout 600 jupyter
# Jupyter extensions
RUN pip3 install -v --no-cache-dir --timeout 600 jupyter_contrib_nbextensions
RUN pip3 install -v --no-cache-dir --timeout 600 jupyter_nbextensions_configurator
RUN pip3 install -v --no-cache-dir --timeout 600 yapf
RUN pip3 install -v --no-cache-dir --timeout 600 nbimporter jdc jupyter_kernel_gateway

# Jupyter Python2 kernel
RUN python2 -m pip install ipykernel
RUN python2 -m ipykernel install --user

# Jupyter Python3 kernel
RUN python3 -m pip install ipykernel
RUN python3 -m ipykernel install --user

# Scala via coursier and Jupyter Scala
# ENV SCALA_VERSION 2.11.11
# ENV SCALA_HOME /usr/local/scala-${SCALA_VERSION}

# ENV PATH $PATH:$SCALA_HOME/bin
# RUN curl -sL --retry 3 --insecure \
# "https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz" \
# | gunzip | tar x -C /usr/local/ \
# && ln -s $SCALA_HOME /usr/local/scala
ENV SCALA_VERSION 2.11.12
ENV ALMOND_VERSION 0.1.11
RUN curl -L -o coursier https://git.io/coursier && chmod +x coursier
RUN ./coursier bootstrap \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    -o almond
RUN ./almond --install && rm -f ./almond

# Jupyter R kernel
RUN apt-get update && apt-get install -y --no-install-recommends \
libcurl4-gnutls-dev libxml2-dev libssl-dev
RUN R -e "install.packages(c('curl', 'repr', 'httr'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('pbdZMQ', 'devtools', 'IRdisplay', 'evaluate', 'crayon', 'uuid', 'digest'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('SparkR'), repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_github('IRkernel/IRkernel')"
RUN R -e "IRkernel::installspec()"

# Env
VOLUME /root/volume
WORKDIR /root/volume

EXPOSE 8888 8088

