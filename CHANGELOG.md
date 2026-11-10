# 0.4.1

- `loadBootstrapJs` / `loadCdnBootstrapJs` load Bootstrap's javascript once
  (a second run broke the data-api: dropdowns never opened); concurrent calls
  share one load.

# 0.4.0

- `dart:js_interop` instead of `dart:js`: works with dart2js and dart2wasm.
- Requires tekartik_jquery 0.4.0 (`dart:js_interop` / `package:web`).
- `Alert.version` returns the loaded Bootstrap version
  (`$.fn.alert.Constructor.VERSION`), null before it is loaded; it read a
  global `Alert` that Bootstrap 3 does not define and always threw.

# 0.1.0

- Initial revision