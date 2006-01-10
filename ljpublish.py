import os, re, sys
import xml.dom.minidom

srcdir = sys.argv[1]
destdir = sys.argv[2]

outf = open("all.xml", "w")
outf.write("""<?xml version="1.0"?>\n""")
outf.write("<journal>\n")
fns = []
for fn in os.listdir(srcdir):
    if re.match("L-\d+$", fn):
        fns += [fn]
fns.sort(lambda a, b: cmp(int(a[2:]), int(b[2:])))
for fn in fns:
    f = open(srcdir+"/"+fn)
    s = f.readline()
    if s[:5] != "<?xml":
        outf.write(s)
    a = f.readlines()
    f.close()
    try:
        f = open(srcdir+"/C-"+fn[2:])
        f.readline()
        a = a[:len(a)-1] + f.readlines() + [a[-1]]
        f.close()
    except:
        pass
    outf.write(''.join(a))
outf.write("</journal>\n")
outf.close()

tags = {}

all = xml.dom.minidom.parse("all.xml")
for e in all.getElementsByTagName("event"):
    itemid = e.getElementsByTagName("itemid")
    if len(itemid) == 0:
        continue
    id = itemid[0].firstChild.data
    tagtag = e.getElementsByTagName("taglist")
    if len(tagtag) > 0:
        taglist = tagtag[0].firstChild.data.split(", ")
        for t in taglist:
            if tags.has_key(t):
                tags[t] += [id]
            else:
                tags[t] = [id]
f = open("tags.xml", "w")
f.write("""<?xml version="1.0"?>\n""")
f.write("<tags>\n")
for t in tags.keys():
    f.write("""<tag name="%s">\n""" % t)
    for i in tags[t]:
        f.write("<itemid>%s</itemid>\n" % i)
    f.write("</tag>\n")
f.write("</tags>\n")
f.close()

os.system("xt all.xml ljpublish.xsl %s/index.html" % destdir)
