#!/bin/sh -l

set -e

# check values
if [ -n "${USER_NAME}" ]; then
    PUBLISH_USER_NAME=${USER_NAME}
else
    PUBLISH_USER_NAME="chengzhangHu"
fi
if [ -n "${EMAIL}" ]; then
    PUBLISH_EMAIL=${USER_NAME}
else
    PUBLISH_EMAIL="cheonghu2019@gmail.com"
fi

if [ -n "${PUBLISH_REPOSITORY}" ]; then
    PRO_REPOSITORY=${PUBLISH_REPOSITORY}
else
    PRO_REPOSITORY=${GITHUB_REPOSITORY}
fi

if [ -z "$PUBLISH_DIR" ]
then
  echo "You must provide the action with the folder path in the repository where your compiled page generate at, example public."
  exit 1
fi

if [ -z "$BRANCH" ]
then
  echo "You must provide the action with a branch name it should deploy to, for example master."
  exit 1
fi

if [ -z "$PERSONAL_TOKEN" ]
then
  echo "You must provide the action with either a Personal Access Token or the GitHub Token secret in order to deploy."
  exit 1
fi

REPOSITORY_PATH="https://x-access-token:${PERSONAL_TOKEN}@github.com/${PRO_REPOSITORY}.git"

# deploy to 
echo "Deploy to ${PRO_REPOSITORY}"

# Directs the action to the the Github workspace.
cd $GITHUB_WORKSPACE 

echo "echo init file list..."
for i in $(ls) ; do  echo $i ; done


echo "run npm install ..." 
npm install


if [ -n "${THEME_BRANCH}" ]; then
    THEME_REPOSITORY=${THEME_BRANCH}
else
    THEME_REPOSITORY="dev"
fi

if [ -n "${THEME_REPOSITORY}" ]; then
    echo "git clone themes repository..."
    rm -rf ./themes/*
    git clone "${HEME_REPOSITORY}" themes
fi

echo "echo list after git clone themes ..."
for i in $(ls) ; do  echo $i ; done

echo "run hexo clean ..."
npx hexo clean


echo "run hexo generate file ..."
npx hexo g

cd $PUBLISH_DIR
echo "copy CNAME if exists"
if [ -n "${CNAME}" ]; then
    echo ${CNAME} > CNAME
fi
echo "run git config..."

# Configures Git.
git init
git config user.name "${PUBLISH_USER_NAME}"
git config user.email "${PUBLISH_EMAIL}"
git remote add origin "${REPOSITORY_PATH}"

git checkout --orphan $BRANCH

git add --all

echo 'run git commit...'
git commit --allow-empty -m "deploying to ${BRANCH}"

echo 'run git push...'
git push origin "${BRANCH}" --force

echo "Deployment succesful!"
