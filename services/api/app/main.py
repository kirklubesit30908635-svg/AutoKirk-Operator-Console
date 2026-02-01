from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os, json, time, uuid
import psycopg
import redis

app = FastAPI(title="Autokirk Operator API")

DB_URL = os.getenv("DATABASE_URL", "")
REDIS_URL = os.getenv("REDIS_URL", "")

QUEUE_KEY = "commands:queue"
CMD_KEY_PREFIX = "command:"  # command:{id} -> json

def db_exec(command_id: str, stage: str, payload: dict | None):
    try:
        with psycopg.connect(DB_URL, connect_timeout=3) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO command_events(command_id, stage, payload) VALUES (%s, %s, %s::jsonb)",
                    (command_id, stage, json.dumps(payload or {})),
                )
            conn.commit()
    except Exception:
        # audit should never block control plane
        pass

def rclient():
    return redis.Redis.from_url(REDIS_URL, socket_connect_timeout=3, decode_responses=True)

class CommandRequest(BaseModel):
    type: str
    args: dict = {}

@app.get("/health")
def health():
    return {"ok": True, "service": "api"}

@app.get("/v1/checks")
def checks():
    db_ok, r_ok = False, False
    db_err, r_err = None, None

    try:
        with psycopg.connect(DB_URL, connect_timeout=3) as conn:
            with conn.cursor() as cur:
                cur.execute("select 1;")
                cur.fetchone()
        db_ok = True
    except Exception as e:
        db_err = str(e)

    try:
        r = rclient()
        r.ping()
        r_ok = True
    except Exception as e:
        r_err = str(e)

    return {"db_ok": db_ok, "db_err": db_err, "redis_ok": r_ok, "redis_err": r_err}

@app.post("/v1/commands")
def create_command(req: CommandRequest):
    cmd_id = str(uuid.uuid4())
    now = int(time.time())

    cmd = {
        "

docker compose up -d --build api agent
docker compose ps

curl -s -X POST http://localhost:8000/v1/commands \
  -H "Content-Type: application/json" \
  -d '{"type":"ping","args":{"msg":"operator-console-online"}}'

cat > services/agent/worker.py <<'PY'
import os, time, json
import redis

REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379/0")
QUEUE_KEY = "commands:queue"
CMD_KEY_PREFIX = "command:"

def handle(cmd: dict) -> dict:
    ctype = cmd.get("type")
    args = cmd.get("args") or {}

    if ctype == "ping":
        return {"ok": True, "echo": args}

    if ctype == "set_flag":
        return {"ok": True, "flag": {"key": args.get("key"), "value": args.get("value")}}

    return {"ok": False, "error": f"unknown command type: {ctype}"}

def main():
    r = redis.Redis.from_url(REDIS_URL, decode_responses=True)
    print(f"[agent] online | redis={REDIS_URL}", flush=True)

    while True:
        r.set("agent:heartbeat", int(time.time()))

        item = r.brpop(QUEUE_KEY, timeout=5)
        if not item:
            continue

        _, cmd_id = item
        key = f"{CMD_KEY_PREFIX}{cmd_id}"
        raw = r.get(key)
        if not raw:
            continue

        cmd = json.loads(raw)
        cmd["status"] = "running"
        r.set(key, json.dumps(cmd), ex=3600)

        result = handle(cmd)

        cmd["status"] = "done" if result.get("ok") else "failed"
        cmd["result"] = result
        cmd["finished_at"] = int(time.time())
        r.set(key, json.dumps(cmd), ex=3600)

        print(f"[agent] handled {cmd_id} -> {cmd['status']}", flush=True)

if __name__ == "__main__":
    main()
