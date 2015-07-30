FROM ubuntu
MAINTAINER raittes@gmail.com

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install make libssl-dev

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:brightbox/ruby-ng && \
    apt-get -y update && \
    apt-get -y install ruby2.0 ruby2.0-dev && \
    update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby2.0 0 && \
    update-alternatives --install /usr/bin/gem gem /usr/bin/gem2.0 0 && \
    gem install bundler

VOLUME /apinfo
ADD . /apinfo
RUN cd /apinfo && bundler install

WORKDIR /apinfo
CMD ["/usr/local/bin/puma", "-C", "config/puma.rb"]
