/// Adds Bootstrap 3 (css and javascript) to the page: [loadBootstrap], or
/// the packaged (`tekartik_bootstrap_asset`) and CDN loaders one by one.
library;

import 'dart:async';

import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_browser_utils/css_utils.dart';
import 'package:tekartik_browser_utils/js_utils.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';

import 'bootstrap.dart';

/// Loads the Bootstrap css and theme, jQuery then Bootstrap's javascript
/// ([bootstrapVersionDefault]): from the CDN in a release build (assertions
/// off, `isRelease`), from tekartik_bootstrap_asset otherwise.
Future loadBootstrap() async {
  if (isRelease) {
    await Future.wait([
      () async {
        await loadCdnBootstrapCss();
        await loadCdnBootstrapThemeCss();
      }(),
      () async {
        await loadCdnJQuery();
        await loadCdnBootstrapJs();
      }(),
    ]);
  } else {
    await Future.wait([
      () async {
        await loadBootstrapCss();
        await loadBootstrapThemeCss();
      }(),
      () async {
        await loadJQuery();
        await loadBootstrapJs();
      }(),
    ]);
  }
}

/// The Bootstrap script loads started, by url: concurrent calls share one
/// script tag; a failed load is removed, the next call retries.
final _scriptLoads = <String, Future<void>>{};

/// Adds the Bootstrap script [src] to the page, once.
///
/// Bootstrap's javascript run twice binds its data-api handlers twice (a
/// `data-toggle="dropdown"` click then opens and closes the menu at once), so
/// nothing is loaded when Bootstrap's javascript is already in the page.
Future<void> _loadBootstrapScript(String src) async {
  // make sure jQuery is loaded
  // this will throw if not
  jQuery;
  if (Alert.version != null) {
    return;
  }
  await (_scriptLoads[src] ??= () async {
    try {
      await loadJavascriptScript(src);
    } catch (e, st) {
      unawaited(_scriptLoads.remove(src));
      Error.throwWithStackTrace(e, st);
    }
  }());
}

/// Adds Bootstrap's javascript [version] of tekartik_bootstrap_asset to the
/// page ([bootstrapVersionDefault] by default). jQuery must be loaded first
/// (throws a [StateError] otherwise). Does nothing when Bootstrap's
/// javascript is already in the page; concurrent calls share one load.
Future loadBootstrapJs({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await _loadBootstrapScript(
    'packages/tekartik_bootstrap_asset/$version/js/bootstrap.min.js',
  );
}

/// Same as [loadBootstrapJs], from maxcdn.bootstrapcdn.com.
Future loadCdnBootstrapJs({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await _loadBootstrapScript(
    '//maxcdn.bootstrapcdn.com/bootstrap/$version/js/bootstrap.min.js',
  );
}

/// Adds the Bootstrap css [version] of tekartik_bootstrap_asset
/// ([bootstrapVersionDefault] by default).
Future loadBootstrapCss({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await loadStylesheet(
    'packages/tekartik_bootstrap_asset/$version/css/bootstrap.min.css',
  );
}

/// Same as [loadBootstrapCss], from maxcdn.bootstrapcdn.com.
Future loadCdnBootstrapCss({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await loadStylesheet(
    '//maxcdn.bootstrapcdn.com/bootstrap/$version/css/bootstrap.min.css',
  );
}

/// Adds the Bootstrap theme css [version] of tekartik_bootstrap_asset
/// ([bootstrapVersionDefault] by default).
Future loadBootstrapThemeCss({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await loadStylesheet(
    'packages/tekartik_bootstrap_asset/$version/css/bootstrap-theme.min.css',
  );
}

/// Same as [loadBootstrapThemeCss], from maxcdn.bootstrapcdn.com.
Future loadCdnBootstrapThemeCss({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await loadStylesheet(
    '//maxcdn.bootstrapcdn.com/bootstrap/$version/css/bootstrap-theme.min.css',
  );
}
