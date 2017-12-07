FROM ubuntu:17.04

MAINTAINER Simon Egli <esp-idf_3c3aee@egli.online>

ARG USER=esp

RUN apt-get update && apt-get install -y \
        build-essential git neovim wget unzip sudo \
        libncurses-dev flex bison gperf python python-serial \
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

RUN wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-75-gbaf03c2-5.2.0.tar.gz
RUN mkdir -p ~/esp && cd ~/esp && tar xzf ../xtensa-esp32-elf-linux64-1.22.0-75-gbaf03c2-5.2.0.tar.gz && cd ..
RUN rm xtensa-esp32-elf-linux64-1.22.0-75-gbaf03c2-5.2.0.tar.gz

RUN cd esp && git clone --recursive https://github.com/espressif/esp-idf.git && cd ~

USER root

COPY provisioning/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod +x /usr/local/bin/*

USER $USER

WORKDIR /home/$USER

ENTRYPOINT [ "/usr/local/bin/docker_entrypoint.sh" ]
