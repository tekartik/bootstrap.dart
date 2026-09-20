---
name: tekartik-bootstrap-setup
description: >-
  Use when a Dart web app has to pull Bootstrap 3 css and js into the page at
  runtime with tekartik_bootstrap: loadBootstrap, loadBootstrapJs,
  loadCdnBootstrapJs, loadBootstrapCss, loadCdnBootstrapCss,
  loadBootstrapThemeCss, loadCdnBootstrapThemeCss, bootstrapVersionDefault,
  bootstrapVersionMin, the Alert wrapper, the btn / btnDefault class names, the
  bootstrap.dart / bootstrap_loader.dart / bootstrap_class.dart imports, the
  jQuery ordering requirement and the tekartik_bootstrap_asset packaged files.
---

# tekartik_bootstrap: loading Bootstrap 3 from Dart (tekartik_bootstrap)

`tekartik_bootstrap` is a thin loader for **Bootstrap 3** (default 3.3.7,
minimum 3.3.5) in a Dart web app: it injects the stylesheet and script tags at
runtime, either from the `tekartik_bootstrap_asset` package or from the
`maxcdn.bootstrapcdn.com` CDN, after making sure jQuery is present. It is not a
widget or component library: the Bootstrap markup stays plain HTML.

## Guidelines

* Dependency (git only, not on pub.dev; single-package repo, so no `path:`):
  ```yaml
  dependencies:
    tekartik_bootstrap:
      git:
        url: https://github.com/tekartik/bootstrap.dart
      version: '>=0.3.0'
  ```
  It pulls `tekartik_jquery`, `tekartik_bootstrap_asset`,
  `tekartik_browser_utils`, `tekartik_common_utils` and `pub_semver`. Declare
  `tekartik_jquery` explicitly too: every js loader needs `jQuery` and you will
  import `package:tekartik_jquery/jquery.dart` to use it.
* Browser only. Everything runs against the DOM and the legacy `dart:js` /
  `dart:html` interop, so these libraries are only usable in code compiled for
  the web (`dart test -p chrome`, `webdev`, `build_web_compilers`), never on the
  Dart VM or in Flutter.
* Three libraries, nothing else is public:
  * `package:tekartik_bootstrap/bootstrap_loader.dart` — all the `load*`
    futures. This is the one you normally import.
  * `package:tekartik_bootstrap/bootstrap.dart` — `bootstrapVersionMin`
    (3.3.5), `bootstrapVersionDefault` (3.3.7) as `pub_semver` `Version`, and
    the `Alert` wrapper.
  * `package:tekartik_bootstrap/bootstrap_class.dart` — the `btn` and
    `btnDefault` class-name strings.
* `await loadBootstrap()` is the one-call entry point: it loads the css and the
  js in parallel and picks the source from `isRelease`
  (`package:tekartik_common_utils/env_utils.dart`) — CDN in release, the
  packaged `tekartik_bootstrap_asset` files in debug. Use it unless you need to
  pin a version or skip the theme.
* Fine-grained loaders, all `Future` returning and all taking an optional
  `version:` (`Version?`, defaulting to `bootstrapVersionDefault`):
  `loadBootstrapCss`, `loadBootstrapThemeCss`, `loadBootstrapJs` read
  `packages/tekartik_bootstrap_asset/<version>/{css,js}/...`;
  `loadCdnBootstrapCss`, `loadCdnBootstrapThemeCss`, `loadCdnBootstrapJs` read
  `//maxcdn.bootstrapcdn.com/bootstrap/<version>/...`. There is no
  "load everything from the CDN" helper other than `loadBootstrap` in release
  mode: chain the three cdn calls yourself.
* Ordering matters: `loadBootstrapJs` and `loadCdnBootstrapJs` touch the
  `jQuery` getter first, which throws a `StateError` when jQuery is missing or
  older than `jQueryVersionMin`. Call `loadJQuery()` or `loadCdnJQuery()` from
  `package:tekartik_jquery/jquery_loader.dart` before them. The css loaders
  have no such requirement and can run in parallel with jQuery.
* Only a version that exists in the packaged asset or on the CDN works. The
  `tekartik_bootstrap_asset` package ships `3.2.0`, `3.3.5` and `3.3.7`; a
  version passed as `version:` is interpolated straight into the url, so a typo
  is a 404 (the loaders complete with an error, they do not fall back).
* `Alert.version` (in `bootstrap.dart`) reads a `VERSION` field off a global
  `Alert` js object and throws on a null global. Bootstrap 3 does not define
  that global, so prefer reading the loaded version through jQuery:
  `(jQuery!.fn('alert') as JsObject)['Constructor']['VERSION']`, which is what
  the package's own test does.
* `btn` and `btnDefault` are plain `final String` values (not `const`), so they
  can be used in expressions but not in `const` contexts. They are the only two
  class names the package exposes; write the other Bootstrap classes
  (`alert`, `alert-warning`, `close`, ...) as literals in your HTML.
* The usual page setup hides `body` in a `<style>` block and reveals it once
  `loadBootstrap()` resolved, so the user never sees the unstyled markup — see
  `example/alert_example.html` and `example/alert_example.dart`.
* Tests are `@TestOn('browser')` and run with `dart test -p chrome`; the CI
  entry point is `tool/run_ci.dart` (`packageRunCi('.')` from
  `package:dev_build/package.dart`). The pure-VM `compat_test.dart` only checks
  `kDartIsWeb`.
* Anti-patterns: calling a `load*Js` helper before jQuery; expecting Bootstrap 4
  or 5 APIs (this is Bootstrap 3 only, jQuery plugins and the `-default` button
  style); calling `loadBootstrapJs()` without depending on
  `tekartik_bootstrap_asset` so `packages/...` is not served; importing these
  libraries from shared code that also runs on the VM.

## Examples

### Load everything and reveal the page

`loadBootstrap()` picks the CDN in release and the packaged assets in debug.

```dart
// ignore_for_file: deprecated_member_use

import 'dart:html';

import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery.dart';

Future<void> main() async {
  await loadBootstrap();
  // The html keeps `body { display: none; }` until the css is in.
  jElement(document.body!)!.fadeIn();
}
```

### Pin a version and force the CDN

```dart
import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_bootstrap/bootstrap.dart';
import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery_loader.dart';

/// Loads css, theme, jQuery and js from the CDN, in the required order.
Future<void> loadBootstrapFromCdn({Version? version}) async {
  version ??= bootstrapVersionDefault; // 3.3.7
  await Future.wait([
    loadCdnBootstrapCss(version: version),
    loadCdnBootstrapThemeCss(version: version),
    () async {
      await loadCdnJQuery();
      await loadCdnBootstrapJs(version: version);
    }(),
  ]);
}
```

### Packaged assets, no theme, explicit jQuery

```dart
import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_bootstrap/bootstrap.dart';
import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery_loader.dart';

Future<void> loadBootstrapLocal() async {
  assert(bootstrapVersionDefault >= bootstrapVersionMin);
  // Served by the tekartik_bootstrap_asset package, version 3.3.5 here.
  var version = Version(3, 3, 5);
  await loadBootstrapCss(version: version);
  await loadJQuery();
  await loadBootstrapJs(version: version);
}
```

### Build Bootstrap markup with the exposed class names

```dart
// ignore_for_file: deprecated_member_use

import 'dart:html';

import 'package:tekartik_bootstrap/bootstrap_class.dart';

ButtonElement createDefaultButton(String text, void Function() onPressed) {
  var button = ButtonElement()
    ..classes.addAll([btn, btnDefault])
    ..text = text;
  button.onClick.listen((_) => onPressed());
  return button;
}
```

### Browser test: the plugins are registered after loading

```dart
@TestOn('browser')
library;

import 'package:tekartik_bootstrap/bootstrap.dart';
import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';

void main() {
  test('bootstrap js registers its jQuery plugins', () async {
    var jq = (await loadJQuery())!;
    expect(jq.fn('alert'), isNull);
    await loadBootstrapJs();
    expect(jq.fn('alert'), isNotNull);
    expect(bootstrapVersionDefault >= bootstrapVersionMin, isTrue);
  });
}
```
