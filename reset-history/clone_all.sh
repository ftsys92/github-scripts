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

message="CLONING REPOSITORIES"
echo $message
echo $message >> "${base_dir}/history.txt"

# List all repositories and clone them using SSH
gh repo list $username --limit 100 | awk '{print $1}' | while read repo; do 
    message="Cloning repository: $repo"
    echo $message
    echo $message >> "${base_dir}/history.txt"

    git clone git@github.com:$repo.git

    message="Cloning repository: $repo completed"
    echo $message
    echo $message >> "${base_dir}/history.txt"
done

message="ALL REPOSITORIES CLONED"
echo $message
echo $message >> "${base_dir}/history.txt"