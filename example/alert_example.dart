import 'dart:html';
import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:tekartik_browser_utils/js_utils.dart';
import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_bootstrap/bootstrap.dart';

main() async {
  print('Hi');
  await loadBootstrapCss();
  await loadBootstrapThemeCss();
  await loadJQuery();
  await loadBootstrapJs();
  jElement(document.body).fadeIn();
  //print('done');
}