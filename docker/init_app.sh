#!/bin/bash

BRANCH=$1

mkdir -p /var/www/
cd /var/www
git clone -b ${BRANCH} https://github.com/kujira28/scouter-github-vue.git
cd scouter-github-vue
npm install
npm run build
