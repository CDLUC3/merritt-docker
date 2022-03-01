Working with Git Submodules
===========================

## Quick command reference

```
man git-submodule		# man page
git submodule			# same as `git submodule status`
git submodule status		# list configured submodules
git submodule summary		# show commits in submodule working trees which are not yet recorded in super project

git submodule add -b main --name mrt-integ-tests git@github.com:cdluc3/mrt-integ-tests.git mrt-integ-tests
                        	# add a new submodule to '.gitmodules':
				#   [submodule "mrt-integ-tests"]
				#           path = mrt-integ-tests
				#           url = git@github.com:cdluc3/mrt-integ-tests.git
				#           branch = main
git submodule init mrt-integ-tests
			 	# initialize/register new submodule
git submodule init		# initialize/register all submodules

git submodule update		# clone/pull code from registerd submodules into defined paths
git submodule update --remote	# update using the status of the submodule’s remote-tracking branch
git submodule update --remote --no-fetch 
				# check for updates, but don't fetch new objects from the remote site
git submodule update --remote --init
                                # update and initialize at the same time
```


## Typical workflow

```
~> cd /dpr2/merritt-workspace/agould/merritt-docker
merritt-docker> git submodule
merritt-docker> git submodule update --remote
merritt-docker> git status
merritt-docker> git add .
merritt-docker> git commit -m "update submodules"
```


## Workflow for new deployment

```
~> mkdir /dpr2/merritt-workspace/agould
~> cd /dpr2/merritt-workspace/agould
agould> git clone git@github.com:CDLUC3/merritt-docker.git
agould> cd merritt-docker
merritt-docker> git checkout my-branch
merritt-docker> git submodule init
merritt-docker> git submodule update --remote
merritt-docker> git submodule
```
 

## Checking submodule status

The `git submodule status` command lists all configured submodules.  For each one it
lists the currently checked out commit hash, the path relative to the
super project root directory where the submodule code will be cloned, and either
the tag or branch referencing the checked out commit.

Each listing can be prefixed with on of:
- '-': the submodule is not initialized or is not yet checked out
- '+': the currently checked out submodule commit does not match what's recorded in the super project
- 'U': the submodule has merge conflicts.

In the below example:
- `mrt-integ-tests, mrt-store` have local commits which have not been recorded in the super project.
- `dryad-app, mrt-oai, mrt-sword` are not registerd.

```
merritt-docker> git submodule
+4af817151cdeac252ee66cb5353295105d9986a0 mrt-integ-tests (heads/main)
 56e633f98031be191f2e27a982e6d5ca1501e0ee mrt-services/audit/mrt-audit (sprint-65-4-g56e633f)
 b7d9dbf0c4cf29cfa7892e1e52b47b83a113dccc mrt-services/dep_cdlzk/cdl-zk-queue (sprint-65-8-gb7d9dbf)
 c76edd6b3c6eb183f4015c224d9ff30bb777f02f mrt-services/dep_cloud/mrt-cloud (sprint-65-1-gc76edd6)
 2d17fb9806f18b29321a906a0b81b133e8cca53b mrt-services/dep_core/mrt-core2 (sprint-65-3-g2d17fb9)
 dc430176853925ccb0e2b9c6b28933d6013e9e54 mrt-services/dep_zoo/mrt-zoo (sprint-65)
-407b806305b3a79e8d9bb826fd08d5592112bb88 mrt-services/dryad/dryad-app (v0.7.17a-26-g407b80630)
 fa969c5acceef9586dea30fa1098e6c5209861c9 mrt-services/ingest/mrt-ingest (sprint-64-main-30-gfa969c5)
 d35df074b79f98a8be84d27fe0c59397b2787ee2 mrt-services/inventory/mrt-inventory (sprint-64-3-gd35df07)
 239c258b66c3bd0005f59a4aaa482bdf92ec4c93 mrt-services/mrt-admin-lambda (sprint-65-main-18-g239c258)
-b0b601c7e3ccb187c7273e9a0def396aaf74c323 mrt-services/oai/mrt-oai (sprint-65)
 8cc0e38d3b31aaa444748386adc497c5fe923071 mrt-services/replic/mrt-replic (sprint-64-7-g8cc0e38)
+b182d03d4f4c0df679372549997239735a95d155 mrt-services/store/mrt-store (sprint-65-15-gb182d03)
-2d1a521ae02571f4bde85701411f09c781a69a9a mrt-services/sword/mrt-sword (sprint-65)
 dffd8a712a6ec2ac2ab3c30395cb8600ec682bf7 mrt-services/ui/mrt-dashboard (sprint-65-main)
```

The `git submodule summary` command shows which commits differ:
```
merritt-docker> git submodule summary 
* mrt-integ-tests 3ee46e2...8e9733d (3):
  > refine perms
  > fix download folder accessibility
  > fix integ tests

* mrt-services/store/mrt-store 2231237...8a924e6 (13):
  < tag or branch name
  < MAVEN_HOME
  < troubleshoot
  < ${maven.home}/conf/settings.xml
  < /dev/null settings file
  < search for settings.xml
```



## Configuring submodules in the super project

The git submodules for this project are configured in file `.gitmodules`.
Here we specify the repository url, branch and the location (path) where
submodule code will be cloned relative to the root of the super project.

Specifying `branch` on all submodules lets us configure different upstream
branches for particular submodules depending on the branch of the super
project.  For example, while refactoring our java builds, the 'java-refactor'
branch in the super project is configured to pull in code from a
'java-refactor' branch for those repos that have been refactored:

```
merritt-docker> head .gitmodules 
[submodule "mrt-services/dep_core/mrt-core2"]
        path = mrt-services/dep_core/mrt-core2
        url = git@github.com:cdluc3/mrt-core2
        branch = java-refactor
[submodule "mrt-services/ingest/mrt-ingest"]
        path = mrt-services/ingest/mrt-ingest
        url = git@github.com:cdluc3/mrt-ingest
        branch = main
```

To add a new submodule:
```
merritt-docker> git submodule add \
  -b main --name mrt-integ-tests git@github.com:cdluc3/mrt-integ-tests.git mrt-integ-tests

merritt-docker> tail -4 .gitmodules
[submodule "mrt-integ-tests"]
        path = mrt-integ-tests
        url = git@github.com:cdluc3/mrt-integ-tests.git
        branch = main
```



## Initializing Submodules

After cloning this repository (or after adding a new submodule) submodules must
be initialized (or registered).  Unregistered submodules are prefixed by a
minus ('-') when running `git submodule status`:
```
merritt-docker> git submodule status
-7aa272c2d81f0a4223e2917d84e042421364dc92 mrt-dependencies/cdl-zk-queue
-0ac8054d899d6e5b7ebb3d46964d406421a1af12 mrt-dependencies/mrt-cloud
-f224861914a480d8bbd1795ab46452444dd72489 mrt-dependencies/mrt-core2
-6a5de6f0fa61d6879e05872883d87bae30b6061e mrt-dependencies/mrt-ingest
[cut]
```

Uninitialized submodules cannot be updated:
```
merritt-docker> git submodule update mrt-dependencies/cdl-zk-queue
Submodule path 'mrt-dependencies/cdl-zk-queue' not initialized
Maybe you want to use 'update --init'?
```

Run `git submodule init` to initialize/register configured submodules:
```
merritt-docker> git submodule init
Submodule 'mrt-dependencies/cdl-zk-queue' (git@github.com:cdluc3/cdl-zk-queue) registered for path 'mrt-dependencies/cdl-zk-queue'
Submodule 'mrt-dependencies/mrt-cloud' (git@github.com:CDLUC3/mrt-cloud) registered for path 'mrt-dependencies/mrt-cloud'
Submodule 'mrt-dependencies/mrt-core2' (git@github.com:cdluc3/mrt-core2) registered for path 'mrt-dependencies/mrt-core2'
Submodule 'mrt-dependencies/mrt-ingest' (git@github.com:cdluc3/mrt-ingest) registered for path 'mrt-dependencies/mrt-ingest'
[cut]
```

It is also possible to de-initialize a particular submodule.  Uninitialized
submodules are ignored when running `git submodule update` for the whole super
project.  This is useful if you are actively developing code within a submodule
and do not want your topic branch to be reverted to the branch configured in
the super project:
```
merritt-docker> git submodule deinit mrt-services/dep_cdlzk/cdl-zk-queue
Cleared directory 'mrt-services/dep_cdlzk/cdl-zk-queue'
Submodule 'mrt-services/dep_cdlzk/cdl-zk-queue' (git@github.com:cdluc3/cdl-zk-queue) unregistered for path 'mrt-services/dep_cdlzk/cdl-zk-queue'
merritt-docker> git submodule status mrt-services/dep_cdlzk/cdl-zk-queue
-b7d9dbf0c4cf29cfa7892e1e52b47b83a113dccc mrt-services/dep_cdlzk/cdl-zk-queue
```



## Updating Submodules

When the super project is initially cloned and even after submodules are
initialized, the directories configured as submodule paths are created, but are
empty.  To populate submodule code run `git submodule update`.  This command
clones submodule code into configured paths (`.gitmodules`) within the working
tree of the super project. 

**Note** - the commit recorded in the super project will be checked out on a
detached HEAD.
```
merritt-docker> git submodule init mrt-integ-tests
Submodule 'mrt-integ-tests' (git@github.com:cdluc3/mrt-integ-tests.git) registered for path 'mrt-integ-tests'
merritt-docker> git submodule update mrt-integ-tests
Submodule path 'mrt-integ-tests': checked out '3ee46e20621cfaacd75193c56ec58160e2bcb370'
merritt-docker> cd mrt-integ-tests/
merritt-docker/mrt-integ-tests> git branch 
* (HEAD detached at 3ee46e2)
  main
```

**Also Note** - the commit recorded in the super project reflects the state of
the submodule at the time the super project itself was last committed.  This
may not be the same as the branch configured in `.gitmodules` or even the
remote of the submodule.

To update a submodule to reflect it's remote tracking branch (as set in
`.gitmodules`) pass the `--remote` option.  This is the proper way to ensure
submodules are up to date:

```
agould@localhost:~/git/github/cdluc3/merritt-docker> git submodule update --remote
Cloning into '/home/agould/git/github/cdluc3/merritt-docker/mrt-services/mrt-admin-lambda'...
Cloning into '/home/agould/git/github/cdluc3/merritt-docker/mrt-services/oai/mrt-oai'...
Cloning into '/home/agould/git/github/cdluc3/merritt-docker/mrt-services/replic/mrt-replic'...
Cloning into '/home/agould/git/github/cdluc3/merritt-docker/mrt-services/store/mrt-store'...
Cloning into '/home/agould/git/github/cdluc3/merritt-docker/mrt-services/sword/mrt-sword'...
Cloning into '/home/agould/git/github/cdluc3/merritt-docker/mrt-services/ui/mrt-dashboard'...
[cut]
```



## Committing state of submodules into super project

After updating submodules against remotes, the commits checked out in
submodules may no longer be in sync with what is recorded in the super project.

Run `git status` in the super project working tree to show which submodules are
out-of-sync:
```
merritt-docker> git status
On branch java-refactor

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   mrt-integ-tests (new commits)
        modified:   mrt-services/store/mrt-store (new commits)
```

To record new state of submodules in the super project simply add and commit submodule paths:
```
merritt-docker> git add mrt-integ-tests mrt-services/store/mrt-store
merritt-docker> git commit -m "update submodules"
```

