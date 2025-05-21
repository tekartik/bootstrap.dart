@TestOn('browser')
library;

import 'dart:js';

import 'package:tekartik_bootstrap/bootstrap.dart';
import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    await loadJQuery();
    await loadBootstrapJs();
  });

  group('alert', () {
    test('version', () {
      expect(
        ((jQuery!.fn('alert') as JsObject)['Constructor']
            as JsObject)['VERSION'],
        bootstrapVersionDefault.toString(),
      );
    });
  });
}
