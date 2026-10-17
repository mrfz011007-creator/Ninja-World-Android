# Build and Test

## Automated build

The `Godot Android Build` workflow runs on pushes, pull requests targeting `main`, and manual dispatch.

It performs these steps on a cloud runner:

1. Install Java 17 and Android SDK components.
2. Install Godot 4.7.2 and matching export templates.
3. Configure Godot's Android SDK paths for headless export.
4. Run repository checks and Godot headless import/startup checks.
5. Export an ARM64 **debug APK** and validate the APK archive.
6. Upload the APK as the `NinjaWorld-debug-apk` workflow artifact for 14 days.

## Download the APK

Open the GitHub repository's **Actions** tab, open a successful run, then download the `NinjaWorld-debug-apk` artifact. The artifact is a ZIP containing `NinjaWorld-debug.apk`.

## Local validation

Run the dependency-free repository checks:

```sh
python3 tests/validate_project.py
```

Open `game/project.godot` in Godot 4.7.2 to run the prototype in the editor. Exporting for Android locally additionally needs the matching Godot Android export templates, Java, and the Android SDK configured in editor settings.

## Debug vs release

The workflow intentionally creates a **debug build for testing**. Release signing is not configured. A proper release pipeline needs an owner-controlled keystore stored outside Git and secrets configured in GitHub Actions.
