cmake_minimum_required(VERSION 3.16)
if(NOT CMAKE_CROSSCOMPILING)
    set(CMAKE_PREFIX_PATH "/opt/Qt/5.15.2/gcc_64")
endif()
project(Tesla_Dashboard_UI VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# 自动处理 MOC, UIC, RCC
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# 查找需要的 Qt 模块 (支持 Qt5 和 Qt6)，根据 pro 文件的 "QT += quick concurrent"
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Gui Concurrent)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Gui Concurrent)

# 添加资源和源码文件
set(PROJECT_SOURCES
    main.cpp
    Controllers/MusicController.cpp
    Controllers/PhoneController.cpp
    qml.qrc
)

# 兼容 Qt5 和 Qt6 创建可执行文件
if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(Tesla_Dashboard_UI
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(Tesla_Dashboard_UI SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(Tesla_Dashboard_UI
            ${PROJECT_SOURCES}
        )
    endif()
endif()

# 链接 Qt 库
target_link_libraries(Tesla_Dashboard_UI PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Concurrent
)

# 包含 CPP 目录路径
target_include_directories(Tesla_Dashboard_UI PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}/CPP
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(Tesla_Dashboard_UI)
    qt_finalize_executable(Tesla_Dashboard_UI)
endif()
