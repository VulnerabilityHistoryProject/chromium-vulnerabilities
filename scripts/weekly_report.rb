require 'active_support/core_ext/hash'
require 'byebug'

class WeeklyReport
  @@SECONDS_IN_WEEK = 604800
  @@START_DATE = Time.new(1991, 8, 5) # Monday before the birth of WWW

  def initialize(options)
    @git = Git.open(options[:repo])
    @repo_dir = options[:repo]
    @skip_existing = options[:skip_existing]
    @weekly_dir = options[:weeklies]
  end

  def week_num(timestamp)
    ((timestamp - @@START_DATE) / @@SECONDS_IN_WEEK).to_i
  end

  def nth_week(i)
    @@START_DATE + (i * @@SECONDS_IN_WEEK).to_i
  end

  def weekly_file(cve)
    "#{@weekly_dir}/#{cve.upcase}-weekly.json"
  end

  def write(cve, calendar)
    File.open(weekly_file(cve), 'w+') do |f|
      # f.write JSON.pretty_generate(calendar)
      f.write JSON.generate(calendar)
    end
  end

  def init_weekly(n)
    {
      week: n,
      date: nth_week(n),
      commits: 0,
      insertions: 0,
      deletions: 0,
      reverts: 0,
      rolls: 0,
      refactors: 0,
      test_files: 0,
      files: [],
      developers: [],
      new_developers: [],
      drive_bys: [],
      ownership_change: false,
    }
  end

  # Append something to an array, then uniq the array
  def append_uniq!(weekly, key, element)
    weekly[key] = (weekly[key] << element).flatten.uniq
  end

  def any_owners_files?(files)
    files.inject(false) do |any_owners, file|
      any_owners || file.to_s.match?(/OWNERS/)
    end
  end

  def revert?(message)
    message.match? /^Revert "/
  end

  def roll?(message)
    message.match? /^Roll /
  end

  def regression?(message)
    message.downcase.match? /regression/
  end

  def refactor?(message)
    message.downcase.match? /refactor/
  end

  def any_test_files?(files)
    files.inject(false) do |any_tests, file|
      any_tests || file.match?(/test/)
    end
  end

  def add(cve, offenders)
    return if offenders.blank?
    calendar = {} # Always start fresh - don't read in the old one
    devs = []

    authors = `git -C #{@repo_dir} log --pretty="%ae"`.split("\n")
    counts = Hash.new(0)
    authors.each { |a| counts[a] += 1 }
    drive_by_authors = counts.select { |a, count| count == 1 }.keys

    commits = `git -C #{@repo_dir} log --author-date-order --reverse --pretty="%H" -- #{offenders.join(' ')}`.split("\n")
    commits.each do |sha|
      commit = @git.object(sha)
      diff = @git.diff(commit, commit.parent)
      commit_files = diff.stats[:files].keys
      email = commit.author.email
      week_n = week_num(commit.author.date)
      calendar[week_n] ||= init_weekly(week_n)
      weekly = calendar[week_n]
      weekly[:commits]    += 1
      weekly[:insertions] += diff.insertions
      weekly[:deletions]  += diff.deletions
      weekly[:reverts]    += revert?(commit.message) ? 1 : 0
      weekly[:rolls]      += roll?(commit.message) ? 1 : 0
      weekly[:refactors]  += refactor?(commit.message) ? 1 : 0
      weekly[:test_files] += any_owners_files?(commit_files) ? 1 : 0
      weekly[:ownership_change] ||= any_owners_files?(commit_files)
      append_uniq!(weekly, :files, commit_files & offenders)
      append_uniq!(weekly, :developers, email)
      append_uniq!(weekly, :new_developers, [email] - devs)
      append_uniq!(weekly, :drive_bys, email) if drive_by_authors.include?(email)
      devs = (devs << email).flatten.uniq
    end
    write(cve, calendar)
  end
end
