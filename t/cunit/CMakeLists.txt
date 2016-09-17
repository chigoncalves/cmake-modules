if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL
    "${CMAKE_CURRENT_SOURCE_DIR}")
  message (FATAL_ERROR [[In source builds are not allowed.
Try running `cmake' . -B<build-dir>]])
endif ()

cmake_minimum_required (VERSION 3.0)
cmake_policy (SET CMP0054 NEW)

project (cunit LANGUAGES C)

find_package (CUnit QUIET)
include (CMakePrintHelpers)

cmake_print_variables (CUnit_INCLUDE_DIRS CUnit_LIBRARIES)

add_executable (cunit cunit.c)
target_include_directories (cunit PUBLIC ${CUnit_INCLUDE_DIRS})
target_link_libraries (cunit PUBLIC ${CUnit_LIBRARIES})
