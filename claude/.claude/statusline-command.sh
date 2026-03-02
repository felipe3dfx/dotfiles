#!/bin/bash

  # Read JSON input from stdin
  input=$(cat)

  # Extract relevant fields
  model=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')
  cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
  output_style=$(echo "$input" | jq -r '.output_style.name // ""')
  remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

  # Get git branch if in a git repo
  git_branch=""
  if git rev-parse --git-dir > /dev/null 2>&1; then
      git_branch=$(git branch --show-current 2>/dev/null || echo "")
  fi

  # Build status line parts
  parts=()

  # Add model name
  parts+=("$(printf '\033[1;36m%s\033[0m' "$model")")

  # Add current directory
  if [ -n "$cwd" ]; then
      dir_name=$(basename "$cwd")
      parts+=("$(printf '\033[1;32m%s\033[0m' "$dir_name")")
  fi

  # Add git branch if available
  if [ -n "$git_branch" ]; then
      parts+=("$(printf '\033[1;35m(%s)\033[0m' "$git_branch")")
  fi

  # Add output style if not default
  if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
      parts+=("$(printf '\033[1;33m[%s]\033[0m' "$output_style")")
  fi

  # Add context remaining if available
  if [ -n "$remaining" ]; then
      parts+=("$(printf '\033[1;34mctx:%s%%\033[0m' "$remaining")")
  fi

  # Join parts with separator
  printf '%s' "${parts[0]}"
  for i in "${parts[@]:1}"; do
      printf ' %s %s' '│' "$i"
  done
