#!/bin/bash

# A helper script to install CUDA for Ubuntu 20.04

set -e

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.5.0/local_installers/cuda-repo-ubuntu2004-11-5-local_11.5.0-495.29.05-1_amd64.deb
dpkg -i cuda-repo-ubuntu2004-11-5-local_11.5.0-495.29.05-1_amd64.deb
apt-key add /var/cuda-repo-ubuntu2004-11-5-local/7fa2af80.pub

apt-get update
apt-get install -y g++ make cuda freeglut3-dev

# Update PATH to include bin directory containing nvcc
echo "export PATH=\$PATH:/usr/local/cuda/bin" >> /home/ubuntu/.bashrc
