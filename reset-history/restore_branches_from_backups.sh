#!/bin/bash

# Your GitHub username
username=$1

# Base directory where repositories are cloned and backups will be created
base_dir="$2/${username}"

# Directory to store backups
backup_dir="${base_dir}/backups"

# Ensure directories exist
mkdir -p "${base_dir}/repos"
mkdir -p "${backup_dir}"

cd "$base_dir/repos"

echo "RESTORING BRANCHES FOR ALL REPOSITORIES"

# Process each repository in the repos directory
for repo_dir in */ ; do
    cd "$base_dir/repos/$repo_dir"

    # Get the repository name
    repo=$(basename "$repo_dir")

    message="RESTORING BRANCHES FOR: $repo"
    echo $message
    echo $message >> "${base_dir}/history.txt"

    # Iterate through all branches in the backup, except 'main'
    for branch in $(ls "${backup_dir}/${repo}" | grep -v 'main'); do
        message="Processing branch: $branch"
        echo $message
        echo $message >> "${base_dir}/history.txt"

        git checkout -b "$branch"

        # Remove all files and directories (except .git) in the repository directory
        find . -mindepth 1 -not -path './.git*' -delete

        # Copy files from backup
        rsync -av --exclude='.git' "${backup_dir}/${repo}/${branch}/" .

        git add -A
        git commit -m "Initial commit for $branch"
        git push -u origin "$branch"
        git checkout main
    done

    message="BRANCHES FOR $repo PROCESSED"
    echo $message
    echo $message >> "${base_dir}/history.txt"
done

message="ALL BRANCHES FOR ALL REPOSITORIES HAVE BEEN PROCESSED"
echo $message
echo $message >> "${base_dir}/history.txt"
