#!/usr/bin/env python3

import os
import re
import sys
import urllib.request
from time import strptime

# Regular Expressions
CVE_RE = re.compile('CVE-[0-9]{4}-[0-9]{4,}')
HTML_RE = re.compile('<[^<]+?>')
BOUNTY_RE = re.compile('\[\$([0-9\.]|TBD|N/A)+\]')
BUG_RE = re.compile('\[[0-9]+\]')
DESCRIPTION_RE = re.compile('[:-]{0,1} [^\.]*(\.|\s)')
CLEAN_RE = re.compile('(\]|\[|\: |\- |\$)')
ANNOUNCED_RE = re.compile('[0-9]{4}-[0-9]{2}-[0-9]{2}')
DATE_RE = re.compile('\w+, \w+ ([0-9]{1}|[0-9]{2}), [0-9]{4}')
CVSS2_RE = re.compile('AV:./AC:./Au:./C:./I:./A:.')
CVSS3_RE = re.compile('AV:./AC:./PR:./UI:./S:./C:./I:./A:.')


def format_date(publish_date):
    fields = publish_date.split()
    sub = fields[1][:3]
    month = str(strptime(sub,'%b').tm_mon)
    if len(month) == 1:
        month = '0' + month
    year = fields[3]
    day = fields[2][:-1]
    if len(day) == 1:
        day = '0' + day
    return "{}-{}-{}".format(year, month, day)


SKELETON = list()
with open("../spec/data/cve-skeleton.yml", "r") as f:
    SKELETON = f.readlines()

def get_skeleton(cve, description, bounty, bug, announced, CVSS):
    """ Return the skeleton of a CVE with the given fields filled. """
    global SKELETON
    skeleton = SKELETON.copy()
    for i in range(len(skeleton)):
        if skeleton[i] == "CVE:\n":
            skeleton[i] = "CVE: {:s}\n".format(cve)
        elif skeleton[i] == "description: |\n":
            skeleton[i] = "description: |\n  {:s}\n".format(description)
        elif skeleton[i] == "bugs: []\n":
            skeleton[i]= "bugs: [{:s}]\n".format(bug)
        elif skeleton[i] == "CVSS:\n":
            skeleton[i] = "CVSS: {:s}\n".format(CVSS)
        elif skeleton[i] == "  amt:\n":
            if bounty == "N/A":
                skeleton[i] = "  amt: 0\n"
            elif bounty == "TBD":
                skeleton[i+1] = "  announced: TBD\n"
            else:
                skeleton[i] = "  amt: {:s}\n".format(bounty)
        elif skeleton[i] == "announced:\n":
            skeleton[i] = "announced: {:s}\n".format(announced)

    return "".join(skeleton)

def clean_line(line):
    """ Decode bytestrings and string newlines. """
    return line.decode().strip("\n")

def clean_match(text):
    """ Clean up the text by removing matches in CLEAN_RE. """
    return CLEAN_RE.sub('', text)

def get_page(url):
    """ Return the raw HTML of the given URL. """
    return urllib.request.urlopen(url)

if __name__ == "__main__":
    url = sys.argv[1]
    page = get_page(url)
    contents = page.readlines()
    matches = list()
    publish_date = ""
    for line in contents:
        line = HTML_RE.sub('', clean_line(line))
        if CVE_RE.search(line):
            matches.append(line)
        if DATE_RE.search(line) and not publish_date:
            publish_date = line

    matches = list(set(matches))
    # For each CVE...
    for cve in matches:
        # Parse out the fields we care about...
        try:
            bounty = clean_match(BOUNTY_RE.search(cve).group(0))
        except:
            bounty = ""

        # The current CVE that matched might be a comment someone left on the
        # chromium blog
        try:
            bug_id = clean_match(BUG_RE.search(cve).group(0))
        except:
            continue
        cve_id = clean_match(CVE_RE.search(cve).group(0))
        try:
            description = clean_match(DESCRIPTION_RE.search(cve).group(0))
        except:
            print("ERROR: Regex failed for Description in " + str(cve_id))
        try:
        	announced = clean_match(ANNOUNCED_RE.search(cve).group(0))
        except:
            announced = format_date(publish_date)

        base_url = "https://nvd.nist.gov/vuln/detail/"
        url = base_url + cve_id
        print(url)
        page = urllib.request.urlopen(url)
        contents = page.readlines()

        CVSS = ""
        for line in contents:
            line = HTML_RE.sub('', line.decode().strip("\n"))
            if CVSS3_RE.search(line):
                CVSS = line.strip()
            elif CVSS2_RE.search(line):
                CVSS = line.strip()

        # And write the new CVE to disk.
        cve_path = "../cves/{:s}.yml".format(cve_id)
        if os.path.exists(cve_path):
            print("Skipping CVE: {:s}.".format(cve_id))
        else:
            skeleton = get_skeleton(cve_id, description, bounty, bug_id, announced, CVSS)
            with open("../cves/" + cve_id + ".yml", "w") as f:
                f.write(skeleton)
            print(" Created CVE: {:s}".format(cve_path))
