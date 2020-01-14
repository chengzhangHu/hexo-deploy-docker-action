# Container image that runs your code
FROM node:10

LABEL "com.github.actions.name"="Hexo deploy with cname and theme support"
LABEL "com.github.actions.description"="This GitHub action will handle the building and deploying process of hexo project."
LABEL "com.github.actions.icon"="git-commit"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="https://github.com/chengzhangHu/hexo-deploy-docker-action.git"
LABEL "homepage"="https://github.com/chengzhangHu/hexo-deploy-docker-action.git"
LABEL "maintainer"="chengzhangHu"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]