FROM lambci/lambda:build-provided

LABEL maintainer="Development Seed <info@developmentseed.org>"
LABEL authors="Matthew Hanson  <matt.a.hanson@gmail.com>"

# install system libraries
RUN \
    yum makecache fast; \
    yum install -y yum-utils rpmdevtools; \
    yum install -y wget libpng-devel nasm rsync; \
    yum install -y epel-release; \
    yum install -y bash-completion --enablerepo=epel; \
    yum install -y which; \
    yum install -y zstd --enablerepo=epel; \
    yum clean all; \
    yum autoremove


# Paths to things
ENV \
    BUILD=/build \
    NPROC=4 \
    PREFIX=/usr/local \
    GDAL_CONFIG=/usr/local/bin/gdal-config \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64 \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib64/pkgconfig \
    GDAL_DATA=/usr/local/share/gdal \
    PROJ_LIB=/usr/local/share/proj

# switch to a build directory
WORKDIR /build


RUN cd /build
RUN yumdownloader --enablerepo=epel zstd.x86_64
RUN yumdownloader which.x86_64;
RUN rpmdev-extract *rpm
RUN mkdir -p /var/task; mkdir -p /var/task/bin
RUN cp /build/*/usr/bin/* /var/task/bin

# ZSTD
# RUN \
#     mkdir zstd; \
#     wget -qO- https://github.com/facebook/zstd/archive/v${ZSTD_VERSION}.tar.gz \
#         | tar -xvz -C zstd --strip-components=1; cd zstd; \
#     make -j ${NPROC} install PREFIX=$PREFIX ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 --silent; \
#     cd ..; rm -rf zstd


# Copy shell scripts and config files over
COPY bin/* /usr/local/bin/

WORKDIR /home/geolambda


CMD ["/bin/bash"]