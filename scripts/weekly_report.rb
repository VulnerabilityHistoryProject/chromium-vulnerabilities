require 'active_support/core_ext/hash'

class WeeklyReport
  def initialize(options)
    @git = Git.open(options[:repo])
    @repo_dir = options[:repo]
    @skip_existing = options[:skip_existing]
  end

  def add(cve, offenders)
    return if offenders.blank?
    Dir.chdir(@repo_dir) do
      output = `git log -- #{offenders.join(' ')}`
      binding.pry

    end
  end
end
