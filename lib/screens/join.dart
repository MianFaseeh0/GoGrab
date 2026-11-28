import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import '../core/anim.dart';
import '../core/state.dart';
import '../core/svg.dart';
import '../core/svg_data.dart' hide kK, kR, kC, kG;
import '../core/theme.dart';
import '../core/ui.dart';
import 'auth.dart' show ScCol;

const _stageIcons = ['pill', 'bread', 'basket', 'pencil', 'card'];

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});
  @override
  State<JoinScreen> createState() => _JoinState();
}

class _JoinState extends State<JoinScreen> {
  final TextEditingController ctl = TextEditingController();
  final FocusNode fn = FocusNode();
  final GlobalKey<ShakeState> shk = GlobalKey<ShakeState>();
  final GlobalKey badgeKey = GlobalKey(), meKey = GlobalKey();
  final ScrollController fsc = ScrollController();
  final List<Timer> tm = [];
  final math.Random rnd = math.Random();

  String v = '';
  bool jt = false, bad = false, showRes = false, joined = false, joining = false;
  JoinCrew? J;
  String msg = 'Type the 4-digit code';
  bool stageOn = false;
  List<int> pos = [0, 1, 2, 3, 4];
  List<bool> shown = List.filled(5, false), gone = List.filled(5, false);
  List<int> hop = List.filled(5, 0);

  @override
  void initState() {
    super.initState();
    fn.addListener(() {
      if (mounted) setState(() {});
    });
    _t(600, () => fn.requestFocus());
  }

  @override
  void dispose() {
    for (final t in tm) {
      t.cancel();
    }
    ctl.dispose();
    fn.dispose();
    fsc.dispose();
    super.dispose();
  }

  void _t(int ms, VoidCallback f) => tm.add(Timer(Duration(milliseconds: ms), () {
        if (mounted) f();
      }));

  void _clear() {
    for (final t in tm) {
      t.cancel();
    }
    tm.clear();
    setState(() {
      jt = false;
      J = null;
      bad = false;
      showRes = false;
      joined = false;
      stageOn = false;
      msg = 'Type the 4-digit code';
      pos = [0, 1, 2, 3, 4];
      shown = List.filled(5, false);
      gone = List.filled(5, false);
      hop = List.filled(5, 0);
    });
  }

  void _onChanged(String raw) {
    final d = raw.replaceAll(RegExp(r'\D'), '');
    final nv = d.length > 4 ? d.substring(0, 4) : d;
    setState(() => v = nv);
    if (jt && nv.length < 4) _clear();
    if (nv.length == 4 && !jt) _find(nv);
  }

  void _find(String code) {
    setState(() => jt = true);
    fn.unfocus();
    if (code == '0000') {
      setState(() => bad = true);
      shk.currentState?.go();
      toast('No crew with that code');
      _t(700, () {
        _clear();
        ctl.clear();
        setState(() => v = '');
      });
      return;
    }
    J = JC[int.parse(code) % JC.length];
    setState(() {
      stageOn = true;
      msg = 'Finding your crew…';
    });
    for (var i = 0; i < 5; i++) {
      _t(i * 70, () => setState(() => shown[i] = true));
    }
    for (var k = 0; k < 7; k++) {
      _t(520 + k * 250, () {
        final a = rnd.nextInt(5), c = (a + 1 + rnd.nextInt(4)) % 5;
        setState(() {
          final tmp = pos[a];
          pos[a] = pos[c];
          pos[c] = tmp;
          hop[a]++;
          hop[c]++;
        });
      });
    }
    _t(2380, () {
      for (var i = 0; i < 5; i++) {
        _t(i * 50, () => setState(() => gone[i] = true));
      }
    });
    _t(2850, () {
      setState(() {
        stageOn = false;
        msg = '';
        showRes = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => boomAt(badgeKey, 14));
    });
  }

  void _join() {
    final j = J;
    if (j == null || !showRes || joining) return;
    setState(() {
      joining = true;
      joined = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (fsc.hasClients) {
        fsc.animateTo(fsc.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
      boomAt(meKey, 18);
    });
    toast('Welcome to ${j.n}');
    _t(1500, () {
      for (final c in crews) {
        c.nw = 0;
      }
      crews.add(Crew(DateTime.now().millisecondsSinceEpoch, j.n, j.b,
          [-1, ...j.m.map((x) => (x[0] as int) % F.length)], 0, 0, 1)
        ..adm = 1
        ..code = 'GG-$v'
        ..names = [S.name, ...j.m.map((x) => x[1] as String)]);
      S.home = true;
      S.tab = 0;
      go('home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScCol([
      upA(0, Bk(onTap: () => go(S.home ? 'home' : 'hub'))),
      const SizedBox(height: 14),
      upA(1, Text('Join a\ncrew.', style: tx(vw(context, 40, 13, 54), h: .94))),
      const SizedBox(height: 22),
      upA(2, _codeBox()),
      const SizedBox(height: 22),
      upA(3, _zone()),
      const Spacer(),
      upA(4, Btn('Join crew', dis: J == null || !showRes || joining, onTap: _join)),
    ]);
  }

  // ── code box ──
  Widget _codeBox() {
    final ok = jt && !bad;
    final fg = ok ? kC : kK;
    final focused = fn.hasFocus;
    final inner = AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.fromLTRB(10, 24, 10, 18),
        decoration: BoxDecoration(
            color: ok ? kR : kC,
            borderRadius: BorderRadius.circular(28),
            border: ok ? Border.all(color: kK, width: 3) : null,
            boxShadow: [hard(ok ? kK : (focused ? kR : kK), 5)]),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Opacity(opacity: .55, child: Text('GG-', style: tx(30, color: fg))),
          const SizedBox(width: 12),
          for (var i = 0; i < 4; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _digit(i, fg),
          ]
        ]));
    return Shake(
        key: shk,
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => fn.requestFocus(),
            child: Stack(children: [
              ok ? inner : DashedBox(color: focused ? kR : kK, radius: 28, child: inner),
              Positioned.fill(
                  child: Opacity(
                      opacity: 0,
                      child: TextField(
                          controller: ctl,
                          focusNode: fn,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4)
                          ],
                          enableInteractiveSelection: false,
                          showCursor: false,
                          autocorrect: false,
                          onChanged: _onChanged))),
            ])));
  }

  Widget _digit(int i, Color fg) {
    final cur = i == v.length && !jt;
    final has = i < v.length;
    Widget content = const SizedBox.shrink();
    if (has) {
      content = bumpA(Text(v[i], style: tx(46, color: fg, h: 1)), ms: 300, key: ValueKey('d$i${v[i]}'));
    } else if (cur) {
      content = Anim(
          loop: true,
          ms: 1000,
          fx: (t, ch) => Opacity(opacity: t < .5 ? 1 : 0, child: ch),
          child: Container(width: 3, height: 38, color: kR));
    }
    return Container(
        width: 46,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: fg, width: 4))),
        child: content);
  }

  // ── stage + result ──
  Widget _zone() => ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 215),
      child: Stack(clipBehavior: Clip.none, children: [
        if (msg.isNotEmpty)
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Opacity(
                  opacity: .7,
                  child: Text(msg, textAlign: TextAlign.center, style: tx(14, mono: true)))),
        if (stageOn) Positioned.fill(child: _stage()),
        if (showRes && J != null) _result(J!),
      ]));

  Widget _stage() => LayoutBuilder(builder: (c, bc) {
        final cx = bc.maxWidth / 2;
        return Stack(clipBehavior: Clip.none, children: [
          for (var i = 0; i < 5; i++)
            AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: const Cubic(.3, 1.6, .5, 1),
                left: cx + (pos[i] - 2) * 64 - 29,
                top: 44,
                child: AnimatedScale(
                    duration: const Duration(milliseconds: 400),
                    curve: const Cubic(.3, 1.6, .5, 1),
                    scale: (shown[i] && !gone[i]) ? 1 : 0,
                    child: _hop(
                        i,
                        Container(
                            width: 58,
                            height: 58,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: kC,
                                shape: BoxShape.circle,
                                border: Border.all(color: kK, width: 3),
                                boxShadow: [hard(kK, 4)]),
                            child: ic(_stageIcons[i], 28, kR, 2.4))))),
        ]);
      });

  Widget _hop(int i, Widget child) => hop[i] == 0
      ? child
      : Anim(
          key: ValueKey('hp$i-${hop[i]}'),
          ms: 400,
          fx: (t, ch) => Transform.translate(
              offset: Offset(0, -26 * math.sin(math.pi * t)),
              child: Transform.rotate(angle: 10 * math.pi / 180 * math.sin(math.pi * t), child: ch)),
          child: child);

  Widget _result(JoinCrew c) {
    final people = <Widget>[
      for (var i = 0; i < c.m.length; i++)
        SizedBox(
            width: 68,
            child: popA(
                delay: 250 + i * 120,
                ms: 550,
                curve: const Cubic(.2, 1.6, .4, 1),
                Column(children: [
                  face((c.m[i][0] as int) % F.length, 64),
                  const SizedBox(height: 4),
                  Text(c.m[i][1] as String, style: tx(14), maxLines: 1, overflow: TextOverflow.clip),
                ]))),
      if (joined)
        SizedBox(
            width: 68,
            child: popA(
                ms: 550,
                curve: const Cubic(.2, 1.6, .4, 1),
                Column(children: [
                  Container(
                      key: meKey,
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(color: kR, spreadRadius: 7),
                        BoxShadow(color: kC, spreadRadius: 4),
                      ]),
                      child: face(S.face, 64)),
                  const SizedBox(height: 6),
                  Text('You', style: tx(14)),
                ]))),
    ];
    return Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          upD(
              Row(children: [
                Container(
                    key: badgeKey,
                    width: 58,
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: kR,
                        shape: BoxShape.circle,
                        border: Border.all(color: kK, width: 3),
                        boxShadow: [hard(kK, 4)]),
                    child: ic(c.b, 30, kC, 2.4)),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.n, style: tx(28, h: 1.05), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('ADMIN ${c.a.toUpperCase()} · ${c.m.length} MEMBERS', style: tx(13, mono: true)),
                ])),
              ]),
              ms: 500),
          const SizedBox(height: 12),
          Bleed(
              extra: 22,
              height: 108,
              child: fadeH(SingleChildScrollView(
                  controller: fsc,
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    for (var i = 0; i < people.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      people[i]
                    ]
                  ])))),
        ]));
  }
}