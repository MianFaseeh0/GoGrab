import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'anim.dart';
import 'svg.dart';
import 'theme.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class DotBg extends StatelessWidget {
  final Widget child;
  const DotBg({super.key, required this.child});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _DotPainter(), child: SizedBox.expand(child: child));
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = kC);
    final p = Paint()..color = rgba(129, 0, 0, .12);
    for (double x = 11; x < size.width + 11; x += 22) {
      for (double y = 11; y < size.height + 11; y += 22) {
        canvas.drawCircle(Offset(x, y), 1.7, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// `.sc` padding: 34px 22px 22px (top grows on notched phones).
EdgeInsets scPad(BuildContext c) {
  final m = MediaQuery.of(c);
  return EdgeInsets.fromLTRB(22, math.max(34.0, m.padding.top + 8), 22, 22 + m.padding.bottom);
}

// ───────────────────────── press helper ─────────────────────────
class Press extends StatefulWidget {
  final Widget Function(bool down) b;
  final VoidCallback? onTap, onLongPress;
  final bool enabled;
  const Press({super.key, required this.b, this.onTap, this.onLongPress, this.enabled = true});
  @override
  State<Press> createState() => _PressState();
}

class _PressState extends State<Press> {
  bool d = false;
  void _s(bool v) {
    if (mounted && d != v) setState(() => d = v);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.enabled ? (_) => _s(true) : null,
      onTapUp: (_) => _s(false),
      onTapCancel: () => _s(false),
      onTap: widget.enabled ? widget.onTap : null,
      onLongPress: widget.enabled ? widget.onLongPress : null,
      child: widget.b(d && widget.enabled));
}

BoxShadow hard(Color c, double dy) =>
    BoxShadow(color: c, offset: Offset(0, dy), blurRadius: 0, spreadRadius: 0);

// ───────────────────────── buttons ─────────────────────────
/// `.btn` (v: '' red, 'k' ink, 'o' outline)
class Btn extends StatelessWidget {
  final String t, v;
  final VoidCallback? onTap;
  final double h, fs;
  final bool dis, auto;
  const Btn(this.t,
      {super.key, this.onTap, this.v = '', this.h = 58, this.fs = 20, this.dis = false, this.auto = false});
  @override
  Widget build(BuildContext context) {
    final bg = v == 'k' ? kK : (v == 'o' ? kC : kR);
    final fg = v == 'o' ? kK : kC;
    final shc = v == 'k' ? kR : kK;
    return Press(
        enabled: !dis,
        onTap: onTap,
        b: (d) => Opacity(
            opacity: dis ? .4 : 1,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: h,
                width: auto ? null : double.infinity,
                padding: auto ? const EdgeInsets.symmetric(horizontal: 26) : null,
                transform: Matrix4.translationValues(0, d ? 4 : 0, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(h >= 58 ? 32 : h / 2),
                    border: v == 'o' ? Border.all(color: kK, width: 3) : null,
                    boxShadow: [hard(shc, (d && v == '') ? 1 : 5)]),
                child: Text(t, style: tx(fs, color: fg)))));
  }
}

/// `.lk` underlined link
class LinkBtn extends StatelessWidget {
  final String t;
  final VoidCallback onTap;
  const LinkBtn(this.t, {super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
          padding: EdgeInsets.zero,
          child: Text(t, style: tx(16).copyWith(decoration: TextDecoration.underline))));
}

/// `.bk` back button
class Bk extends StatelessWidget {
  final VoidCallback onTap;
  const Bk({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: kK, shape: BoxShape.circle, boxShadow: [hard(kR, 4)]),
          child: ic('back', 24, kC, 3)));
}

/// `.ab` round add button (rotates 90deg while pressed)
class AddBtn extends StatelessWidget {
  final VoidCallback onTap;
  const AddBtn({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => Press(
      onTap: onTap,
      b: (d) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 54,
          height: 54,
          alignment: Alignment.center,
          transformAlignment: Alignment.center,
          transform: Matrix4.translationValues(0, d ? 4 : 0, 0)..rotateZ(d ? math.pi / 2 : 0),
          decoration:
              BoxDecoration(color: kR, shape: BoxShape.circle, boxShadow: [hard(kK, d ? 1 : 5)]),
          child: ic('plus', 28, kC, 3.2)));
}

// ───────────────────────── text field ─────────────────────────
class InField extends StatefulWidget {
  final TextEditingController c;
  final String? hint;
  final int? maxLen;
  final bool obscure;
  final TextInputType? kt;
  final double h, fs;
  final ValueChanged<String>? onSubmit;
  const InField(
      {super.key,
      required this.c,
      this.hint,
      this.maxLen,
      this.obscure = false,
      this.kt,
      this.h = 58,
      this.fs = 20,
      this.onSubmit});
  @override
  State<InField> createState() => InFieldState();
}

class InFieldState extends State<InField> {
  final FocusNode fn = FocusNode();
  final GlobalKey<ShakeState> sk = GlobalKey<ShakeState>();
  bool bad = false;
  @override
  void initState() {
    super.initState();
    fn.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void shake() {
    setState(() => bad = true);
    sk.currentState?.go();
    fn.requestFocus();
  }

  @override
  void dispose() {
    fn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = fn.hasFocus;
    return Shake(
        key: sk,
        child: Container(
            height: widget.h,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: kC,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: (f || bad) ? kR : kK, width: 3),
                boxShadow: [hard(f ? kR : kK, 4)]),
            child: TextField(
                controller: widget.c,
                focusNode: fn,
                obscureText: widget.obscure,
                keyboardType: widget.kt,
                cursorColor: kK,
                onSubmitted: widget.onSubmit,
                onChanged: (_) {
                  if (bad) setState(() => bad = false);
                },
                inputFormatters:
                    widget.maxLen == null ? null : [LengthLimitingTextInputFormatter(widget.maxLen)],
                enableSuggestions: false,
                autocorrect: false,
                style: tx(widget.fs, color: kK),
                decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: tx(widget.fs, color: const Color(0xFF757575))))));
  }
}

/// `.fl` mono label
Widget fl(String t, {double mt = 0, double mb = 6}) =>
    Padding(padding: EdgeInsets.only(top: mt, bottom: mb), child: Text(t, style: tx(13, mono: true)));

// ───────────────────────── chips / cards ─────────────────────────
/// `.fc` filter chip
class Fc extends StatelessWidget {
  final String t;
  final bool on;
  final VoidCallback onTap;
  const Fc(this.t, {super.key, required this.on, required this.onTap});
  @override
  Widget build(BuildContext context) => Press(
      onTap: onTap,
      b: (d) => AnimatedScale(
          duration: const Duration(milliseconds: 200),
          curve: const Cubic(.2, 1.6, .4, 1),
          scale: d ? .93 : (on ? 1.06 : 1),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: on ? kK : kC,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: kK, width: 3)),
              child: Text(t, style: tx(15, ls: 0, color: on ? kC : kK)))));
}

/// Horizontal chip strip (`.fb`)
class ChipBar extends StatelessWidget {
  final List<Widget> kids;
  final EdgeInsets pad;
  const ChipBar(this.kids, {super.key, this.pad = const EdgeInsets.fromLTRB(22, 4, 22, 8)});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: pad,
      child: Row(children: [
        for (var i = 0; i < kids.length; i++) ...[if (i > 0) const SizedBox(width: 10), kids[i]]
      ]));
}

/// `.cc` ticket-style card
class Cc extends StatelessWidget {
  final bool pn, flash;
  final int n;
  final double rot; // degrees
  final Widget child;
  final VoidCallback? onTap, onLongPress;
  const Cc(
      {super.key,
      required this.child,
      this.pn = false,
      this.flash = false,
      this.n = 0,
      this.rot = -.7,
      this.onTap,
      this.onLongPress});
  @override
  Widget build(BuildContext context) {
    final card = Press(
        onTap: onTap,
        onLongPress: onLongPress,
        b: (d) => Transform.rotate(
            angle: rot * math.pi / 180,
            child: AnimatedScale(
                duration: const Duration(milliseconds: 150),
                scale: d ? .97 : 1,
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: pn ? kR : kC,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: kK, width: 3),
                        boxShadow: [hard(kK, 5)]),
                    child: DefaultTextStyle.merge(
                        style: TextStyle(color: pn ? kC : kK), child: child)))));
    return flash
        ? bumpA(card, ms: 450)
        : popA(card, delay: n * 80, ms: 500, curve: const Cubic(.2, 1.4, .4, 1));
  }
}

/// `.cbd` round badge
Widget cbd(String icon, Color c, {double sz = 58, double isz = 30, Color bg = kR}) => Container(
    width: sz,
    height: sz,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    child: ic(icon, isz, c, 2.4));

/// `.stub` right-hand perforated strip
class Stub extends StatelessWidget {
  final List<Widget> kids;
  final Color color;
  final MainAxisAlignment main;
  const Stub(this.kids, {super.key, required this.color, this.main = MainAxisAlignment.spaceBetween});
  @override
  Widget build(BuildContext context) => CustomPaint(
      painter: _DashV(color),
      child: Container(
          constraints: const BoxConstraints(minWidth: 66),
          padding: const EdgeInsets.only(left: 15),
          child: Column(
              mainAxisAlignment: main, crossAxisAlignment: CrossAxisAlignment.center, children: kids)));
}

class _DashV extends CustomPainter {
  final Color c;
  _DashV(this.c);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = c
      ..strokeWidth = 3;
    for (double y = 0; y < s.height; y += 9) {
      canvas.drawLine(Offset(1.5, y), Offset(1.5, math.min(y + 6, s.height)), p);
    }
  }

  @override
  bool shouldRepaint(covariant _DashV o) => o.c != c;
}

/// `.rn` small pill
Widget rn(String t, bool pn) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: pn ? kC : kK, borderRadius: BorderRadius.circular(14)),
    child: Text(t, style: tx(12, mono: true, color: pn ? kR : kC)));

/// CSS mask-image fade (top / bottom px)
Widget fadeV(Widget child, {double top = 0, double bottom = 0}) => ShaderMask(
    blendMode: BlendMode.dstIn,
    shaderCallback: (r) {
      final h = r.height <= 0 ? 1.0 : r.height;
      return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0x00000000), Color(0xFF000000), Color(0xFF000000), Color(0x00000000)],
          stops: [0, (top / h).clamp(0.0, 1.0), (1 - bottom / h).clamp(0.0, 1.0), 1]).createShader(r);
    },
    child: child);

Widget fadeH(Widget child, {double right = 28}) => ShaderMask(
    blendMode: BlendMode.dstIn,
    shaderCallback: (r) {
      final w = r.width <= 0 ? 1.0 : r.width;
      return LinearGradient(
          colors: const [Color(0xFF000000), Color(0xFF000000), Color(0x00000000)],
          stops: [0, (1 - right / w).clamp(0.0, 1.0), 1]).createShader(r);
    },
    child: child);

class NoGlow extends ScrollBehavior {
  const NoGlow();
  @override
  Widget buildOverscrollIndicator(BuildContext c, Widget child, ScrollableDetails d) => child;
}

// ───────────────────────── tab bar ─────────────────────────
class Tbar extends StatelessWidget {
  final List<String> labels;
  final int idx;
  final ValueChanged<int> onTap;
  const Tbar(this.labels, this.idx, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Container(
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(color: kK, borderRadius: BorderRadius.circular(40), boxShadow: [hard(kR, 5)]),
      child: LayoutBuilder(builder: (ctx, bc) {
        final seg = bc.maxWidth / labels.length;
        return Stack(children: [
          AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: const Cubic(.2, 1.3, .4, 1),
              left: idx * seg,
              top: 0,
              bottom: 0,
              width: seg,
              child: Container(
                  decoration: BoxDecoration(color: kC, borderRadius: BorderRadius.circular(32)))),
          Row(children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(i),
                      child: Center(
                          child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: tx(17, ls: 0, color: i == idx ? kK : kC),
                              child: Text(labels[i]))))),
          ])
        ]);
      }));
}

// ───────────────────────── toast ─────────────────────────
final ValueNotifier<bool> _toastOn = ValueNotifier(false);
final ValueNotifier<String> _toastTxt = ValueNotifier('');
Timer? _tt;
void toast(String t) {
  _toastTxt.value = t;
  _toastOn.value = true;
  _tt?.cancel();
  _tt = Timer(const Duration(milliseconds: 1800), () => _toastOn.value = false);
}

class ToastHost extends StatelessWidget {
  const ToastHost({super.key});
  @override
  Widget build(BuildContext context) => Positioned(
      left: 0,
      right: 0,
      bottom: 26 + MediaQuery.of(context).padding.bottom,
      child: IgnorePointer(
          child: ValueListenableBuilder<bool>(
              valueListenable: _toastOn,
              builder: (c, on, _) => AnimatedSlide(
                  duration: const Duration(milliseconds: 350),
                  curve: const Cubic(.2, 1.4, .4, 1),
                  offset: Offset(0, on ? 0 : 1),
                  child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 350),
                      opacity: on ? 1 : 0,
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration:
                                  BoxDecoration(color: kK, borderRadius: BorderRadius.circular(24)),
                              child: ValueListenableBuilder<String>(
                                  valueListenable: _toastTxt,
                                  builder: (c, t, _) =>
                                      Text(t, style: tx(14, mono: true, color: kC))))))))));
}

// ───────────────────────── confetti ─────────────────────────
class _P {
  final Offset o;
  final double dx, dy, rot;
  final Color c;
  final double t0;
  _P(this.o, this.dx, this.dy, this.rot, this.c, this.t0);
}

final GlobalKey<_ConfettiState> _cfKey = GlobalKey<_ConfettiState>();
final math.Random _rnd = math.Random();

/// Fire confetti from the centre of [k]'s widget (the HTML `boom(...at(el))`).
void boomAt(GlobalKey k, [int n = 26]) {
  final b = k.currentContext?.findRenderObject();
  if (b is! RenderBox || !b.attached) return;
  _cfKey.currentState?.add(b.localToGlobal(b.size.center(Offset.zero)), n);
}

class ConfettiLayer extends StatefulWidget {
  ConfettiLayer() : super(key: _cfKey);
  @override
  State<ConfettiLayer> createState() => _ConfettiState();
}

class _ConfettiState extends State<ConfettiLayer> with SingleTickerProviderStateMixin {
  final List<_P> ps = [];
  late final Ticker tk;
  double now = 0;
  @override
  void initState() {
    super.initState();
    tk = createTicker((d) {
      now = d.inMicroseconds / 1e6;
      ps.removeWhere((p) => now - p.t0 > 1.2);
      if (ps.isEmpty) tk.stop();
      if (mounted) setState(() {});
    });
  }

  void add(Offset o, int n) {
    // A restarted Ticker reports elapsed from zero, so reset the clock when idle.
    if (!tk.isActive) {
      now = 0;
      ps.clear();
      tk.start();
    }
    for (var i = 0; i < n; i++) {
      final a = _rnd.nextDouble() * 6.28, r = 50 + _rnd.nextDouble() * 120;
      ps.add(_P(o, math.cos(a) * r, math.sin(a) * r + 50, _rnd.nextDouble() * 720,
          const [kR, kK, kD][i % 3], now));
    }
    setState(() {});
  }

  @override
  void dispose() {
    tk.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
      child: CustomPaint(size: Size.infinite, painter: _CfPainter(List.of(ps), now)));
}

class _CfPainter extends CustomPainter {
  final List<_P> ps;
  final double now;
  _CfPainter(this.ps, this.now);
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in ps) {
      final e = ((now - p.t0) / 1.2).clamp(0.0, 1.0);
      final k = Curves.easeOut.transform(e);
      canvas.save();
      canvas.translate(p.o.dx + p.dx * k, p.o.dy + p.dy * k);
      canvas.rotate(p.rot * k * math.pi / 180);
      canvas.drawRRect(
          RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 10, 14), const Radius.circular(2)),
          Paint()..color = p.c.withAlpha(((1 - k) * 255).round()));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CfPainter o) => true;
}

void haptic([bool strong = false]) {
  try {
    strong ? HapticFeedback.mediumImpact() : HapticFeedback.selectionClick();
  } catch (_) {}
}

// ───────────────────────── bottom sheets ─────────────────────────
void closeSheet() => navKey.currentState?.pop();

/// Slides a sheet up over everything (the HTML `.ov` + `.sh`).
/// [top] reproduces `.sh.tall{top:..}`: the sheet may grow up to that line.
Future<void> showSheet(Widget Function(BuildContext) b, {double? top}) {
  return showGeneralDialog<void>(
      context: navKey.currentContext!,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: rgba(129, 0, 0, .4),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (c, a, s) {
        final m = MediaQuery.of(c);
        return Material(
            type: MaterialType.transparency,
            child: DefaultTextStyle(
                style: tx(16, color: kK),
                child: AnimatedPadding(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.fromLTRB(
                        10, top ?? 0, 10, 12 + math.max(m.viewInsets.bottom, m.padding.bottom)),
                    child: Align(alignment: Alignment.bottomCenter, child: b(c)))));
      },
      transitionBuilder: (c, a, s, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1.25), end: Offset.zero).animate(
              CurvedAnimation(
                  parent: a, curve: const Cubic(.2, 1.1, .3, 1), reverseCurve: Curves.easeIn)),
          child: child));
}

/// `.pn2` panel with the drag grip (`.gr`). Drag down > 80px to dismiss.
class Pn2 extends StatefulWidget {
  final List<Widget> kids;
  const Pn2(this.kids, {super.key});
  @override
  State<Pn2> createState() => _Pn2State();
}

class _Pn2State extends State<Pn2> {
  double dy = 0;
  bool drag = false;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
      duration: Duration(milliseconds: drag ? 0 : 300),
      width: double.infinity,
      transform: Matrix4.translationValues(0, dy, 0),
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 22),
      decoration: BoxDecoration(
          color: kC,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: kK, width: 3),
          boxShadow: [hard(kK, 5)]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragStart: (_) => setState(() => drag = true),
            onVerticalDragUpdate: (d) => setState(() => dy = math.max(0, dy + d.delta.dy)),
            onVerticalDragEnd: (_) {
              final close = dy > 80;
              setState(() {
                drag = false;
                dy = 0;
              });
              if (close) closeSheet();
            },
            child: SizedBox(
                width: double.infinity,
                height: 30,
                child: Center(
                    child: Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                            color: kK.withAlpha(89), borderRadius: BorderRadius.circular(3)))))),
        ...widget.kids,
      ]));
}

/// `.st2` sheet title
Widget st2(String t, {double mb = 14}) =>
    Padding(padding: EdgeInsets.only(bottom: mb), child: Center(child: Text(t, style: tx(28))));

/// Confirm sheet (`conf` in the HTML). [fn] runs 260ms after closing.
void conf(String t, String m, String b, VoidCallback fn) {
  showSheet((c) => Pn2([
        st2(t),
        Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(m, textAlign: TextAlign.center, style: tx(13, mono: true))),
        Btn(b, onTap: () {
          closeSheet();
          Timer(const Duration(milliseconds: 260), fn);
        }),
        const SizedBox(height: 12),
        const LinkBtn('Cancel', onTap: closeSheet),
      ]));
}

/// Lets a strip bleed [extra] px past its padded parent (CSS negative margin).
class Bleed extends StatelessWidget {
  final double extra, height;
  final Widget child;
  const Bleed({super.key, this.extra = 22, required this.height, required this.child});
  @override
  Widget build(BuildContext context) => SizedBox(
      height: height,
      child: LayoutBuilder(
          builder: (c, bc) => OverflowBox(
              minWidth: bc.maxWidth + 2 * extra,
              maxWidth: bc.maxWidth + 2 * extra,
              minHeight: height,
              maxHeight: height,
              child: child)));
}

/// Dashed rounded border (CSS `border: 3px dashed`).
class DashedBox extends StatelessWidget {
  final Color color;
  final double radius, width;
  final Widget child;
  final bool circle;
  const DashedBox(
      {super.key,
      required this.color,
      this.radius = 28,
      this.width = 3,
      this.circle = false,
      required this.child});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(foregroundPainter: _DashRR(color, radius, width, circle), child: child);
}

class _DashRR extends CustomPainter {
  final Color c;
  final double r, w;
  final bool circle;
  _DashRR(this.c, this.r, this.w, this.circle);
  @override
  void paint(Canvas canvas, Size s) {
    final rect = Rect.fromLTWH(w / 2, w / 2, s.width - w, s.height - w);
    final path = Path()
      ..addRRect(circle
          ? RRect.fromRectAndRadius(rect, Radius.circular(rect.shortestSide / 2))
          : RRect.fromRectAndRadius(rect, Radius.circular(r - w / 2)));
    final p = Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w;
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, math.min(d + 8, m.length)), p);
        d += 13;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashRR o) => o.c != c;
}
