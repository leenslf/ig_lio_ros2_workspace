# iG-LIO ROS2 Docker Workspace

Container and documentation for iG-LIO setup with moborobot. 


## Prerequisites

Before starting, ensure you have:

- Docker Engine (>= 20.10)
- Docker Compose (>= 2.0)
- Container Tools on Vscode
## Installation

### 1. Clone This Repository

```bash
git clone https://github.com/leenslf/ig_lio_ros2_workspace.git
```


### 2. Clone ig_lio

```bash
cd ~/ig_lio_ros2_workspace/workspace
git clone https://github.com/leenslf/ig_lio -b dropLivox-rebased
```


## 3. Try It Out
1. On your host PC

    ```bash
    xhost +local:docker
    ```
2. Open ig_lio_ros2_workspace folder in VScode and follow prompt to Rebuild and Reopen in container

3. Clone Moborobot project
      ```bash
        git clone https://github.com/leenslf/TrajectorySense.git
    ```
      and check the documentation for more.
4. Build and source
   ```bash
    colcon build
   source install/setup.bash
    ```
6. To launch iG-LIO node with Velodyne:
   ```bash
   ros2 launch ig_lio ig_lio_velodyne.launch.py
   ```
