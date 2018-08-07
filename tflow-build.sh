#!/bin/bash

# Building tensorflow package from the sources manually

TF_BRANCH=r1.8

cd /

git clone --branch=${TF_BRANCH} --depth=1 https://github.com/tensorflow/tensorflow.git

cd tensorflow

git checkout ${TF_BRANCH}

updatedb

cd /

cp build_tf_package.sh /tensorflow

cd tensorflow

/bin/bash build_tf_package.sh
