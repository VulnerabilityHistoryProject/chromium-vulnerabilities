def cve_ymls
  Dir['cves/*.yml']
end

def gitlog_txt
  'commits/gitlog.txt'
end

def git_log_cmd
  'git log --pretty=format:":::%n%H%n%an%n%ae%n%ad%n%P%n%s%n%b%n;;;" --stat --stat-width=300 --stat-name-width=300 --ignore-space-change '
end
