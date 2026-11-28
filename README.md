# GoGrab (Flutter port of the HTML prototype)

Screens: login, face picker, hub, name crew, invite, join (code + shuffle search),
home (Crew / Runs / Me tabs), crew (Runs / Members / Me), add-run sheet,
store-type picker (~49 types), time wheel, ranked assignee strip, edit-run screen.

## Run
    flutter create . --platforms=android,ios,web   # one-time: generates platform folders
    flutter pub get
    flutter run

## Notes
- `lib/core/svg_data.dart` is generated from the HTML: `python3 tools/gen_svg_data.py`
  (edit the path at the top of the script to point at the HTML file).
- Fonts (Bricolage Grotesque, DM Mono) load through `google_fonts` at runtime, so the first
  launch needs internet. To work offline, add the .ttf files as assets and use `fontFamily`.
- Not compiled or run in the sandbox that produced it (no Flutter/Dart toolchain there).
  Run `flutter analyze` first and fix any small typos it reports.
