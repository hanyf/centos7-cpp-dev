FROM centos:7

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

RUN useradd builder -u 1000 -m -G users,wheel

USER builder

WORKDIR /home/builder