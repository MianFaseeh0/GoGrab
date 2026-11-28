import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'svg_data.dart';

String hexOf(Color c) =>
    // ignore: deprecated_member_use
    '#${(c.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

final Map<String, Widget> _faceCache = {};

String faceSvg(int i) {
  final l = (F[i][2] as String).split(',');
  final e = l.firstWhere((x) => x.startsWith('e_'), orElse: () => '');
  final f = l.where((x) => !x.startsWith('e_') && P.containsKey(x)).toList();
  final back = f.where((x) => BK.contains(x)).map((x) => P[x]!).join();
  final front = f.where((x) => !BK.contains(x)).map((x) => P[x]!).join();
  final svg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="-4 -18 108 122">$back'
      '<circle cx="50" cy="56" r="34" fill="$kC" stroke="$kK" stroke-width="5"/>'
      '${EY[e.isEmpty ? 'd' : e]}${MO[F[i][3]]}$front</svg>';
  return svg.replaceAll('fill="rgba(129,0,0,.10)"', 'fill="#810000" fill-opacity=".1"');
}

/// A character face, exactly the SVG from the prototype.
Widget face(int i, double z) {
  final key = '$i@$z';
  return _faceCache.putIfAbsent(
      key,
      () => SizedBox(
          width: z,
          height: z * 1.13,
          child: SvgPicture.string(faceSvg(i), width: z, height: z * 1.13, fit: BoxFit.contain)));
}

final Map<String, Widget> _icCache = {};

/// Stroke icon (24x24 viewBox) in colour [c].
Widget ic(String n, double z, Color c, [double w = 2.2]) {
  final key = '$n@$z@${hexOf(c)}@$w';
  return _icCache.putIfAbsent(key, () {
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="${hexOf(c)}" stroke-width="$w" stroke-linecap="round" stroke-linejoin="round">${IC[n] ?? ''}</g></svg>';
    return SizedBox(width: z, height: z, child: SvgPicture.string(svg, width: z, height: z));
  });
}
