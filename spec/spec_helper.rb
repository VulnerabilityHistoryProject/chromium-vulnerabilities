
RSpec.configure do |config|
  config.tty = true
  config.color = true
end

def cve_dir
  File.expand_path "#{File.dirname(__FILE__)}/../cves"
end

def cve_yml(cve)
  File.expand_path "#{File.dirname(__FILE__)}/../cves/#{cve}.yml"
end
