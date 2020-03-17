def cve_ymls
  Dir['cves/*.yml']
end

def gitlog_txt
  'commits/gitlog.txt'
end

def git_log_cmd
  'git log --pretty=format:":::%n%H%n%an%n%ae%n%ad%n%P%n%s%n%b%n;;;" --stat --stat-width=300 --stat-name-width=300 --ignore-space-change '
end

def cve_skeleton_data
  File.open('spec/data/cve-skeleton.yml') { |f| YAML.load(f) }
end

def keep_only_source_code(files)
  files.select do |f|
    f.end_with?('.c') ||
    f.end_with?('.cc') ||
    f.end_with?('.cpp') ||
    f.end_with?('.dsp') ||
    f.end_with?('.gyp') ||
    f.end_with?('.h') ||
    f.end_with?('.java') ||
    f.end_with?('.js') ||
    f.end_with?('.m4') ||
    f.end_with?('.make') ||
    f.end_with?('.py') ||
    f.end_with?('.S') ||
    f.end_with?('.sb') ||
    f.end_with?('.scons') ||
    f.end_with?('.sh') ||
    f.end_with?('.in') ||
    f.end_with?('DEPS') ||
    f.end_with?('Makefile')
  end
end
