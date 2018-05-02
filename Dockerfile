FROM ruby:2.5.1-alpine3.7
LABEL maintainer "Sean Escriva <sean.escriva@gmail.com>"

ENV SFN_VERSION 3.0.30

RUN apk add --no-cache ca-certificates curl
RUN apk add --no-cache --virtual .build-deps build-base ruby-dev
RUN set -x \
    && gem install --no-document --version $SFN_VERSION sfn \
    && gem install --no-document sfn-parameters \
                                 sfn-lambda \
                                 sparkle-pack-aws-availability-zones \
                                 sparkle-pack-aws-vpc \
                                 sparkle-pack-aws-amis \
                                 vault \
                                 pry \
    && mkdir -p /root/.aws \
    && apk del .build-deps

WORKDIR /repo

ENTRYPOINT ["/usr/local/bundle/bin/sfn"]

CMD ["-h"]
