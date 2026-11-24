#!/usr/bin/env python3
import sys, json, ssl, base64, ipaddress, datetime, urllib.request
LOG = "/var/ossec/logs/active-responses.log"
def log(m):
    open(LOG, "a").write("%s opn-block: %s\n" % (datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S"), m))
conf = {}
for l in open("/var/ossec/etc/opnsense-ar.conf"):
    if "=" in l:
        k, v = l.strip().split("=", 1)
        conf[k] = v
data = json.loads(sys.stdin.readline())
cmd = data.get("command")
try:
    ip = data["parameters"]["alert"]["data"]["srcip"]
    a = ipaddress.ip_address(ip)
except Exception as e:
    log("sem srcip valido: %s" % e); sys.exit(0)
last = int(ip.split(".")[-1])
protegido = (
    a not in ipaddress.ip_network("10.10.0.0/16")
    or a in ipaddress.ip_network("10.10.10.0/24")
    or a in ipaddress.ip_network("10.10.70.0/24")
    or (a in ipaddress.ip_network("10.10.90.0/24") and 10 <= last <= 19)
    or last == 1
)
if protegido:
    log("%s protegido ou fora do ambito, ignorado (%s)" % (ip, cmd)); sys.exit(0)
if cmd not in ("add", "delete"):
    sys.exit(0)
if cmd == "add":
    print(json.dumps({"version": 1, "origin": {"name": "opn-block", "module": "active-response"}, "command": "check_keys", "parameters": {"keys": [ip]}}))
    sys.stdout.flush()
    try:
        ok = json.loads(sys.stdin.readline()).get("command") == "continue"
    except Exception:
        ok = False
    if not ok:
        log("abort ou ja bloqueado: %s" % ip); sys.exit(0)
url = "https://10.10.70.1/api/firewall/alias_util/%s/H_BLOQUEADOS" % cmd
auth = base64.b64encode(("%s:%s" % (conf["OPN_KEY"], conf["OPN_SECRET"])).encode()).decode()
req = urllib.request.Request(url, data=json.dumps({"address": ip}).encode(),
      headers={"Content-Type": "application/json", "Authorization": "Basic " + auth})
ctx = ssl.create_default_context(); ctx.check_hostname = False; ctx.verify_mode = ssl.CERT_NONE
try:
    r = urllib.request.urlopen(req, timeout=8, context=ctx).read().decode()
    log("%s %s -> %s" % (cmd, ip, r))
except Exception as e:
    log("ERRO %s %s: %s" % (cmd, ip, e))
