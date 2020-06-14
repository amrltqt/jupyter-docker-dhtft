FROM ubuntu:20.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV MINICONDA_INSTALLER=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH

# User space
RUN mkdir /lab

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates git

RUN wget --quiet ${MINICONDA_INSTALLER} -O ./miniconda.sh \
    && /bin/bash ./miniconda.sh -b -p /opt/conda \
    && rm ./miniconda.sh \
    && ln -s /opt/conda/etc/profils.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate base" >> ~/.bashrc

RUN conda update -n base -c defaults conda
RUN conda install -y -c conda-forge jupyterlab pandas numpy networkx nltk scipy matplotlib pygraphviz pydot pyyaml gdal scikit-learn tensorflow

EXPOSE 80

WORKDIR /lab

CMD [ "jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser"]