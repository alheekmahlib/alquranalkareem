# alquran-sync — QR Device Sync Worker

Cloudflare Worker + D1 relay لزامنة بيانات تطبيق القرآن بين الأجهزة بدون حساب.
الهوية هي `room_id` سري (128-bit) يُنقل عبر QR. التصميم الكامل في
`docs/superpowers/specs/2026-08-24-qr-device-sync-design.md`.

## التطوير

```bash
npm install
npm test          # vitest داخل بيئة workers محاكاة (miniflare)
npm run typecheck
```

## النشر

```bash
# مرة واحدة: أنشئ قاعدة D1 وسجل database_id في wrangler.toml
npx wrangler d1 create alquran-sync

# هجرات + نشر (التوكن عبر متغير بيئة فقط)
CLOUDFLARE_API_TOKEN=... npx wrangler d1 migrations apply alquran-sync --remote
CLOUDFLARE_API_TOKEN=... npx wrangler deploy
```

## نقاط النهاية (v1)

| Method | Path | الوصف |
|---|---|---|
| POST | `/v1/rooms` | إنشاء غرفة → `{room_id}` |
| POST | `/v1/rooms/:id/join` | انضمام → snapshot + `latest_seq` |
| POST | `/v1/rooms/:id/changes` | دفع دفعة تغييرات (≤500) |
| GET | `/v1/rooms/:id/changes?since=seq` | سحب تغييرات بعد مؤشر |
| GET | `/v1/rooms/:id` | حالة الغرفة (عدد الأجهزة، آخر نشاط) |

الحدود: 5 أجهزة/غرفة، 10 غرف/IP/يوم، 500 عنصر/دفعة، 4KB/عنصر.
تنظيف مجدول يوميًا للغرف الخاملة أكثر من 6 أشهر.
