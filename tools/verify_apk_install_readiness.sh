#!/usr/bin/env bash
set -euo pipefail

APK_PATH="${1:-build/android/Orlumi-Petal-Nook.apk}"
BUILD_TOOLS_DIR="${ANDROID_HOME:?ANDROID_HOME is required}/build-tools/35.0.0"
REPORT_DIR="$(dirname "$APK_PATH")"

if [[ ! -s "$APK_PATH" ]]; then
  echo "APK missing or empty: $APK_PATH" >&2
  exit 1
fi

"$BUILD_TOOLS_DIR/apksigner" verify --verbose --print-certs "$APK_PATH" | tee "$REPORT_DIR/apksigner-report.txt"
"$BUILD_TOOLS_DIR/aapt" dump badging "$APK_PATH" | tee "$REPORT_DIR/aapt-badging.txt"

grep -q "package: name='com.orlumi.petalnook'" "$REPORT_DIR/aapt-badging.txt"
grep -q "native-code:.*'arm64-v8a'" "$REPORT_DIR/aapt-badging.txt"

unzip -l "$APK_PATH" | tee "$REPORT_DIR/apk-contents.txt"
grep -q "lib/arm64-v8a/libgodot_android.so" "$REPORT_DIR/apk-contents.txt"

echo "PETAL_NOOK_APK_INSTALL_READINESS: PASS"
