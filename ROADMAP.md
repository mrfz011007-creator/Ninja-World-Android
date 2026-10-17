# Ninja World — Development Roadmap

## Product direction

Build an original 3D anime-inspired ninja exploration game for Android. The first prototype uses low-cost procedural placeholder geometry so that the controls, scene layout, and build pipeline can be verified before expensive art is introduced.

**Device baseline:** Android 13 / ARM64 phone with roughly 4 GB RAM. This is a design constraint, not a claim that performance has already been measured.

## Milestone 1 — Foundation and first APK

**This branch prepares this milestone.**

- [x] Create an isolated repository and define the project layout.
- [x] Add a Godot project with a small 3D forest scene.
- [x] Add third-person movement, keyboard mappings, and touch controls.
- [x] Add an Android ARM64 debug export preset.
- [x] Add CI validation, headless launch checks, APK export, and artifact upload.
- [ ] Confirm the first GitHub Actions run succeeds.
- [ ] Install and manually test the APK on the target phone.

**Exit criteria:** the APK builds in CI, installs, opens to the prototype, and responds to touch controls on a real Android device.

## Milestone 2 — Character and camera

- Improve movement feel and camera follow/rotation.
- Add animation states and original placeholder character art.
- Make touch controls configurable and account for different screen sizes.
- Add pause/resume behavior and save-safe lifecycle handling.

## Milestone 3 — First explorable region

- Replace the primitive test grove with a designed village/forest layout.
- Add collision for scenery, boundaries, and landmarks.
- Add interactable NPCs and simple dialogue.
- Add level-of-detail and visibility/performance checks before expanding the map.

## Milestone 4 — Combat prototype

- Add a basic attack, cooldown, hit detection, and damage feedback.
- Add one enemy type with a small, testable behavior state machine.
- Add dodge and one original energy-based ability.
- Test input conflicts, reset conditions, and combat edge cases.

## Milestone 5 — Missions and progression

- Add mission objectives and completion state.
- Add experience, levels, and a small ability progression system.
- Persist player progress locally with versioned save data.
- Test interrupted saves and malformed save files.

## Milestone 6 — World expansion

- Add additional handcrafted regions and mission chains.
- Introduce streaming/loading boundaries if profiling demonstrates a need.
- Track asset sizes and avoid committing generated or licensed assets without review.
- Keep every region independently testable.

## Milestone 7 — Optimization and release

- Profile on the physical phone: FPS, memory, thermal behavior, battery drain, load time.
- Reduce draw calls, texture sizes, shadows, and geometry where measurements justify it.
- Test on more than one Android device and screen aspect ratio.
- Configure release signing with GitHub Secrets only after a secure release process is agreed.
- Produce a versioned release APK/AAB and a rollback checkpoint.

## Working rules

- Keep each milestone small and verifiable.
- Treat a successful build as build evidence only; it is not gameplay QA.
- Do not put secrets or private signing material in Git.
- Do not merge major gameplay changes until the user can inspect test results and the APK.
- Use original names, characters, story, code, and assets for a project intended for wider distribution.
