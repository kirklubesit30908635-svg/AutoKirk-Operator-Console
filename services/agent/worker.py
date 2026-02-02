import os, time
import redis

REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379/0")

def main():
    r = redis.Redis.from_url(REDIS_URL)
    print(f"[agent] online | redis={REDIS_URL}")
    while True:
        r.set("agent:heartbeat", int(time.time()))
        print("[agent] heartbeat")
        time.sleep(5)

if __name__ == "__main__":
    main()
