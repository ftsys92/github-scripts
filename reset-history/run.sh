#!/bin/bash

# Your GitHub username
username=$1

# Base directory where repositories are cloned and backups will be created
base_dir="$2/${username}"

# Directory to store backups
backup_dir="${base_dir}/backups"

rm -rf $base_dir

# Ensure directories exist
mkdir -p "${base_dir}/repos"
mkdir -p "${backup_dir}"

echo $'#############' RUN FROM: $(date --iso-8601=seconds) $'#############' >> "${base_dir}/history.txt"

echo $(dirname $0)
bash $(dirname $0)/clone_all.sh $1 $2
bash $(dirname $0)/make_backups.sh $1 $2
bash $(dirname $0)/clean_repos_local_files.sh  $1 $2
bash $(dirname $0)/init_new_git.sh $1 $2
bash $(dirname $0)/restore_branches_from_backups.sh $1 $2
