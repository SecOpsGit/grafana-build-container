FROM centos:6.6

RUN yum install -y yum-plugin-ovl initscripts curl tar gcc libc6-dev gcc-c++ openssl-devel && \
    yum install -y g++ make automake autoconf curl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel && \
    yum install -y wget yum-utils bzip2 bzip2-devel && \
    yum install -y fontconfig freetype freetype-devel fontconfig-devel libstdc++ && \
    yum install -y rpm-build patch readline readline-devel libtool bison lzma && \
    yum install -y which tar expect

# Install RUBY 1.9.3
# install necessary utilities
# RUN yum install -y which tar
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    curl -sSl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable && \
    source /etc/profile.d/rvm.sh && \
    /bin/bash -l -c "rvm requirements" && \
    /bin/bash -l -c "rvm install 2.1.9" && \
    /bin/bash -l -c "rvm use 2.1.9 --default" && \
    /bin/bash -l -c "gem install fpm -v 1.4"

# install nodejs
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
    yum install -y nodejs --nogpgcheck

# Install git 2.16.2
RUN yum groupinstall -y "Development Tools" && \
    yum install -y gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel wget which tar && \
    wget https://github.com/git/git/archive/v2.16.2.tar.gz -O git.tar.gz && \
    tar zxf git.tar.gz && \
    cd git-* && \
    make configure && \
    ./configure --prefix=/usr && \
    make install && \
    cd .. && \
    rm git.tar.gz && \
    rm -rf git-*

# Add to build container
#  - pip install awscli and python 2.7.3
#    - sudo apt-get update; sudo apt-get install rpm; sudo apt-get install expect

ENV GOLANG_VERSION 1.9.3

RUN wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo && \
    yum install -y yarn --nogpgcheck && \
    wget https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz


ENV PATH /usr/local/go/bin:$PATH

RUN mkdir -p /go/src /go/bin && chmod -R 777 /go

ENV GOPATH /go
ENV PATH /go/bin:$PATH