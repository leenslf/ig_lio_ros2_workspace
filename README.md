# iG-LIO ROS2 Docker Workspace

This repo essentially utilizes publicly availble repos with some fixes to make them all compatible with each other. 


## Prerequisites

Before starting, ensure you have:

- Docker Engine (>= 20.10)
- Docker Compose (>= 2.0)

## Installation

### 1. Clone Repository

```bash
git clone https://github.com/leenslf/ig_lio_ros2_workspace.git
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
git clone https://github.com/leenslf/ig_lio -b restarting
```


## Try It Out
1. On your host PC

    ```bash
    xhost +local:docker
    ```
2. Open ig_lio_ros2_workspace folder in VScode and follow prompt to Rebuild and Reopen in container (some Docker VScode extensions could be required)

3. Launch iG-LIO node:
   ```bash
   ros2 launch ig_lio ig_lio_velodyne.launch.py
   ```


Check out https://github.com/leenslf/TrajectorySense.git for more


