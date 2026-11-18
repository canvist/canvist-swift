FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# git is how the agent checks out the revision after the image is built.
# Swift itself is installed by scripts/install-swift.sh so the image and
# the install script stay on the same toolchain.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/install-swift.sh /tmp/install-swift.sh
RUN bash /tmp/install-swift.sh && rm -f /tmp/install-swift.sh

USER ubuntu
