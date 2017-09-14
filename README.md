# chromium-vulnerabilities
Data for vulnerabilityhistory.org

# Travis Build [![Build Status](https://travis-ci.org/andymeneely/chromium-vulnerabilities.svg?branch=master)](https://travis-ci.org/andymeneely/chromium-vulnerabilities)

Every push and pull request is run against our integrity checkers on Travis. Click on the above tag to see the status of the build.

# For SWEN 331 Students

Please see the assignments folder for information about your project.

# Get the Git Log data for commits/gitlog.txt

Use this git command to generate the git log:

```
git log --pretty=format:":::%n%H%n%an%n%ae%n%ad%n%P%n%s%n%b%n;;;" --stat --stat-width=300 --stat-name-width=300 --ignore-space-change
```

This gets absolutely everything, so don't commit that file - but cut it down to the commits you need. We're working on automating this.

Here's an example of just one commit:

```
$ cd tmp/v8
$ git log -1 --pretty=format:":::%n%H%n%an%n%ae%n%ad%n%P%n%s%n%b%n;;;" --stat --stat-width=300 --stat-name-width=300 --ignore-space-change 498b074bd0db2913cf2c9458407c0d340bbcc05e >> ..\..\commits\gitlog.txt
```

Here's how to get commits between VCC and fix (Windows cmd):

```
$ cd tmp/v8
$ git log --pretty=format:"%H" 498b074bd0db2913cf2c9458407c0d340bbcc05e..b32ff09a49fe4c76827e717f911e5a0066bdad4b -- src/regexp.js > ../commit_hashes.txt
$ for /F %i in (../commit_hashes.txt) do git log -1 --pretty=format:":::%n%H%n%an%n%ae%n%ad%n%P%n%s%n%b%n;;;" --stat --stat-width=300 --stat-name-width=300 --ignore-space-change %i >> ..\..\commits\gitlog.txt
```

# Get Git log as json
Run git_log_json.rb using -e (environment) -f (earliest commit) -l (latest commit) and -o (output dir).
ex: `ruby git_log_json.rb -e ../ -f b5a4700 -l da484cb -o ../commits/`

# Get the Releases data

Release data is scraped from this [Wikipedia article](https://en.wikipedia.org/wiki/Google_Chrome_version_history)

```
$ cd scripts
$ ruby get_releases.rb
```

# Merge Student CVE assignment

Here's how you merge in student data once the assignment is finished.

1. Make sure the current `dev` branch is updated and works with the build
2. Switch `vulnerability-history` locally to pull from `dev` instead of `master`.
3. Squash and merge the student pull req into `dev`
4. Run `rails data:chromium` locally. When it says "Loading data version " and then a git hash, make sure that matches up with the latest merge you just made (so you know you are pulling the latest chromium-vulnerabilities data).
5. If all is well, then do any spot-checks of their data to make sure everything got tagged just fine.
6. If all is not well:
  * You may need to merge their changes with any of your changes. This might be on GitHub itself, or locally.
  * You may need to correct their YML structure to make it compatible with the loader. Make the change locally and push back to `dev` to fix it and re-run.
  * If things fail on an exception, you can always put in this snippet somewhere to figure out what file failed and use byebug to figure out the problem:
  ```
  begin
    # code where things when wrong
  rescue
    byebug
  end
  ```
  * You can always do `rails data:chromium:nogit` to reload things without hitting GitHub - helpful for quicker debugging.
