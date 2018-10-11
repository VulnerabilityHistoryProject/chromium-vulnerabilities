require 'git'

# A collection of utilitize to save thing to git
class GitSaver

  def initialize(repo, gitlog_json)
    @git = Git.open(repo)
    @gitlog_json = gitlog_json
    @gitlog = JSON.parse(File.read(gitlog_json))
  end

  # Lookup and save a commit
  def add(sha, skip_existing = true)
    if @gitlog.key? sha
      if skip_existing
        puts "#{sha} already exists in gitlog.json, skipping"
        return
      end
      puts "WARNING! Commit #{sha} already exists in gitlog.json. Will be overwritten."
    end

    @gitlog[sha] = {} # Even if it existed before, let's reset
    commit = @git.object(sha)
    diff = @git.diff(commit, commit.parent)
    @gitlog[sha][:commit]     = sha
    @gitlog[sha][:author]     = commit.author.name
    @gitlog[sha][:email]      = commit.author.email
    @gitlog[sha][:date]       = commit.author.date
    @gitlog[sha][:message]    = commit.message.
                                  gsub('\n', '\\n').
                                  gsub('"', '&quot')[0..2000]
    @gitlog[sha][:insertions] = diff.insertions
    @gitlog[sha][:deletions]  = diff.deletions
    @gitlog[sha][:churn]      = @gitlog[sha][:insertions].to_i +
                                @gitlog[sha][:deletions].to_i
    @gitlog[sha][:filepaths]  = diff.stats[:files]
  end

  def save
    File.open(@gitlog_json, 'w') do |file|
      file.write(@gitlog.to_json)
    end
  end

  # Similar method as above, but not adding file info
  def add_mega(sha, curator_note, skip_existing = true)
    if @gitlog.key? sha
      if skip_existing
        puts "#{sha} already exists in gitlog.json, skipping"
        return
      end
      puts "WARNING! Commit #{sha} already exists in gitlog.json. Will be overwritten."
    end

    @gitlog[sha] = {} # Even if it existed before, let's reset
    commit = @git.object(sha)
    @gitlog[sha][:commit]   = sha
    @gitlog[sha][:author]   = commit.author.name
    @gitlog[sha][:email]    = commit.author.email
    @gitlog[sha][:date]     = commit.author.date
    @gitlog[sha][:message]  = curator_note +
                                commit.message.
                                  gsub('\n', '\\n').
                                  gsub('"', '&quot')[0..2000]
    @gitlog[sha][:filepaths]  = {}
  end

end
