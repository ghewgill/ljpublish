import os, sys

srcdir = sys.argv[1]
destdir = sys.argv[2]

outf = open("all.xml", "w")
outf.write("""<?xml version="1.0"?>\n""")
outf.write("<journal>\n")
fns = []
for fn in os.listdir(srcdir):
    fns += [fn]
fns.sort(lambda a, b: cmp(int(a[2:]), int(b[2:])))
for fn in fns:
    f = open(srcdir+"/"+fn)
    s = f.readline()
    if s[:5] != "<?xml":
        outf.write(s)
    for s in f:
        outf.write(s)
    f.close()
outf.write("</journal>\n")
outf.close()

os.system("xt all.xml ljpublish.xsl %s/index.html" % destdir)
