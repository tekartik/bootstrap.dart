@TestOn('browser')
library;

import 'package:tekartik_bootstrap/bootstrap.dart';
import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';

void main() {
  test('Alert.version', () async {
    // Null until Bootstrap's javascript is loaded.
    expect(Alert.version, isNull);
    await loadJQuery();
    expect(Alert.version, isNull);
    await loadBootstrapJs();
    expect(Alert.version, bootstrapVersionDefault.toString());
  });
}
