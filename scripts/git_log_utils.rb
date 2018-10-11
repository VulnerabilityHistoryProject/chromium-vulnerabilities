require_relative 'script_helpers'


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
    end
    return files.flatten.uniq
  end

end
