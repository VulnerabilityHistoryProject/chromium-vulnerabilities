import re
import sys
import urllib.request
from time import strptime

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


s = list()
ANNOUNCED_RE = re.compile('[0-9]{4}-[0-9]{2}-[0-9]{2}')
CVE_RE = re.compile('CVE-[0-9]{4}-[0-9]{4,}')
HTML_RE = re.compile('<[^<]+?>')
CLEAN_RE = re.compile('(\]|\[|\: |\- |\$)')
DATE_RE = re.compile('\w+, \w+ ([0-9]{1}|[0-9]{2}), [0-9]{4}')

def clean_match(text):
    """ Clean up the text by removing matches in CLEAN_RE. """
    return CLEAN_RE.sub('', text)

url = sys.argv[1]
page = urllib.request.urlopen(url)
contents = page.readlines()
matches = list()
publish_date = ""
for line in contents:
    line = HTML_RE.sub('', line.decode().strip("\n"))
    if CVE_RE.search(line):
        matches.append(line)
    if DATE_RE.search(line) and not publish_date:
        publish_date = line

matches = list(set(matches))
print (matches)
# For each CVE...
for cve in matches:
    cve_id = clean_match(CVE_RE.search(cve).group(0))
    try:
    	announced = clean_match(ANNOUNCED_RE.search(cve).group(0))
    except:
        announced = format_date(publish_date)
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
