#!/usr/bin/env python3
"""Fast, dependency-free checks for the Godot project scaffold and collision regression coverage."""

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
    "game/tests/collision_smoke.gd",
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
    main_script = (ROOT / "game/scripts/main.gd").read_text(encoding="utf-8")
    collision_test = (ROOT / "game/tests/collision_smoke.gd").read_text(encoding="utf-8")
    workflow = (ROOT / ".github/workflows/android-build.yml").read_text(encoding="utf-8")

    if 'run/main_scene="res://scenes/main.tscn"' not in project:
        fail("Godot main scene path is not configured.")
    if "textures/vram_compression/import_etc2_astc=true" not in project:
        fail("Android ETC2/ASTC texture import must be enabled.")
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
    if "res://tests/collision_smoke.gd" not in workflow:
        fail("Workflow does not execute the collision regression test.")

    collision_requirements = {
        "tree physics body": "var trunk_body := StaticBody3D.new()",
        "tree collision shape": "var trunk_collision := CollisionShape3D.new()",
        "cylindrical tree collider": "var trunk_shape := CylinderShape3D.new()",
        "gate physics body": "var body := StaticBody3D.new()",
        "gate collision shape": "var collision := CollisionShape3D.new()",
        "box-shaped gate collider": "var collision_shape := BoxShape3D.new()",
        "matching visual and collision dimensions": "collision_shape.size = box_size",
    }
    for description, required_text in collision_requirements.items():
        if required_text not in main_script:
            fail(f"Missing {description} in main.gd.")

    for required_test in (
        "TreeCollisionProbe",
        "GateCollisionProbe",
        "CylinderShape3D",
        "BoxShape3D",
        "move_and_collide",
    ):
        if required_test not in collision_test:
            fail(f"Collision regression test is missing {required_test!r}.")

    print(f"PASS: {len(REQUIRED_FILES)} required project files are present.")
    print("PASS: main scene, Android preset, texture import, and APK workflow are configured.")
    print("PASS: tree and gate colliders are implemented and collision regression coverage is present.")


if __name__ == "__main__":
    main()
