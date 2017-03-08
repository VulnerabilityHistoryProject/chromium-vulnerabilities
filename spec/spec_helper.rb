
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

def cve_ymls
  Dir["#{cve_dir}/**/*.yml"].map
end

def cve_hash(file)
  YAML.load(File.open(file))
end

def git_log
  File.expand_path "#{File.dirname(__FILE__)}/../commits/gitlog.txt"
end

def git_log_has?(word)
  included = false
  File.open(git_log, 'r').each do |line|
    included ||= line.include? word
  end
  return included
end

def valid_git_hash_or_empty(str)
  str.nil? ||
    str.to_s.nil? ||
    str =~ /[0-9a-z]{40}/
end
