if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL
    "${CMAKE_CURRENT_SOURCE_DIR}")
  message (FATAL_ERROR [[In source builds are not allowed.
Try running `cmake' . -B<build-dir>]])
endif ()

cmake_minimum_required (VERSION 3.0)
cmake_policy (SET CMP0054 NEW)

project (gtk+3 LANGUAGES C)

find_package (Gtk3 QUIET)
include (CMakePrintHelpers)

cmake_print_variables (Gtk3_INCLUDE_DIRS Gtk3_LIBRARIES)

add_executable (gtk+3 gtk+3.c)
target_include_directories (gtk+3 PUBLIC ${Gtk3_INCLUDE_DIRS})
target_link_libraries (gtk+3 PUBLIC ${Gtk3_LIBRARIES})
