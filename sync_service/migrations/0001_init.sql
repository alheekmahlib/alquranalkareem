CREATE TABLE IF NOT EXISTS rooms (
  id TEXT PRIMARY KEY,
  created_at INTEGER NOT NULL,
  last_active_at INTEGER NOT NULL,
  next_seq INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS devices (
  room_id TEXT NOT NULL,
  device_id TEXT NOT NULL,
  first_seen INTEGER NOT NULL,
  last_seen INTEGER NOT NULL,
  PRIMARY KEY (room_id, device_id)
);

CREATE TABLE IF NOT EXISTS changes (
  room_id TEXT NOT NULL,
  seq INTEGER NOT NULL,
  kind TEXT NOT NULL,
  item_key TEXT NOT NULL,
  payload TEXT NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted INTEGER NOT NULL DEFAULT 0,
  device_id TEXT NOT NULL,
  PRIMARY KEY (room_id, seq)
);

CREATE INDEX IF NOT EXISTS idx_changes_room_updated
  ON changes(room_id, updated_at);

CREATE TABLE IF NOT EXISTS room_creates (
  day TEXT NOT NULL,
  ip TEXT NOT NULL,
  count INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (day, ip)
);
