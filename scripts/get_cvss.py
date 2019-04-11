import re
import urllib.request
import os

CVSS2_RE = re.compile('AV:./AC:./Au:./C:./I:./A:.')
CVSS3_RE = re.compile('AV:./AC:./PR:./UI:./S:./C:./I:./A:.')
HTML_RE = re.compile('<[^<]+?>')
base_url = "https://nvd.nist.gov/vuln/detail/"

all_ymls = os.listdir('../cves')
for filename in all_ymls:
    cve = filename[:-4]
    print(cve)
    url = base_url + cve
    page = urllib.request.urlopen(url)
    contents = page.readlines()
    CVSS = ""
    for line in contents:
        line = HTML_RE.sub('', line.decode().strip("\n"))
        if CVSS3_RE.search(line):
            CVSS = line.strip()
        elif CVSS2_RE.search(line):
            CVSS = line.strip()

    with open('../cves/' + filename, "r") as f:
        file_contents = f.readlines()

    for i in range(len(file_contents)):
        if file_contents[i][:4] == "CWE:":
            break

    file_contents.insert(i+1, "CVSS: {}\n".format(CVSS))

    with open('../cves/' + filename, "w") as f:
        f.writelines(file_contents)
