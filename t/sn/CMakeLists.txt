if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL
    "${CMAKE_CURRENT_SOURCE_DIR}")
  message (FATAL_ERROR [[In source builds are not allowed.
Try running `cmake' . -B<build-dir>]])
endif ()

cmake_minimum_required (VERSION 3.0)
cmake_policy (SET CMP0054 NEW)

project (sn LANGUAGES C)

find_package (SN QUIET)
add_definitions (${SN_DEFINITIONS})

add_executable (sn main.c)
target_include_directories (sn PUBLIC ${SN_INCLUDE_DIRS})
target_link_libraries (sn PUBLIC ${SN_LIBRARIES})
