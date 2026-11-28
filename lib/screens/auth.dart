import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../core/anim.dart';
import '../core/state.dart';
import '../core/svg.dart';
import '../core/svg_data.dart' hide kK, kR, kC, kG;
import '../core/theme.dart';
import '../core/ui.dart';

/// Scrollable column that still lets a Spacer push the last item to the bottom
/// (`.sw{margin-top:auto}`), and survives the keyboard.
class ScCol extends StatelessWidget {
  final List<Widget> kids;
  const ScCol(this.kids, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
      padding: scPad(context),
      child: LayoutBuilder(
          builder: (c, bc) => SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: bc.maxHeight),
                  child: IntrinsicHeight(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: kids))))));
}

// ═════════════════════════ LOGIN ═════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  bool su = false;
  final nme = TextEditingController(text: 'Faseeh');
  final em = TextEditingController(text: 'name@email.com');
  final pw = TextEditingController(text: 'password');
  @override
  void dispose() {
    nme.dispose();
    em.dispose();
    pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = scPad(context).top;
    return Stack(children: [
      ScCol([
        const SizedBox(height: 36),
        upA(0, Text(su ? 'Join the\ncrew.' : 'Welcome\nback.', style: tx(h2Size(context), h: .94))),
        const SizedBox(height: 46),
        if (su) ...[
          upA(2, _field('NAME', InField(c: nme))),
          const SizedBox(height: 16),
        ],
        upA(3, _field('EMAIL', InField(c: em, kt: TextInputType.emailAddress))),
        const SizedBox(height: 16),
        upA(4, _field('PASSWORD', InField(c: pw, obscure: true))),
        upA(
            5,
            Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Center(
                    child: LinkBtn(su ? 'Have an account? Log in' : 'New here? Sign up',
                        onTap: () => setState(() => su = !su))))),
        const Spacer(),
        upA(
            6,
            Btn(su ? 'Create account' : 'Log in', v: 'k', onTap: () {
              if (su && nme.text.trim().isNotEmpty) S.name = nme.text.trim();
              go('face');
            })),
      ]),
      Positioned(
          right: 22,
          top: top + 26,
          child: upA(
              1,
              Container(
                  width: 78,
                  height: 78,
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: kR, shape: BoxShape.circle, boxShadow: [hard(kK, 5)]),
                  child: ic('pill', 40, kC, 2.4)))),
    ]);
  }

  Widget _field(String l, Widget f) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [fl(l), f]);
}

// ═════════════════════════ FACE ═════════════════════════
class FaceScreen extends StatefulWidget {
  const FaceScreen({super.key});
  @override
  State<FaceScreen> createState() => _FaceState();
}

class _FaceState extends State<FaceScreen> {
  int bump = 0;
  late final List<int> order; // faces in section order
  @override
  void initState() {
    super.initState();
    order = [
      for (var si = 0; si < SEC.length; si++)
        for (var i = 0; i < F.length; i++)
          if (F[i][1] == si) i
    ];
  }

  @override
  Widget build(BuildContext context) {
    final slivers = <Widget>[];
    for (var si = 0; si < SEC.length; si++) {
      final ids = [for (var i = 0; i < F.length; i++) if (F[i][1] == si) i];
      slivers.add(SliverPersistentHeader(pinned: true, delegate: _GH(SEC[si].toUpperCase())));
      slivers.add(SliverPadding(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 14),
          sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1 / 1.08),
              delegate: SliverChildBuilderDelegate((c, k) {
                final i = ids[k];
                final n = order.indexOf(i).clamp(0, 14);
                return _Cell(
                    i: i,
                    n: n,
                    sel: i == S.face,
                    onTap: () => setState(() {
                          S.face = i;
                          bump++;
                        }));
              }, childCount: ids.length))));
    }
    return Padding(
        padding: scPad(context),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (S.ret) ...[
            upA(
                0,
                Bk(onTap: () {
                  S.ret = false;
                  go('home');
                })),
            const SizedBox(height: 8),
          ],
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              upA(0, Text('Pick your\nface.', style: tx(h2Size(context), h: .94))),
              upA(
                  1,
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('39 faces · scroll for more', style: tx(13, mono: true)))),
            ])),
            const SizedBox(width: 8),
            SizedBox(
                width: 96,
                child: upA(
                    1,
                    bumpA(
                        Column(children: [
                          face(S.face, 78),
                          const SizedBox(height: 2),
                          Text(F[S.face][0] as String, style: tx(13, mono: true))
                        ]),
                        ms: 500,
                        key: ValueKey('pv$bump')))),
          ]),
          const SizedBox(height: 20),
          Expanded(
              child: upA(
                  2,
                  Stack(clipBehavior: Clip.none, children: [
                    Positioned(
                        left: -6,
                        right: -6,
                        top: 0,
                        bottom: 0,
                        child: fadeV(
                            ScrollConfiguration(
                                behavior: const NoGlow(),
                                child: CustomScrollView(slivers: slivers)),
                            top: 14,
                            bottom: 22))
                  ]))),
          const SizedBox(height: 12),
          upA(
              3,
              Btn('This is me', v: 'k', onTap: () {
                if (S.ret) {
                  S.ret = false;
                  S.tab = 2;
                  go('home');
                  Timer(const Duration(milliseconds: 500), () => toast('Face updated'));
                } else {
                  go('hub');
                }
              })),
        ]));
  }
}

class _GH extends SliverPersistentHeaderDelegate {
  final String t;
  _GH(this.t);
  @override
  double get minExtent => 34;
  @override
  double get maxExtent => 34;
  @override
  Widget build(BuildContext c, double shrink, bool overlaps) => Container(
      color: kC,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
      child: Text(t, style: tx(12, mono: true)));
  @override
  bool shouldRebuild(covariant _GH o) => o.t != t;
}

class _Cell extends StatelessWidget {
  final int i, n;
  final bool sel;
  final VoidCallback onTap;
  const _Cell({required this.i, required this.n, required this.sel, required this.onTap});
  @override
  Widget build(BuildContext context) => popA(
      delay: n * 30,
      ms: 450,
      Press(
          onTap: onTap,
          b: (d) => AnimatedScale(
              duration: const Duration(milliseconds: 200),
              curve: const Cubic(.2, 1.6, .4, 1),
              scale: d ? .94 : (sel ? 1.05 : 1),
              child: Stack(clipBehavior: Clip.none, children: [
                Positioned.fill(
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                            color: sel ? kR : kC,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: kK, width: 3),
                            boxShadow: [hard(kK, sel ? 5 : 4)]),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          face(i, 58),
                          const SizedBox(height: 2),
                          Text(F[i][0] as String, style: tx(13, ls: 0, color: sel ? kC : kK)),
                        ]))),
                if (sel)
                  Positioned(
                      top: -9,
                      right: -9,
                      child: popA(
                          ms: 350,
                          Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: kK, shape: BoxShape.circle),
                              child: ic('check', 16, kC, 3.5)))),
              ]))));
}

// ═════════════════════════ HUB ═════════════════════════
class HubScreen extends StatelessWidget {
  const HubScreen({super.key});
  @override
  Widget build(BuildContext context) => Padding(
      padding: scPad(context),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        upA(
            0,
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('HEY ${S.name.toUpperCase()}', style: tx(14, mono: true))),
                  face(S.face, 50),
                ])),
        const SizedBox(height: 8),
        upA(1, Text('Start a\ncrew.', style: tx(h2Size(context), h: .94))),
        const SizedBox(height: 34),
        upA(
            2,
            _Opt(
                red: true,
                icon: 'bolt',
                ico: kR,
                bg: kC,
                t: 'Create a crew',
                s: 'Name it, pick a badge, invite friends.',
                onTap: () => go('name'))),
        const SizedBox(height: 22),
        upA(
            3,
            _Opt(
                red: false,
                icon: 'code',
                ico: kC,
                bg: kR,
                t: 'Join a crew',
                s: 'Got a code? Hop right in.',
                onTap: () => go('jn'))),
      ]));
}

class _Opt extends StatelessWidget {
  final bool red;
  final String icon, t, s;
  final Color ico, bg;
  final VoidCallback onTap;
  const _Opt(
      {required this.red,
      required this.icon,
      required this.ico,
      required this.bg,
      required this.t,
      required this.s,
      required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: red ? kR : null,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: kK, width: 3),
              boxShadow: [hard(kK, 6)]),
          child: DefaultTextStyle.merge(
              style: TextStyle(color: red ? kC : kK),
              child: Row(children: [
                Container(
                    width: 68,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                    child: ic(icon, 34, ico, 2.4)),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t, style: tx(28, h: 1)),
                  const SizedBox(height: 6),
                  Text(s, style: tx(13, mono: true)),
                ])),
              ]))));
}

// ═════════════════════════ NAME CREW ═════════════════════════
final TextEditingController cnCtl = TextEditingController();

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});
  @override
  State<NameScreen> createState() => _NameState();
}

class _NameState extends State<NameScreen> {
  final GlobalKey<InFieldState> fk = GlobalKey<InFieldState>();
  @override
  Widget build(BuildContext context) {
    return ScCol([
      upA(0, Bk(onTap: () => go(S.home ? 'home' : 'hub'))),
      const SizedBox(height: 14),
      upA(1, Text('Name your\ncrew.', style: tx(h2Size(context), h: .94))),
      const SizedBox(height: 28),
      upA(
          2,
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            fl('CREW NAME'),
            InField(key: fk, c: cnCtl, hint: 'The Boys', maxLen: 18),
          ])),
      const SizedBox(height: 26),
      upA(
          3,
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Pick a badge', style: tx(22)),
            const SizedBox(height: 8),
            for (var r = 0; r < 2; r++) ...[
              if (r > 0) const SizedBox(height: 12),
              Row(children: [
                for (var k = 0; k < 4; k++) ...[
                  if (k > 0) const SizedBox(width: 12),
                  Expanded(
                      child: _Badge(
                          b: BADGES[r * 4 + k],
                          n: r * 4 + k,
                          onTap: () {
                            setState(() => S.badge = BADGES[r * 4 + k]);
                            haptic();
                          })),
                ]
              ])
            ]
          ])),
      const Spacer(),
      upA(
          4,
          Btn('Create crew', onTap: () {
            final v = cnCtl.text.trim();
            if (v.isEmpty) {
              fk.currentState?.shake();
              return;
            }
            S.crew = v;
            go('inv');
          })),
    ]);
  }
}

class _Badge extends StatelessWidget {
  final String b;
  final int n;
  final VoidCallback onTap;
  const _Badge({required this.b, required this.n, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final sel = b == S.badge;
    return popA(
        delay: 350 + n * 60,
        ms: 500,
        Press(
            onTap: onTap,
            b: (d) => AspectRatio(
                aspectRatio: 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: const Cubic(.2, 1.8, .4, 1),
                    transformAlignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(d ? .9 : (sel ? 1.12 : 1.0))
                      ..rotateZ(sel ? -6 * 3.14159265 / 180 : 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: sel ? kR : kC,
                        shape: BoxShape.circle,
                        border: Border.all(color: kK, width: 3),
                        boxShadow: [hard(kK, 4)]),
                    child: ic(b, 34, sel ? kC : kK)))));
  }
}

// ═════════════════════════ INVITE ═════════════════════════
class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});
  @override
  State<InviteScreen> createState() => _InviteState();
}

class _InviteState extends State<InviteScreen> {
  final List<Timer> tm = [];
  final GlobalKey tbKey = GlobalKey(), dgKey = GlobalKey();
  final ScrollController sc = ScrollController();
  final Map<Mem, GlobalKey> keys = {};
  final Set<Mem> late_ = {};
  int mcGen = 0;
  bool copied = false;
  int copyGen = 0;
  @override
  void initState() {
    super.initState();
    S.code = 'GG-${1000 + (DateTime.now().microsecondsSinceEpoch % 9000)}';
    members = [Mem(S.face, S.name, true)];
    tm.add(Timer(const Duration(milliseconds: 700), () => boomAt(tbKey)));
    tm.add(Timer(const Duration(milliseconds: 1750), () => boomAt(dgKey, 18)));
    tm.add(Timer(const Duration(milliseconds: 3200), () => _join(1, 'Ahmad')));
    tm.add(Timer(const Duration(milliseconds: 5600), () => _join(2, 'Wasif')));
  }

  @override
  void dispose() {
    for (final t in tm) {
      t.cancel();
    }
    sc.dispose();
    super.dispose();
  }

  void _join(int f, String n) {
    if (!mounted) return;
    final m = Mem(f, n);
    setState(() {
      members.add(m);
      late_.add(m);
      mcGen++;
    });
    toast('$n joined the crew');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (sc.hasClients) {
        sc.animateTo(sc.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
      final k = keys[m];
      if (k != null) boomAt(k, 16);
    });
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: S.code));
    if (!mounted) return;
    setState(() {
      copied = true;
      copyGen++;
    });
    toast('Code ${S.code} copied');
    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => copied = false);
    });
  }

  Future<void> _share() async {
    final t = 'Join my crew “${S.crew}” on GoGrab with code ${S.code}';
    try {
      await Share.share(t, subject: 'GoGrab');
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: S.code));
      toast('Invite copied: ${S.code}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: scPad(context),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          upA(0, Bk(onTap: () => go('name'))),
          const SizedBox(height: 14),
          upA(1, Text('Invite the\ncrew.', style: tx(vw(context, 40, 13, 54), h: .94))),
          const SizedBox(height: 18),
          bobA(delay: 2400, _ticket()),
          const SizedBox(height: 6),
          Bleed(extra: 22, height: 108, child: fadeH(_members())),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(children: [
                Row(children: [
                  Expanded(
                      child: copied
                          ? bumpA(Btn('Copied ✓', v: 'o', onTap: _copy),
                              ms: 500, k: 1.05, key: ValueKey('c$copyGen'))
                          : Btn('Copy', v: 'o', onTap: _copy)),
                  const SizedBox(width: 12),
                  Expanded(child: Btn('Share', v: 'k', onTap: _share)),
                ]),
                const SizedBox(height: 12),
                Btn('Done', onTap: () {
                  addCrew();
                  S.home = true;
                  S.tab = 0;
                  go('home');
                }),
              ])),
        ]));
  }

  Widget _members() => SingleChildScrollView(
      controller: sc,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (var i = 0; i < members.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          _item(members[i], i),
        ],
        const SizedBox(width: 16),
        popA(
            delay: 1500,
            ms: 500,
            curve: const Cubic(.2, 1.6, .4, 1),
            GestureDetector(
                onTap: _share,
                child: DashedBox(
                    color: kK,
                    circle: true,
                    child: SizedBox(
                        width: 64, height: 64, child: Center(child: ic('plus', 28, kK, 3)))))),
      ]));

  Widget _item(Mem m, int i) {
    final key = keys.putIfAbsent(m, () => GlobalKey());
    return SizedBox(
        width: 68,
        child: popA(
            delay: late_.contains(m) ? 0 : 900 + i * 100,
            ms: 550,
            curve: const Cubic(.2, 1.6, .4, 1),
            Column(children: [
              Container(
                  key: key,
                  width: 64,
                  height: 64,
                  decoration: m.me
                      ? const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(color: kR, spreadRadius: 7),
                          BoxShadow(color: kC, spreadRadius: 4),
                        ])
                      : null,
                  child: face(m.f, 64)),
              SizedBox(height: m.me ? 6 : 4),
              Text(m.me ? 'You' : m.n, style: tx(14), maxLines: 1, overflow: TextOverflow.clip),
            ])));
  }

  Widget _ticket() {
    return Anim(
        ms: 800,
        curve: const Cubic(.2, 1.3, .4, 1),
        fx: (t, ch) => Opacity(
            opacity: t.clamp(0.0, 1.0).toDouble(),
            child: Transform.translate(
                offset: Offset(0, -238 * 1.2 * (1 - t)),
                child: Transform.rotate(angle: (-12 + 9.5 * t) * 3.14159265 / 180, child: ch))),
        child: Container(
            height: 238,
            decoration: BoxDecoration(
                color: kR,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: kK, width: 3),
                boxShadow: [hard(kK, 6)]),
            child: DefaultTextStyle.merge(
                style: const TextStyle(color: kC),
                child: Stack(clipBehavior: Clip.none, children: [
                  Positioned(
                      left: 15,
                      top: 15,
                      child: Anim(
                          delay: 500,
                          ms: 800,
                          curve: const Cubic(.2, 1.5, .4, 1),
                          fx: (t, ch) => Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(t)
                                ..rotateZ(-6.2831853 * (1 - t)),
                              child: ch),
                          child: Container(
                              key: tbKey,
                              width: 56,
                              height: 56,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: kC, shape: BoxShape.circle),
                              child: ic(S.badge, 32, kR, 2.4)))),
                  Positioned(
                      left: 85,
                      top: 15,
                      right: 81,
                      child: rise(delay: 750, Text(S.crew, style: tx(27, h: 1)))),
                  Positioned(
                      left: 85,
                      top: 55,
                      child: rise(delay: 850, Text('Admin ${S.name}', style: tx(12, mono: true)))),
                  Positioned(
                      right: 13,
                      top: 17,
                      child: popA(
                          delay: 1300,
                          ms: 500,
                          curve: const Cubic(.2, 1.8, .4, 1),
                          bumpA(
                              Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: kK, borderRadius: BorderRadius.circular(16)),
                                  child: Text(
                                      '${members.length} ${members.length == 1 ? 'member' : 'members'}',
                                      style: tx(12, mono: true, color: kC))),
                              ms: 400,
                              key: ValueKey('mc$mcGen')))),
                  Positioned(left: 15, right: 15, top: 87, child: _codeBox()),
                  Positioned(
                      left: 15,
                      right: 15,
                      top: 193,
                      child: SizedBox(height: 3, child: CustomPaint(painter: _DashH()))),
                  Positioned(
                      left: 15,
                      right: 15,
                      top: 201,
                      height: 22,
                      child: LayoutBuilder(
                          builder: (c, bc) => Anim(
                              delay: 1000,
                              ms: 800,
                              curve: Curves.ease,
                              fx: (t, ch) => ClipRect(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: t.clamp(0.0, 1.0).toDouble(),
                                      child: ch)),
                              child: SizedBox(
                                  width: bc.maxWidth,
                                  height: 22,
                                  child: CustomPaint(painter: _Barcode()))))),
                ]))));
  }

  Widget _codeBox() => popA(
      delay: 900,
      ms: 500,
      curve: const Cubic(.2, 1.4, .4, 1),
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              height: 96,
              color: kK,
              child: LayoutBuilder(
                  builder: (c, bc) => Stack(children: [
                        Positioned.fill(
                            child: Column(children: [
                          const SizedBox(height: 11),
                          Text('POOL CODE', style: tx(11, mono: true, color: kC)),
                          Row(key: dgKey, mainAxisAlignment: MainAxisAlignment.center, children: [
                            for (var i = 0; i < S.code.length; i++) _dpop(S.code[i], i),
                          ]),
                        ])),
                        // The shine sweep. Anim's fx returns a Positioned so it is a direct Stack child.
                        Positioned.fill(
                            child: IgnorePointer(
                                child: Anim(
                                    delay: 1900,
                                    ms: 900,
                                    curve: Curves.ease,
                                    fx: (t, ch) => Stack(children: [
                                          Positioned(
                                              left: -80 + (bc.maxWidth * 1.3 + 80) * t,
                                              top: 0,
                                              bottom: 0,
                                              width: 60,
                                              child: ch)
                                        ]),
                                    child: Transform(
                                        transform: Matrix4.skewX(-20 * 3.14159265 / 180),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [
                                          const Color(0x00EEEBDD),
                                          rgba(238, 235, 221, .35),
                                          const Color(0x00EEEBDD)
                                        ])))))))
                      ])))));

  Widget _dpop(String ch, int n) => Anim(
      delay: 1000 + n * 90,
      ms: 550,
      fx: (t, c) {
        const cu = Cubic(.2, 1.6, .4, 1);
        double sc, rot, ty;
        if (t < .6) {
          final u = cu.transform(t / .6);
          sc = 1.5 * u;
          rot = -30 + 36 * u;
          ty = 10 * (1 - u);
        } else {
          final u = cu.transform((t - .6) / .4);
          sc = 1.5 - .5 * u;
          rot = 6 * (1 - u);
          ty = 0;
        }
        return Opacity(
            opacity: (t / .6).clamp(0.0, 1.0).toDouble(),
            child: Transform.translate(
                offset: Offset(0, ty),
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(sc)
                      ..rotateZ(rot * 3.14159265 / 180),
                    child: c)));
      },
      child: Text(ch, style: tx(46, mono: true, h: 1.05, ls: .03, color: kC)));
}

class _DashH extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = kC
      ..strokeWidth = 3;
    for (double x = 0; x < s.width; x += 9) {
      canvas.drawLine(Offset(x, 1.5), Offset(x + 6 > s.width ? s.width : x + 6, 1.5), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class _Barcode extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = kC;
    for (double x = 0; x < s.width; x += 9) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 3, s.height), p);
      canvas.drawRect(Rect.fromLTWH(x + 5, 0, 1, s.height), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}