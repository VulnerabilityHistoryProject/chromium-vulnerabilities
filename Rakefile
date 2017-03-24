require 'nokogiri'
require 'open-uri'
require 'rspec/core/rake_task'
require 'yaml'
require 'zlib'
require_relative 'scripts/cve_commits.rb'
require_relative 'scripts/cve_update_skeleton.rb'
require_relative 'scripts/pull_task_handler'
require_relative 'scripts/reviews_to_fixes.rb'
require_relative 'scripts/script_helpers.rb'


desc 'Run the specs by default'
task default: :spec

RSpec::Core::RakeTask.new(:spec)

namespace :git do

  desc 'Clone the Chromium repos (SLOW!)'
  task :clone => [
    'clone:blink',
    'clone:src',
    'clone:v8',
  ]

  namespace :clone do

    task :src do
      puts "Cloning chromium/src..."
      Dir.chdir('./tmp') do
        puts `git clone https://chromium.googlesource.com/chromium/src`
      end
    end

    task :blink do
      puts "Cloning chromium/blink..."
      Dir.chdir('./tmp') do
        puts `git clone https://chromium.googlesource.com/chromium/blink`
      end
    end

    task :v8 do
      puts "Cloning v8..."
      Dir.chdir('./tmp') do
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
end
