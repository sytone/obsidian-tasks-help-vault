This vault is to help users of the Tasks plugin as well as users of the preview version located at [sytone/obsidian-tasks-x (github.com)](https://github.com/sytone/obsidian-tasks-x)

Contributions are accepted and wanted! This could be unique ways to use the Tasks plugin or the way you manage tasks in Obsidian so others can learn. 

## Local Usage

1. To use this vault use the `Download ZIP` link under code. 
2. Extract to a local folder.
3. Open that folder in Obsidian


## Git Replication

If you want to get the latest copy you will need to make it a git repo. You can do this via a fork or direct from the `obsidian-tasks-help-vault`

To clone a local copy run `git clone https://github.com/sytone/obsidian-tasks-help-vault.git`

To update run `git pull`


## Update local copy to be able sync with the repo

```
git config --global init.defaultBranch main
git init
git remote add origin https://github.com/sytone/obsidian-tasks-help-vault.git
git fetch
git reset origin/main
git checkout -t origin/main
```