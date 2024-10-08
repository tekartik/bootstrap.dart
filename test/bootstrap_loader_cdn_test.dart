@TestOn('browser')
library;

import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';

void main() {
  group('loader', () {
    test('load', () async {
      var jq = (await loadJQuery())!;
      expect(jq.fn('alert'), isNull);
      await loadCdnBootstrapJs();
      expect(jq.fn('alert'), isNotNull);
    });
  });
}
