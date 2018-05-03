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

# generate hostkeys
RUN su - alpine -c "ssh-keygen -t dsa -f /home/alpine/.ssh/ssh_host_dsa_key -N '' 1>> /dev/null \
  && ssh-keygen -t ecdsa -f /home/alpine/.ssh/ssh_host_ecdsa_key -N '' 1>> /dev/null \
  && ssh-keygen -t ed25519 -f /home/alpine/.ssh/ssh_host_ed25519_key -N '' 1>> /dev/null \
  && ssh-keygen -t rsa -b 4096 -f /home/alpine/.ssh/ssh_host_rsa_key -N '' 1>> /dev/null"

# disallow user logins
RUN echo 'This is Tunneller' > /etc/nologin

# copy custom configuration
COPY --chown=alpine:alpine ssh /home/alpine/.ssh/

# change to non-root user
USER alpine

# start openssh daemon
ENTRYPOINT ["/usr/sbin/sshd", "-D", "-f", "/home/alpine/.ssh/sshd_config"]
