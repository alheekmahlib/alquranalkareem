import { Hono } from "hono";
import { cors } from "hono/cors";

export interface Env {
  SYNC_DB: D1Database;
}

// Limits — see docs/superpowers/specs/2026-08-24-qr-device-sync-design.md
const MAX_DEVICES_PER_ROOM = 5;
const MAX_CHANGES_PER_BATCH = 500;
const MAX_BODY_BYTES = 300_000; // ~256KB payload + envelope
const MAX_PAYLOAD_CHARS = 4096;
const MAX_KEY_CHARS = 128;
const MAX_DEVICE_ID_CHARS = 64;
const MAX_ROOM_CREATES_PER_IP_PER_DAY = 10;
const ROOM_TTL_MS = 183 * 24 * 60 * 60 * 1000; // ~6 months of inactivity
const PULL_PAGE_LIMIT = 1000;

const ALLOWED_KINDS = new Set([
  "bookmark",
  "bookmark_ayah",
  "adhkar",
  "khatmah",
  "khatmah_day",
  "books_bookmark",
  "kv",
]);

interface ChangeInput {
  kind: string;
  key: string;
  payload: string;
  updated_at: number;
  deleted: boolean;
}

const app = new Hono<{ Bindings: Env }>();

app.use("*", cors());

function errorResponse(status: number, code: string, message: string) {
  return Response.json({ error: { code, message } }, { status });
}

function randomRoomId(): string {
  const bytes = new Uint8Array(16);
  crypto.getRandomValues(bytes);
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

/** POST /v1/rooms — create a sync room; room_id is the shared secret. */
app.post("/v1/rooms", async (c) => {
  const db = c.env.SYNC_DB;
  const ip = c.req.header("CF-Connecting-IP") ?? "unknown";
  const day = new Date().toISOString().slice(0, 10);
  const now = Date.now();

  const counter = await db
    .prepare("SELECT count FROM room_creates WHERE day = ?1 AND ip = ?2")
    .bind(day, ip)
    .first<{ count: number }>();
  if (counter && counter.count >= MAX_ROOM_CREATES_PER_IP_PER_DAY) {
    return errorResponse(429, "RATE_LIMITED", "Too many rooms created from this address today");
  }

  const roomId = randomRoomId();
  await db.batch([
    db
      .prepare(
        `INSERT INTO room_creates (day, ip, count) VALUES (?1, ?2, 1)
         ON CONFLICT (day, ip) DO UPDATE SET count = count + 1`,
      )
      .bind(day, ip),
    db
      .prepare("INSERT INTO rooms (id, created_at, last_active_at, next_seq) VALUES (?1, ?2, ?2, 0)")
      .bind(roomId, now),
  ]);

  return Response.json({ room_id: roomId });
});

/** POST /v1/rooms/:id/join — join a room, receive the current snapshot. */
app.post("/v1/rooms/:id/join", async (c) => {
  const db = c.env.SYNC_DB;
  const roomId = c.req.param("id");
  const now = Date.now();

  const body = await c.req.json<{ device_id?: unknown }>().catch(() => null);
  const deviceId = body?.device_id;
  if (typeof deviceId !== "string" || deviceId.length === 0 || deviceId.length > MAX_DEVICE_ID_CHARS) {
    return errorResponse(400, "BAD_REQUEST", "device_id is required (max 64 chars)");
  }

  const room = await db
    .prepare("SELECT id, next_seq FROM rooms WHERE id = ?1")
    .bind(roomId)
    .first<{ id: string; next_seq: number }>();
  if (!room) {
    return errorResponse(404, "ROOM_NOT_FOUND", "Sync room does not exist or has expired");
  }

  const existing = await db
    .prepare("SELECT 1 AS present FROM devices WHERE room_id = ?1 AND device_id = ?2")
    .bind(roomId, deviceId)
    .first<{ present: number }>();
  const counts = await db
    .prepare("SELECT COUNT(*) AS n FROM devices WHERE room_id = ?1")
    .bind(roomId)
    .first<{ n: number }>();
  const alreadyJoined = Boolean(existing);
  if (!alreadyJoined && (counts?.n ?? 0) >= MAX_DEVICES_PER_ROOM) {
    return errorResponse(403, "ROOM_FULL", "This sync room already has the maximum number of devices");
  }

  // Snapshot = latest change per (kind, item_key), tombstones included.
  const snapshot = await db
    .prepare(
      `SELECT c.kind, c.item_key AS key, c.payload, c.updated_at, c.deleted
       FROM changes c
       JOIN (
         SELECT kind, item_key, MAX(seq) AS max_seq
         FROM changes WHERE room_id = ?1 GROUP BY kind, item_key
       ) m ON c.kind = m.kind AND c.item_key = m.item_key AND c.seq = m.max_seq
       WHERE c.room_id = ?1`,
    )
    .bind(roomId)
    .all<{ kind: string; key: string; payload: string; updated_at: number; deleted: number }>();

  await db.batch([
    db
      .prepare(
        `INSERT INTO devices (room_id, device_id, first_seen, last_seen) VALUES (?1, ?2, ?3, ?3)
         ON CONFLICT (room_id, device_id) DO UPDATE SET last_seen = ?3`,
      )
      .bind(roomId, deviceId, now),
    db.prepare("UPDATE rooms SET last_active_at = ?1 WHERE id = ?2").bind(now, roomId),
  ]);

  return Response.json({
    latest_seq: room.next_seq,
    device_count: (counts?.n ?? 0) + (alreadyJoined ? 0 : 1),
    items: snapshot.results ?? [],
  });
});

function validateChanges(raw: unknown): { ok: true; changes: ChangeInput[] } | { ok: false; message: string } {
  if (!Array.isArray(raw) || raw.length === 0) {
    return { ok: false, message: "changes must be a non-empty array" };
  }
  if (raw.length > MAX_CHANGES_PER_BATCH) {
    return { ok: false, message: `changes batch exceeds ${MAX_CHANGES_PER_BATCH} items` };
  }
  const changes: ChangeInput[] = [];
  for (const item of raw) {
    if (typeof item !== "object" || item === null) {
      return { ok: false, message: "each change must be an object" };
    }
    const candidate = item as Record<string, unknown>;
    if (typeof candidate.kind !== "string" || !ALLOWED_KINDS.has(candidate.kind)) {
      return { ok: false, message: `unsupported kind: ${String(candidate.kind)}` };
    }
    if (typeof candidate.key !== "string" || candidate.key.length === 0 || candidate.key.length > MAX_KEY_CHARS) {
      return { ok: false, message: "key must be 1-128 chars" };
    }
    if (typeof candidate.payload !== "string" || candidate.payload.length > MAX_PAYLOAD_CHARS) {
      return { ok: false, message: "payload must be a string of at most 4096 chars" };
    }
    if (typeof candidate.updated_at !== "number" || !Number.isFinite(candidate.updated_at) || candidate.updated_at <= 0) {
      return { ok: false, message: "updated_at must be a positive epoch-milliseconds number" };
    }
    if (typeof candidate.deleted !== "boolean") {
      return { ok: false, message: "deleted must be a boolean" };
    }
    changes.push({
      kind: candidate.kind,
      key: candidate.key,
      payload: candidate.payload,
      updated_at: candidate.updated_at,
      deleted: candidate.deleted,
    });
  }
  return { ok: true, changes };
}

/** POST /v1/rooms/:id/changes — append a batch of changes atomically. */
app.post("/v1/rooms/:id/changes", async (c) => {
  const db = c.env.SYNC_DB;
  const roomId = c.req.param("id");
  const now = Date.now();

  const contentLength = Number(c.req.header("Content-Length") ?? 0);
  if (contentLength > MAX_BODY_BYTES) {
    return errorResponse(413, "PAYLOAD_TOO_LARGE", "Request body exceeds the size limit");
  }

  const body = await c.req.json<{ device_id?: unknown; changes?: unknown }>().catch(() => null);
  const deviceId = body?.device_id;
  if (typeof deviceId !== "string" || deviceId.length === 0 || deviceId.length > MAX_DEVICE_ID_CHARS) {
    return errorResponse(400, "BAD_REQUEST", "device_id is required (max 64 chars)");
  }

  const validated = validateChanges(body?.changes);
  if (!validated.ok) {
    return errorResponse(400, "BAD_REQUEST", validated.message);
  }

  const room = await db
    .prepare("SELECT id, next_seq FROM rooms WHERE id = ?1")
    .bind(roomId)
    .first<{ id: string; next_seq: number }>();
  if (!room) {
    return errorResponse(404, "ROOM_NOT_FOUND", "Sync room does not exist or has expired");
  }

  const statements: D1PreparedStatement[] = [
    db
      .prepare("UPDATE rooms SET next_seq = next_seq + ?1, last_active_at = ?2 WHERE id = ?3")
      .bind(validated.changes.length, now, roomId),
    db
      .prepare(
        `INSERT INTO devices (room_id, device_id, first_seen, last_seen) VALUES (?1, ?2, ?3, ?3)
         ON CONFLICT (room_id, device_id) DO UPDATE SET last_seen = ?3`,
      )
      .bind(roomId, deviceId, now),
  ];
  validated.changes.forEach((change, index) => {
    statements.push(
      db
        .prepare(
          `INSERT INTO changes (room_id, seq, kind, item_key, payload, updated_at, deleted, device_id)
           VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)`,
        )
        .bind(roomId, room.next_seq + index + 1, change.kind, change.key, change.payload, change.updated_at, change.deleted ? 1 : 0, deviceId),
    );
  });
  await db.batch(statements);

  return Response.json({ latest_seq: room.next_seq + validated.changes.length });
});

/** GET /v1/rooms/:id/changes?since=seq — pull changes after a cursor. */
app.get("/v1/rooms/:id/changes", async (c) => {
  const db = c.env.SYNC_DB;
  const roomId = c.req.param("id");

  const room = await db
    .prepare("SELECT id, next_seq FROM rooms WHERE id = ?1")
    .bind(roomId)
    .first<{ id: string; next_seq: number }>();
  if (!room) {
    return errorResponse(404, "ROOM_NOT_FOUND", "Sync room does not exist or has expired");
  }

  const sinceParam = c.req.query("since") ?? "0";
  const since = Number(sinceParam);
  if (!Number.isInteger(since) || since < 0) {
    return errorResponse(400, "BAD_REQUEST", "since must be a non-negative integer");
  }

  const rows = await db
    .prepare(
      `SELECT seq, kind, item_key AS key, payload, updated_at, deleted, device_id
       FROM changes WHERE room_id = ?1 AND seq > ?2 ORDER BY seq ASC LIMIT ?3`,
    )
    .bind(roomId, since, PULL_PAGE_LIMIT + 1)
    .all<{
      seq: number;
      kind: string;
      key: string;
      payload: string;
      updated_at: number;
      deleted: number;
      device_id: string;
    }>();

  const results = rows.results ?? [];
  const hasMore = results.length > PULL_PAGE_LIMIT;
  const page = hasMore ? results.slice(0, PULL_PAGE_LIMIT) : results;
  const lastSeq = page.length > 0 ? page[page.length - 1].seq : since;

  return Response.json({ changes: page, latest_seq: lastSeq, has_more: hasMore, room_latest_seq: room.next_seq });
});

/** GET /v1/rooms/:id — room status for the settings screen. */
app.get("/v1/rooms/:id", async (c) => {
  const db = c.env.SYNC_DB;
  const roomId = c.req.param("id");

  const room = await db
    .prepare("SELECT id, created_at, last_active_at, next_seq FROM rooms WHERE id = ?1")
    .bind(roomId)
    .first<{ id: string; created_at: number; last_active_at: number; next_seq: number }>();
  if (!room) {
    return errorResponse(404, "ROOM_NOT_FOUND", "Sync room does not exist or has expired");
  }

  const counts = await db
    .prepare("SELECT COUNT(*) AS n FROM devices WHERE room_id = ?1")
    .bind(roomId)
    .first<{ n: number }>();

  return Response.json({
    device_count: counts?.n ?? 0,
    created_at: room.created_at,
    last_active_at: room.last_active_at,
    latest_seq: room.next_seq,
  });
});

/** DELETE /v1/rooms/:id/devices/:deviceId — مغادرة الغرفة (إلغاء الإقران).
 *  إذا غادر آخر جهاز تُحذف الغرفة كاملة ببياناتها. */
app.delete("/v1/rooms/:id/devices/:deviceId", async (c) => {
  const db = c.env.SYNC_DB;
  const roomId = c.req.param("id");
  const deviceId = c.req.param("deviceId");
  if (deviceId.length === 0 || deviceId.length > MAX_DEVICE_ID_CHARS) {
    return errorResponse(400, "BAD_REQUEST", "invalid device_id");
  }

  const room = await db
    .prepare("SELECT id FROM rooms WHERE id = ?1")
    .bind(roomId)
    .first<{ id: string }>();
  if (!room) {
    return errorResponse(404, "ROOM_NOT_FOUND", "Sync room does not exist or has expired");
  }

  await db
    .prepare("DELETE FROM devices WHERE room_id = ?1 AND device_id = ?2")
    .bind(roomId, deviceId)
    .run();

  const remaining = await db
    .prepare("SELECT COUNT(*) AS n FROM devices WHERE room_id = ?1")
    .bind(roomId)
    .first<{ n: number }>();

  if ((remaining?.n ?? 0) === 0) {
    // آخر جهاز غادر — لا معنى لبقاء الغرفة وبياناتها على الخادم.
    await db.batch([
      db.prepare("DELETE FROM changes WHERE room_id = ?1").bind(roomId),
      db.prepare("DELETE FROM rooms WHERE id = ?1").bind(roomId),
    ]);
    return Response.json({ device_count: 0, room_deleted: true });
  }

  return Response.json({ device_count: remaining!.n, room_deleted: false });
});

app.notFound(() => errorResponse(404, "NOT_FOUND", "Unknown endpoint"));

export default {
  fetch: app.fetch,
  async scheduled(_event: ScheduledController, env: Env): Promise<void> {
    const db = env.SYNC_DB;
    const cutoff = Date.now() - ROOM_TTL_MS;
    const today = new Date().toISOString().slice(0, 10);
    // أجهزة خاملة أكثر من 30 يومًا تُشطب حتى لا تأكل حد الخمسة أشباحًا.
    const staleDeviceCutoff = Date.now() - 30 * 24 * 60 * 60 * 1000;

    const stale = await db
      .prepare("SELECT id FROM rooms WHERE last_active_at < ?1")
      .bind(cutoff)
      .all<{ id: string }>();

    const statements: D1PreparedStatement[] = stale.results.map((room) =>
      db.prepare("DELETE FROM changes WHERE room_id = ?1").bind(room.id),
    );
    for (const room of stale.results) {
      statements.push(db.prepare("DELETE FROM devices WHERE room_id = ?1").bind(room.id));
    }
    for (const room of stale.results) {
      statements.push(db.prepare("DELETE FROM rooms WHERE id = ?1").bind(room.id));
    }
    statements.push(db.prepare("DELETE FROM room_creates WHERE day < ?1").bind(today));
    statements.push(
      db.prepare("DELETE FROM devices WHERE last_seen < ?1").bind(staleDeviceCutoff),
    );

    await db.batch(statements);
  },
} satisfies ExportedHandler<Env>;
