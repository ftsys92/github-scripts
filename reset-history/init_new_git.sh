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

message="INITIALIZING NEW GIT REPOSITORIES"
echo $message
echo $message >> "${base_dir}/history.txt"

# Process each repository in the repos directory
for repo_dir in */ ; do
    cd "$base_dir/repos/$repo_dir"

    # Get the repository name
    repo=$(basename "$repo_dir")

    message="Initializing new git repository for: $repo"
    echo $message
    echo $message >> "${base_dir}/history.txt"

    git init

    # Copy the backup of the main branch into the repository
    rsync -av --exclude='.git' "${backup_dir}/${repo}/main/" .

    git add -A
    git commit -m "initial commit"
    git branch -M main
    git remote add origin git@github.com:$username/$repo.git

    # Delete and create fresh repo using GitHub CLI
    gh repo delete $username/$repo --yes
    gh repo create $username/$repo --public

    git push -u origin main

    message="Repository $repo initialized and pushed to remote"
    echo $message
    echo $message >> "${base_dir}/history.txt"

done

message="ALL REPOSITORIES HAVE BEEN PROCESSED"
echo $message
echo $message >> "${base_dir}/history.txt"

