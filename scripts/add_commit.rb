require 'git'
require 'optparse'
require 'logger'
require 'json'
require_relative 'git_saver'

options = {}
options[:gitlog_json] = 'commits/gitlog.json'
options[:repo] = 'tmp/src'

OptionParser.new do |opts|
  opts.banner = <<~EOS
  Usage: add_commit.rb \
    --sha commit_sha_to_add \
    --gitlog commits/gitlog.json \
    --repo tmp/src
  EOS
  opts.on('--gitlog g',
          'Location of the gitlog.json file to append to') do |g|
    options[:gitlog_json] = g
  end
  opts.on('--sha s',
          'The SHA of the commit to add') do |sha|
    options[:sha] = sha
  end
  opts.on('--repo r',
          'Path to the repository to get the commit data') do |r|
    options[:repo] = r
  end
end.parse!
puts "Adding commit with options: #{options}"

saver = GitSaver.new(options[:repo], options[:gitlog_json])
saver.add options[:sha]
saver.save
