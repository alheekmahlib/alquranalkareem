import { describe, expect, it } from "vitest";
import { exports } from "cloudflare:workers";

const worker = exports.default;
const BASE = "https://sync.test";

async function post(path: string, body: unknown): Promise<Response> {
  return worker.fetch(`${BASE}${path}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

async function createRoom(): Promise<string> {
  const res = await post("/v1/rooms", {});
  expect(res.status).toBe(200);
  const data = (await res.json()) as { room_id: string };
  return data.room_id;
}

async function joinRoom(roomId: string, deviceId: string): Promise<Response> {
  return post(`/v1/rooms/${roomId}/join`, { device_id: deviceId });
}

function bookmarkChange(key: string, updatedAt = Date.now(), deleted = false) {
  return {
    kind: "bookmark",
    key,
    payload: JSON.stringify({ sorahName: "الفاتحة", pageNum: 1 }),
    updated_at: updatedAt,
    deleted,
  };
}

async function pushChanges(roomId: string, deviceId: string, changes: unknown[]): Promise<Response> {
  return post(`/v1/rooms/${roomId}/changes`, { device_id: deviceId, changes });
}

describe("POST /v1/rooms", () => {
  it("creates a room with a 128-bit base64url id", async () => {
    const roomId = await createRoom();
    expect(roomId).toMatch(/^[A-Za-z0-9_-]{22}$/);
  });

  it("rate limits creation beyond 10 per address per day", async () => {
    let lastStatus = 200;
    for (let i = 0; i < 15; i++) {
      const res = await post("/v1/rooms", {});
      lastStatus = res.status;
      if (res.status === 429) break;
      expect(res.status).toBe(200);
    }
    expect(lastStatus).toBe(429);
    const limited = (await (await post("/v1/rooms", {})).json()) as { error: { code: string } };
    expect(limited.error.code).toBe("RATE_LIMITED");
  });
});

describe("POST /v1/rooms/:id/join", () => {
  it("joins a fresh room with an empty snapshot", async () => {
    const roomId = await createRoom();
    const res = await joinRoom(roomId, "device-1");
    expect(res.status).toBe(200);
    const data = (await res.json()) as { latest_seq: number; device_count: number; items: unknown[] };
    expect(data.latest_seq).toBe(0);
    expect(data.device_count).toBe(1);
    expect(data.items).toEqual([]);
  });

  it("returns 404 for an unknown room", async () => {
    const res = await joinRoom("does-not-exist", "device-1");
    expect(res.status).toBe(404);
  });

  it("rejects the 6th device but lets existing devices rejoin", async () => {
    const roomId = await createRoom();
    for (let i = 0; i < 5; i++) {
      const res = await joinRoom(roomId, `device-${i}`);
      expect(res.status).toBe(200);
    }
    const sixth = await joinRoom(roomId, "device-5");
    expect(sixth.status).toBe(403);
    const body = (await sixth.json()) as { error: { code: string } };
    expect(body.error.code).toBe("ROOM_FULL");

    const rejoin = await joinRoom(roomId, "device-0");
    expect(rejoin.status).toBe(200);
    const data = (await rejoin.json()) as { device_count: number };
    expect(data.device_count).toBe(5);
  });
});

describe("POST /v1/rooms/:id/changes", () => {
  it("appends a batch and advances latest_seq", async () => {
    const roomId = await createRoom();
    await joinRoom(roomId, "device-1");

    const res = await pushChanges(roomId, "device-1", [bookmarkChange("a"), bookmarkChange("b")]);
    expect(res.status).toBe(200);
    expect(((await res.json()) as { latest_seq: number }).latest_seq).toBe(2);

    const more = await pushChanges(roomId, "device-1", [bookmarkChange("c")]);
    expect(((await more.json()) as { latest_seq: number }).latest_seq).toBe(3);
  });

  it("rejects invalid batches", async () => {
    const roomId = await createRoom();
    await joinRoom(roomId, "device-1");

    const empty = await pushChanges(roomId, "device-1", []);
    expect(empty.status).toBe(400);

    const badKind = await pushChanges(roomId, "device-1", [{ ...bookmarkChange("x"), kind: "evil" }]);
    expect(badKind.status).toBe(400);

    const emptyKey = await pushChanges(roomId, "device-1", [bookmarkChange("")]);
    expect(emptyKey.status).toBe(400);

    const missingDevice = await post(`/v1/rooms/${roomId}/changes`, { changes: [bookmarkChange("y")] });
    expect(missingDevice.status).toBe(400);
  });

  it("returns 404 for an unknown room", async () => {
    const res = await pushChanges("nope", "device-1", [bookmarkChange("a")]);
    expect(res.status).toBe(404);
  });
});

describe("GET /v1/rooms/:id/changes", () => {
  it("pulls changes incrementally via the since cursor", async () => {
    const roomId = await createRoom();
    await joinRoom(roomId, "device-1");
    await pushChanges(roomId, "device-1", [bookmarkChange("a"), bookmarkChange("b"), bookmarkChange("c")]);

    const first = await worker.fetch(`${BASE}/v1/rooms/${roomId}/changes?since=0`);
    expect(first.status).toBe(200);
    const firstData = (await first.json()) as { changes: { seq: number; key: string }[]; latest_seq: number; has_more: boolean };
    expect(firstData.changes.map((c) => c.key)).toEqual(["a", "b", "c"]);
    expect(firstData.latest_seq).toBe(3);
    expect(firstData.has_more).toBe(false);

    const second = await worker.fetch(`${BASE}/v1/rooms/${roomId}/changes?since=${firstData.latest_seq}`);
    const secondData = (await second.json()) as { changes: unknown[] };
    expect(secondData.changes).toEqual([]);
  });

  it("rejects a malformed since parameter", async () => {
    const roomId = await createRoom();
    const res = await worker.fetch(`${BASE}/v1/rooms/${roomId}/changes?since=abc`);
    expect(res.status).toBe(400);
  });
});

describe("DELETE /v1/rooms/:id/devices/:deviceId", () => {
  it("removes the device and decrements the count", async () => {
    const roomId = await createRoom();
    await joinRoom(roomId, "device-1");
    await joinRoom(roomId, "device-2");

    const info = await worker.fetch(`${BASE}/v1/rooms/${roomId}`);
    expect(((await info.json()) as { device_count: number }).device_count).toBe(2);

    const leave = await worker.fetch(`${BASE}/v1/rooms/${roomId}/devices/device-1`, {
      method: "DELETE",
    });
    expect(leave.status).toBe(200);
    expect(((await leave.json()) as { device_count: number }).device_count).toBe(1);

    const after = await worker.fetch(`${BASE}/v1/rooms/${roomId}`);
    expect(((await after.json()) as { device_count: number }).device_count).toBe(1);
  });

  it("deletes the whole room when the last device leaves", async () => {
    const roomId = await createRoom();
    await joinRoom(roomId, "device-1");

    const leave = await worker.fetch(`${BASE}/v1/rooms/${roomId}/devices/device-1`, {
      method: "DELETE",
    });
    expect(leave.status).toBe(200);
    expect(((await leave.json()) as { room_deleted: boolean }).room_deleted).toBe(true);

    const after = await worker.fetch(`${BASE}/v1/rooms/${roomId}`);
    expect(after.status).toBe(404);
  });

  it("rejoining with the same device_id does not inflate the count", async () => {
    const roomId = await createRoom();
    await joinRoom(roomId, "device-1");
    await joinRoom(roomId, "device-1");
    await joinRoom(roomId, "device-1");

    const info = await worker.fetch(`${BASE}/v1/rooms/${roomId}`);
    expect(((await info.json()) as { device_count: number }).device_count).toBe(1);
  });

  it("returns 404 for an unknown room", async () => {
    const res = await worker.fetch(`${BASE}/v1/rooms/nope/devices/device-1`, {
      method: "DELETE",
    });
    expect(res.status).toBe(404);
  });
});

describe("snapshot correctness", () => {
  it("join returns the latest state per key, tombstones included", async () => {
    const roomId = await createRoom();
    await joinRoom(roomId, "device-1");

    const later = Date.now() + 1000;
    await pushChanges(roomId, "device-1", [bookmarkChange("a", Date.now())]);
    await pushChanges(roomId, "device-1", [
      { ...bookmarkChange("a", later, true), payload: "" }, // deleted later
      bookmarkChange("b", later),
    ]);

    const join = await joinRoom(roomId, "device-2");
    const data = (await join.json()) as {
      items: { kind: string; key: string; deleted: number; updated_at: number }[];
    };
    const itemA = data.items.find((i) => i.key === "a");
    const itemB = data.items.find((i) => i.key === "b");
    expect(itemA?.deleted).toBe(1);
    expect(itemA?.updated_at).toBe(later);
    expect(itemB).toBeDefined();
  });
});

describe("GET /v1/rooms/:id", () => {
  it("returns room status", async () => {
    const roomId = await createRoom();
    await joinRoom(roomId, "device-1");
    const res = await worker.fetch(`${BASE}/v1/rooms/${roomId}`);
    expect(res.status).toBe(200);
    const data = (await res.json()) as { device_count: number; latest_seq: number };
    expect(data.device_count).toBe(1);
    expect(data.latest_seq).toBe(0);
  });

  it("returns 404 for an unknown room", async () => {
    const res = await worker.fetch(`${BASE}/v1/rooms/nope`);
    expect(res.status).toBe(404);
  });
});
