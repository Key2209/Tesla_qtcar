# 1. 告诉 CMake 我们在交叉编译 Linux 系统
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# 2. 指定交叉编译器的绝对路径
set(CMAKE_C_COMPILER "/opt/atk-dlrk356x-toolchain/bin/aarch64-buildroot-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "/opt/atk-dlrk356x-toolchain/bin/aarch64-buildroot-linux-gnu-g++")

# 3. 指定 Sysroot (核心！让 CMake 去这里找 ARM 的系统头文件和基础库)
set(CMAKE_SYSROOT "/opt/atk-dlrk356x-toolchain/aarch64-buildroot-linux-gnu/sysroot")

# 4. 指定 Qt 库的路径 (让 find_package(Qt5) 找到 ARM 版的 Qt)
set(CMAKE_PREFIX_PATH "${CMAKE_SYSROOT}/usr/lib/cmake")

# 5. 设置查找策略：只在 Sysroot 中寻找库和头文件，绝不去宿主机(Ubuntu)目录找，防止混用
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)