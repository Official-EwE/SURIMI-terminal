#!/bin/bash
set -e

# Persist K8s env vars for login shells (su - strips them)
{
  echo "export KUBERNETES_SERVICE_HOST=${KUBERNETES_SERVICE_HOST:-kubernetes.default.svc}"
  echo "export KUBERNETES_SERVICE_PORT=${KUBERNETES_SERVICE_PORT:-443}"
  echo 'export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"'
  [ -n "$PASSWORD" ] && echo "export PASSWORD=$PASSWORD"
} >> /home/onyxia/.bashrc
chown onyxia:onyxia /home/onyxia/.bashrc

# Start sshd
/usr/sbin/sshd -D &

# ttyd with password if set
TTYD_ARGS="--port 7681 --writable"
if [ -n "$PASSWORD" ]; then
  TTYD_ARGS="$TTYD_ARGS --credential onyxia:$PASSWORD"
fi

exec su - onyxia -c "exec ttyd $TTYD_ARGS bash"
