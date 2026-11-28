import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import '../core/anim.dart';
import '../core/state.dart';
import '../core/svg.dart';
import '../core/theme.dart';
import '../core/ui.dart';
import 'auth.dart' show cnCtl;
import 'crew.dart' show openCrew;
import 'runform.dart' show openEdit;

/// Lets sheets (rename) refresh the home screen.
VoidCallback? homeRefresh;

/// A pane list that fades at the top/bottom like `.ls2` and leaves room for the tab bar.
Widget paneList(List<Widget> kids, {double gap = 16}) => Expanded(
    child: fadeV(
        ScrollConfiguration(
            behavior: const NoGlow(),
            child: ListView(padding: const EdgeInsets.fromLTRB(22, 10, 22, 130), children: [
              for (var i = 0; i < kids.length; i++) ...[if (i > 0) SizedBox(height: gap), kids[i]]
            ])),
        top: 10,
        bottom: 100));

Widget emptyMsg(String t) => rise(Padding(
    padding: const EdgeInsets.symmetric(vertical: 60),
    child: Center(child: Text(t, textAlign: TextAlign.center, style: tx(14, mono: true)))));

/// Tiny overlapping stack of faces (`.stk`).
Widget faceStack(List<int> faces) {
  final shown = faces.take(4).toList(), ex = faces.length - shown.length;
  return Row(mainAxisSize: MainAxisSize.min, children: [
    SizedBox(
        width: 30.0 + (shown.length - 1) * 21,
        height: 34,
        child: Stack(children: [
          for (var i = 0; i < shown.length; i++) Positioned(left: i * 21.0, top: 0, child: face(shown[i], 30)),
        ])),
    if (ex > 0) ...[const SizedBox(width: 6), Text('+$ex', style: tx(13, ls: 0))],
  ]);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int tab = 0;
  final List<int> gens = [0, 0, 0];
  int? flashId;
  bool tLoc = true, tNot = true;
  Timer? hintT;

  @override
  void initState() {
    super.initState();
    tab = S.tab;
    gens[tab]++;
    homeRefresh = () {
      if (mounted) setState(() {});
    };
    if (tab == 0) _hint();
  }

  @override
  void dispose() {
    hintT?.cancel();
    homeRefresh = null;
    super.dispose();
  }

  void _hint() {
    if (hint) return;
    hint = true;
    hintT = Timer(const Duration(milliseconds: 1400), () => toast('Tip: press and hold a crew to pin it'));
  }

  void _tab(int i) {
    if (i == tab) return;
    setState(() {
      tab = i;
      S.tab = i;
      gens[i]++;
      flashId = null;
      for (final c in crews) {
        c.nw = 0;
      }
    });
    if (i == 0) _hint();
  }

  void _pin(Crew c) {
    setState(() {
      c.pin ^= 1;
      flashId = c.id;
    });
    haptic();
    toast(c.pin == 1 ? '${c.n} pinned to the top' : '${c.n} unpinned');
  }

  @override
  Widget build(BuildContext context) {
    final top = math.max(38.0, MediaQuery.of(context).padding.top + 12);
    return Stack(children: [
      _pane(0, top, _crewPane),
      _pane(1, top, _runsPane),
      _pane(2, top, _mePane),
      Positioned(
          left: 22,
          right: 22,
          bottom: 20 + MediaQuery.of(context).padding.bottom,
          child: upA(3, Tbar(const ['Crew', 'Runs', 'Me'], tab, _tab))),
    ]);
  }

  Widget _pane(int i, double top, Widget Function() build) {
    final active = i == tab;
    final dx = active ? 0.0 : (i < tab ? -40.0 : 40.0);
    return Positioned.fill(
        child: IgnorePointer(
            ignoring: !active,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: const Cubic(.2, .9, .3, 1),
                transform: Matrix4.translationValues(dx, 0, 0),
                child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: active ? 1 : 0,
                    child: Padding(
                        padding: EdgeInsets.only(top: top),
                        child: KeyedSubtree(key: ValueKey('hp$i-${gens[i]}'), child: build()))))));
  }

  Widget _head(String t, Widget trailing) => upA(
      0,
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(t, style: tx(60, h: 1)),
            trailing,
          ])));

  // ═════════ crews ═════════
  Widget _crewPane() {
    final L = [...crews]..sort((a, b) {
        final p = b.pin - a.pin;
        return p != 0 ? p : b.id.compareTo(a.id);
      });
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _head('Crew', AddBtn(onTap: _openAdd)),
      upA(1, Padding(padding: const EdgeInsets.fromLTRB(22, 16, 22, 4), child: Text('YOUR CREWS', style: tx(13, mono: true)))),
      paneList([for (var i = 0; i < L.length; i++) _crewCard(L[i], i)]),
    ]);
  }

  Widget _crewCard(Crew c, int i) {
    final pn = c.pin == 1;
    final fg = pn ? kC : kK;
    return Cc(
        key: ValueKey('cr${c.id}'),
        pn: pn,
        flash: flashId == c.id,
        n: i,
        rot: i.isEven ? -.7 : .7,
        onTap: () => openCrew(c.id),
        onLongPress: () => _pin(c),
        child: IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(child: cbd(c.b, pn ? kR : kC, bg: pn ? kC : kR)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.n, style: tx(24, h: 1.05)),
            const SizedBox(height: 8),
            faceStack([for (final m in c.m) fi(m)]),
            const SizedBox(height: 5),
            Text('${c.m.length} member${c.m.length > 1 ? 's' : ''}', style: tx(12, mono: true)),
          ])),
          const SizedBox(width: 14),
          Stack(clipBehavior: Clip.none, children: [
            Stub([
              SizedBox(height: 22, child: pn ? ic('pin', 22, fg, 2.4) : null),
              rn('${c.r} run${c.r == 1 ? '' : 's'}', pn),
            ], color: fg),
            if (c.nw == 1)
              Positioned(
                  top: -10,
                  right: -12,
                  child: popA(
                      delay: 700,
                      ms: 400,
                      Transform.rotate(
                          angle: 10 * math.pi / 180,
                          child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(10)),
                              child: Text('NEW', style: tx(11, mono: true, color: kC)))))),
          ]),
        ])));
  }

  // ═════════ runs ═════════
  Widget _runsPane() {
    final L = runs.where((r) => flt == 'All' || (flt == 'Today' && r.d == 'Today') || (flt == 'Later' && r.d != 'Today') || flt == r.cr).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _head('Runs', Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(18)),
          child: Text('${L.length} active', style: tx(13, mono: true, color: kC)))),
      const SizedBox(height: 6),
      upA(
          1,
          ChipBar([
            for (final f in ['All', 'Today', 'Later', ...crews.map((c) => c.n)])
              Fc(f, on: f == flt, onTap: () => setState(() => flt = f)),
          ])),
      paneList(L.isEmpty
          ? [emptyMsg('Nothing here. Nice and quiet.')]
          : [for (var i = 0; i < L.length; i++) _runCard(L[i], i)]),
    ]);
  }

  Widget _runCard(GRun r, int i) {
    final pn = i == 0;
    return Cc(
        pn: pn,
        n: i,
        rot: i.isEven ? -.7 : .7,
        onTap: () {
          final ci = crews.indexWhere((x) => x.n == r.cr);
          if (ci < 0) return;
          final c = crews[ci];
          ensure(c);
          final k = c.rr!.indexWhere((x) => x.t == r.t);
          if (k < 0) return;
          if (c.rr![k].by != meK(c)) return toast('Only ${nm(c, c.rr![k].by)} can edit this run');
          openEdit(c, k, 'home');
        },
        child: Row(children: [
          cbd(r.c, pn ? kR : kC, bg: pn ? kC : kR),
          const SizedBox(width: 14),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r.t, style: tx(24, h: 1.05)),
            const SizedBox(height: 5),
            Text(CAT[r.c] ?? '', style: tx(12, mono: true)),
            const SizedBox(height: 6),
            Row(children: [face(r.fi, 24), const SizedBox(width: 6), Text('from ${r.f}', style: tx(14, ls: 0))]),
            const SizedBox(height: 6),
            Row(children: [
              ic('clock', 14, pn ? kC : kK, 2.4),
              const SizedBox(width: 6),
              Text('${r.d} · ${r.tm}', style: tx(13, mono: true)),
            ]),
          ])),
        ]));
  }

  // ═════════ me ═════════
  Widget _mePane() => SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 130),
      child: Column(children: [
        upA(
            0,
            Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Press(
                    onTap: () {
                      S.ret = true;
                      go('face');
                    },
                    b: (d) => AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        curve: const Cubic(.2, 1.6, .4, 1),
                        scale: d ? .92 : 1,
                        child: Stack(clipBehavior: Clip.none, children: [
                          face(S.face, 126),
                          Positioned(
                              right: -4,
                              bottom: 6,
                              child: wobA(
                                  delay: 1000,
                                  Container(
                                      width: 42,
                                      height: 42,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: kR,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: kK, width: 3),
                                          boxShadow: [hard(kK, 3)]),
                                      child: ic('plus', 20, kC, 3.4)))),
                        ]))))),
        upA(1, Padding(padding: const EdgeInsets.only(top: 10), child: Text(S.name, style: tx(42, h: 1)))),
        upA(2, Padding(padding: const EdgeInsets.only(top: 14), child: Btn('Change name', v: 'o', auto: true, h: 46, fs: 16, onTap: _openName))),
        const SizedBox(height: 26),
        upA(3, _row('Location · Always', _Tog(tLoc), () {
          setState(() => tLoc = !tLoc);
          toast('Location alerts ${tLoc ? 'on' : 'off'}');
        })),
        const SizedBox(height: 12),
        upA(4, _row('Notifications', _Tog(tNot), () {
          setState(() => tNot = !tNot);
          toast('Notifications ${tNot ? 'on' : 'off'}');
        })),
        const SizedBox(height: 12),
        upA(5, _row('Settings', ic('chev', 22, kC, 2.8), () => toast('Settings screen is next'))),
        const SizedBox(height: 12),
        upA(6, _row('Log out', null, () {
          toast('Logged out');
          go('login');
        })),
      ]));

  Widget _row(String t, Widget? trail, VoidCallback onTap) => Press(
      onTap: onTap,
      b: (d) => AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: d ? .98 : 1,
          child: Container(
              height: 66,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                  color: kR,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: kK, width: 3),
                  boxShadow: [hard(kK, 4)]),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t, style: tx(19, ls: 0, color: kC)),
                if (trail != null) trail,
              ]))));

  // ═════════ sheets ═════════
  void _openAdd() {
    showSheet((c) => Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              decoration: BoxDecoration(
                  color: rgba(238, 235, 221, .97),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: kK, width: 3),
                  boxShadow: [hard(kK, 5)]),
              clipBehavior: Clip.antiAlias,
              child: Column(children: [
                _ir('bolt', false, 'Create a crew', 'Name it, pick a badge', () {
                  closeSheet();
                  Timer(const Duration(milliseconds: 260), () {
                    cnCtl.clear();
                    go('name');
                  });
                }),
                Container(height: 2, color: rgba(27, 23, 23, .2)),
                _ir('code', true, 'Join a crew', 'Got a code? Hop in', () {
                  closeSheet();
                  Timer(const Duration(milliseconds: 300), () => go('jn'));
                }),
              ])),
          const SizedBox(height: 10),
          Press(
              onTap: closeSheet,
              b: (d) => AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 58,
                  width: double.infinity,
                  alignment: Alignment.center,
                  transform: Matrix4.translationValues(0, d ? 4 : 0, 0),
                  decoration: BoxDecoration(
                      color: kC,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: kK, width: 3),
                      boxShadow: [hard(kK, d ? 1 : 5)]),
                  child: Text('Cancel', style: tx(20)))),
        ]));
  }

  Widget _ir(String icon, bool outline, String t, String s, VoidCallback onTap) => Press(
      onTap: onTap,
      b: (d) => Container(
          color: d ? rgba(129, 0, 0, .12) : null,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(children: [
            Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: outline ? kC : kR,
                    shape: BoxShape.circle,
                    border: outline ? Border.all(color: kR, width: 3) : null),
                child: ic(icon, 26, outline ? kR : kC, 2.4)),
            const SizedBox(width: 14),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t, style: tx(21)),
              const SizedBox(height: 2),
              Text(s, style: tx(12, mono: true)),
            ])),
            ic('chev', 22, kK, 2.6),
          ])));

  void _openName() => showSheet((c) => const _NameSheet());
}

class _Tog extends StatelessWidget {
  final bool on;
  const _Tog(this.on);
  @override
  Widget build(BuildContext context) => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 56,
      height: 32,
      decoration: BoxDecoration(
          color: on ? kC : kD,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kC, width: 3)),
      child: Stack(children: [
        AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: const Cubic(.2, 1.6, .4, 1),
            top: 3,
            left: on ? 27 : 3,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: on ? kR : kC, shape: BoxShape.circle))),
      ]));
}

class _NameSheet extends StatefulWidget {
  const _NameSheet();
  @override
  State<_NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<_NameSheet> {
  final ctl = TextEditingController(text: S.name);
  final fk = GlobalKey<InFieldState>();
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      fk.currentState?.fn.requestFocus();
      ctl.selection = TextSelection(baseOffset: 0, extentOffset: ctl.text.length);
    });
  }

  @override
  void dispose() {
    ctl.dispose();
    super.dispose();
  }

  void _save([String? _]) {
    final v = ctl.text.trim();
    if (v.isEmpty) {
      fk.currentState?.shake();
      return;
    }
    S.name = v;
    homeRefresh?.call();
    closeSheet();
    toast('Name updated to $v');
  }

  @override
  Widget build(BuildContext context) => Pn2([
        st2('Change name'),
        InField(key: fk, c: ctl, maxLen: 14, onSubmit: _save),
        const SizedBox(height: 14),
        Btn('Save', onTap: _save),
        const SizedBox(height: 12),
        const LinkBtn('Cancel', onTap: closeSheet),
      ]);
}
