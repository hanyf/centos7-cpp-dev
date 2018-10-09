FROM centos:7

MAINTAINER Yanfei Han <kalerfu@gmail.com>

RUN yum update -y

RUN yum install -y 	centos-release-scl \
					centos-release-scl-rh \
					wget \
					which

RUN yum install -y 	devtoolset-7-gcc* \
					devtoolset-7-gdb \
					devtoolset-7-make \
					devtoolset-7-gdb-gdbserver
#					devtoolset-7-\*

RUN echo "source scl_source enable devtoolset-7" >> /etc/bashrc

RUN yum remove -y cmake

RUN source scl_source enable devtoolset-7; scl enable devtoolset-7 bash \
	&& wget https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz \
	&& tar xvf cmake-3.12.3.tar.gz && cd cmake-3.12.3 && ./bootstrap --prefix=/usr/local && make && make install && cd .. && rm -rf cmake-3.12.3*

# Make sudo work
ARG SUDO_USER=builder
ARG SUDO_USER_PASS=builder
RUN yum install sudo -y \
	&& useradd -g wheel ${SUDO_USER} \
	&& chmod 740 /etc/sudoers \
	&& echo "${SUDO_USER}:${SUDO_USER_PASS}" | chpasswd \
	&& sed -i -e 's/^\(%wheel\s\+.\+\)/#\1/gi' /etc/sudoers \
	&& echo '${SUDO_USER} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
	&& echo -e '\n%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
	&& echo -e '\nDefaults:root   !requiretty' >> /etc/sudoers \
	&& echo -e '\nDefaults:%wheel !requiretty' >> /etc/sudoers \
	&& chmod 440 /etc/sudoers

USER builder

WORKDIR /home/builder