exec 2>&1
echo "== $(hostname) $(date '+%F %T') =="
command -v python3 >/dev/null || { echo "sem python3"; exit 1; }
GW=$(ip r | awk '/default/{print $3; exit}')
python3 - "$GW" <<'PY'
import socket,sys,struct
msg=b'\x12\x34\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00\x07example\x03com\x00\x00\x01\x00\x01'
def q(server,tcp=False):
    try:
        if tcp:
            s=socket.socket(); s.settimeout(2); s.connect((server,53)); s.send(struct.pack('>H',len(msg))+msg); d=s.recv(512)
        else:
            s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM); s.settimeout(2); s.sendto(msg,(server,53)); d=s.recv(512)
        return "RESPONDE" if d else "SEM RESPOSTA"
    except Exception:
        return "BLOQUEADO"
print("gateway", sys.argv[1], "udp53:", q(sys.argv[1]))
print("1.1.1.1 udp53:", q("1.1.1.1"))
print("1.1.1.1 tcp53:", q("1.1.1.1",True))
PY
timeout 1 bash -c 'exec 3<>/dev/tcp/1.1.1.1/853' 2>/dev/null && echo "1.1.1.1 tcp853: ABERTO" || echo "1.1.1.1 tcp853: BLOQUEADO"
