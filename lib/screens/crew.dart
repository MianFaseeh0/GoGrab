import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import '../core/anim.dart';
import '../core/state.dart';
import '../core/svg.dart';
import '../core/theme.dart';
import '../core/ui.dart';
import 'home.dart' show paneList, emptyMsg;
import 'runform.dart' show addRun, openEdit, onRunsChanged;

void openCrew(int id) {
  final i = crews.indexWhere((x) => x.id == id);
  if (i < 0) return;
  final c = crews[i];
  CC = c;
  ensure(c);
  cFlt = 'All';
  S.tab = 0;
  go('crew');
}

class CrewScreen extends StatefulWidget {
  const CrewScreen({super.key});
  @override
  State<CrewScreen> createState() => _CrewState();
}

class _CrewState extends State<CrewScreen> {
  int tab = 0;
  final List<int> gens = [1, 0, 0];

  @override
  void initState() {
    super.initState();
    onRunsChanged = () {
      if (mounted) setState(() {});
    };
  }

  @override
  void dispose() {
    onRunsChanged = null;
    super.dispose();
  }

  void _tab(int i) {
    if (i == tab) return;
    setState(() {
      tab = i;
      gens[i]++;
    });
  }

  void _gone(String t) {
    final c = CC!;
    crews = crews.where((x) => x != c).toList();
    runs = runs.where((r) => r.cr != c.n).toList();
    S.tab = 0;
    go('home');
    Timer(const Duration(milliseconds: 500), () => toast(t));
  }

  @override
  Widget build(BuildContext context) {
    final c = CC;
    if (c == null) return const SizedBox.shrink();
    final m = MediaQuery.of(context);
    final top = math.max(34.0, m.padding.top + 8);
    final paneTop = top + 46 + 10 + 54 + 14;
    return Stack(children: [
      _pane(0, paneTop, () => _runs(c)),
      _pane(1, paneTop, () => _members(c)),
      _pane(2, paneTop, () => _me(c)),
      Positioned(
          left: 22,
          right: 22,
          top: top,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Bk(onTap: () {
                S.tab = 0;
                go('home');
              }),
              const SizedBox(width: 12),
              DashedBox(
                  color: kK,
                  radius: 16,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      child: Text(c.code ?? '', style: tx(15, mono: true)))),
              const Spacer(),
              Visibility(
                  visible: tab == 0,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: const AddBtn(onTap: addRun)),
            ]),
            const SizedBox(height: 10),
            Text(c.n,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tx(vw(context, 38, 12.5, 50), h: 1)),
          ])),
      Positioned(
          left: 22,
          right: 22,
          bottom: 20 + m.padding.bottom,
          child: Tbar(const ['Runs', 'Members', 'Me'], tab, _tab)),
    ]);
  }

  Widget _pane(int i, double top, Widget Function() b) {
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
                        child: KeyedSubtree(key: ValueKey('cp$i-${gens[i]}'), child: b()))))));
  }

  // ═════════ runs ═════════
  Widget _runs(Crew c) {
    final me = meK(c), adm = me == c.adm;
    final L = <int>[
      for (var i = 0; i < c.rr!.length; i++)
        if (cFlt == 'All' || c.rr![i].by == me) i
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      upA(
          0,
          ChipBar([
            for (final f in ['By me', 'All']) Fc(f, on: f == cFlt, onTap: () => setState(() => cFlt = f)),
          ])),
      paneList(L.isEmpty
          ? [emptyMsg(cFlt == 'All' ? 'No runs yet. Tap + to start one.' : 'You have not made any runs here.')]
          : [for (var n = 0; n < L.length; n++) _runCard(c, L[n], n, me, adm)]),
    ]);
  }

  Widget _runCard(Crew c, int i, int n, int me, bool adm) {
    final r = c.rr![i];
    final mine = r.by == me, tm = r.to == me;
    final fg = tm ? kC : kK;
    return Cc(
        key: ValueKey('rr${r.t}$i$n'),
        pn: tm,
        n: n,
        rot: n.isEven ? -.7 : .7,
        onTap: () {
          if (!mine) return toast('Only ${nm(c, r.by)} can edit this run');
          openEdit(c, i, 'crew');
        },
        child: IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(child: cbd(r.c, tm ? kR : kC, bg: tm ? kC : kR)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(r.t, style: tx(24, h: 1.05)),
            const SizedBox(height: 5),
            Text(CAT[r.c] ?? '', style: tx(12, mono: true)),
            const SizedBox(height: 6),
            Row(children: [
              face(fx(c, r.to), 24),
              const SizedBox(width: 6),
              Flexible(child: Text('for ${nm(c, r.to)}', style: tx(14, ls: 0), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 5),
            Text('by ${nm(c, r.by)}', style: tx(12, mono: true)),
            const SizedBox(height: 6),
            Row(children: [
              ic('clock', 14, fg, 2.4),
              const SizedBox(width: 6),
              Text('${r.d} · ${r.tm}', style: tx(13, mono: true)),
            ]),
          ])),
          if (mine || adm) ...[
            const SizedBox(width: 14),
            Stub([
              Press(
                  onTap: () {
                    c.rr!.removeAt(i);
                    c.r = math.max(0, c.r - 1);
                    final g = runs.indexWhere((x) => x.t == r.t && x.cr == c.n);
                    if (g >= 0) runs.removeAt(g);
                    setState(() {});
                    toast('Run deleted');
                  },
                  b: (d) => AnimatedScale(
                      duration: const Duration(milliseconds: 150),
                      scale: d ? .88 : 1,
                      child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: kK, shape: BoxShape.circle),
                          child: ic('trash', 22, kC, 2.4)))),
              rn(mine ? 'mine' : 'admin', tm),
            ], color: fg),
          ],
        ])));
  }

  // ═════════ members ═════════
  Widget _members(Crew c) {
    final me = meK(c), adm = me == c.adm;
    int sc(int k) => k == c.adm ? 0 : (k == me ? 1 : 2);
    final o = List<int>.generate(c.m.length, (i) => i)..sort((a, b) => sc(a) - sc(b));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      upA(0, Padding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 0), child: Text('${c.m.length} MEMBER${c.m.length > 1 ? 'S' : ''}', style: tx(13, mono: true)))),
      paneList([
        for (var n = 0; n < o.length; n++) _memCard(c, o[n], n, me, adm),
      ]),
    ]);
  }

  Widget _memCard(Crew c, int k, int n, int me, bool adm) {
    final isAdm = k == c.adm;
    final tags = [isAdm ? 'ADMIN' : 'MEMBER', if (k == me) 'YOU'].join(' · ');
    return Cc(
        key: ValueKey('mm${c.names![k]}$k'),
        pn: isAdm,
        n: n,
        rot: n.isEven ? -.7 : .7,
        child: IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(child: SizedBox(width: 58, height: 58, child: Center(child: face(fx(c, k), 54)))),
          const SizedBox(width: 14),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(nm(c, k), style: tx(24, h: 1.05)),
            const SizedBox(height: 5),
            Text(tags, style: tx(12, mono: true)),
          ])),
          if (adm && k != me) ...[
            const SizedBox(width: 14),
            Stub([
              Press(
                  onTap: () => _remove(c, k),
                  b: (d) => AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      transform: Matrix4.translationValues(0, d ? 2 : 0, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: kR,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [hard(kK, d ? 1 : 3)]),
                      child: Text('Remove', style: tx(13, ls: 0, color: kC)))),
            ], color: isAdm ? kC : kK, main: MainAxisAlignment.center),
          ],
        ])));
  }

  void _remove(Crew c, int k) {
    final n = nm(c, k);
    conf('Remove $n?', '$n will lose access to this crew and its runs.', 'Remove', () {
      c.m.removeAt(k);
      c.names!.removeAt(k);
      if (k < c.adm!) c.adm = c.adm! - 1;
      c.rr = c.rr!
          .where((r) => r.to != k && r.by != k)
          .map((r) => CRun(r.t, r.c, r.to > k ? r.to - 1 : r.to, r.by > k ? r.by - 1 : r.by, r.d, r.tm))
          .toList();
      if (mounted) setState(() {});
      toast('$n removed');
    });
  }

  // ═════════ me ═════════
  Widget _me(Crew c) {
    final me = meK(c), adm = me == c.adm, mine = cst(c, me), f = math.min(mine.streak, 7);
    final B = [for (var k = 0; k < c.m.length; k++) (k: k, d: cst(c, k).done)]..sort((a, b) => b.d - a.d);
    final mx = math.max(1, B.first.d);
    final kids = <Widget>[
      upA(0, Text('YOUR PROGRESS', style: tx(13, mono: true))),
      upA(
          1,
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _stt(true, 'COMPLETED', '${mine.done}', 'tasks done', null)),
            const SizedBox(width: 14),
            Expanded(child: _stt(false, 'STREAK', '${mine.streak}', 'day${mine.streak == 1 ? '' : 's'} in a row', ic('flame', 36, kR, 2.4))),
          ])),
      upA(
          2,
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (var i = 0; i < 7; i++) _wd('MTWTFSS'[i], i >= 7 - f),
          ])),
      upA(3, Padding(padding: const EdgeInsets.only(top: 6), child: Text('LEADERBOARD', style: tx(13, mono: true)))),
      for (var i = 0; i < B.length; i++) upA(i + 4, _lr(c, B[i].k, B[i].d, mx, i, B[i].k == me)),
      upA(9, Padding(padding: const EdgeInsets.only(top: 10), child: Btn('Leave crew', v: 'o', onTap: () {
        conf('Leave ${c.n}?', adm && c.m.length > 1 ? 'The admin badge passes to the next member.' : 'You will stop getting its runs.', 'Leave crew', () => _gone('You left ${c.n}'));
      }))),
      if (adm)
        upA(10, Btn('Delete crew', v: 'k', onTap: () {
          conf('Delete ${c.n}?', 'This removes the crew and all its runs for everyone.', 'Delete crew', () => _gone('${c.n} deleted'));
        })),
    ];
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 130),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (var i = 0; i < kids.length; i++) ...[if (i > 0) const SizedBox(height: 16), kids[i]]
        ]));
  }

  Widget _stt(bool red, String a, String n, String b, Widget? icon) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: red ? kR : kC,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: kK, width: 3),
          boxShadow: [hard(kK, 5)]),
      child: DefaultTextStyle.merge(
          style: TextStyle(color: red ? kC : kK),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a, style: tx(12, mono: true)),
            Row(children: [
              if (icon != null) ...[icon, const SizedBox(width: 6)],
              Text(n, style: tx(56, h: 1.05)),
            ]),
            Text(b, style: tx(12, mono: true)),
          ])));

  Widget _wd(String d, bool on) => Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: on ? kR : null,
          shape: BoxShape.circle,
          border: Border.all(color: kK, width: 3),
          boxShadow: on ? [hard(kK, 3)] : null),
      child: Text(d, style: tx(13, ls: 0, color: on ? kC : kK)));

  Widget _lr(Crew c, int k, int done, int mx, int i, bool me) {
    final fg = me ? kC : kK;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
            color: me ? kR : kC,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: kK, width: 3),
            boxShadow: [hard(kK, 4)]),
        child: Row(children: [
          Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: me ? kC : kK, shape: BoxShape.circle),
              child: Text('${i + 1}', style: tx(15, ls: 0, color: me ? kR : kC))),
          const SizedBox(width: 12),
          face(fx(c, k), 40),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(nm(c, k), style: tx(19, color: fg), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                    height: 8,
                    color: me ? rgba(238, 235, 221, .3) : rgba(27, 23, 23, .18),
                    child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (done / mx).clamp(0.0, 1.0),
                        child: Container(color: me ? kC : kR)))),
          ])),
          const SizedBox(width: 12),
          Text('$done', style: tx(14, mono: true, color: fg)),
        ]));
  }
}
