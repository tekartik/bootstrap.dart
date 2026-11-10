@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:tekartik_bootstrap/bootstrap_loader.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

int _bootstrapScriptCount() =>
    web.document.querySelectorAll('script[src*="bootstrap.min.js"]').length;

void main() {
  test('loading twice runs bootstrap once', () async {
    await loadJQuery();
    // Two components loading Bootstrap at startup, then once more.
    await Future.wait([loadBootstrapJs(), loadBootstrapJs()]);
    await loadBootstrapJs();
    expect(_bootstrapScriptCount(), 1);

    // Each run of bootstrap.js binds its data-api handlers on the document:
    // run twice, a dropdown toggle opens then closes at once.
    final dropdown = web.document.createElement('div')
      ..className = 'dropdown'
      ..innerHTML =
          ('<button type="button" data-toggle="dropdown">menu</button>'
                  '<ul class="dropdown-menu"><li>item</li></ul>')
              .toJS;
    web.document.body!.appendChild(dropdown);
    (dropdown.querySelector('button')! as web.HTMLElement).click();
    expect(dropdown.classList.contains('open'), isTrue);
    dropdown.remove();
  }, timeout: const Timeout(Duration(seconds: 30)));
}
