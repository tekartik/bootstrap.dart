# tekartik_bootstrap

Loads [Bootstrap 3](https://getbootstrap.com/docs/3.3/) (css and javascript,
3.3.7 by default) into a Dart web page at runtime, after jQuery: from the
`tekartik_bootstrap_asset` package or from the maxcdn.bootstrapcdn.com CDN.
The markup stays plain Bootstrap HTML.

Browser only (`dart:js_interop`, `package:web`: dart2js and dart2wasm).

## Getting started

Not on pub.dev, a git dependency:

```yaml
dependencies:
  tekartik_bootstrap:
    git:
      url: https://github.com/tekartik/bootstrap.dart
    version: '>=0.4.0'
  tekartik_jquery:
    git:
      url: https://github.com/tekartik/jquery.dart
    version: '>=0.4.0'
```

```dart
import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'package:web/web.dart' as web;

Future<void> main() async {
  // css + theme, jQuery then Bootstrap's javascript.
  await loadBootstrap();
  // The page hides its body until the css is in.
  jElement(web.document.body!)!.fadeIn();
}
```

The page: [example/alert_example.html](example/alert_example.html)
(`<style>body { display: none; }</style>`, Bootstrap markup, the compiled
script).

## What to use

* `loadBootstrap()`: everything; the CDN in a release build (assertions off,
  `isRelease`), the packaged files otherwise.
* `loadBootstrapCss`, `loadBootstrapThemeCss`, `loadBootstrapJs` (packaged
  files, `packages/tekartik_bootstrap_asset/<version>/...`) and the
  `loadCdn...` ones, all with an optional `version:` (3.2.0, 3.3.5 or 3.3.7
  packaged).
* `Alert.version` (`bootstrap.dart`): the version of the loaded Bootstrap
  javascript, null before.

## Good to know

* Load jQuery before Bootstrap's javascript (`loadJQuery()` of
  `package:tekartik_jquery/jquery_loader.dart`): `loadBootstrapJs` throws a
  `StateError` otherwise.
* `loadBootstrapJs` and `loadCdnBootstrapJs` do nothing when Bootstrap's
  javascript is already in the page (any version), and concurrent calls share
  one script: Bootstrap 3 run twice binds its data-api twice, a dropdown then
  opens and closes at once.
* A version is put in the url as is: one that is not packaged (or on the CDN)
  fails with a 404, no fallback.
* Bootstrap 3 only (jQuery plugins); not for the Dart VM nor Flutter.
