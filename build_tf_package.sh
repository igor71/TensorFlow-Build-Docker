#! /bin/bash

############################################################################
# Configure the build for CPU with MKL by accepting default build options  #
# and setting library locations                                            #
############################################################################

export CI_BUILD_PYTHON=python PYTHON_BIN_PATH=/usr/bin/python PYTHON_LIB_PATH=/usr/local/lib/python2.7/dist-packages

export CC_OPT_FLAGS='-march=native' TF_NEED_JEMALLOC=0 TF_NEED_GCP=0 TF_NEED_CUDA=0 TF_NEED_CUDA=0 TF_NEED_HDFS=0

export TF_NEED_S3=0 TF_NEED_OPENCL=0 TF_NEED_GDR=0 TF_ENABLE_XLA=0 TF_NEED_VERBS=0 TF_NEED_MPI=0

export TF_NEED_KAFKA=0 TF_NEED_OPENCL_SYCL=0

yes N |./configure

####################################################################################################
# Build and Install TensorFlow. The 'mkl' option builds with Intel(R) Math Kernel Library (MKL),   #
# which detects the platform it is currently running on                                            #
# and takes appropriately optimized paths. The -march=native option is for code that is not in MKL,#
# and assumes this container will be run on the same architecture on which it is built.            #
# ##################################################################################################

WHL_DIR=/whl
HOME=/home/jenkins

bazel build --config="opt" \
            --config=mkl \
            --copt="-DEIGEN_USE_VML" \
            --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
            //tensorflow/tools/pip_package:build_pip_package && \
            mkdir ${WHL_DIR} && \
            bazel-bin/tensorflow/tools/pip_package/build_pip_package ${WHL_DIR}

#######################################################################
# Copy tensorflow package from build folder to jenkins home directory #
#######################################################################

cp ${WHL_DIR}/tensorflow-*.whl $HOME

cd ${HOME}
ls -lh tensorflow-*.whl
     if [ "$?" != "0" ]; then
          echo "There is no tensorflow package in $HOME dir!!!"
          exit -1
     fi
echo "All Done!!! Look for tensorflow whl package at ${WHL_DIR}"
