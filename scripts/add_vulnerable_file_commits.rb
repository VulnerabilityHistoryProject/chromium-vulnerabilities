require 'git'
require 'json'
require 'logger'
require 'optparse'
require 'pp'
require 'yaml'
require_relative 'git_saver'

options = {}
options[:gitlog_json] = 'commits/gitlog.json'
options[:repo] = 'tmp/src'
options[:cves] = 'cves'
options[:skip_existing] = false

OptionParser.new do |opts|
  opts.banner = <<~EOS
  Usage: add_vulnerable_file_commits.rb \
    --gitlog commits/gitlog.json \
    --repo tmp/src
    --skip-existing
  EOS
  opts.on('--gitlog g',
          'Location of the gitlog.json file to append to') do |g|
    options[:gitlog_json] = g
  end
  opts.on('--repo r',
          'Path to the repository to get the commit data') do |r|
    options[:repo] = r
  end
  opts.on('--cves c',
          'Path to the CVE yml files') do |c|
    options[:cves] = c
  end
  opts.on('--skip-existing',
          'Path to the CVE yml files') do |skip|
    options[:skip_existing] = true
  end
end.parse!
puts "Adding commit with options: #{options}"

failed = []
filepaths = []
puts "Traversing CVE ymls"
shas = []
Dir["#{options[:cves]}/**/*.yml"].each do |file|
  yml = YAML.load(File.open(file))
  shas += yml['fixes'].map { |fix| fix[:commit] || fix['commit'] }
  shas.each do |sha|
    Dir.chdir('tmp/src') do
      filepaths << `git log --stat -1 --pretty="" --name-only #{sha}`.split
    end
  end
end
filepaths = filepaths.flatten.sort.uniq.delete_if {|f| f == 'DEPS' }

puts "Vulnerable files: #{filepaths}"

puts "Getting file edits for #{filepaths.size} files"
edit_shas = []
Dir.chdir('tmp/src') do
  filepaths.each do |filepath|
    puts "  running: git log --pretty=%H -- #{filepath}"
    edit_shas << `git log --pretty="%H" -- #{filepath}`.split
  end
end
edit_shas = edit_shas.flatten.uniq

puts "Getting git logs for #{edit_shas.size} commits"
saver = GitSaver.new(options[:repo], options[:gitlog_json])
edit_shas.each do |sha|
  begin
    saver.add(sha, options[:skip_existing])
  rescue
    puts "FAILED to add #{sha}"
    failed << sha
  end
  print '.'
end
saver.save

puts "The following commits could not be found:"
pp failed
