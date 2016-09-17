if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL
    "${CMAKE_CURRENT_SOURCE_DIR}")
  message (FATAL_ERROR [[In source builds are not allowed.
Try running `cmake' . -B<build-dir>]])
endif ()

cmake_minimum_required (VERSION 3.0)
cmake_policy (SET CMP0054 NEW)

project (cmake-modules LANGUAGES C)
set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/modules")

set (TEST_DIRECTORY "${PROJECT_SOURCE_DIR}/t")

try_compile (Guile_SUCCESS ${PROJECT_BINARY_DIR}/t/guile
             ${TEST_DIRECTORY}/guile guile
	     CMAKE_FLAGS -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH})

try_compile (Gtk3_SUCCESS ${PROJECT_BINARY_DIR}/t/gtk+3
             ${TEST_DIRECTORY}/gtk+3 gtk+3
	     CMAKE_FLAGS -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH})

try_compile (Imlib2_SUCCESS ${PROJECT_BINARY_DIR}/t/imlib2
             ${TEST_DIRECTORY}/imlib2 imlib2
	     CMAKE_FLAGS -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH})

try_compile (CUnit_SUCCESS ${PROJECT_BINARY_DIR}/t/cunit
             ${TEST_DIRECTORY}/cunit cunit
	     CMAKE_FLAGS -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH})

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

if (Imlib2_SUCCESS)
  message (STATUS "cmake-modules: Imlib2 test passed!")
else ()
  message (WARNING "cmake-modules: Imlib2 test failed!")
endif ()

if (CUnit_SUCCESS)
  message (STATUS "cmake-modules: CUnit test passed!")
else ()
  message (WARNING "cmake-modules: CUnit test failed!")
endif ()
