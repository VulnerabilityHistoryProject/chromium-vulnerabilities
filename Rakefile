require 'rspec/core/rake_task'

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
      require_relative 'scripts/reviews_to_fixes.rb'
      ReviewsToFixes.new.run
    end

  end
end
