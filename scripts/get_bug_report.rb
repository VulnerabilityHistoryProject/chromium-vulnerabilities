require 'mechanize'
require 'date'
require 'json'
browser = Mechanize.new
cve = ARGV[0]
page = browser.get('https://cve.mitre.org/cgi-bin/cvename.cgi?name=' + cve)
mitre_links = page.links
for link in mitre_links
  keys = Array["CONFIRM:https://code.google.com/p/chromium/issues/detail?id=",
               "MISC:https://code.google.com/p/chromium/issues/detail?id=",
               "CONFIRM:https://crbug.com/", "MISC:https://crbug.com/"]
  if(link.text[0..(keys[0].length-1)] == keys[0] ||
      link.text[0..(keys[1].length-1)] == keys[1] ||
      link.text[0..(keys[2].length-1)] == keys[2] ||
      link.text[0..(keys[3].length-1)] == keys[3])
    bug_page = link
    break
  end
end
puts bug_page