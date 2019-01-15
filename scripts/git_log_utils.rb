require_relative 'script_helpers'
require 'git'

class GitLogUtils

  def initialize(repo)
    @git = Git.open(repo)
  end

  def get_files_from_shas(fixes)
    files = []
    fixes.each do |sha|
      commit = @git.object(sha)
      diff = @git.diff(commit, commit.parent)
      files << diff.stats[:files].keys
    rescue #catch file not found exception
    end
    return files.flatten.uniq
  end

end
