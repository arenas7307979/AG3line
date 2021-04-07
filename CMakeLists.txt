cmake_minimum_required(VERSION 3.10)
project(AG3line VERSION 1.0)

find_package(OpenCV)
message("-- OpenCV_FOUND: ${OpenCV_FOUND}")
message("-- OpenCV_INCLUDE_DIRS: ${OpenCV_INCLUDE_DIRS}")
message("-- OpenCV_LIBS: ${OpenCV_LIBS}")

include_directories(src ${OpenCV_INCLUDE_DIRS})
file(GLOB_RECURSE EXE_SOURCES "src/*.cpp")

add_executable(AG3line ${EXE_SOURCES})
target_link_libraries(AG3line ${OpenCV_LIBS})