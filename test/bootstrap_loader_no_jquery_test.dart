@TestOn('browser')
library;

import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:test/test.dart';

void main() {
  group('loader no jquery', () {
    test('load', () async {
      try {
        await loadBootstrapJs();
        fail('should throw');
      } catch (e) {
        expect(e, isNot(const TypeMatcher<TestFailure>()));
      }
    });
  });
}
