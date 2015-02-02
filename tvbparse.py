#!/usr/bin/env python
# -*- coding: utf-8 -*-

# inputfile = open("wikidump.xml").read()

# soup = BeautifulSoup(inputfile)
# z = soup.find_all("page")
# str(z[1].text)


# x = re.split("==.+==", z[1].text)
# x[4]

import urllib2
from bs4 import BeautifulSoup

page = urllib2.urlopen("http://zh.wikipedia.org/zh-hk/女人最痛").read()
page = urllib2.urlopen("http://zh.wikipedia.org/zh-hk/老表，你好嘢！_(電視劇)").read()

x = BeautifulSoup(page)

for i in x.find_all("table")[7].find_all("tr"):
    if len(i.find_all("td")) != 2:
        print i.find("td").get_text()
g = x.find_all("table")

#print g[0].find_all("tr")[0].find("td") is None
def checkActors(x):
    if x.find_all("tr")[0].find("td") is not None:
        #print "Good"
        return x.find_all("tr")[0].find("td").get_text() == "演員".decode('utf-8')
#        return x.find_all("tr")[0].find("td").get_text() == u"演員"
    else:
        return False


actorTabs = filter(checkActors, g)

def extractActors(actorTab):
    res = []
    for i in actorTab.find_all("tr"):
        if len(i.find_all("td")) != 2:
            if i.find("td").get_text() != "演員".decode('utf-8'):
                 res.append(i.find("td").get_text())
        else:
            if i.find("td").find("a"):
                #print "find a, maybe actor"
                # actor
                res.append(i.find("td").get_text())
    return res




alla= reduce(lambda x, y: x+y, map(extractActors, actorTabs))


def extractInfobox(x):
    infobox = x.find("table", attrs = {"class":"infobox"})
    infobox_alllines = infobox.find_all("tr")
    for line in infobox_alllines:
        if line.find("th") is not None:
            if line.find("th").get_text() == "類型".decode('utf-8'):
                genre = line.find('td').get_text()
            if line.find("th").get_text() == "集數".decode('utf-8'):
                noepi = line.find('td').get_text()
            if line.find("th").get_text() == "監製".decode('utf-8'):
                direct = line.find('td').get_text()
    return {"genre": genre, "noepi": noepi, "direct": direct}


extractInfobox(x)


import re
import time

def getalldrama(year):
    print year
    time.sleep(2)
    t = "http://zh.wikipedia.org/wiki/%E7%BF%A1%E7%BF%A0%E5%8F%B0%E9%9B%BB%E8%A6%96%E5%8A%87%E9%9B%86%E5%88%97%E8%A1%A8_%28" + str(year) + "%E5%B9%B4%29"
    dramalistraw = urllib2.urlopen(t).read()
    dramalist = BeautifulSoup(dramalistraw)
    d = dramalist.find("table", attrs = {"class": "navbox"})
    q = filter(lambda x: x.find("th", attrs = {"class":"navbox-group", "scope": "row"}), d.find_all("tr"))
    r = []
    for x in q:
        if re.search(ur"黃金時段|線劇集", x.find("th").get_text()):
            if re.search(ur"非", x.find("th").get_text()) is None:
                r.append(x)
    res = []
    for g in range(0, len(r)):
        for a in r[g].find_all("a"):
            res.append({"type":g, "name": a.get_text(), "link": a['href'], "year": year})
    return res

alldramas = reduce(lambda x, y: x+y, [getalldrama(year) for year in range(2004, 2015)])

#大長今
#醫道
# should be removed

alldramas = [i for i in alldramas if i['name'] != "大長今".decode('utf-8') and i['name'] != "醫道".decode('utf-8')]

import pickle
pickle.dump(alldramas, open("alldramas.p", "wb"))
