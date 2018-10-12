# Curated Commits for Chromium `curated_commits.json`

There are over a million commits in Chromium. We want to look at a tiny slice of those commits show them, and then summarize the rest.

The file gitlog.json is a database of all the git commits that are:

* Mentioned as a fix commit in a CVE YML
* Mentioned as a vcc commit in a CVE YML
* Mentioned as an "interesting commit" in a CVE YML

To re-populate the `curated_commits.json`, see main README.md

# Churn Reports `churn_reports.json`

For every vulnerability fix, we look up the files involved in that fix.
We look at any commit that involved any of those "vulnerable" files.
We then aggregate the commit information across all of those vulnerable files into weekly "reports".
Those weekly reports are Monday-Sunday reports are summaries of what happened.
