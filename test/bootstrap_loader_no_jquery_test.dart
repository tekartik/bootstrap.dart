@TestOn("browser")
import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:dev_test/test.dart';

void main() {
  group('loader no jquery', () {
    test('load', () async {
      try {
        await loadBootstrapJs();
        throw "should throw";
      } catch (e) {}
    });
  });
}
