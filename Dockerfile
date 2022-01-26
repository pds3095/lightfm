FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y libxml2 libxslt-dev wget bzip2 gcc vim curl

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda install pytest jupyter scikit-learn

ENV PYTHONDONTWRITEBYTECODE 1

ADD x/recommendations/. /home/recommendations/
ADD lightfm/. /home/lightfm/
ADD x/projectx-backend-92a6b14e8848.json /home/
WORKDIR /home/

ENV GOOGLE_APPLICATION_CREDENTIALS /home/projectx-backend-92a6b14e8848.json

RUN cd lightfm && pip install -e . && pip install -r custom_requirements.txt

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin