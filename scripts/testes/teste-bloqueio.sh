#!/bin/bash
exec 2>&1
timeout 3 bash -c 'echo > /dev/tcp/1.1.1.1/443' 2>/dev/null && echo "443 Internet: ok" || echo "443 Internet: BLOQUEADO"
