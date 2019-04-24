FROM ubuntu:18.04

MAINTAINER Simon Egli <esp-idf_3c3aee@egli.online>

ARG USER=esp
ARG ESP_BRANCH=v3.2

RUN apt-get update && apt-get install -y \
        build-essential git neovim wget unzip sudo \
        libncurses-dev flex bison gperf \
        python python-pip python-setuptools python-serial \
        python-cryptography python-future \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN groupadd -g 1000 -r $USER
RUN useradd -u 1000 -g 1000 --create-home -r $USER

#Change password
RUN echo "$USER:$USER" | chpasswd

#Make sudo passwordless
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$USER

RUN usermod -aG sudo $USER
RUN usermod -aG plugdev $USER
RUN usermod -aG dialout $USER

VOLUME /projects
RUN chown $USER:$USER /projects

USER $USER

WORKDIR /home/$USER

RUN wget https://capnproto.org/capnproto-c++-0.6.1.tar.gz
RUN tar zxf capnproto-c++-0.6.1.tar.gz
RUN cd capnproto-c++-0.6.1 && ./configure && make -j8 check && sudo make install
RUN rm capnproto-c++-0.6.1.tar.gz
RUN cd ..

#ESPRESSIF environment install
ARG XTENSAFILE=xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
RUN wget https://dl.espressif.com/dl/$XTENSAFILE
RUN mkdir -p ~/esp && cd ~/esp && tar xzf ../$XTENSAFILE && cd ..
RUN rm $XTENSAFILE

RUN pwd
RUN cd esp && git clone -b $ESP_BRANCH --recursive https://github.com/espressif/esp-idf.git && cd ~
RUN /usr/bin/python -m pip install --user -r ~/esp/esp-idf/requirements.txt
#End ESPRESSIF environment install

USER root

COPY provisioning/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod +x /usr/local/bin/*

USER $USER

WORKDIR /home/$USER

ENTRYPOINT [ "/usr/local/bin/docker_entrypoint.sh" ]
