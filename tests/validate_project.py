#!/usr/bin/env python3
"""Fast, dependency-free checks for the initial Godot project scaffold."""

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
REQUIRED_FILES = (
    "game/project.godot",
    "game/export_presets.cfg",
    "game/scenes/main.tscn",
    "game/scripts/main.gd",
    "game/scripts/player_controller.gd",
    "game/scripts/mobile_hud.gd",
    "ROADMAP.md",
    "docs/AI_CODING_AGENT.md",
    ".github/workflows/android-build.yml",
)


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    for relative_path in REQUIRED_FILES:
        if not (ROOT / relative_path).is_file():
            fail(f"Missing required file: {relative_path}")

    project = (ROOT / "game/project.godot").read_text(encoding="utf-8")
    preset = (ROOT / "game/export_presets.cfg").read_text(encoding="utf-8")
    scene = (ROOT / "game/scenes/main.tscn").read_text(encoding="utf-8")
    workflow = (ROOT / ".github/workflows/android-build.yml").read_text(encoding="utf-8")

    if 'run/main_scene="res://scenes/main.tscn"' not in project:
        fail("Godot main scene path is not configured.")
    if 'path="res://scripts/main.gd"' not in scene:
        fail("Main scene does not reference the world script.")
    if 'name="Android"' not in preset or 'platform="Android"' not in preset:
        fail("Android export preset is missing.")
    if 'package/unique_name="com.mrfz011007.ninjaworld"' not in preset:
        fail("Android package ID is missing or unexpected.")
    if "godot --headless" not in workflow or "--export-debug" not in workflow:
        fail("Workflow does not run Godot headlessly and export a debug APK.")
    if "upload-artifact" not in workflow:
        fail("Workflow does not upload the APK artifact.")

    print(f"PASS: {len(REQUIRED_FILES)} required project files are present.")
    print("PASS: main scene, Android preset, and APK workflow are configured.")


if __name__ == "__main__":
    main()
