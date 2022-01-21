@TestOn('browser')
library jquery_browser_test;

import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';

void main() {
  group('loader', () {
    test('load', () async {
      var jq = (await loadJQuery())!;
      expect(jq.fn('alert'), isNull);
      await loadBootstrapJs();
      expect(jq.fn('alert'), isNotNull);
    });
  });
}
