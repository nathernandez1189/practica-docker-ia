#!/usr/bin/env bash
set -euo pipefail
# Ejecutar como root dentro de Ubuntu 22.04.
source /etc/os-release
[[ "$ID" == ubuntu && "$VERSION_ID" == 22.04 ]] || { echo 'Se requiere Ubuntu 22.04'; exit 1; }
if ! command -v docker >/dev/null; then
  conflicts=()
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q 'install ok installed'; then conflicts+=("$pkg"); fi
  done
  if ((${#conflicts[@]})); then apt-get remove -y "${conflicts[@]}"; fi
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  printf 'deb [arch=%s signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu %s stable\n' "$(dpkg --print-architecture)" "$VERSION_CODENAME" > /etc/apt/sources.list.d/docker.list
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  apt-get clean
fi
usermod -aG docker vagrant
systemctl enable --now docker
docker run --rm hello-world
systemctl is-active docker
docker version
