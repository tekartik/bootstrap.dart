library;

import 'dart:async';

import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_browser_utils/css_utils.dart';
import 'package:tekartik_browser_utils/js_utils.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';

import 'bootstrap.dart';

// Load jquery and bootstrap
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
      }()
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
      }()
    ]);
  }
}

Future loadBootstrapJs({Version? version}) async {
  version ??= bootstrapVersionDefault;

  // make sure jQuery is loaded
  // this will throw if not
  jQuery;
  //print(jsObjectToDebugString(jQuery.jsObject));
  // load jquery
  await loadJavascriptScript(
      'packages/tekartik_bootstrap_asset/$version/js/bootstrap.min.js');
  //print(jsObjectToDebugString(jQuery.jsObject));
}

Future loadCdnBootstrapJs({Version? version}) async {
  version ??= bootstrapVersionDefault;

  jQuery;
  await loadJavascriptScript(
      '//maxcdn.bootstrapcdn.com/bootstrap/$version/js/bootstrap.min.js');
}

Future loadBootstrapCss({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await loadStylesheet(
      'packages/tekartik_bootstrap_asset/$version/css/bootstrap.min.css');
}

Future loadCdnBootstrapCss({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await loadStylesheet(
      '//maxcdn.bootstrapcdn.com/bootstrap/$version/css/bootstrap.min.css');
}

Future loadBootstrapThemeCss({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await loadStylesheet(
      'packages/tekartik_bootstrap_asset/$version/css/bootstrap-theme.min.css');
}

Future loadCdnBootstrapThemeCss({Version? version}) async {
  version ??= bootstrapVersionDefault;
  await loadStylesheet(
      '//maxcdn.bootstrapcdn.com/bootstrap/$version/css/bootstrap-theme.min.css');
}
