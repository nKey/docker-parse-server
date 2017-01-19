#!/usr/bin/env bash

set -e

if [ ! -d ${REPO_PATH} ]; then
    mkdir -p ${REPO_PATH}

    git init --bare ${REPO_PATH} > /dev/null

    cat << EOF > ${REPO_PATH}/hooks/post-receive
#!/bin/bash
unset GIT_INDEX_FILE

git --work-tree="${WORKTREE}" --git-dir="${REPO_PATH}" clean -df
git --work-tree="${WORKTREE}" --git-dir="${REPO_PATH}" checkout -f
cd "${WORKTREE}"
git --work-tree="${WORKTREE}" --git-dir="${REPO_PATH}" submodule update --init --recursive
EOF

    chmod a+x ${REPO_PATH}/hooks/post-receive > /dev/null

    chown -R git:git "${REPO_PATH}" > /dev/null
    chown -R git:git "${WORKTREE}" > /dev/null
fi

exec "$@"
