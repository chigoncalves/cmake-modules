#[[.rst

FindCUnit
---------

This module finds the package CUnit.

Usage to use it just issue the following command:

.. code-block:: cmake

   find_package (CUnit)

Upon ``find_package ()`` return the following variables will be set.

CUnit_FOUND
  Will have a *true* value if this module manages to find CUnit.

CUnit_INCLUDE_DIRS
  Will have a list of include directories.

CUnit_LIBRARIES
  Will have a list of libraries needed by CUnit.

CUnit_VERSION_STRING
  Wil have the version of the library found.

CUnit_VERSION_MAJOR

CUnit_VERSION_MINOR

CUnit_VERSION_PATCH

Hints
~~~~~
CUnit_ROOT_DIR
  Use this variable to provide hints to find_*, you may pass it to
  :command:`cmake` via -DCUnit_ROOT_DIR=<extra-path> or set the
  environtment variable via: ``export CUnit_ROOT_DIR=<extra-path> or

.. code::

   % CUnit_ROOT_DIR=<extra-path> cmake ../

#]]

include (CMakePrintHelpers)
include (SelectLibraryConfigurations)
include (FindPackageHandleStandardArgs)

set (CUnit_FOUND)
set (CUnit_INCLUDE_DIRS)
set (CUnit_LIBRARIES)

if (CUnit_FIND_COMPONENTS)
  message (SEND_ERROR "FindCUnit: This module does not have any "
"components. Fix the invocation of `find_package ()'.")
endif ()

find_path (CUnit_INCLUDE_DIR
  CUnit.h

  HINTS ${CUnit_ROOT_DIR}
  ENV CUnit_ROOT_DIR
  PATH_SUFFIXES CUnit cunit CUnit-2.0 cunit-2.0
  DOC "Include directory for CUnit.")

set (header_file "${CUnit_INCLUDE_DIR}/CUnit.h")
file (STRINGS ${header_file} CUnit_VERSION_STRING REGEX
      "#define[ \t]+CU_VERSION")
unset (header_file)

if (CUnit_VERSION_STRING)
  string (STRIP ${CUnit_VERSION_STRING} CUnit_VERSION_STRING)
  string (REGEX REPLACE "\"" "" CUnit_VERSION_STRING
          ${CUnit_VERSION_STRING})
  string (REGEX REPLACE "-" "." CUnit_VERSION_STRING
          ${CUnit_VERSION_STRING})

  string (REGEX REPLACE ".*CU_VERSION[ ]+([0-9]+).*$" "\\1"
          CUnit_VERSION_MAJOR "${CUnit_VERSION_STRING}")
  string (REGEX REPLACE ".*CU_VERSION[ ]+[0-9]+\\.([0-9]+).*$" "\\1"
          CUnit_VERSION_MINOR "${CUnit_VERSION_STRING}")
  string (REGEX REPLACE
          ".*CU_VERSION[ ]+[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1"
	  CUnit_VERSION_PATCH "${CUnit_VERSION_STRING}")
endif ()

set (CUnit_VERSION_STRING
     "${CUnit_VERSION_MAJOR}.${CUnit_VERSION_MINOR}.\
${CUnit_VERSION_PATCH}")

find_library (CUnit_LIBRARY_RELEASE
  cunit
  PATHS /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
  DOC "CUnit Release Library."
)

select_library_configurations (CUnit)


list (APPEND CUnit_INCLUDE_DIRS ${CUnit_INCLUDE_DIR})

find_package_handle_standard_args (CUnit
  FOUND_VAR CUnit_FOUND
  REQUIRED_VARS CUnit_LIBRARIES CUnit_INCLUDE_DIRS
  VERSION_VAR CUnit_VERSION
)

if (CUnit_FOUND AND NOT TARGET CUnit::LIBRARY)
  add_library (CUnit::LIBRARY UNKNOWN IMPORTED)
  set_property (TARGET CUnit::LIBRARY APPEND PROPERTY
                IMPORTED_CONFIGURATIONS RELEASE)

  set_target_properties (CUnit::LIBRARY
    PROPERTIES
      INTERFACE_LOCATION "${CUnit_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${CUnit_INCLUDE_DIR}")

  set_target_properties (CUnit::LIBRARY PROPERTIES
                         IMPORTED_LOCATION_RELEASE
			 ${CUnit_LIBRARY_RELEASE})
endif ()

if (CUnit_FIND_VERSION AND CUnit_FIND_VERSION_EXACT)
  if (NOT CUnit_VERSION VERSION_EQUAL CUnit_FIND_VERSION)
    message (FATAL_ERROR "Requested version is greater than the one found")
  endif ()
endif ()


mark_as_advanced (
  CUnit_LIBRARIES
  CUnit_LIBRARY
  CUnit_LIBRARY_RELEASE
  CUnit_LIBRARY_DEBUG
  CUnit_INCLUDE_DIR
  CUnit_INCLUDE_DIRS
  CUnit_VERSION
)
