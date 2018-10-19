import re
import sys
import urllib.request

s = list()
ANNOUNCED_RE = re.compile('[0-9]{4}-[0-9]{2}-[0-9]{2}')
CVE_RE = re.compile('CVE-[0-9]{4}-[0-9]{4,}')
HTML_RE = re.compile('<[^<]+?>')
CLEAN_RE = re.compile('(\]|\[|\: |\- |\$)')

def clean_match(text):
    """ Clean up the text by removing matches in CLEAN_RE. """
    return CLEAN_RE.sub('', text)

with open("../spec/data/cve-skeleton.yml", "r") as f:
	s = f.readlines()
	skel = s.copy()
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
			print("{} has no date".format(cve_id))
			continue
		cve_path = "../cves/{:s}.yml".format(cve_id)
		skel[24] = "announced: {}\n".format(announced)
		skeleton = "".join(skel)
		with open("../cves/" + cve_id + ".yml", "w") as f:
			f.write(skeleton)
		print(" Updated CVE: {:s}".format(cve_path))
