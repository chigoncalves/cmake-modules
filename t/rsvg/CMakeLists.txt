if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL
    "${CMAKE_CURRENT_SOURCE_DIR}")
  message (FATAL_ERROR [[In source builds are not allowed.
Try running `cmake' . -B<build-dir>]])
endif ()

cmake_minimum_required (VERSION 3.0)
cmake_policy (SET CMP0054 NEW)

project (rsvg LANGUAGES C)

find_package (RSVG QUIET)
add_definitions (${RSVG_DEFINITIONS})

add_executable (rsvg main.c)
target_include_directories (rsvg PUBLIC ${RSVG_INCLUDE_DIRS})
target_link_libraries (rsvg PUBLIC ${RSVG_LIBRARIES})
