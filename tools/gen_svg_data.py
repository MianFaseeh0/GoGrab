import re
s=open('/mnt/user-data/uploads/GoGrab__crew_screen.html').read()
def split_top(body):
    out=[];d=0;cur='';q=None;i=0
    while i<len(body):
        ch=body[i]
        if q:
            cur+=ch
            if ch=='\\': cur+=body[i+1]; i+=1
            elif ch==q: q=None
        else:
            if ch in '`\'"': q=ch;cur+=ch
            elif ch in '([{': d+=1;cur+=ch
            elif ch in ')]}': d-=1;cur+=ch
            elif ch==',' and d==0: out.append(cur);cur=''
            else: cur+=ch
        i+=1
    if cur.strip(): out.append(cur)
    return [x.strip() for x in out if x.strip()]
def grab(start,end):
    a=s.index(start)+len(start); b=s.index(end,a); return s[a:b]
def dstr(expr):
    res='';i=0
    while i<len(expr):
        ch=expr[i]
        if ch=='`':
            j=i+1;buf=''
            while expr[j]!='`':
                if expr[j]=='\\': buf+=expr[j:j+2]; j+=2; continue
                buf+=expr[j]; j+=1
            buf=buf.replace("'","\\'")
            res+="'"+buf+"'"; i=j+1
        else: res+=ch; i+=1
    return res
def kv(item):
    k,v=item.split(':',1); return k.strip().strip("'"),v.strip()
out=["// GENERATED from the HTML prototype. Do not edit by hand.","// ignore_for_file: prefer_single_quotes, unnecessary_string_escapes","const String kK='#1B1717',kR='#810000',kC='#EEEBDD',kG='#B9B1A0';","String s(String d,[Object? f,String? st,num? w])=>'<path d=\"$d\" fill=\"${(f==null||f==0)?'none':f}\"${st!=null?' stroke=\"$st\" stroke-width=\"${w??4}\"':''} stroke-linejoin=\"round\" stroke-linecap=\"round\"/>';"]
sh=re.search(r"SH='([^']*)',CP='([^']*)'",s); out.append(f"const String SH='{sh.group(1)}',CP='{sh.group(2)}';")
def fixcalls(t):
    return re.sub(r"\bK\b","kK",re.sub(r"\bR\b","kR",re.sub(r"\bC\b","kC",re.sub(r"\bG\b","kG",t))))
def mapdart2(name,body):
    items=split_top(body); L=[f"final Map<String,String> {name}={{"]
    for it in items:
        k,v=kv(it); v=dstr(v)
        v=v.replace("${K}","$kK").replace("${R}","$kR").replace("${C}","$kC").replace("${G}","$kG")
        parts=re.split(r"('(?:[^'\\]|\\.)*')",v)
        v=''.join(p if p.startswith("'") else fixcalls(p) for p in parts)
        L.append(f"  '{k}': {v},")
    L.append("};"); return "\n".join(L)
P=grab("const P={","};\nconst EY"); EY=grab("const EY={","};\nconst MO"); MO=grab("const MO={","};\nconst BK")
out.append(mapdart2('P',P)); out.append(mapdart2('EY',EY)); out.append(mapdart2('MO',MO))
bk=re.search(r"const BK=new Set\(\[(.*?)\]\)",s).group(1); out.append(f"const Set<String> BK={{{bk}}};")
Fb=grab("const F=[","];\nconst SEC")
out.append("final List<List<Object>> F=<List<Object>>["+Fb+"];")
sec=re.search(r"const SEC=\[(.*?)\];",s).group(1); out.append(f"const List<String> SEC=[{sec}];")
ic0=grab("const IC={","};\nconst ic=")
ics=[("IC0",ic0)]
for m in re.finditer(r"Object\.assign\(IC,\{(.*?)\}\);",s,re.S): ics.append(("X",m.group(1)))
out.append("final Map<String,String> IC={};")
out.append("void initIcons(){")
for _,b in ics:
    for it in split_top(b):
        k,v=kv(it); v=v.strip()
        assert v[0]=="'" and v[-1]=="'",(k,v[:30])
        out.append(f"  IC['{k}']={v};")
out.append("}")
open('/home/claude/flutter_out/lib/core/svg_data.dart','w').write("\n".join(out)+"\n")
print(len(P),len(ics),[len(split_top(b)) for _,b in ics])
