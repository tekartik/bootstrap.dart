library tekartik_bootstrap;

import 'package:pub_semver/pub_semver.dart';
import 'dart:js';

Version get bootstrapVersionMin => new Version(3, 3, 5);
//Version get bootstrapVersionDefault => new Version(3, 3, 5);

Version get bootstrapVersionDefault => new Version(3, 3, 7);

JsObject get _Alert => context['Alert'];

class Alert {
  static String get version => _Alert['VERSION'];
}