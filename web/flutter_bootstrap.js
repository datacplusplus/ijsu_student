{{flutter_js}}
{{flutter_build_config}}

// Cache-bust the app code: every build gets a new version stamp, so after a
// deploy browsers download the new main.dart.js instead of a cached copy.
// __BUILD_ID__ is replaced after each build (see WORK_SUMMARY.md, section 9).
for (const b of _flutter.buildConfig.builds) {
  if (b.mainJsPath) b.mainJsPath += "?v=__BUILD_ID__";
}

_flutter.loader.load();
