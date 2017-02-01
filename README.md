# chromium-vulnerabilities
Data for vulnerabilityhistory.org

# Get the Git Log data

Use this git command to generate the git log:

```
git log --pretty=format:":::%n%H%n%an%n%ae%n%ad%n%P%n%s%n%b%n;;;" --stat --stat-width=300 --stat-name-width=300 --ignore-space-change
```

This gets absolutely everything, so don't commit that file - but cut it down to the commits you need. We're working on automating this.
