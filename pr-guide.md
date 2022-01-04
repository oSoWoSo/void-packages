
## Little PR Guide
### The little void contribution guide
### Useful hints

###    Use just one commit per package
### Correct a wrong commit
$ `git commit --amend`

### Squash commits related to a single issue into a cingle commit (e.g. four commits into one)
$ `git rebase -i HEAD~4`

# Workflow
### Setup
### 1. Fork voidlinux's void-packages repository on github.com
### 2. Clone forked repository and add remote upstream
$ `cd /opt`

$ `git clone git@github.com:my-github-username/void-packages.git`

$ `git remote add upstream https://github.com/void-linux/void-packages.git`

### 4. Binary bootstrap environment
$ `./xbps-src binary-bootstrap`

### 5. Install xtools helper package
$ `xbps-install xtools`

# Create new package and PR
### 1. Create new package template and git branch
$ `cd /opt/void-packages`

$ `git pull --rebase upstream master`

$ `git checkout -b my-new-package`

$ `xnew my-new-package`

$ `vim srcpkgs/my-new-package/template`

### 2. Configure template according to voidlinux's manual:
 https://github.com/void-linux/void-packages/blob/master/Manual.md
### 3. Lint the package template
$ `xlint srcpkgs/my-new-package/template`

### 4. Generate sha256sums
$ `xgensum -f srcpkgs/my-new-package/template`

### 5. Build and package it
$ `./xbps-src pkg my-new-package`

### 6. Commit according to voidlinux's commit rules:
 https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md#committing-your-changes

$ `git commit -m "New package: my-new-package-package_version_number`

### Or even better using xbump which adds the correct commit message automatically.
$ `xbump my-new-package`

### 7. Push to your own (origin) repository
$ `git push -u origin my-new-package`

### 8. Create a PR on github.com
# Install your new package
$ `cd /opt/void-packages`

$ `git checkout (-b) my-new-package`

### 1. Using xbps-install
$ `xbps-install --repository=hostdir/binpkgs/my-new-package my-new-package`

### 2. Using xi
$ `xi my-new-package`

# Update a your package
### 1. Update local repository
$ `cd /opt/void-packages`

$ `git checkout master`

$ `git pull --rebase upstream master`

$ `./xbps-src bootstrap-update`

### 2. Make changes to the template
$ `git checkout (-b) my-package-to-update`

$ `vim srcpkgs/my-package-to-update/template`

### 3. Update sha256sums
$ `xgensum -f srcpkgs/my-package-to-update/template`

### 4. Lint the template file again
$ `xlint srcpkgs/my-package-to-update`

### 5. Build and package it again
$ `./xbps-src pkg my-package-to-update`

### 6. Commit according to voidlinux's commit rules:
 https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md#committing-your-changes

$ `git commit -m "my-package-to-update: update to new_package_version_number"`

##    Or even better using xbump which adds the correct commit message automatically.
$ `xbump my-package-to-update`

### 7. Push to your own (origin) repository
$ `git push -f origin my-package-to-update`

# 8. Create a PR on github.com
