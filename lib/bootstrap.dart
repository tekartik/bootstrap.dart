/// Bootstrap versions and the [Alert] plugin.
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:pub_semver/pub_semver.dart';

/// The oldest Bootstrap supported.
Version get bootstrapVersionMin => Version(3, 3, 5);

/// The Bootstrap loaded by default.
Version get bootstrapVersionDefault => Version(3, 3, 7);

/// The [name] property of [object] when it is a javascript object.
JSObject? _property(JSObject? object, String name) {
  if (object == null) {
    return null;
  }
  final value = object[name];
  if (value.isUndefinedOrNull) {
    return null;
  }
  return value as JSObject;
}

/// The Bootstrap 3 alert plugin constructor (`jQuery.fn.alert.Constructor`),
/// null until jQuery and Bootstrap's javascript are loaded.
JSObject? get _alertConstructor => _property(
  _property(_property(_property(globalContext, 'jQuery'), 'fn'), 'alert'),
  'Constructor',
);

/// The Bootstrap alert plugin.
class Alert {
  /// Version of the loaded Bootstrap javascript (`$.fn.alert.Constructor.VERSION`),
  /// null when Bootstrap's javascript is not loaded.
  static String? get version =>
      (_alertConstructor?['VERSION'] as JSString?)?.toDart;
}
