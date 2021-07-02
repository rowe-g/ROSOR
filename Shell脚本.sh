# Apache License 2.0
# Copyright (c) 2017, ROBOTIS CO., LTD.

echo ""
echo "[Note] Target OS version  >>> Ubuntumate 20.04"
echo "[Note] Target ROS version >>> ROS Noetic"
echo "[Note] Catkin workspace   >>> $HOME/catkin_ws"
echo ""
echo "PRESS [ENTER] TO CONTINUE THE INSTALLATION"
echo "IF YOU WANT TO CANCEL, PRESS [CTRL] + [C]"

# 用read命令获取用户在terminal中的键盘输入：
read

echo "[Set the target OS, ROS version and name of catkin workspace]"

# 对以下几个变量赋值：
# 这种 变量名=${变量名:="变量内容"} 的写法，意思是如果这个变量是空的或者未赋初值，
# 则对其进行赋值，否则就不赋值。
name_os_version=${name_os_version:="xenial"}
name_ros_version=${name_ros_version:="noetic"}
name_catkin_workspace=${name_catkin_workspace:="catkin_ws"}

echo "[Update the package lists and upgrade them]"

# 对本地软件库进行更新升级，变量-y的意思是在可能随后出现的命令行交互提示中，直接输入 yes
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[Install build environment, the chrony, ntpdate and set the ntpdate]"

# 安装以下几个程序：
sudo apt-get install -y chrony ntpdate build-essential
# 命令用于同步更新互联网时间，或者NTP服务器时间（不重要）：
sudo ntpdate ntp.ubuntu.com

echo "[Add the ROS repository]"

# shell中可以采用if来进行条件判断，以fi结尾。if后面的[]里是判断条件，-e表示文件存在时返回true
# 以下命令表示，如果/etc/apt/sources.list.d/ros-latest.list不存在，那么：
# 创建该文件并将deb http://packages.ros.org/ros/ubuntu xenial main写入该文件，
# 该文件记录着程序包的下载源；
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  #”sh -c“表示执行-c后面的字符串中的命令
  sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu ${name_os_version} main\" > /etc/apt/sources.list.d/ros-latest.list"
fi

echo "[Download the ROS keys]"
# 对roskey变量赋值，所赋的值为apt-key list | grep "Open Robotics"命令的返回值
roskey=`apt-key list | grep "Open Robotics"`
# -z表示如果变量roskey的长度是zero，也就是说apt-key list | grep "Open Robotics"命令没有返回值，
# 也就是说apt-key列表中没有"Open Robotics"相关的条目，
# 那么把以下内容写入apt-key，可看做下载安装ros时所需要的秘钥：
if [ -z "$roskey" ]; then
  sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
fi

echo "[Check the ROS keys]"
roskey=`apt-key list | grep "Open Robotics"`
# 执行同样的操作检查上面步骤中添加秘钥是否成功：
# -n表示如果变量roskey的长度不为0，代表成功添加秘钥
if [ -n "$roskey" ]; then
  echo "[ROS key exists in the list]"
else
  # 如果因为某种原因添加秘钥失败，退出此脚本
  echo "[Failed to receive the ROS key, aborts the installation]"
  exit 0
fi

echo "[Update the package lists and upgrade them]"
# 在添加了下载源和秘钥之后，需要做更新升级：
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[Install the ros-desktop-full and all rqt plugins]"
# 关键步骤：下载并安装ros-noetic程序包和相关程序包：
sudo apt-get install -y ros-$name_ros_version-desktop-full ros-$name_ros_version-rqt-*

echo "[Initialize rosdep]"
# 执行ros-noetic规定的初始化和更新步骤：
sudo sh -c "rosdep init"
rosdep update

echo "[Environment setup and getting rosinstall]"
# 环境配置、下载安装其他程序：
source /opt/ros/$name_ros_version/setup.sh
sudo apt-get install -y python-rosinstall

echo "[Make the catkin workspace and test the catkin_make]"
# 执行对catkin_make的测试：
# 首先建立catkin_ws文件夹
mkdir -p $HOME/$name_catkin_workspace/src
cd $HOME/$name_catkin_workspace/src
# 初始化workspace
catkin_init_workspace
cd $HOME/$name_catkin_workspace
# 执行catkin_make
catkin_make

echo "[Set the ROS evironment]"
# 以下是对ROS环境的配置，将以下各行文字写入~/.bashrc文件：
sh -c "echo \"alias eb='nano ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias sb='source ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias gs='git status'\" >> ~/.bashrc"
sh -c "echo \"alias gp='git pull'\" >> ~/.bashrc"
sh -c "echo \"alias cw='cd ~/$name_catkin_workspace'\" >> ~/.bashrc"
sh -c "echo \"alias cs='cd ~/$name_catkin_workspace/src'\" >> ~/.bashrc"
sh -c "echo \"alias cm='cd ~/$name_catkin_workspace && catkin_make'\" >> ~/.bashrc"

sh -c "echo \"source /opt/ros/$name_ros_version/setup.bash\" >> ~/.bashrc"
sh -c "echo \"source ~/$name_catkin_workspace/devel/setup.bash\" >> ~/.bashrc"

sh -c "echo \"export ROS_MASTER_URI=http://localhost:11311\" >> ~/.bashrc"
sh -c "echo \"export ROS_HOSTNAME=localhost\" >> ~/.bashrc"

source $HOME/.bashrc

echo "[Complete!!!]"
# 完成、退出
exit 0