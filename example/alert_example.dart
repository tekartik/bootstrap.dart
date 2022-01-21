import 'dart:html';

import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery.dart';

Future<void> main() async {
  await loadBootstrap();
  jElement(document.body!)!.fadeIn();
  //print('done');
}
