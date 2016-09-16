if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL
    "${CMAKE_CURRENT_SOURCE_DIR}")
  message (FATAL_ERROR [[In source builds are not allowed.
Try running `cmake' . -B<build-dir>]])
endif ()

cmake_minimum_required (VERSION 3.0)
cmake_policy (SET CMP0054 NEW)
include (CMakePrintHelpers)

project (cmake-modules LANGUAGES C)
list (APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/modules")

set (cmake_CLI_SWITCH "--warn-uninitialize"
		      CACHE
		      INTERNAL
		      "CMake command line switches used to run my\
modules tests.")

set (TEST_DIRECTORY "${PROJECT_SOURCE_DIR}/t")

try_compile (Guile_SUCCESS ${PROJECT_BINARY_DIR}/t/guile
             ${TEST_DIRECTORY}/guile guile
	     CMAKE_FLAGS -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/modules)

try_compile (Gtk3_SUCCESS ${PROJECT_BINARY_DIR}/t/gtk+3
             ${TEST_DIRECTORY}/gtk+3 gtk+3
	     CMAKE_FLAGS -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/modules)

if (Guile_SUCCESS)
  message (STATUS "cmake-modules: Guile test passed!")
else ()
  message (WARNING "cmake-modules: Guile test failed!")
endif ()

if (Gtk3_SUCCESS)
  message (STATUS "cmake-modules: Gtk3 test passed!")
else ()
  message (WARNING "cmake-modules: Gtk3 test failed!")
endif ()
