library tekartik_bootstrap;

import 'dart:js';

import 'package:pub_semver/pub_semver.dart';

Version get bootstrapVersionMin => Version(3, 3, 5);
//Version get bootstrapVersionDefault => new Version(3, 3, 5);

Version get bootstrapVersionDefault => Version(3, 3, 7);

// ignore: non_constant_identifier_names
JsObject? get _Alert => context['Alert'] as JsObject?;

class Alert {
  static String? get version => _Alert!['VERSION'] as String?;
}
