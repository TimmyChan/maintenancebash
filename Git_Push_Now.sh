#!/usr/bin/bash

function gitpushnow() {
  now=`date`
  echo ${now} > $1/last_run.txt
  tlp-stat > $1/tlp-stat.log
  ##### Pushing to Git #####
  git -C $1 add .
  git -C $1 commit -m "${now}"
  git -C $1 push
}
