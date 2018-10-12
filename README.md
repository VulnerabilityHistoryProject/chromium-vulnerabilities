# chromium-vulnerabilities
Data for [vulnerabilityhistory.org](http://vulnerabilityhistory.org)

# Travis Build [![Build Status](https://travis-ci.org/andymeneely/chromium-vulnerabilities.svg?branch=master)](https://travis-ci.org/andymeneely/chromium-vulnerabilities)

Every push and pull request is run against our integrity checkers on Travis. Click on the above tag to see the status of the build.

# For SWEN 331 Students

Please see the assignments folder for information about your project.

Would you like to run the tests locally before pushing to your pull request? Here's what you do:

  1. You'll need Ruby 2.4+
  2. Run `gem install bundler` (if you don't already have bundler)
  3. `cd` to the root of this repo, run `bundle install`
  4. Run `rspec` from the root of the repo to run all the tests. You'll see similar output as you get on Travis. Thousands of green dots is good.

# Load the tmp/ folder with the git source

```
mkdir tmp
cd tmp
git clone https://chromium.googlesource.com/chromium/src
```

# List all Fix Commits

Be in the root of this repository, and run:

```
rake cve:fixes
```

# Clone the Chromium git repo

```
cd tmp
git clone https://chromium.googlesource.com/chromium/src
```
(takes a very long time!)

# Scrape a GoogleBlog page for CVE's

Be in the root of this repository, and run:

```
python scripts/get_cves_from_url.py https://chromereleases.googleblog.com/some/blog/post
```

This will scrape the page source for lines beginning with `[$bounty] [bug_id] priority CVE-2017-12345: description.` and create a new CVE in `cves/` for each match.

# Populate gitlog.json with a single SHA

Be in the root of this repository, and run:

```
ruby scripts/add_commit.rb --sha commit_sha_to_add
```

See the source code for other options.

# Populate gitlog.json with any mentioned SHA in CVE yamls

When you want to make sure that any commit that's mentioned in a YAML is also in the gitlog, you can run this script. It will NOT figure out commits between VCC and Fix, however.

Be in the root of this repository, and run:

```
ruby scripts/add_mentioned_commits.rb
```

This will overwrite any commit and take a LONG time (5-10 minutes). If you just want to go quickly and add what's not already there, use:

```
ruby scripts/add_mentioned_commits.rb --skip-existing
```

So if a commit is already in gitlog.json then we won't look it up in the GitLog. This is a much faster option.

By default, this script checks the `tmp/src` directory. If you need, say, `v8`, there's an option for that.

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
