require 'git'
require 'json'
require 'logger'
require 'optparse'
require 'pp'
require 'yaml'
require 'pry'
require 'parallel'
require 'active_support/core_ext/hash'
require_relative 'git_log_utils'
require_relative 'weekly_report'

options = {}
options[:weeklies] = 'commits/weeklies'
options[:repo] = 'tmp/src'
options[:cves] = 'cves'
options[:skip_existing] = false

OptionParser.new do |opts|
  opts.banner = <<~EOS
  Usage: generate_weeklies.rb \
    --repo tmp/src
    --cves cves
    --weeklies commits/weeklies
    --skip-existing
  EOS
  opts.on('--repo r',
          'Path to the repository to get the commit data') do |r|
    options[:repo] = r
  end
  opts.on('--cves c',
          'Path to the CVE yml files') do |c|
    options[:cves] = c
  end
  opts.on('--weeklies c',
          'Path to the outgoing weeklies files') do |w|
    options[:weeklies] = w
  end
  opts.on('--skip-existing',
          'Path to the CVE yml files') do |skip|
    options[:skip_existing] = true
  end
end.parse!
puts "Executing with options: #{options}"

git_utils = GitLogUtils.new(options[:repo])

puts "Generating weekly reports"
weekly_reporter = WeeklyReport.new(options)
ymls = Dir["#{options[:cves]}/**/*.yml"].to_a
Parallel.each(ymls, in_processes: 8, progress: 'Generating weeklies') do |file|
#ymls.each do |file|
  yml = YAML.load(File.open(file)).deep_symbolize_keys
  fix_commits = yml[:fixes].inject([]) do |memo, fix|
    memo << fix[:commit] unless fix[:commit].blank?
    memo
  end
  begin
    offenders = git_utils.get_files_from_shas(fix_commits)
  rescue
    puts "ERROR #{file}: could not get files for #{fix_commits}"
  end
  weekly_reporter.add(yml[:CVE], offenders)
  # print '.'
end
