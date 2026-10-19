cmake_minimum_required(VERSION 3.21)

project(VSyntaxHighlighting VERSION 6.30.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(GNUInstallDirs)
include(GenerateExportHeader)

find_package(Qt6 6.9 NO_MODULE REQUIRED COMPONENTS Core Gui Network)
find_package(Python 3 REQUIRED COMPONENTS Interpreter)

option(QRC_SYNTAX "Bundle the syntax definition files inside the library as resources" ON)
option(NO_STANDARD_PATHS "Skip lookup of syntax and theme definitions in QStandardPaths locations" OFF)

add_subdirectory(data)
add_subdirectory(src)
