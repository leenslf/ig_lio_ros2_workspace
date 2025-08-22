#!/usr/bin/env bash

sudo apt update

rosdep init
rosdep update
rosdep install -r -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO

sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*