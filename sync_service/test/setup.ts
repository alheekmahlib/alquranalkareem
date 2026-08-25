import { beforeAll, beforeEach } from "vitest";
import { env } from "cloudflare:workers";
import schemaSql from "../migrations/0001_init.sql?raw";

beforeAll(async () => {
  // Idempotent (IF NOT EXISTS) — safe to run once per test file.
  // The schema contains no semicolons inside literals, so a plain
  // split is a reliable statement splitter here.
  const statements = schemaSql
    .split(";")
    .map((statement) => statement.trim())
    .filter((statement) => statement.length > 0);
  await env.SYNC_DB.batch(statements.map((statement) => env.SYNC_DB.prepare(statement)));
});

// Storage is shared by all tests in a file; wipe tables for
// deterministic per-test isolation.
beforeEach(async () => {
  await env.SYNC_DB.batch([
    env.SYNC_DB.prepare("DELETE FROM changes"),
    env.SYNC_DB.prepare("DELETE FROM devices"),
    env.SYNC_DB.prepare("DELETE FROM rooms"),
    env.SYNC_DB.prepare("DELETE FROM room_creates"),
  ]);
});
