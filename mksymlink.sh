#!/bin/bash

list="gitconfig config/nvim"

for i in $list; do
  ln -sf `pwd`/$i ~/.$i
done
