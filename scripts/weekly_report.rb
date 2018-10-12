require 'active_support/core_ext/hash'
require 'byebug'

class WeeklyReport
  @@SECONDS_IN_WEEK = 604800
  @@START_DATE = Time.new(1991, 8, 5) # Monday before the birth of WWW

  def initialize(options)
    @git = Git.open(options[:repo])
    @repo_dir = options[:repo]
    @skip_existing = options[:skip_existing]
    @calendar = init_calendar(options[:weeklies])
  end

  def week_num(timestamp)
    ((timestamp - @@START_DATE) / @@SECONDS_IN_WEEK).to_i
  end

  def nth_week(i)
    @@START_DATE + (i * @@SECONDS_IN_WEEK).to_i
  end

  def init_calendar(weeklies_file)
    File.open(weeklies_file, 'a+') do |f|
      str = f.read
      JSON.parse(str.blank? ? '{}' : str)
    end
  end

  def init_weekly(n)
    {
      week: n,
      date: nth_week(n),
      commits: 0,
      insertions: 0,
      deletions: 0,
      developers: [],
      files: [],
      new_developers: [],
      ownership_change: false,
    }
  end

  # Append something to an array, then uniq the array
  def append_uniq!(weekly, key, element)
    weekly[key] = (weekly[key] << element).uniq
  end

  def add(cve, offenders)
    return if offenders.blank?
    puts "Adding report..."
    Dir.chdir(@repo_dir) do
      commits = `git log --author-date-order --reverse --pretty="%H" -- #{offenders.join(' ')}`.split("\n")
      commits.each do |sha|
        # puts sha
        # byebug
        commit = @git.object(sha)
        diff = @git.diff(commit, commit.parent)
        week_n = week_num(commit.author.date)
        # byebug
        @calendar[week_n] ||= init_weekly(week_n)
        weekly = @calendar[week_n]
        weekly[:commits] += 1
        weekly[:insertions] += diff.insertions
        weekly[:deletions]  += diff.deletions
        append_uniq!(weekly, :developers, commit.author.email)
        append_uniq!(weekly, :files, commit.author.email)
      end
      pp @calendar
    end
  end
end
