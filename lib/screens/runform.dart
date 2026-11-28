import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import '../core/anim.dart';
import '../core/state.dart';
import '../core/svg.dart';
import '../core/theme.dart';
import '../core/ui.dart';

/// Set by the crew screen so add / edit / delete can refresh its list.
VoidCallback? onRunsChanged;

// ═════════════════════════ shared form ═════════════════════════
class RunForm extends StatefulWidget {
  final Crew c;
  final TextEditingController tc;
  final GlobalKey<InFieldState> fk;
  const RunForm({super.key, required this.c, required this.tc, required this.fk});
  @override
  State<RunForm> createState() => _RunFormState();
}

class _RunFormState extends State<RunForm> {
  late final List<FixedExtentScrollController> wc;
  @override
  void initState() {
    super.initState();
    wc = [FS.d, FS.h, FS.m, FS.a].map((i) => FixedExtentScrollController(initialItem: i)).toList();
  }

  @override
  void dispose() {
    for (final w in wc) {
      w.dispose();
    }
    super.dispose();
  }

  void _setW(int k, int i) {
    setState(() {
      switch (k) {
        case 0:
          FS.d = i;
        case 1:
          FS.h = i;
        case 2:
          FS.m = i;
        default:
          FS.a = i;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fl('RUN NAME', mt: 2),
      InField(key: widget.fk, c: widget.tc, hint: 'Buy milk', maxLen: 22),
      fl('STORE TYPE', mt: 16),
      _catBtn(),
      Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 6),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('DEADLINE', style: tx(13, mono: true)),
            Text('${DAYS[FS.d]} · ${fTm()}', style: tx(13, mono: true)),
          ])),
      _wheels(),
      fl('ASSIGN TO · TOP FINISHERS FIRST', mt: 16),
      _assign(),
    ]);
  }

  // ── category button ──
  Widget _catBtn() => Press(
      onTap: () => openCat(() {
            if (mounted) setState(() {});
          }),
      b: (d) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 58,
          padding: const EdgeInsets.fromLTRB(8, 0, 14, 0),
          transform: Matrix4.translationValues(0, d ? 3 : 0, 0),
          decoration: BoxDecoration(
              color: kC,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: kK, width: 3),
              boxShadow: [hard(kK, d ? 1 : 4)]),
          child: Row(children: [
            cbd(FS.c, kC, sz: 40, isz: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(CAT[FS.c] ?? '', style: tx(20), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ic('chev', 20, kK, 2.8),
          ])));

  // ── time wheels ──
  Widget _wheels() {
    final dayL = DAYS, hrL = HRS.map((e) => '$e').toList(), mnL = MNS, apL = const ['AM', 'PM'];
    return Container(
        height: 158,
        decoration: BoxDecoration(
            color: kC,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: kK, width: 3),
            boxShadow: [hard(kK, 4)]),
        clipBehavior: Clip.antiAlias,
        child: Stack(children: [
          Positioned(
              left: 8,
              right: 8,
              top: 60,
              height: 32,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: rgba(129, 0, 0, .14), borderRadius: BorderRadius.circular(12)))),
          fadeV(
              Row(children: [
                _col(0, dayL, FS.d, 24),
                _col(1, hrL, FS.h, 10),
                _col(2, mnL, FS.m, 10),
                _col(3, apL, FS.a, 10),
              ]),
              top: 49,
              bottom: 49),
        ]));
  }

  Widget _col(int k, List<String> L, int sel, int flex) => Expanded(
      flex: flex,
      child: ListWheelScrollView.useDelegate(
          controller: wc[k],
          itemExtent: 32,
          diameterRatio: 40,
          perspective: .0005,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (i) => _setW(k, i),
          childDelegate: ListWheelChildListDelegate(children: [
            for (var j = 0; j < L.length; j++)
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => wc[k].animateToItem(j,
                      duration: const Duration(milliseconds: 250), curve: Curves.ease),
                  child: Center(
                      child: Opacity(
                          opacity: j == sel ? 1 : .45,
                          child: Text(L[j],
                              maxLines: 1,
                              style: tx(17, ls: 0, color: j == sel ? kR : kK))))),
          ])));

  // ── assignee strip ──
  Widget _assign() {
    final c = widget.c, o = rankM(c);
    return Bleed(
        extra: 8,
        height: 118,
        child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
            children: [
              for (var i = 0; i < o.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                _member(c, o[i], i, o.length),
                if (i == 2 && o.length > 3)
                  const Padding(
                      padding: EdgeInsets.only(left: 12, top: 6, bottom: 6),
                      child: SizedBox(width: 3, child: CustomPaint(painter: _VDash()))),
              ]
            ]));
  }

  Widget _member(Crew c, int k, int i, int n) {
    final on = k == FS.to;
    final fg = on ? kC : kK;
    return Press(
        onTap: () => setState(() => FS.to = k),
        b: (d) => AnimatedScale(
            duration: const Duration(milliseconds: 200),
            curve: const Cubic(.2, 1.6, .4, 1),
            scale: d ? .94 : 1,
            child: Stack(clipBehavior: Clip.none, children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  padding: const EdgeInsets.fromLTRB(2, 8, 2, 6),
                  decoration: BoxDecoration(
                      color: on ? kR : kC,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: kK, width: 3),
                      boxShadow: [hard(kK, 4)]),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    face(fx(c, k), 42),
                    const SizedBox(height: 2),
                    SizedBox(
                        width: 72,
                        child: Text(nm(c, k),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tx(14, color: fg))),
                    const SizedBox(height: 2),
                    Text(c.m.length < 2 ? 'you' : '${pct(c, k)}%', style: tx(12, mono: true, color: fg)),
                  ])),
              if (i < 3 && c.m.length > 1)
                Positioned(
                    top: -8,
                    left: -6,
                    child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: on ? kC : kK, shape: BoxShape.circle),
                        child: Text('${i + 1}', style: tx(12, ls: 0, color: on ? kR : kC)))),
            ])));
  }
}

class _VDash extends CustomPainter {
  const _VDash();
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = kK
      ..strokeWidth = 3;
    for (double y = 0; y < s.height; y += 9) {
      canvas.drawLine(Offset(1.5, y), Offset(1.5, math.min(y + 6, s.height)), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ═════════════════════════ category picker (second sheet) ═════════════════════════
void openCat(VoidCallback cb) => showSheet((c) => _CatPicker(cb), top: 64);

class _CatPicker extends StatefulWidget {
  final VoidCallback cb;
  const _CatPicker(this.cb);
  @override
  State<_CatPicker> createState() => _CatPickerState();
}

class _CatPickerState extends State<_CatPicker> {
  final qc = TextEditingController();
  int g = -1;
  @override
  void initState() {
    super.initState();
    qc.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    qc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = qc.text.trim().toLowerCase();
    final L = CL.where((x) => (g < 0 || x.g == g) && x.n.toLowerCase().contains(q)).toList();
    return Pn2([
      st2('Store type', mb: 10),
      InField(c: qc, hint: 'Search ${CL.length} store types', h: 50, fs: 17),
      const SizedBox(height: 4),
      Bleed(
          extra: 22,
          height: 58,
          child: ChipBar([
            for (var i = 0; i < CG.length + 1; i++)
              Fc(i == 0 ? 'All' : CG[i - 1], on: i - 1 == g, onTap: () => setState(() => g = i - 1)),
          ], pad: const EdgeInsets.fromLTRB(22, 8, 22, 8))),
      Flexible(
          child: L.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: Text('No store type matches.', style: tx(14, mono: true))))
              : GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: .88,
                  padding: const EdgeInsets.fromLTRB(2, 8, 2, 10),
                  children: [for (final x in L) _tile(x)])),
    ]);
  }

  Widget _tile(Cat x) {
    final sel = x.k == FS.c;
    return Press(
        onTap: () {
          FS.c = x.k;
          closeSheet();
          widget.cb();
        },
        b: (d) => AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: d ? .93 : 1,
            child: Container(
                padding: const EdgeInsets.fromLTRB(2, 10, 2, 8),
                decoration: BoxDecoration(
                    color: sel ? kR : kC,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: kK, width: 3),
                    boxShadow: [hard(kK, 3)]),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ic(x.k, 28, sel ? kC : kK, 2.2),
                  const SizedBox(height: 5),
                  Text(x.n,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tx(11, ls: -.01, h: 1.1, color: sel ? kC : kK)),
                ]))));
  }
}

// ═════════════════════════ add-run sheet ═════════════════════════
void addRun() {
  final c = CC;
  if (c == null) return;
  final me = meK(c), n = fNow();
  FS = FormS()
    ..c = 'basket'
    ..to = rankM(c).firstWhere((k) => k != me, orElse: () => me)
    ..d = n.d
    ..h = n.h
    ..m = n.m
    ..a = n.a;
  showSheet((ctx) => _AddRun(c), top: 52);
}

class _AddRun extends StatefulWidget {
  final Crew c;
  const _AddRun(this.c);
  @override
  State<_AddRun> createState() => _AddRunState();
}

class _AddRunState extends State<_AddRun> {
  final tc = TextEditingController();
  final fk = GlobalKey<InFieldState>();
  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  void _submit() {
    final v = tc.text.trim();
    if (v.isEmpty) {
      fk.currentState?.shake();
      return;
    }
    final c = widget.c, d = DAYS[FS.d], tm = fTm();
    c.rr!.insert(0, CRun(v, FS.c, FS.to, meK(c), d, tm));
    c.r++;
    runs.add(GRun(v, FS.c, S.name, S.face, d, tm, c.n));
    final who = nm(c, FS.to);
    closeSheet();
    cFlt = 'All';
    onRunsChanged?.call();
    toast('Run added for $who');
  }

  @override
  Widget build(BuildContext context) => Pn2([
        st2('New run'),
        Flexible(
            child: ScrollConfiguration(
                behavior: const NoGlow(),
                child: SingleChildScrollView(child: RunForm(c: widget.c, tc: tc, fk: fk)))),
        const SizedBox(height: 12),
        Btn('Add run', onTap: _submit),
        const SizedBox(height: 12),
        const LinkBtn('Cancel', onTap: closeSheet),
      ]);
}

// ═════════════════════════ edit screen ═════════════════════════
void openEdit(Crew c, int i, String from) {
  final r = c.rr![i];
  ED = EditCtx(c, r, from);
  final p = fParse(r.d, r.tm);
  FS = FormS()
    ..t = r.t
    ..c = r.c
    ..to = r.to
    ..d = p.d
    ..h = p.h
    ..m = p.m
    ..a = p.a;
  go('edit');
}

void edBack() {
  if (ED?.from == 'home') {
    S.tab = 1;
    go('home');
  } else {
    go('crew');
  }
}

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});
  @override
  State<EditScreen> createState() => _EditState();
}

class _EditState extends State<EditScreen> {
  final tc = TextEditingController(text: ED?.r.t ?? '');
  final fk = GlobalKey<InFieldState>();
  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  void _save() {
    final v = tc.text.trim();
    if (v.isEmpty) {
      fk.currentState?.shake();
      return;
    }
    final e = ED!, c = e.c, r = e.r;
    final gi = runs.indexWhere((x) => x.t == r.t && x.cr == c.n);
    r.t = v;
    r.c = FS.c;
    r.to = FS.to;
    r.d = DAYS[FS.d];
    r.tm = fTm();
    if (gi >= 0) {
      runs[gi]
        ..t = v
        ..c = r.c
        ..d = r.d
        ..tm = r.tm;
    }
    edBack();
    Timer(const Duration(milliseconds: 400), () => toast('Run updated'));
  }

  @override
  Widget build(BuildContext context) {
    final e = ED;
    if (e == null) return const SizedBox.shrink();
    return Padding(
        padding: scPad(context),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          upA(0, const Bk(onTap: edBack)),
          const SizedBox(height: 14),
          upA(1, Text('Edit\nrun.', style: tx(vw(context, 40, 13, 54), h: .94))),
          Expanded(
              child: upA(
                  2,
                  Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Stack(clipBehavior: Clip.none, children: [
                        Positioned(
                            left: -22,
                            right: -22,
                            top: 0,
                            bottom: 0,
                            child: ScrollConfiguration(
                                behavior: const NoGlow(),
                                child: SingleChildScrollView(
                                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 14),
                                    child: RunForm(c: e.c, tc: tc, fk: fk))))
                      ])))),
          upA(
              3,
              Column(children: [
                Btn('Save changes', onTap: _save),
                const SizedBox(height: 12),
                const Btn('Cancel', v: 'o', onTap: edBack),
              ])),
        ]));
  }
}
