# github-scripts

Some of scripts to automate or to use within github

## Reset GitHub history
**DANGER!!!**

Those scripts are made for reseting all your GitHub repositories history.
 - Clones all repos
 - Makes backups of all branches
 - Cleans all repos directories
 - Inits new repos(including deletes remote repos on GitHub) and restores main branch backup
 - Restores rest of branches from backup

Each branch in each repo will conatin `.commits_history` file that will include all commits of that branch made with simple format of author metadata and date.

### Prerequisition
In order to use those scrips you have to:
- Generate ssh-keys and add it to your user on GitHub
- Setup git user localy (git config)
- Install GitHub CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md and authorize with `delete_repo` scope.

**NOTE:** It might(it will) delete all remote repos and recreates them as public repos.

### Run

Based on bash and tested Ubuntu 22.04 only.
```bash
./reset-history/run.sh {GITHUB_USER_NAME} {FULL_PATH_TO_FOLDER_OF_DATA_FOLDER}
```
e.g.
```bash
./reset-history/run.sh john_doe /home/john/projects/data
```

### Run separatly
Each script can be runned separatly(possibly). Just make sure you need that and you aware of what is going there in the script and what that script does and requires. 

For example, if you want to run `init_new_git.sh` you have to put backup(all files except `.git` folder) of a `main` branch under `$base_dir/backups/main` folder.

## Disclaimer
All scripts were maid for personal needs, be careful running this for your's.