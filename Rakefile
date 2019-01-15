# require 'irb'
# require 'nokogiri'
# require 'open-uri'
# require 'optparse'
# require 'zlib'
require 'csv'
require 'rspec/core/rake_task'
require 'yaml'
require_relative 'scripts/cve_commits.rb'
require_relative 'scripts/cve_update_skeleton.rb'
require_relative 'scripts/git_log_utils.rb'
require_relative 'scripts/list_cve_data.rb'
require_relative 'scripts/pull_task_handler'
require_relative 'scripts/reviews_to_fixes.rb'
require_relative 'scripts/script_helpers.rb'
require_relative 'scripts/update_curated.rb'

desc 'Run the specs by default'
task default: :spec

RSpec::Core::RakeTask.new(:spec)

namespace :list do

  desc 'Use Git to list all of the files that were fixed from a vulnerability'
  task :vulnerable_files do
    puts "Getting vulnerable files list"
    tmpFixes = ListCVEData.new.get_fixes
    fixes = []
    gitRepository = "#{ENV['GIT_REPOSITORY']}"
    outputFile = "#{ENV['OUTPUT_FILE']}"
    gitStart = "#{ENV['GIT_START']}"
    gitEnd = "#{ENV['GIT_END']}"
    if gitRepository.to_s.empty?
      gitRepository = "./tmp/src"
    end
    if gitStart.to_s.empty? && gitEnd.to_s.empty?
      fixes = tmpFixes
    else
      Dir.chdir(gitRepository) do
        tmpFixes.each do |fix|
          gitLogCommand = "git log --before=#{gitEnd} --after=#{gitStart} "+'--pretty=format:"%H" ' + fix + ' -1'
          check = `#{gitLogCommand}`
          if fix.to_s == check.chomp.to_s
            fixes << fix
          end
        end
      end
    end
    result = GitLogUtils.new(gitRepository).get_files_from_shas(fixes)
    if outputFile.to_s.empty?
      puts result.to_a
    else
      puts "Writing output file #{outputFile}"
      CSV.open(outputFile, 'w+') do |csv|
        csv << [ 'filepath' ]
        result.to_a.each { |f| csv << [f] }
      end
    end
  end
end

namespace :git do

  desc 'Clone the Chromium repos (SLOW!)'
  task :clone => [
    'clone:blink',
    'clone:src',
    'clone:v8',
  ]

  namespace :clone do
    task :src do
      gitDirectory = "#{ENV['GIT_REPOSITORY']}"
      if gitDirectory.empty?
        gitDirectory = "./tmp"
      end
      puts "Cloning chromium/src..."
      Dir.chdir(gitDirectory) do
        puts `git clone https://chromium.googlesource.com/chromium/src`
      end
    end

    task :blink do
      gitDirectory = "#{ENV['GIT_REPOSITORY']}"
      if gitDirectory.empty?
        gitDirectory = "./tmp"
      end
      puts "Cloning chromium/blink..."
      Dir.chdir(gitDirectory) do
        puts `git clone https://chromium.googlesource.com/chromium/blink`
      end
    end

    task :v8 do
      gitDirectory = "#{ENV['GIT_REPOSITORY']}"
      if gitDirectory.empty?
        gitDirectory = "./tmp"
      end
      puts "Cloning v8..."
      Dir.chdir(gitDirectory) do
        puts `git clone https://chromium.googlesource.com/v8/v8`
      end
    end

  end

  namespace :log do

    desc 'Iterate over code reviews and get fixes'
    task :reviews_to_fixes do
      ReviewsToFixes.new.run
    end

    desc 'Get commit data from mentions in CVE yamls'
    task :cve_commits do
      CVECommits.new.run
    end

  end
end

namespace :pull do

  desc "This task is used to examine .yml files for the absence of CVSS scores. If absences are detected the CVSS scores will be scraped from the relevant NVD XML and put into the yml file."
  task :cvss do
    unless Dir.exist?('cves')
      puts "[ERROR] Chromium CVEs not found in /tmp/checkout/chromium-vulnerabilities as expected. Please clone the chromium repo if you have not already."
      return
    end

    puts "Loading CVEs..."
    loaded_cves = Pull_Task_Handler.load_cves('cves')

    unless Dir.exist?('tmp/xml')
      puts "Downloading XML Files..."
      Pull_Task_Handler.download_xml
    end

    puts "Adding CVSS scores to YML..."
    Pull_Task_Handler.modify_yml(loaded_cves, 'cvss')
    puts "Cleaning XML files..."
    Pull_Task_Handler.clean('tmp')
  end

end

namespace :cve do

  desc 'Update CVE ymls from skeleton'
  task :update_skeleton do
    CVEUpdateSkeleton.new.run
  end

  desc 'Output newline delimited list of git fixes for every CVE'
  task :fixes do
    ListCVEData.new.print_fixes
  end

  desc 'Output newline delimited list of CVE missing fix data'
  task :missing_fixes do
    ListCVEData.new.print_missing_fixes
  end

  desc 'Update curated - ONE TIME TASK'
  task :update_curated do
     UpdateCurated.new.run
  end

end
