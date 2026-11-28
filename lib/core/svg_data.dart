// GENERATED from the HTML prototype. Do not edit by hand.
// ignore_for_file: prefer_single_quotes, unnecessary_string_escapes
const String kK='#1B1717',kR='#810000',kC='#EEEBDD',kG='#B9B1A0';
String s(String d,[Object? f,String? st,num? w])=>'<path d="$d" fill="${(f==null||f==0)?'none':f}"${st!=null?' stroke="$st" stroke-width="${w??4}"':''} stroke-linejoin="round" stroke-linecap="round"/>';
const String SH='M17 52Q12 14 50 14Q88 14 83 52Q72 30 50 32Q28 30 17 52Z',CP='M16 48Q20 14 52 16Q82 16 84 48Z';
final Map<String,String> P={
  'short': s(SH,kK),
  'part': s(SH,kK)+s('M42 16Q40 26 46 33',0,kC,3),
  'spiky': s('M17 50L22 20L34 34L44 12L54 32L66 12L72 34L84 22L84 50Q70 30 50 32Q30 30 17 50Z',kK),
  'curls': '<g fill="$kK"><circle cx="26" cy="36" r="10"/><circle cx="40" cy="24" r="10"/><circle cx="57" cy="22" r="10"/><circle cx="73" cy="30" r="10"/><circle cx="80" cy="46" r="8"/><circle cx="20" cy="50" r="8"/></g>',
  'long': s('M16 58Q6 8 50 10Q94 8 84 58L88 96Q74 84 80 56Q70 30 50 32Q30 30 20 56Q26 84 12 96Z',kK),
  'bob': s('M14 68Q4 10 50 10Q96 10 86 68Q82 40 50 36Q18 40 14 68Z',kK),
  'pony': s(SH,kK)+s('M78 30Q98 40 88 74',0,kK,7),
  'pig': '${s(SH,kK)}<circle cx="10" cy="50" r="9" fill="$kK"/><circle cx="90" cy="50" r="9" fill="$kK"/><circle cx="14" cy="38" r="4" fill="$kR"/><circle cx="86" cy="38" r="4" fill="$kR"/>',
  'grey': s(SH,kG,kK,3),
  'bun_g': '${s(SH,kG,kK,3)}<circle cx="50" cy="8" r="11" fill="$kG" stroke="$kK" stroke-width="3"/>',
  'tuft': s('M50 22Q42 6 56 6',0,kK,4),
  'bald': '',
  'cap': s(CP,kR,kK,4)+s('M62 46h34',0,kK,7),
  'beanie': '${s('M18 46Q20 12 50 12Q80 12 82 46Z',kR,kK,4)}<rect x="15" y="42" width="70" height="11" rx="5" fill="$kC" stroke="$kK" stroke-width="4"/><circle cx="50" cy="9" r="6" fill="$kC" stroke="$kK" stroke-width="4"/>',
  'bandana': '${s('M16 46Q50 14 84 46L84 54Q50 28 16 54Z',kR,kK,4)}<circle cx="86" cy="48" r="6" fill="$kR" stroke="$kK" stroke-width="4"/>',
  'scarf': s('M12 64Q4 6 50 8Q96 6 88 64Q80 36 50 34Q20 36 12 64Z',kR,kK,4)+s('M16 66Q20 96 50 98Q80 96 84 66',0,kR,7),
  'crown': s('M26 26l6-20 11 12 7-16 7 16 11-12 6 20z',kR,kK,3.5),
  'chef': '${s('M24 30Q10 8 34 10Q44-6 58 8Q82 2 76 30Z',kC,kK,4)}<rect x="26" y="28" width="48" height="10" rx="3" fill="$kC" stroke="$kK" stroke-width="4"/>',
  'wizard': s('M20 36L54-10L80 36Z',kR,kK,4)+s('M12 38h76',0,kK,6),
  'ninja': '<path d="M15 42Q50 26 85 42V56Q50 44 15 56Z" fill="$kK"/><path d="M85 46l12 8-12 8z" fill="$kK"/>',
  'pirate': '${s('M16 46Q50 14 84 46L84 54Q50 28 16 54Z',kR,kK,4)}<circle cx="39" cy="58" r="9" fill="$kK"/>${s('M30 52L18 38',0,kK,3)}',
  'headphones': '${s('M16 54Q16 14 50 14Q84 14 84 54',0,kK,6)}<rect x="8" y="46" width="14" height="24" rx="6" fill="$kR" stroke="$kK" stroke-width="3"/><rect x="78" y="46" width="14" height="24" rx="6" fill="$kR" stroke="$kK" stroke-width="3"/>',
  'helmet': '<circle cx="50" cy="56" r="42" fill="rgba(129,0,0,.10)" stroke="$kK" stroke-width="5"/>${s('M28 36Q38 24 56 24',0,kC,4)}',
  'ears_cat': s('M18 44L20 8L44 26Z M82 44L80 8L56 26Z',kC,kK,4),
  'ears_panda': '<circle cx="22" cy="28" r="12" fill="$kK"/><circle cx="78" cy="28" r="12" fill="$kK"/>',
  'ears_bear': '<circle cx="22" cy="28" r="12" fill="$kG" stroke="$kK" stroke-width="4"/><circle cx="78" cy="28" r="12" fill="$kG" stroke="$kK" stroke-width="4"/>',
  'ears_bunny': '<ellipse cx="36" cy="6" rx="9" ry="24" fill="$kC" stroke="$kK" stroke-width="4"/><ellipse cx="64" cy="6" rx="9" ry="24" fill="$kC" stroke="$kK" stroke-width="4"/>',
  'horns': s('M24 30L16 4L40 20Z M76 30L84 4L60 20Z',kR,kK,3.5),
  'antenna': '${s('M50 22V6',0,kK,4)}<circle cx="50" cy="6" r="6" fill="$kR" stroke="$kK" stroke-width="3"/>',
  'antennae': '${s('M38 24L30 6M62 24L70 6',0,kK,3)}<circle cx="30" cy="6" r="5" fill="$kR"/><circle cx="70" cy="6" r="5" fill="$kR"/>',
  'glasses': '<g fill="none" stroke="$kK" stroke-width="4"><circle cx="39" cy="57" r="11"/><circle cx="61" cy="57" r="11"/></g>',
  'glasses_sq': '<g fill="none" stroke="$kK" stroke-width="4"><rect x="27" y="48" width="22" height="18" rx="3"/><rect x="51" y="48" width="22" height="18" rx="3"/></g>',
  'shades': '<path d="M24 50h52v10q-8 10-20 3l-6-4-6 4q-12 7-20-3z" fill="$kK"/>',
  'must': s('M33 66q8-7 17-1q9-6 17 1q-8 6-17 2q-9 4-17-2z',kK),
  'beard': s('M19 62Q20 96 50 96Q80 96 81 62Q68 80 50 76Q32 80 19 62Z',kK),
  'beard_g': s('M19 62Q20 96 50 96Q80 96 81 62Q68 80 50 76Q32 80 19 62Z',kG,kK,3),
  'bow': s('M70 22l16-10v22z M70 22l-16-10v22z',kR,kK,3),
  'cheeks': '<circle cx="27" cy="68" r="5" fill="$kR" opacity=".3"/><circle cx="73" cy="68" r="5" fill="$kR" opacity=".3"/>',
  'nose_cat': '<path d="M47 64h6l-3 4z" fill="$kR"/>${s('M30 66l-14-2M30 70l-14 4M70 66l14-2M70 70l14 4',0,kK,2.5)}',
  'muzzle': '<ellipse cx="50" cy="68" rx="14" ry="10" fill="$kC" stroke="$kK" stroke-width="3"/><ellipse cx="50" cy="64" rx="5" ry="3.5" fill="$kK"/>',
};
final Map<String,String> EY={
  'd': '<circle cx="39" cy="57" r="4" fill="$kK"/><circle cx="61" cy="57" r="4" fill="$kK"/>',
  'e_lash': '<circle cx="39" cy="57" r="4" fill="$kK"/><circle cx="61" cy="57" r="4" fill="$kK"/>${s('M32 51l-5-3M68 51l5-3M35 49l-2-5M65 49l2-5',0,kK,2.5)}',
  'e_wide': '<circle cx="38" cy="57" r="8" fill="#fff" stroke="$kK" stroke-width="3"/><circle cx="62" cy="57" r="8" fill="#fff" stroke="$kK" stroke-width="3"/><circle cx="39" cy="58" r="3.5" fill="$kK"/><circle cx="61" cy="58" r="3.5" fill="$kK"/>',
  'e_robot': '<rect x="29" y="50" width="17" height="13" rx="2" fill="$kK"/><rect x="54" y="50" width="17" height="13" rx="2" fill="$kK"/>',
  'e_alien': '<ellipse cx="37" cy="57" rx="8" ry="12" fill="$kK" transform="rotate(20 37 57)"/><ellipse cx="63" cy="57" rx="8" ry="12" fill="$kK" transform="rotate(-20 63 57)"/>',
  'e_panda': '<ellipse cx="37" cy="56" rx="9" ry="11" fill="$kK" transform="rotate(20 37 56)"/><ellipse cx="63" cy="56" rx="9" ry="11" fill="$kK" transform="rotate(-20 63 56)"/><circle cx="38" cy="56" r="3" fill="$kC"/><circle cx="62" cy="56" r="3" fill="$kC"/>',
};
final Map<String,String> MO={
  'smile': s('M38 70q12 10 24 0',0,kK,4),
  'grin': '<path d="M36 68q14 18 28 0z" fill="$kK"/>',
  'o': '<ellipse cx="50" cy="72" rx="5" ry="6" fill="$kK"/>',
  'smirk': s('M40 73q12 4 22-6',0,kK,4),
  'flat': s('M40 72h22',0,kK,4),
  'grill': '<rect x="37" y="66" width="26" height="11" fill="$kC" stroke="$kK" stroke-width="3"/>${s('M43 66v11M50 66v11M57 66v11',0,kK,2)}',
  'fang': '${s('M38 69q12 8 24 0',0,kK,4)}<path d="M42 71l3 7 3-5M58 71l-3 7-3-5" fill="#fff" stroke="$kK" stroke-width="2"/>',
};
const Set<String> BK={'ears_cat','ears_panda','ears_bear','ears_bunny','antenna','antennae','horns'};
final List<List<Object>> F=<List<Object>>[['Bandana',0,'bandana','smile'],['Specs',0,'short,glasses','smile'],['Bookworm',0,'part','smile'],['Cap',0,'cap','smile'],['Curls',0,'curls','smile'],['Beanie',0,'beanie','smile'],
['Dad',1,'bald,must,glasses_sq','smile'],['Mom',1,'scarf,e_lash','smile'],['Son',1,'short,cheeks','grin'],['Daughter',1,'pig,cheeks,e_lash','grin'],['Grandpa',1,'grey,beard_g','smile'],['Grandma',1,'bun_g,glasses','smile'],['Baby',1,'tuft,e_wide,cheeks','o'],['Uncle',1,'part,must,shades','smirk'],['Man',1,'short,beard','smile'],['Woman',1,'long,e_lash','smile'],
['Girlfriend',2,'long,bow,e_lash,cheeks','smile'],['Boyfriend',2,'spiky','smirk'],['Bro',2,'cap,shades','grin'],['Sis',2,'pony,e_lash','grin'],['Bestie',2,'bob,cheeks','grin'],['Cool Dude',2,'short,shades','smirk'],['Gamer',2,'short,headphones','grin'],['Nerd',2,'part,glasses_sq','smile'],['Boss',2,'part,glasses','flat'],['Chef',2,'chef,must','smile'],['Rockstar',2,'spiky,shades','grin'],
['Cat',3,'ears_cat,nose_cat','smile'],['Panda',3,'ears_panda,e_panda,muzzle','smile'],['Bunny',3,'ears_bunny,cheeks','smile'],['Bear',3,'ears_bear,muzzle','smile'],['Robot',3,'antenna,e_robot','grill'],['Alien',3,'antennae,e_alien','smile'],['Monster',3,'horns','fang'],['Ninja',3,'ninja','flat'],['Pirate',3,'pirate','smirk'],['King',3,'crown,beard','smile'],['Wizard',3,'wizard,beard_g','smile'],['Astronaut',3,'helmet','grin']];
const List<String> SEC=['Crew classics','Family','Friends & love','Fun characters'];
final Map<String,String> IC={};
void initIcons(){
  IC['star']='<path d="M12 3l2.7 5.6 6.1.8-4.5 4.2 1.1 6-5.4-3-5.4 3 1.1-6L3.2 9.4l6.1-.8z"/>';
  IC['bolt']='<path d="M13 3L5 14h6l-1 7 8-11h-6z"/>';
  IC['heart']='<path d="M12 20s-8-5-8-11a4.5 4.5 0 018-2.5A4.5 4.5 0 0120 9c0 6-8 11-8 11z"/>';
  IC['flame']='<path d="M12 2c1 4 6 6 6 12a6 6 0 01-12 0c0-3 2-4 3-7 1 1 2 2 3-5z"/>';
  IC['game']='<rect x="2" y="7" width="20" height="11" rx="5"/><path d="M7 10v5M4.5 12.5h5"/><circle cx="15.5" cy="11" r="1"/><circle cx="18" cy="14" r="1"/>';
  IC['pizza']='<path d="M3 6q9-5 18 0l-9 15z"/><circle cx="10" cy="9" r="1"/><circle cx="14" cy="10" r="1"/><circle cx="12" cy="14" r="1"/>';
  IC['rocket']='<path d="M12 2c4 3 5 8 4 13H8c-1-5 0-10 4-13z"/><circle cx="12" cy="9" r="1.5"/><path d="M8 15l-3 4M16 15l3 4"/>';
  IC['moon']='<path d="M20 14A8 8 0 019 3a8 8 0 1011 11z"/>';
  IC['back']='<path d="M15 5l-7 7 7 7"/>';
  IC['plus']='<path d="M12 4v16M4 12h16"/>';
  IC['check']='<path d="M5 12l5 5 9-10"/>';
  IC['pill']='<g transform="rotate(-40 12 12)"><rect x="2" y="7.5" width="20" height="9" rx="4.5"/><path d="M12 7.5v9"/></g>';
  IC['code']='<path d="M8 8l-5 4 5 4M16 8l5 4-5 4M14 5l-4 14"/>';
  IC['lock']='<rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11V8a4 4 0 018 0v3"/>';
  IC['pin']='<path d="M9 3h6l-1 6 3 3v2H7v-2l3-3z"/><path d="M12 14v7"/>';
  IC['chev']='<path d="M9 5l7 7-7 7"/>';
  IC['clock']='<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>';
  IC['bread']='<path d="M3 16Q3 6 12 6Q21 6 21 16Q21 18 18 18H6Q3 18 3 16Z"/><path d="M9 9l1 4M13 9l1 4"/>';
  IC['basket']='<path d="M3 10h18l-2 9H5z"/><path d="M8 10l3-6M16 10l-3-6"/>';
  IC['pencil']='<path d="M4 20l1-4L16 5l3 3L8 19z"/>';
  IC['card']='<rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/>';
  IC['trash']='<path d="M4 7h16M9 7V4h6v3M6 7l1 13h10l1-13M10 11v6M14 11v6"/>';
  IC['cart']='<circle cx="9" cy="20" r="1.5"/><circle cx="18" cy="20" r="1.5"/><path d="M2 4h3l3 11h10l2-8H6"/>';
  IC['milk']='<path d="M8 3h8v4l2 3v11H6V10l2-3z"/><path d="M6 13h12"/>';
  IC['apple']='<path d="M12 8c-5-3-9 1-7 7 1 3 3 6 5 5 1-.5 3-.5 4 0 2 1 4-2 5-5 2-6-2-10-7-7z"/><path d="M12 8c0-3 1-4 3-5"/>';
  IC['meat']='<path d="M5 14c-2-5 3-10 9-9 4 1 6 5 5 9-1 4-6 6-10 4-2-1-3-2-4-4z"/><circle cx="14" cy="10" r="2"/>';
  IC['shop']='<path d="M3 9l2-5h14l2 5zM4 9v11h16V9M10 20v-6h4v6"/>';
  IC['candy']='<rect x="8" y="8" width="8" height="8" rx="3"/><path d="M8 12L3 9v6zM16 12l5-3v6z"/>';
  IC['cup']='<path d="M4 8h13v6a5 5 0 01-5 5H9a5 5 0 01-5-5z"/><path d="M17 10h2a2 2 0 010 4h-2M8 3v2M12 3v2"/>';
  IC['fork']='<path d="M7 3v8M5 3v5a2 2 0 004 0V3M7 11v10M17 3c-2 2-2 8 0 9v9"/>';
  IC['burger']='<path d="M4 11a8 6 0 0116 0z"/><path d="M3 15h18M5 19h14a2 2 0 002-2v-2H3v2a2 2 0 002 2z"/>';
  IC['cone']='<path d="M7 11a5 5 0 1110 0z"/><path d="M7 11l5 11 5-11"/>';
  IC['drop']='<path d="M12 3c4 5 6 8 6 11a6 6 0 01-12 0c0-3 2-6 6-11z"/>';
  IC['cross']='<path d="M9 3h6v6h6v6h-6v6H9v-6H3V9h6z"/>';
  IC['flask']='<path d="M9 3h6M10 3v6l-5 10a1.5 1.5 0 001.3 2h11.4A1.5 1.5 0 0019 19l-5-10V3M7 15h10"/>';
  IC['glasses']='<circle cx="7" cy="14" r="4"/><circle cx="17" cy="14" r="4"/><path d="M11 14h2M3 14L5 6M21 14l-2-8"/>';
  IC['scissors']='<circle cx="6" cy="6" r="3"/><circle cx="6" cy="18" r="3"/><path d="M8 8l12 10M8 16L20 6"/>';
  IC['paw']='<circle cx="6" cy="11" r="2"/><circle cx="10" cy="6" r="2"/><circle cx="15" cy="6" r="2"/><circle cx="19" cy="11" r="2"/><path d="M8 18c0-4 2-6 4-6s4 2 4 6c0 2-2 2-4 1-2 1-4 1-4-1z"/>';
  IC['wrench']='<path d="M14 6a4 4 0 005 5l-9 9a2.1 2.1 0 01-3-3l9-9a4 4 0 01-2-2z"/>';
  IC['home']='<path d="M3 11l9-8 9 8M5 10v10h14V10M10 20v-6h4v6"/>';
  IC['sofa']='<path d="M5 11V8a3 3 0 013-3h8a3 3 0 013 3v3M3 12a2 2 0 014 0v3h10v-3a2 2 0 014 0v6H3zM6 18v2M18 18v2"/>';
  IC['leaf']='<path d="M5 19C4 9 10 4 20 4c0 10-5 16-13 15M5 19l8-8"/>';
  IC['book']='<path d="M4 4h7a2 2 0 012 2v14a2 2 0 00-2-2H4zM20 4h-7v16a2 2 0 012-2h5z"/>';
  IC['printer']='<path d="M7 9V3h10v6M7 17H4v-7h16v7h-3M7 14h10v7H7z"/>';
  IC['chip']='<rect x="6" y="6" width="12" height="12" rx="2"/><path d="M9 3v3M15 3v3M9 18v3M15 18v3M3 9h3M3 15h3M18 9h3M18 15h3"/>';
  IC['phone']='<rect x="7" y="2" width="10" height="20" rx="3"/><path d="M11 18h2"/>';
  IC['laptop']='<rect x="5" y="5" width="14" height="10" rx="1.5"/><path d="M2 19h20"/>';
  IC['shirt']='<path d="M8 3L3 6l2 5 3-1v11h8V10l3 1 2-5-5-3a4 4 0 01-8 0z"/>';
  IC['boot']='<path d="M8 3h6v8l6 3v5H5V13zM5 16h15"/>';
  IC['needle']='<path d="M20 4L6 18M18 6l-2 2M5 19a2 2 0 003 0M9 15c3 1 6-2 8-6"/>';
  IC['gem']='<path d="M6 4h12l4 6-10 11L2 10zM2 10h20M9 4l-2 6 5 11 5-11-2-6"/>';
  IC['gift']='<rect x="3" y="9" width="18" height="12" rx="1"/><path d="M12 9v12M3 13h18M12 9C9 9 7 7 8.5 5.5S12 6 12 9c0-3 2-4.5 3.5-3S15 9 12 9z"/>';
  IC['ball']='<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c4 4 4 14 0 18M12 3c-4 4-4 14 0 18"/>';
  IC['dumbbell']='<path d="M6 7v10M3 9v6M18 7v10M21 9v6M6 12h12"/>';
  IC['car']='<path d="M4 16v-4l2-5h12l2 5v4zM4 12h16"/><circle cx="8" cy="17" r="1.5"/><circle cx="16" cy="17" r="1.5"/>';
  IC['wheel']='<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="3"/><path d="M12 3v6M12 15v6M3 12h6M15 12h6"/>';
  IC['box']='<path d="M3 7l9-4 9 4v10l-9 4-9-4zM3 7l9 4 9-4M12 11v10"/>';
  IC['signal']='<path d="M4 20v-4M9 20v-8M14 20V8M19 20V4"/>';
  IC['bag']='<path d="M5 8h14l1 13H4zM9 8V6a3 3 0 016 0v2"/>';
  IC['fuel']='<path d="M5 21V4h9v17M3 21h13M14 9h3l2 2v7a1.5 1.5 0 003 0V9l-3-3M7 8h5"/>';
}
