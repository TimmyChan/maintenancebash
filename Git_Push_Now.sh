#!/usr/bin/bash

function gitpushnow() {
  now=`date`
  echo "Last run: ${now}" > $1/status.txt
  echo "By $USER" >> $1/status.txt
  echo "tlp-stat output:" >> $1/status.txt
  echo "##########" >> $1/status.txt
  tlp-stat >> $1/status.txt
  ##### Pushing to Git #####
  git -C $1 add .
  git -C $1 commit -m "${now}"
  git -C $1 push
}
