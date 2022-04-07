#!/usr/bin/bash

function gitpushnow() {
  now=`date`
  echo "Last run: ${now}" > $1/status.txt
  tlp-stat >> $1/tlp_stat.log
  ##### Pushing to Git #####
  git -C $1 add .
  git -C $1 commit -m "${now}"
  git -C $1 push
}
