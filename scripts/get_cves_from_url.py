#!/usr/bin/env python3

import os
import re
import sys
import urllib.request

# Regular Expressions
CVE_RE = re.compile('CVE-[0-9]{4}-[0-9]{4,}')
HTML_RE = re.compile('<[^<]+?>')
BOUNTY_RE = re.compile('\[\$([0-9\.]|TBD|N/A)+\]')
BUG_RE = re.compile('\[[0-9]+\]')
ANNOUNCED_RE = re.compile('[0-9]{4}-[0-9]{2}-[0-9]{2}')
DESCRIPTION_RE = re.compile('[:-]{0,1} [^\.]*(\.|\s)')
CLEAN_RE = re.compile('(\]|\[|\: |\- |\$)')

SKELETON = list()
with open("./spec/data/cve-skeleton.yml", "r") as f:
    SKELETON = f.readlines()

def get_skeleton(cve, description, bounty, bug, announced):
    """ Return the skeleton of a CVE with the given fields filled. """
    global SKELETON
    skeleton = SKELETON.copy()
    skeleton[0] = "CVE: {:s}\n".format(cve)
    skeleton[16] = "description: |\n  {:s}\n".format(description)
    skeleton[22] = "bugs: [{:s}]\n".format(bug)

    if bounty == "N/A":
        skeleton[18] = "  amt: 0\n"
    elif bounty == "TBD":
        skeleton[19] = "  announced: TBD\n"
    else:
        skeleton[18] = "  amt: {:s}\n".format(bounty)

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
    for line in contents:
        line = HTML_RE.sub('', clean_line(line))
        if CVE_RE.search(line):
            matches.append(line)

    matches = list(set(matches))
    # For each CVE...
    for cve in matches:
        # Parse out the fields we care about...
        try:
            bounty = clean_match(BOUNTY_RE.search(cve).group(0))
        except:
            bounty = ""
        bug_id = clean_match(BUG_RE.search(cve).group(0))
        cve_id = clean_match(CVE_RE.search(cve).group(0))
        announced = clean_match(ANNOUNCED_RE.search(cve).group(0))
        try:
            description = clean_match(DESCRIPTION_RE.search(cve).group(0))
        except:
            print("ERROR: Regex failed for Description in " + str(cve_id))

        # And write the new CVE to disk.
        cve_path = "./cves/{:s}.yml".format(cve_id)
        if os.path.exists(cve_path):
            print("Skipping CVE: {:s}.".format(cve_id))
        else:
            skeleton = get_skeleton(cve_id, description, bounty, bug_id)
            with open("./cves/" + cve_id + ".yml", "w") as f:
                f.write(skeleton)
            print(" Created CVE: {:s}".format(cve_path))
