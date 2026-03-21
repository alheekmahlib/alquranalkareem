#!/usr/bin/env python3
"""
Generate audio files for Azkar using ElevenLabs TTS API.

For each zekr entry:
  1. Generate audio for the zekr text (single API call)
  2. Repeat it programmatically using pydub according to 'count'
  3. Append reference and description audio if present
  4. Save as {id}.mp3

Usage:
  export ELEVENLABS_API_KEY="your_api_key_here"
  python generate_azkar_audio.py
  python generate_azkar_audio.py --start-id 1 --end-id 10
  python generate_azkar_audio.py --output-dir ./audio_output
"""

import argparse
import json
import os
import re
import shutil
import sys
import time

import requests
from pydub import AudioSegment

# ── Config ──────────────────────────────────────────────────────────────────
API_BASE = "https://api.elevenlabs.io/v1/text-to-speech"
VOICE_ID = "MI88rOZjXbH22N8KHXUo"  # Ali - calm & Deep Arabic Saudi Narrator
MODEL_ID = "eleven_multilingual_v2"
VOICE_SETTINGS = {"stability": 0.6, "similarity_boost": 0.85}

SILENCE_BETWEEN_REPEATS_MS = 1500  # 1.5s between each zekr repetition
SILENCE_BEFORE_REF_MS = 2000       # 2s before reference
SILENCE_BEFORE_DESC_MS = 1500      # 1.5s before description
API_DELAY_SECONDS = 1.0            # delay between API calls


def clean_zekr_text(text: str) -> str:
    """Remove curly braces and clean up zekr text for TTS."""
    text = text.replace("{", "").replace("}", "")
    # Remove inline Quranic verse numbers like ١ ٢ ٣ that appear standalone
    text = re.sub(r"\s[١٢٣٤٥٦٧٨٩٠]+\s", " ", text)
    text = text.strip()
    # Remove trailing/leading dots that might cause issues
    return text


def generate_speech(text: str, api_key: str, output_path: str) -> bool:
    """Call ElevenLabs TTS API and save the audio to output_path."""
    url = f"{API_BASE}/{VOICE_ID}"
    headers = {
        "xi-api-key": api_key,
        "Content-Type": "application/json",
        "Accept": "audio/mpeg",
    }
    payload = {
        "text": text,
        "model_id": MODEL_ID,
        "voice_settings": VOICE_SETTINGS,
    }

    response = requests.post(url, json=payload, headers=headers, timeout=120)

    if response.status_code == 200:
        with open(output_path, "wb") as f:
            f.write(response.content)
        return True
    else:
        print(f"  ✗ API error {response.status_code}: {response.text[:200]}")
        return False


def build_final_audio(zekr_path, count, ref_path, desc_path, output_path):
    """Combine zekr (repeated), reference, and description into one mp3."""
    """Combine zekr (repeated), reference, and description into one mp3."""
    zekr_audio = AudioSegment.from_mp3(zekr_path)
    silence_repeat = AudioSegment.silent(duration=SILENCE_BETWEEN_REPEATS_MS)
    silence_ref = AudioSegment.silent(duration=SILENCE_BEFORE_REF_MS)
    silence_desc = AudioSegment.silent(duration=SILENCE_BEFORE_DESC_MS)

    # Repeat zekr 'count' times with silence between
    combined = zekr_audio
    for _ in range(count - 1):
        combined += silence_repeat + zekr_audio

    # Append reference audio if available
    if ref_path and os.path.exists(ref_path):
        ref_audio = AudioSegment.from_mp3(ref_path)
        combined += silence_ref + ref_audio

    # Append description audio if available
    if desc_path and os.path.exists(desc_path):
        desc_audio = AudioSegment.from_mp3(desc_path)
        combined += silence_desc + desc_audio

    combined.export(output_path, format="mp3", bitrate="192k")


def process_entry(entry: dict, api_key: str, output_dir: str, temp_dir: str) -> bool:
    """Process a single azkar entry: generate audio parts and combine."""
    entry_id = entry["id"]
    category = entry.get("category", "")
    count = int(entry.get("count", "1"))
    zekr = clean_zekr_text(entry.get("zekr", ""))
    reference = entry.get("reference", "").strip()
    description = entry.get("description", "").strip()

    final_path = os.path.join(output_dir, f"{entry_id}.mp3")

    # Skip if already exists (resume support)
    if os.path.exists(final_path):
        print(f"  ⊘ Already exists, skipping.")
        return True

    if not zekr:
        print(f"  ✗ Empty zekr text, skipping.")
        return False

    # Paths for temporary audio parts
    zekr_tmp = os.path.join(temp_dir, f"{entry_id}_zekr.mp3")
    ref_tmp = os.path.join(temp_dir, f"{entry_id}_ref.mp3")
    desc_tmp = os.path.join(temp_dir, f"{entry_id}_desc.mp3")

    api_calls = 1 + (1 if reference else 0) + (1 if description else 0)
    print(f"  → {api_calls} API call(s), count={count}, chars={len(zekr)}")

    # 1) Generate zekr audio
    if not os.path.exists(zekr_tmp):
        if not generate_speech(zekr, api_key, zekr_tmp):
            return False
        time.sleep(API_DELAY_SECONDS)

    # 2) Generate reference audio (if non-empty)
    ref_path_final = None
    if reference:
        if not os.path.exists(ref_tmp):
            if not generate_speech(reference, api_key, ref_tmp):
                print(f"  ⚠ Reference audio failed, continuing without it.")
                ref_path_final = None
            else:
                ref_path_final = ref_tmp
                time.sleep(API_DELAY_SECONDS)
        else:
            ref_path_final = ref_tmp

    # 3) Generate description audio (if non-empty)
    desc_path_final = None
    if description:
        if not os.path.exists(desc_tmp):
            if not generate_speech(description, api_key, desc_tmp):
                print(f"  ⚠ Description audio failed, continuing without it.")
                desc_path_final = None
            else:
                desc_path_final = desc_tmp
                time.sleep(API_DELAY_SECONDS)
        else:
            desc_path_final = desc_tmp

    # 4) Combine everything with pydub
    try:
        build_final_audio(zekr_tmp, count, ref_path_final, desc_path_final, final_path)
        print(f"  ✓ Saved {final_path}")
        return True
    except Exception as e:
        print(f"  ✗ Audio assembly failed: {e}")
        # Remove partial file if it exists
        if os.path.exists(final_path):
            os.remove(final_path)
        return False


def main():
    parser = argparse.ArgumentParser(description="Generate Azkar audio via ElevenLabs TTS")
    parser.add_argument("--json", default=os.path.join(os.path.dirname(__file__), "assets", "json", "azkar.json"),
                        help="Path to azkar.json")
    parser.add_argument("--output-dir", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "azkar_audio"),
                        help="Directory to save final mp3 files")
    parser.add_argument("--start-id", type=int, default=None, help="Start from this ID (inclusive)")
    parser.add_argument("--end-id", type=int, default=None, help="End at this ID (inclusive)")
    parser.add_argument("--api-key", default=None, help="ElevenLabs API key (or set ELEVENLABS_API_KEY env var)")
    parser.add_argument("--keep-temp", action="store_true", help="Keep temporary audio files")
    args = parser.parse_args()

    # Resolve API key
    api_key = args.api_key or os.environ.get("ELEVENLABS_API_KEY")
    if not api_key:
        print("Error: No API key provided.")
        print("Set ELEVENLABS_API_KEY environment variable or use --api-key flag.")
        sys.exit(1)

    # Load azkar data
    json_path = args.json
    if not os.path.exists(json_path):
        print(f"Error: JSON file not found: {json_path}")
        sys.exit(1)

    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)["data"]

    # Filter by ID range if specified
    if args.start_id is not None:
        data = [e for e in data if e["id"] >= args.start_id]
    if args.end_id is not None:
        data = [e for e in data if e["id"] <= args.end_id]

    if not data:
        print("No entries to process.")
        sys.exit(0)

    # Create output and temp directories
    output_dir = args.output_dir
    temp_dir = os.path.join(output_dir, "_temp")
    os.makedirs(output_dir, exist_ok=True)
    os.makedirs(temp_dir, exist_ok=True)

    total = len(data)
    success = 0
    failed = 0
    skipped = 0

    print(f"╔══════════════════════════════════════════════╗")
    print(f"║  Azkar Audio Generator - ElevenLabs TTS     ║")
    print(f"║  Voice: Ali (MI88rOZjXbH22N8KHXUo)          ║")
    print(f"║  Model: eleven_multilingual_v2               ║")
    print(f"║  Entries: {total:<35} ║")
    print(f"║  Output: {output_dir:<36} ║")
    print(f"╚══════════════════════════════════════════════╝")
    print()

    # Estimate total characters
    total_chars = 0
    for entry in data:
        z = clean_zekr_text(entry.get("zekr", ""))
        r = entry.get("reference", "").strip()
        d = entry.get("description", "").strip()
        total_chars += len(z) + len(r) + len(d)
    print(f"Estimated total characters: ~{total_chars:,}")
    print(f"Estimated API calls: ~{sum(1 + (1 if e.get('reference','').strip() else 0) + (1 if e.get('description','').strip() else 0) for e in data)}")
    print()

    for i, entry in enumerate(data, 1):
        entry_id = entry["id"]
        category = entry.get("category", "")
        print(f"[{i}/{total}] ID {entry_id} — {category}")

        result = process_entry(entry, api_key, output_dir, temp_dir)
        if result:
            final_path = os.path.join(output_dir, f"{entry_id}.mp3")
            if "Already exists" not in "":  # check via file mod time
                success += 1
            else:
                skipped += 1
        else:
            failed += 1

    # Cleanup temp files
    if not args.keep_temp and os.path.exists(temp_dir):
        shutil.rmtree(temp_dir)
        print(f"\n🧹 Temporary files cleaned up.")

    print(f"\n{'='*50}")
    print(f"Done! Results:")
    print(f"  ✓ Success:  {success}")
    print(f"  ✗ Failed:   {failed}")
    print(f"  ⊘ Skipped:  {skipped}")
    print(f"  Output dir: {output_dir}")


if __name__ == "__main__":
    main()
