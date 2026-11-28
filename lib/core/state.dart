import 'package:material_ui/material_ui.dart';
import 'svg_data.dart';

// ───────────────────────── models ─────────────────────────
class Crew {
  int id;
  String n, b;
  List<int> m; // face index per member, -1 = me
  int r, pin, nw;
  int? adm;
  String? code;
  List<String>? names;
  List<CRun>? rr;
  Crew(this.id, this.n, this.b, this.m, this.r, this.pin, [this.nw = 0]);
}

/// A run inside a crew (to / by are member positions in Crew.m).
class CRun {
  String t, c, d, tm;
  int to, by;
  CRun(this.t, this.c, this.to, this.by, this.d, this.tm);
}

/// A run in the global Runs tab.
class GRun {
  String t, c, f, d, tm, cr;
  int fi;
  GRun(this.t, this.c, this.f, this.fi, this.d, this.tm, this.cr);
}

class Mem {
  int f;
  String n;
  bool me;
  Mem(this.f, this.n, [this.me = false]);
}

class AppS {
  String name = 'Faseeh';
  int face = 0;
  String badge = 'bolt';
  String crew = '';
  String code = '';
  bool home = false;
  int tab = 0;
  bool ret = false;
}

final S = AppS();
List<Crew> crews = [];
List<GRun> runs = [];
List<Mem> members = [];
String flt = 'All';
bool hint = false;
Crew? CC;
String cFlt = 'All';

// ───────────────────────── navigation ─────────────────────────
final ValueNotifier<String> route = ValueNotifier<String>('login');
void go(String id) => route.value = id;

// ───────────────────────── data ─────────────────────────
final Map<String, String> CAT = {
  'pill': 'Pharmacy',
  'bread': 'Bakery',
  'basket': 'Grocery',
  'pencil': 'Stationery',
  'card': 'ATM'
};

class Cat {
  final String k, n;
  final int g;
  Cat(this.k, this.n, this.g);
}

const List<String> CG = ['Daily', 'Food', 'Health', 'Home', 'Tech & office', 'Style & fun', 'Services'];
final List<Cat> CL = [];

void initCats() {
  if (CL.isNotEmpty) return;
  const raw =
      'basket,Grocery;cart,Supermarket;bread,Bakery;milk,Dairy & milk;apple,Fruit & veg;meat,Butcher;shop,Convenience;drop,Water supply;flame,Gas cylinder|candy,Mithai & sweets;cup,Cafe & chai;fork,Restaurant;burger,Fast food;cone,Ice cream;juice,Juice bar,cup|pill,Pharmacy;cross,Clinic;flask,Lab & tests;glasses,Optician;scissors,Salon & barber;spark,Cosmetics,star;baby,Baby store,heart;paw,Pet shop|wrench,Hardware;home,Home & kitchen;sofa,Furniture;bolt,Electrician;leaf,Garden|pencil,Stationery;book,Bookshop;printer,Print & copy;chip,Electronics;phone,Mobile shop;laptop,Computers|shirt,Clothing;boot,Shoes;needle,Tailor;gem,Jewellery;gift,Gifts & flowers;game,Toys & games;ball,Sports;dumbbell,Gym gear|fuel,Petrol pump;car,Auto parts;wheel,Tyres & repair;wash,Laundry,drop;card,ATM & bank;box,Post & courier;signal,SIM & telecom;bag,Mall & general';
  final groups = raw.split('|');
  for (var gi = 0; gi < groups.length; gi++) {
    for (final x in groups[gi].split(';')) {
      final p = x.split(',');
      final a = p[0], b = p[1];
      final c = p.length > 2 ? p[2] : null;
      CL.add(Cat(a, b, gi));
      if (IC[a] == null && c != null) IC[a] = IC[c]!;
      CAT[a] = b;
    }
  }
}

void initData() {
  crews = [
    Crew(1, 'The Boys', 'game', [-1, 1, 2], 2, 1),
    Crew(2, 'Family', 'heart', [-1, 7, 6, 9, 8], 1, 0),
    Crew(3, 'Office Lunch', 'pizza', [-1, 24, 25, 26, 22, 21], 1, 0),
  ];
  runs = [
    GRun('Buy medicine', 'pill', 'Ahmad', 1, 'Today', '8 PM', 'The Boys'),
    GRun('Buy bread', 'bread', 'Wasif', 2, 'Today', '9 PM', 'The Boys'),
    GRun('Pick up cash', 'card', 'Mom', 7, 'Tomorrow', '11 AM', 'Family'),
    GRun('Get samosas', 'basket', 'Boss', 24, 'Tomorrow', '1 PM', 'Office Lunch'),
  ];
  flt = 'All';
  hint = false;
}

class JoinCrew {
  final String n, b, a;
  final List<List<Object>> m;
  const JoinCrew(this.n, this.b, this.a, this.m);
}

const List<JoinCrew> JC = [
  JoinCrew('Weekend Gang', 'rocket', 'Zara', [
    [3, 'Zara'], [4, 'Hamza'], [5, 'Ali'], [10, 'Sana']
  ]),
  JoinCrew('Cousins', 'star', 'Bilal', [
    [11, 'Bilal'], [12, 'Noor'], [13, 'Hira'], [14, 'Umar'], [15, 'Maya']
  ]),
  JoinCrew('Flat 4B', 'pizza', 'Danish', [
    [16, 'Danish'], [17, 'Eman'], [18, 'Taha']
  ]),
];

const List<String> BADGES = ['bolt', 'heart', 'star', 'flame', 'game', 'pizza', 'rocket', 'moon'];

// ───────────────────────── helpers ─────────────────────────
int fi(int i) => i < 0 ? S.face : i;
int fx(Crew c, int k) => c.m[k] < 0 ? S.face : c.m[k];
String nm(Crew c, int k) => c.m[k] < 0 ? 'You' : c.names![k];
int meK(Crew c) => c.m.indexOf(-1);
({int done, int streak}) cst(Crew c, int k) => c.m.length < 2
    ? (done: 0, streak: 0)
    : (done: 6 + ((k * 7 + c.n.length * 3) % 15), streak: 1 + ((k * 3 + c.n.length) % 8));
int pct(Crew c, int k) => c.m.length < 2 ? 0 : 62 + ((k * 13 + c.n.length * 7) % 36);
List<int> rankM(Crew c) {
  final l = List<int>.generate(c.m.length, (i) => i);
  l.sort((a, b) {
    final d = pct(c, b) - pct(c, a);
    return d != 0 ? d : a - b;
  });
  return l;
}

void ensure(Crew c) {
  c.adm ??= const {'The Boys': 0, 'Family': 1, 'Office Lunch': 1}[c.n] ?? 0;
  c.names ??= c.m
      .map((f) => f < 0
          ? S.name
          : ((c.n == 'The Boys' ? const {1: 'Ahmad', 2: 'Wasif'}[f] : null) ?? (F[f][0] as String)))
      .toList();
  if (c.code == null) {
    final s = c.id.toString();
    final last4 = int.parse(s.substring(s.length > 4 ? s.length - 4 : 0));
    c.code = 'GG-${1000 + (last4 * 7) % 9000}';
  }
  c.rr ??= switch (c.n) {
    'The Boys' => [
        CRun('Buy medicine', 'pill', 0, 1, 'Today', '8 PM'),
        CRun('Buy bread', 'bread', 0, 2, 'Today', '9 PM'),
        CRun('Get chai', 'cup', 1, 0, 'Tomorrow', '10 AM'),
      ],
    'Family' => [
        CRun('Pick up cash', 'card', 0, 1, 'Tomorrow', '11 AM'),
        CRun('Get groceries', 'basket', 2, 0, 'Today', '6 PM'),
      ],
    'Office Lunch' => [CRun('Get samosas', 'basket', 0, 1, 'Tomorrow', '1 PM')],
    _ => <CRun>[],
  };
}

void addCrew() {
  for (final c in crews) {
    c.nw = 0;
  }
  crews.add(Crew(DateTime.now().millisecondsSinceEpoch, S.crew, S.badge,
      members.map((x) => x.me ? -1 : x.f).toList(), 0, 0, 1)
    ..code = S.code
    ..adm = 0
    ..names = members.map((x) => x.me ? S.name : x.n).toList());
}

// ───────────────────────── run form (add / edit) ─────────────────────────
const _wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _mo = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
final List<String> DAYS = List.generate(14, (i) {
  if (i < 2) return const ['Today', 'Tomorrow'][i];
  final d = DateTime.now().add(Duration(days: i));
  return '${_wd[d.weekday - 1]} ${d.day} ${_mo[d.month - 1]}';
});
final List<int> HRS = List.generate(12, (i) => i + 1);
final List<String> MNS = List.generate(12, (i) => (i * 5).toString().padLeft(2, '0'));

class FormS {
  String t = '';
  String c = 'basket';
  int to = 0, d = 0, h = 0, m = 0, a = 0;
}

FormS FS = FormS();
String fTm() => '${HRS[FS.h]}:${MNS[FS.m]} ${FS.a == 1 ? 'PM' : 'AM'}';

({int d, int h, int m, int a}) fNow() {
  final n = DateTime.now();
  var h = n.hour + 1, d = 0;
  if (h > 23) {
    h = 0;
    d = 1;
  }
  final hh = h % 12 == 0 ? 12 : h % 12;
  return (d: d, h: hh - 1, m: (n.minute / 5).ceil() % 12, a: h >= 12 ? 1 : 0);
}

({int d, int h, int m, int a}) fParse(String dl, String tm) {
  final m = RegExp(r'(\d+)(?::(\d+))? ?(AM|PM)').firstMatch(tm);
  final hh = int.tryParse(m?.group(1) ?? '') ?? 0;
  final mm = int.tryParse(m?.group(2) ?? '') ?? 0;
  final idx = DAYS.indexOf(dl);
  return (
    d: idx < 0 ? 0 : idx,
    h: (hh == 0 ? 8 : hh) - 1,
    m: (mm / 5).round().clamp(0, 11),
    a: m?.group(3) == 'AM' ? 0 : 1
  );
}

/// The edit screen remembers what it is editing.
class EditCtx {
  final Crew c;
  final CRun r;
  final String from;
  EditCtx(this.c, this.r, this.from);
}

EditCtx? ED;
