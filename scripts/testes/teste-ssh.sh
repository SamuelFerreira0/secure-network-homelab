#!/bin/bash
exec 2>&1
for i in $(seq 1 10); do
  timeout 6 ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=3 invalido$i@10.10.20.20 true 2>&1 | tail -1
done
