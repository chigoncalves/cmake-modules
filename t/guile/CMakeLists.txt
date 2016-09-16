if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL
    "${CMAKE_CURRENT_SOURCE_DIR}")
  message (FATAL_ERROR [[In source builds are not allowed.
Try running `cmake' . -B<build-dir>]])
endif ()

cmake_minimum_required (VERSION 3.0)
cmake_policy (SET CMP0054 NEW)

project (guile LANGUAGES C)

find_package (Guile QUIET)

add_executable (guile guile.c)
target_include_directories (guile PUBLIC ${Guile_INCLUDE_DIRS})
target_link_libraries (guile PUBLIC ${Guile_LIBRARIES})
