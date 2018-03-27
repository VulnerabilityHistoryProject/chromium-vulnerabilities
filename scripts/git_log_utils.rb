require_relative 'script_helpers'


class GitLogUtils

  def get_files_from_shas(fixes)
    files = []
    Dir.chdir('./tmp/src') do
      fixes.each do |sha|
        files << `git show --name-only --pretty='' #{sha}`.split("\n")
      end
    end
    return files.uniq
  end

end
