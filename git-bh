#!/bin/bash
f=$1
shift
csha=""
{ git log --pretty=format:%H -- "$f"; echo; } | {
  while read hash; do
    res=$(git blame -L"/$1/",+1 $hash -- "$f" 2>/dev/null | sed 's/^/  /')
    sha=${res%% (*}
    if [[ "${res}" != "" && "${csha}" != "${sha}" ]]; then
      echo "--- ${hash}"
      echo "${res}"
      csha="${sha}"
    fi
  done
}
