FROM bash:latest
COPY ./ .

COPY input.txt .
RUN apk add coreutils
CMD /usr/local/bin/bash solution.sh
