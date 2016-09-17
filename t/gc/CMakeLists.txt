if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL
    "${CMAKE_CURRENT_SOURCE_DIR}")
  message (FATAL_ERROR [[In source builds are not allowed.
Try running `cmake' . -B<build-dir>]])
endif ()

cmake_minimum_required (VERSION 3.0)
cmake_policy (SET CMP0054 NEW)

project (gc LANGUAGES C)

find_package (GC QUIET)
add_definitions (${GC_DEFINITIONS})

add_executable (gc main.c)
target_include_directories (gc PUBLIC ${GC_INCLUDE_DIRS})
target_link_libraries (gc PUBLIC ${GC_LIBRARIES})
