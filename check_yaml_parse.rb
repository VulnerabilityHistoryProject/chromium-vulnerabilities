require 'yaml'

hash = YAML.load(File.open('cves/CVE-2011-3092.yml'))
puts hash
puts "Done!"
