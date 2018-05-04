FROM alpine

# expose tcp port
EXPOSE 2222

# add non-root user
# TODO https://github.com/gliderlabs/docker-alpine/issues/38#issuecomment-385264500
RUN addgroup -g 1000 alpine \
  && adduser -u 1000 -s /bin/sh -G alpine -D alpine \
  && passwd -u alpine

# install openssh
RUN apk add --no-cache openssh

# disallow user logins
RUN echo 'This is Tunneller' > /etc/nologin

# copy artifacts
COPY ssh /usr/local/

# change to non-root user
USER alpine

# start openssh daemon
ENTRYPOINT ["/usr/local/sbin/sshd"]
