import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

const kC = Color(0xFFEEEBDD); // cream
const kR = Color(0xFF810000); // crimson
const kD = Color(0xFF630000); // dark crimson
const kK = Color(0xFF1B1717); // ink
const kG = Color(0xFFB9B1A0);

Color rgba(int r, int g, int b, double a) => Color.fromRGBO(r, g, b, a);

/// Bricolage Grotesque 800 (default, letter-spacing -.03em) or DM Mono 500.
/// [ls] is in em, exactly like the CSS. Colour is left null so it inherits.
TextStyle tx(double size, {bool mono = false, Color? color, double? ls, double? h}) {
  if (mono) {
    return GoogleFonts.dmMono(
        fontSize: size,
        fontWeight: FontWeight.w500,
        letterSpacing: (ls ?? 0) * size,
        color: color,
        height: h);
  }
  return GoogleFonts.bricolageGrotesque(
      fontSize: size,
      fontWeight: FontWeight.w800,
      letterSpacing: (ls ?? -.03) * size,
      color: color,
      height: h);
}

/// CSS clamp(min, vw, max) using the real screen width.
double vw(BuildContext c, double min, double pct, double max) {
  final w = MediaQuery.of(c).size.width * pct / 100;
  return w < min ? min : (w > max ? max : w);
}

/// h2 size = clamp(44px,15vw,60px)
double h2Size(BuildContext c) => vw(c, 44, 15, 60);
