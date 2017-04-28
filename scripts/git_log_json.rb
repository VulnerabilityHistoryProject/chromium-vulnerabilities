require 'git'
require 'optparse'
require 'logger'
require 'json'

options = {}
options[:environment] = '../'
options[:output] = '../commits/'

OptionParser.new do |opts|
  opts.banner = "Usage: pretty-print.rb -e environment -f firstcommit -l lastcommit"
  opts.on('-e v', '--environment v', 'Environment') {|v| options[:environment] = v}
  opts.on('-f f', '--firstcommit f', 'First Commit') {|f| options[:firstcommit] = f}
  opts.on('-l l', '--lastcommit l', 'Last Commit') {|l| options[:lastcommit] = l}
  opts.on('o o', '--outdir o', 'Output Dir') {|o| options[:output] = o}
end.parse!

g = Git.open(options[:environment])
if options[:firstcommit] && options[:lastcommit]
  commits = g.log.between(options[:firstcommit], options[:lastcommit]).to_a
  commits << g.object(options[:firstcommit])
else
  commits = g.log
end

commits_to_jsonify = []
commits.each do |x|
  # Get list of files and caculate their churn
  files_hash = {}
  stats = g.diff(x, x.parent.sha).stats
  g.gtree(x).diff(x.parent.sha).each do |f|
    file_churn = stats[:files][f.path]
    churn = file_churn[:insertions] + file_churn[:deletions]
    files_hash[f.path] = churn
  end
  c = {
    :commit => x,
    :author => x.author.name,
    :email => x.author.email,
    :date => x.author.date,
    :parent => x.parent.sha,
    :message => x.message.gsub('\n', '\\n').gsub('"', '&quot'),
    :insertions => g.diff(x, x.parent.sha).insertions,
    :deletions => g.diff(x, x.parent.sha).deletions,
    :filepaths => files_hash
  }
  commits_to_jsonify << c
end

File.open(options[:output] + 'gitlog.json', 'w') { |file| file.write(commits_to_jsonify.to_json)}
