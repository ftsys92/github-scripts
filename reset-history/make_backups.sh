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

cd "${base_dir}/repos"

message="BACKUPING REPOSITORIES"
echo $message
echo $message >> "${base_dir}/history.txt"

# Process each repository
for repo_dir in */ ; do
    cd "$base_dir/repos/$repo_dir"

    # Get the repository name
    repo=$(basename "$(pwd)")

    message="Backuping repository: $repo"
    echo $message
    echo $message >> "${base_dir}/history.txt"

    # Fetch all branches
    git fetch --all

     for branch in $(git branch -r | grep -v 'origin/HEAD' | grep origin | sed 's/origin\///'); do
        # Skip non-branch lines (like 'origin/HEAD -> origin/main')
        if [[ "$branch" == *'->'* ]]; then
            continue
        fi

        # Make sure it is updated
        git checkout "$branch"
        git pull

        # Create a backup directory for the branch
        mkdir -p "${backup_dir}/${repo}/${branch}"

        # Copy all files except the .git directory
        rsync -av --exclude='.git' . "${backup_dir}/${repo}/${branch}/"

        # Save commit history: author, email, message and date
        echo $'#############' RUN FROM: $(date --iso-8601=seconds) $'#############' >> "${backup_dir}/${repo}/${branch}/.commits_history"
        git rev-list ${branch} |
            while read sha1; do
                echo $(git show -s --format='%an<%ae> %s: %ad' --date=format:'%Y-%m-%d' $sha1 | tr -d '\n';) >> "${backup_dir}/${repo}/${branch}/.commits_history"
            done
    done

    message="Backup for $repo completed"
    echo $message
    echo $message >> "${base_dir}/history.txt"

done

message="BACKUP COMPLETED."
echo $message
echo $message >> "${base_dir}/history.txt"