import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'package:web/web.dart' as web;

Future<void> main() async {
  await loadBootstrap();
  jElement(web.document.body!)!.fadeIn();
  //print('done');
}
