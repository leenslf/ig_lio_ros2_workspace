# iG-LIO ROS2 Docker Workspace

This repo essentially utilizes publicly availble repos with some fixes to make them all compatible with each other. 


## Prerequisites

Before starting, ensure you have:

- Docker Engine (>= 20.10)
- Docker Compose (>= 2.0)

## Installation

### 1. Clone Repository

```bash
git https://github.com/leenslf/ig_lio_ros2_workspace.git
cd ig_lio_ros2_workspace
```

### 2. Build Livox SDK2 (Host System)

The Livox SDK2 requires compilation on the host system due to hardware drivers:

```bash
cd ~
git clone https://github.com/Livox-SDK/Livox-SDK2.git
cd Livox-SDK2

# Fix GCC compatibility issues
sed -i '1i #include <cstdint>' sdk_core/comm/define.h
sed -i '1i #include <cstdint>' sdk_core/logger_handler/file_manager.h

# Apply cstdint includes to all relevant files
find sdk_core -name "*.h" -o -name "*.cpp" | xargs grep -l "uint.*_t\|int.*_t" | while read file; do
    if ! grep -q "#include <cstdint>" "$file"; then
        sed -i '1i #include <cstdint>' "$file"
    fi
done

# Build and install
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=~/livox_sdk2_install ..
make -j$(nproc) && make install
```

### 3. Setup ROS2 Workspace

```bash
cd ~/ig_lio_ros2_workspace/workspace

# Clone required packages
git clone https://github.com/Livox-SDK/livox_ros2_driver.git
git clone https://github.com/Wataru-Oshima-Tokyo/ig_lio.git -b humble
```

### 4. Apply iG-LIO Compatibility Fixes

Navigate to the iG-LIO directory and apply necessary fixes:

```bash
cd ig_lio

# Update CMakeLists.txt dependencies
sed -i 's/find_package(livox_ros_driver2 REQUIRED)/find_package(livox_interfaces REQUIRED)/' CMakeLists.txt
sed -i 's/livox_ros_driver2/livox_interfaces/' CMakeLists.txt

# Update package.xml dependencies  
sed -i 's/livox_ros_driver2/livox_interfaces/g' package.xml

# Fix include paths in source files
find . -name "*.h" -o -name "*.hpp" -o -name "*.cpp" | xargs sed -i 's|livox_ros_driver2/msg|livox_interfaces/msg|g'

# Fix namespace references
find . -name "*.h" -o -name "*.hpp" -o -name "*.cpp" | xargs sed -i 's/livox_ros_driver2::/livox_interfaces::/g'

cd ..
```

## Building the Workspace

### 1. Start Docker Environment

```bash
cd ~/ig_lio_ros2_workspace

# Enable X11 forwarding for GUI applications
xhost +local:docker

# Start the Docker container
code path/to/repo/
```
Then click on reopen in container and wait for build. 

### 2. Install Dependencies and Build

Inside the Docker container:

```bash
# Install additional dependencies
apt update && apt install -y libgoogle-glog-dev

apt install -y \
    gazebo \
    ros-humble-gazebo-ros \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-robot-state-publisher \
    ros-humble-joint-state-publisher


# Source ROS2 environment
source /opt/ros/humble/setup.bash

# Build Livox packages first
colcon build --packages-select livox_sdk_vendor livox_interfaces livox_ros2_driver
source install/setup.bash

# Build iG-LIO
colcon build --packages-select ig_lio
source install/setup.bash
```

**Note:** You may see stderr warnings during the build - these are typically non-critical and can be ignored.

## Usage

### Running iG-LIO SLAM

1. **Launch the main SLAM node:**
   ```bash
   ros2 launch ig_lio ig_lio_velodyne.launch.py
   ```

2. **Start RViz for visualization (new terminal):**
   ```bash
   rviz2
   ```



# 🚀 How to Try It Out

Clone the repository and follow the provided instructions to launch the simulation:

```bash
git clone https://github.com/leenslf/TrajectorySense.git
# Follow the setup and run instructions in the README