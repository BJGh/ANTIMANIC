FROM debian:12-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    grub-pc-bin grub-efi-amd64-bin grub-common xorriso mtools ca-certificates \
    parted e2fsprogs rsync coreutils util-linux \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work

COPY build_iso.sh /work/build_iso.sh
RUN chmod +x /work/build_iso.sh

ENTRYPOINT ["/work/build_iso.sh"]
