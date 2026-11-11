"""New portfolio figure generation from thesis aggregates; not original statistical analysis.
Standard library only. Run from any working directory: python scripts/make_figures.py
"""
import csv
from pathlib import Path
from html import escape
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets'
def read(name):
    with (ROOT/'data'/name).open(encoding='utf-8',newline='') as f:
        return list(csv.DictReader(f))
def text(x,y,s,size=16,fill='#152e41',weight='400'):
    return f'<text x="{x}" y="{y}" font-family="system-ui, sans-serif" font-size="{size}" fill="{fill}" font-weight="{weight}">{escape(str(s))}</text>'
def rect(x,y,w,h,c,rx=0):
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{c}"/>'
def save(name,w,h,body,title,desc):
    s=f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" role="img" aria-labelledby="title desc"><title id="title">{escape(title)}</title><desc id="desc">{escape(desc)}</desc><rect width="100%" height="100%" fill="white"/>'+body+'</svg>'
    (OUT/name).write_text(s,encoding='utf-8')
scores=read('score-summary.csv')
assert len(scores)==2 and all(int(r['n'])==15 for r in scores)
assert [float(r['mean']) for r in scores]==[14.27,16.93]
b=text(20,30,'Written assessment · score / 20',21,weight='650')
for i,(stat,label) in enumerate([('median','Median · primary summary'),('mean','Mean · complementary summary')]):
    y=65+i*138
    b+=text(20,y,label,16,weight='650')
    for j,r in enumerate(scores):
        yy=y+18+j*43;value=float(r[stat]);b+=text(20,yy+20,r['phase'],14)
        b+=rect(180,yy,500,25,'#edf2f4',3)+rect(180,yy,value*25,25,['#617f94','#146675'][j],3)
        b+=text(190+value*25,yy+19,r[stat],15,weight='650')
for tick in range(0,21,5):b+=text(175+tick*25,337,tick,13,'#506775')
b+=text(20,370,'N = 15 paired participants · Source: thesis Table 4.2',13,'#506775')
save('assessment.svg',760,395,b,'Written questionnaire medians and means','Median: 14 before, 17 after. Mean: 14.27 before, 16.93 after. Scale 0 to 20. No uncertainty intervals.')
rows=read('strategy-origins.csv'); cats=['spontaneous','peer_prompted','teacher_prompted','not_observable'];colors=['#146675','#6586a0','#b87a29','#e0e4e7']
assert len(rows)==3 and all(sum(int(r[k]) for k in cats)==int(r['total'])==90 for r in rows)
assert [sum(int(r[k]) for r in rows) for k in cats]==[188,52,19,11]
b=text(20,30,'Strategy origin by game session',21,weight='650')
for i,r in enumerate(rows):
    y=70+i*64; x=195
    b+=text(12,y+23,['FracciChef','Dominó Fraccionario','FraccUNO'][i],14)
    for k,c in zip(cats,colors):
        n=int(r[k]);w=n/90*480
        b+=rect(x,y,w,35,c)
        if w>=25:b+=text(x+w/2-7,y+24,n,13,'white' if k in ('spontaneous','peer_prompted','teacher_prompted') else '#152e41',weight='600')
        x+=w
labels=['Spontaneous','Peer-prompted','Teacher-prompted','Not observable']
for i,(c,l) in enumerate(zip(colors,labels)):
    x=20+(i%2)*340;y=295+(i//2)*27;b+=rect(x,y-12,14,14,c)+text(x+23,y,l,14)
b+=text(20,360,'Each bar = 90 criterion ratings, from the same 15 pupils; not independent cases.',13,'#516474')
save('strategy-origins.svg',760,386,b,'Strategy-origin counts in three game sessions','FracciChef: 56 spontaneous, 22 peer, 9 teacher, 3 not observable. Domino: 68,16,4,2. FraccUNO: 64,14,6,6. Each totals 90.')
b=text(20,30,'One class. Complementary sources of evidence.',21,weight='650')
for x,title,lines in [(20,'S1 / Establish baseline',['Written questionnaire','22 pupils; select 15 for follow-up']), (20,'S2–S4 / Observe reasoning',['Three fraction games','Game-specific rubrics + field notes']), (20,'S5 / Assess after the sequence',['25 min free play + 25 min questionnaire','15 paired assessment records'])]:
    i=['S1 / Establish baseline','S2–S4 / Observe reasoning','S5 / Assess after the sequence'].index(title);y=62+i*110
    b+=rect(x,y,720,88,'#f0f5f7',5)+rect(x,y,5,88,'#166c79')+text(x+20,y+27,title,18,weight='650')+text(x+20,y+51,lines[0],15)+text(x+20,y+72,lines[1],14,'#516474')
    if i<2:b+=text(370,y+104,'↓',19,'#166c79')
b+=text(20,420,'Single-group design · No control group · No delayed follow-up',14,'#516474')
save('study-design.svg',760,445,b,'Five-session single-group study design','Baseline followed by three games and a final session with free play and post-assessment. No control group or delayed follow-up.')
print('Verified aggregate totals; generated 3 SVG figures.')

# Additional figures for the revised portfolio. These are rule illustrations,
# not original artwork, participant responses, or new research observations.
b=text(20,28,'FracciChef · one requirement, two valid routes',19,weight='650')
b+=rect(20,54,720,62,'#f2f7f8',6)+text(40,91,'Recipe requires: 2/4 of one ingredient',21,weight='650')
for y,label,expr in [(145,'Option A','1/4  +  1/4  =  2/4'),(231,'Option B','1/2  =  2/4')]:
    b+=text(25,y,label,14,'#506775')+rect(155,y-27,565,58,'#f2f7f8',6)+text(180,y+10,expr,26,'#146675',weight='650')
save('fraccichef-example.svg',760,292,b,'FracciChef equivalent ingredient combinations','One requirement of two quarters can be met by two quarter cards or one half card.')
b=text(20,28,'Dominó Fraccionario · connect equivalent quantities',19,weight='650')
b+=rect(45,70,210,125,'#f2f7f8',8)+rect(62,87,87,90,'#146675')+rect(149,87,87,90,'#dfe9ed')
b+='<rect x="62" y="87" width="174" height="90" fill="none" stroke="#163344" stroke-width="2"/>'
b+=text(316,151,'=',40,'#146675',weight='650')+rect(405,70,240,125,'#f2f7f8',8)+text(480,150,'2/4',42,'#146675',weight='650')
b+=text(72,229,'1 of 2 equal parts',17,'#506775')+text(437,229,'Equivalent value',17,'#506775')
save('domino-example.svg',760,266,b,'Visual-symbolic fraction equivalence','One half shaded rectangle equals two quarters. New illustration of a documented rule.')
b=text(20,28,'FraccUNO · choose between legal moves',19,weight='650')
for x,y,c,value,label in [(20,72,'#225c9a','1/2','In play'),(280,72,'#225c9a','3/4','Colour match'),(535,72,'#a23e45','2/4','Equivalent value')]:
    b+=rect(x,y,180,130,c,8)+text(x+43,y+78,value,40,'white',weight='650')+text(x,y+159,label,17,'#506775')
b+=text(223,146,'→',30,'#146675')+text(481,146,'or',19,'#506775')
save('fraccuno-example.svg',760,272,b,'Two legal FraccUNO moves','A blue half card can be followed by a blue three quarters card or a red two quarters card. Labels distinguish colour matching and equivalent value.')

# Narrow figures avoid shrinking data labels to unreadable sizes on phones.
b=text(16,26,'Written assessment · score / 20',17,weight='650')
for i,(stat,label) in enumerate([('median','Median'),('mean','Mean')]):
    y=62+i*160;b+=text(16,y,label,18,weight='650')
    for j,r in enumerate(scores):
        yy=y+20+j*53;v=float(r[stat]);b+=text(16,yy+15,r['phase'],14)
        b+=rect(16,yy+24,300,12,'#edf2f4',3)+rect(16,yy+24,v*15,12,['#617f94','#146675'][j],3)+text(326,yy+35,r[stat],14,weight='650')
for t in range(0,21,5):b+=text(12+t*15,377,t,12,'#506775')
b+=text(16,408,'N = 15 paired participants',13,'#506775')
save('assessment-mobile.svg',390,430,b,'Written assessment scores','Median 14 to 17, mean 14.27 to 16.93. Score out of 20. Source: thesis Table 4.2.')
b=text(16,26,'Strategy origin by session',18,weight='650')
for i,r in enumerate(rows):
    y=68+i*120;b+=text(16,y,['FracciChef','Dominó Fraccionario','FraccUNO'][i],17,weight='650');x=16
    for k,c in zip(cats,colors):
        n=int(r[k]);w=n/90*350;b+=rect(x,y+16,w,31,c)
        if w>21:b+=text(x+w/2-5,y+37,n,13,'white' if k!='not_observable' else '#163344')
        x+=w
    b+=text(16,y+72,' / '.join(str(r[k]) for k in cats)+' · total 90',14,'#506775')
for i,(c,l) in enumerate(zip(colors,labels)):
    yy=440+i*29;b+=rect(16,yy-12,15,15,c)+text(41,yy,l,15)
b+=text(16,568,'Same 15 pupils · repeated criterion ratings',13,'#506775')
save('strategy-origins-mobile.svg',390,590,b,'Strategy-origin counts','Counts in category order spontaneous, peer-prompted, teacher-prompted, not observable. FracciChef 56/22/9/3; Dominó 68/16/4/2; FraccUNO 64/14/6/6.')
print('Generated 8 figures: 3 study charts, 3 game examples and 2 narrow charts.')
