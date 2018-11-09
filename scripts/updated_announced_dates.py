import re
import sys
import urllib.request

s = list()
ANNOUNCED_RE = re.compile('[0-9]{4}-[0-9]{2}-[0-9]{2}')
CVE_RE = re.compile('CVE-[0-9]{4}-[0-9]{4,}')
HTML_RE = re.compile('<[^<]+?>')
CLEAN_RE = re.compile('(\]|\[|\: |\- |\$)')
DATE_RE = re.compile('\w, \w [0-9]{2}, [0-9]{4}')

def clean_match(text):
    """ Clean up the text by removing matches in CLEAN_RE. """
    return CLEAN_RE.sub('', text)

url = sys.argv[1]
page = urllib.request.urlopen(url)
contents = page.readlines()
matches = list()
for line in contents:
    line = HTML_RE.sub('', line.decode().strip("\n"))
    if CVE_RE.search(line):
        matches.append(line)

matches = list(set(matches))
print (matches)
# For each CVE...
for cve in matches:
    cve_id = clean_match(CVE_RE.search(cve).group(0))
    try:
    	announced = clean_match(ANNOUNCED_RE.search(cve).group(0))
    except:
        announced = clean_match(DATE_RE.search(csv).group(0))
    	print("{} has no date".format(cve_id))
    	continue
    cve_path = "../cves/{:s}.yml".format(cve_id)
    new = "announced: {}\n".format(announced)
    with open("../cves/" + cve_id + ".yml", "r") as f:
        contents = f.readlines()

    for i in range(len(contents)):
        if ("announced: \n" == contents[i]):
            contents[i] = new

    with open("../cves/" + cve_id + ".yml", "w") as f:
        f.writelines(contents)

    print(" Updated CVE: {:s}".format(cve_path))
