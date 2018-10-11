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
  Usage: add_mentioned_commit.rb \
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

saver = GitSaver.new(options[:repo], options[:gitlog_json])
failed = []

puts "Traversing CVE ymls"
shas = []
Dir["#{options[:cves]}/**/*.yml"].each do |file|
  yml = YAML.load(File.open(file))
  shas += yml['fixes'].map { |fix| fix[:commit] || fix['commit'] }
  shas += yml['vccs'].map  { |vcc| vcc[:commit] || vcc['commit'] }
  shas += yml['interesting_commits']['commits'].map  { |c| c[:commit] || c['commit'] }
end

puts "Handling known 'mega' commits"
megas = YAML.load(File.open('commits/mega-commits.yml')) || []
megas.each do |mega|
  shas.delete mega['commit']
  saver.add_mega(mega['commit'],
                 mega['note'],
                 options[:skip_existing])
end

puts "Getting git logs"
shas.uniq.reject { |sha| sha.to_s.empty? }.each do |sha|
  # puts "Attempting to add: #{sha}"
  begin
    saver.add(sha, options[:skip_existing])
    print '.'
  rescue StandardError => e
    puts "\nFAILED to add #{sha}. #{e}\n"
    failed << sha
  end
end
saver.save

puts "The following commits could not be found:"
pp failed
