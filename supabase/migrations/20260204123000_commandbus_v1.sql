CREATE TABLE IF NOT EXISTS command_events (
  id BIGSERIAL PRIMARY KEY,
  command_id TEXT NOT NULL,
  ts TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  stage TEXT NOT NULL,
  payload JSONB
);

CREATE INDEX IF NOT EXISTS idx_command_events_command_id ON command_events(command_id);
