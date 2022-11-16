#!/bin/usr/env python3.9
import re 
import sys

class citeTitle2Cite(object):
    def __init__(self, page):
        self._bib = None
        with open("output/documentRef.bib", "r") as f: self._bib = f.readlines()
        self._b = "\n".join(self._bib)
        # never change this to page/{foo}, very important
        # this will clobber files
        with open("output/"+page+".tex", "r") as f: self._page = f.readlines()
        self._p = "\n".join(self._page)

    def findCiteTitle(self, entry=None):
        if not entry:
            entry = self._p
        # create list of tuples
        # m[n][0] is \citeTitle{foo}
        # m[n][1] is foo
        m = re.findall("(\\\citetitle{\s?([a-zA-Z0-9]+)\s?})", entry)
        return m

    def buildBibTitleDict(self):
        d = {}
        # create a list entry for each bib item
        b = [x for x in self._b.strip().split("@") if x]
        b = [x[x.index("{") + 1:] for x in b]
        for entry in b:
            bib = [e.strip() for e in re.split(",\s?\n", entry)]
            key = None 
            value = None
            for field in bib:
                if field and "=" not in field:
                    key = field.strip()
                else:
                    if "title" in field.lower():
                        value = field[field.index("{") : ]
                if key and value:
                    d[key] = value
                    key = None 
                    value = None
        return d

    def replaceAll(self):
        d = self.buildBibTitleDict()
        #c = self.findCiteTitle()
        #result = [line.replace() for line in self._page]
        newPage = []
        for l1 in self._page:
            m = self.findCiteTitle(l1)
            if m:
                l2 = l1.replace(m[0][0], d[m[0][1]] )
                newPage.append(l2)
            else:
                newPage.append(l1)
        return "".join(newPage)


if __name__ == "__main__":
    page = sys.argv[1]
    c = citeTitle2Cite(page)
    d = c.buildBibTitleDict()
    #print(d)
    t = c.findCiteTitle()
    #print(t)
    #print("\n\n\n\n\n")
    #print(c.replaceAll())
    contents = c.replaceAll()
    with open("output/"+page+".tex", "w") as f:
        f.write(contents)
    #print(sys.argv[1])
