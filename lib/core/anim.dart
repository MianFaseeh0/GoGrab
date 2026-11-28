import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

double _o(double t) => t < 0 ? 0 : (t > 1 ? 1 : t);

/// Generic CSS-keyframe-like animation: waits [delay] ms (staying at t=0, like
/// `animation-fill-mode: both`), runs [ms], then holds the end state.
class Anim extends StatefulWidget {
  final Widget child;
  final int delay, ms;
  final Curve curve;
  final bool loop, reverse;
  final Widget Function(double t, Widget child) fx;
  const Anim(
      {super.key,
      required this.child,
      required this.fx,
      this.delay = 0,
      this.ms = 500,
      this.curve = Curves.linear,
      this.loop = false,
      this.reverse = false});
  @override
  State<Anim> createState() => _AnimState();
}

class _AnimState extends State<Anim> with SingleTickerProviderStateMixin {
  late final AnimationController c =
      AnimationController(vsync: this, duration: Duration(milliseconds: widget.ms));
  Timer? t;
  @override
  void initState() {
    super.initState();
    void go() {
      if (!mounted) return;
      if (widget.loop) {
        c.repeat(reverse: widget.reverse);
      } else {
        c.forward();
      }
    }

    if (widget.delay <= 0) {
      go();
    } else {
      t = Timer(Duration(milliseconds: widget.delay), go);
    }
  }

  @override
  void dispose() {
    t?.cancel();
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: c,
      child: widget.child,
      builder: (ctx, ch) => widget.fx(widget.curve.transform(c.value), ch!));
}

const _bounce = Cubic(.2, 1.3, .4, 1);

/// `.sc.show .a` : fade + rise 26px, staggered by --i.
Widget upA(int i, Widget c) => Anim(
    delay: i * 80 + 100,
    ms: 550,
    curve: _bounce,
    fx: (t, ch) => Opacity(
        opacity: _o(t), child: Transform.translate(offset: Offset(0, 26 * (1 - t)), child: ch)),
    child: c);

/// `@keyframes up` with custom delay / duration (used by join result).
Widget upD(Widget c, {int delay = 0, int ms = 500}) => Anim(
    delay: delay,
    ms: ms,
    curve: _bounce,
    fx: (t, ch) => Opacity(
        opacity: _o(t), child: Transform.translate(offset: Offset(0, 26 * (1 - t)), child: ch)),
    child: c);

/// `@keyframes pop`: scale 0 -> 1 with a -16deg twist.
Widget popA(Widget c,
        {int delay = 0, int ms = 500, Curve curve = const Cubic(.2, 1.5, .4, 1), Key? key}) =>
    Anim(
        key: key,
        delay: delay,
        ms: ms,
        curve: curve,
        fx: (t, ch) => Opacity(
            opacity: _o(t),
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(t)
                  ..rotateZ(-16 * math.pi / 180 * (1 - t)),
                child: ch)),
        child: c);

/// `@keyframes rise2`
Widget rise(Widget c, {int delay = 0, int ms = 500}) => Anim(
    delay: delay,
    ms: ms,
    curve: Curves.ease,
    fx: (t, ch) => Opacity(
        opacity: _o(t), child: Transform.translate(offset: Offset(0, 12 * (1 - t)), child: ch)),
    child: c);

/// `@keyframes bump`: scale 1 -> k at 40% -> 1.
Widget bumpA(Widget c, {int ms = 300, double k = 1.3, Key? key, int delay = 0}) => Anim(
    key: key,
    delay: delay,
    ms: ms,
    fx: (t, ch) {
      final s = t < .4
          ? 1 + (k - 1) * Curves.ease.transform(t / .4)
          : k - (k - 1) * Curves.ease.transform((t - .4) / .6);
      return Transform.scale(scale: s, child: ch);
    },
    child: c);

/// `@keyframes wob`: rotate 14deg + scale 1.06 and back, forever.
Widget wobA(Widget c, {int delay = 0}) => Anim(
    delay: delay,
    ms: 1500,
    loop: true,
    reverse: true,
    curve: Curves.ease,
    fx: (t, ch) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateZ(14 * math.pi / 180 * t)
          ..scale(1 + .06 * t),
        child: ch),
    child: c);

/// `@keyframes bob`: float up 5px, tilt .8deg, forever.
Widget bobA(Widget c, {int delay = 0}) => Anim(
    delay: delay,
    ms: 2000,
    loop: true,
    reverse: true,
    curve: Curves.easeInOut,
    fx: (t, ch) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(0.0, -5.0 * t)
          ..rotateZ(.8 * math.pi / 180 * t),
        child: ch),
    child: c);

/// Horizontal shake (`@keyframes shake`).
class Shake extends StatefulWidget {
  final Widget child;
  const Shake({super.key, required this.child});
  @override
  State<Shake> createState() => ShakeState();
}

class ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  void go() => c.forward(from: 0);
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: c,
      child: widget.child,
      builder: (ctx, ch) {
        final t = c.value;
        double dx = 0;
        if (t > 0 && t < 1) {
          if (t < .2) {
            dx = -7 * (t / .2);
          } else if (t < .4) {
            dx = -7 + 14 * ((t - .2) / .2);
          } else if (t < .6) {
            dx = 7 - 11 * ((t - .4) / .2);
          } else if (t < .8) {
            dx = -4 + 8 * ((t - .6) / .2);
          } else {
            dx = 4 - 4 * ((t - .8) / .2);
          }
        }
        return Transform.translate(offset: Offset(dx, 0), child: ch);
      });
}
