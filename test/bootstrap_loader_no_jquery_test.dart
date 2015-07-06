@TestOn("browser")
library jquery_browser_test;

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:tekartik_bootstrap/bootstrap_loader.dart';

import 'package:test/test.dart';
import 'dart:html';

void main() {

  group('loader no jquery', () {

    test('load', () async {
      try {
        await loadBootstrapJs();
        throw "should throw";
      } catch (e) {

      }
    });

  });


}
