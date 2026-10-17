# Ninja World — Android

An original 3D anime-inspired ninja exploration prototype for Android, built with **Godot 4.7.2** and **GitHub Actions**.

> This repository starts with original placeholder geometry and code. It does not include Naruto characters, logos, music, models, or other franchise assets.

## Current milestone

**Milestone 1 — project foundation and first debug APK**

- A small 3D forest path built from Godot primitives.
- Third-person player movement, keyboard support, and on-screen touch controls.
- Android ARM64 debug APK exported in GitHub Actions.
- Headless Godot startup and repository structure checks.

This is a prototype, not a completed open-world game. Real-device FPS, memory use, heat, battery impact, and Android installation still need to be checked.

## Build with GitHub Actions

1. Open the **Actions** tab.
2. Select **Godot Android Build**.
3. Open a completed workflow run.
4. Download the `NinjaWorld-debug-apk` artifact.

The workflow builds a **debug APK** for testing. Release signing and distribution are intentionally not configured yet; never commit keystores, passwords, API keys, or other secrets.

## Project layout

- `game/` — Godot project, scene scripts, and Android export preset.
- `.github/workflows/android-build.yml` — cloud validation and APK export.
- `tests/` — repository-level checks.
- `ROADMAP.md` — staged development plan.
- `docs/AI_CODING_AGENT.md` — safe future plan for an AI coding agent; no autonomous agent is enabled yet.

## Local editor

Open `game/project.godot` with Godot 4.7.2. For Android export outside CI, configure matching Godot export templates, Java, and the Android SDK as described in the [official Android export guide](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html).

## Design principles

- Small, testable increments rather than a large unverified code dump.
- Original characters, story, names, and assets for a distributable project.
- ARM64 and the Godot Compatibility renderer as a conservative first target.
- Build artifacts are evidence of a successful build, not proof that gameplay is complete.
