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

message="CLEANING REPOSITORY DIRECTORIES"
echo $message
echo $message >> "${base_dir}/history.txt"

# Process each repository in the repos directory
for repo_dir in */ ; do
    message="Cleaning repository directory: $repo_dir"
    echo $message
    echo $message >> "${base_dir}/history.txt"

    # Remove all contents of repo
    rm -rf "$base_dir/repos/$repo_dir"

    # Recreate empty repo folder
    mkdir "$base_dir/repos/$repo_dir"

    message="Repository directory $repo_dir cleaned."
    echo $message
    echo $message >> "${base_dir}/history.txt"
done

message="ALL REPOSITORY DIRECTORIES HAVE BEEN CLEANED"
echo $message
echo $message >> "${base_dir}/history.txt"
