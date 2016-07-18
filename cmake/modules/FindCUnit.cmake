#[[.rst

FindCUnit
---------

This module finds the package CUnit.

Usage
~~~~~

.. code-block:: cmake

   find_package (CUnit)

If everything went fine **FindCUnit** will define the folowing
variables.

.. variable:: CUnit_FOUND

   Will set to *true* if CUnit was found in your system.

.. variable:: CUnit_INCLUDE_DIRS

   Will be set with a list of include directories.

.. variable:: CUnit_LIBRARIES

   Will set with a list of libraries to link you project to.

.. variable:: CUnit_VERSION_STRING

   Wil be set with CUnit full version.

.. variable:: CUnit_VERSION_MAJOR

   Will be set with CUnit major version.

.. variable:: CUnit_VERSION_MINOR

   Will be set with CUnit major version.

.. variable:: CUnit_VERSION_PATCH

   Will be set with CUnit patch version.

Hints
~~~~~
:envvar:`CUnit_ROOT_DIR`

  Use this variable to provide hints to :filename:`find_{*}` commands,
  you may pass it to :command:`cmake` or set the environtment variable.

.. code-block:: cmake

   % cmake . -Bbuild -DCUnit_ROOT_DIR=<extra-path>

   # or
   % export CUnit_ROOT_DIR=<extra-path>;
   % cmake . -Bbuild

   # or
   % CUnit_ROOT_DIR=<extra-path> cmake . -Bbuild


#]]


#=====================================================================
# Copyright 2016 chigoncalves <Edelcides Gonçalves>
#
# This file is not part of CMake
#
#=====================================================================


include (SelectLibraryConfigurations)
include (FindPackageHandleStandardArgs)

set (CUnit_FOUND)
set (CUnit_INCLUDE_DIRS)
set (CUnit_LIBRARIES)
set (CUnit_VERSION_STRING)
set (CUnit_VERSION_MAJOR)
set (CUnit_VERSION_MINOR)
set (CUnit_VERSION_PATCH)

find_path (CUnit_INCLUDE_DIR
           CUnit.h
	   HINTS
	     "${CUnit_ROOT_DIR}"
	     ENV CUnit_ROOT_DIR
	   PATH_SUFFIXES CUnit cunit CUnit-2.0 cunit-2.0
	   DOC "Include directory for CUnit.")

file (STRINGS "${CUnit_INCLUDE_DIR}/CUnit.h" CUnit_VERSION_STRING
      REGEX "#define[ \t]+CU_VERSION")

if (CUnit_VERSION_STRING)
  string (STRIP ${CUnit_VERSION_STRING} CUnit_VERSION_STRING)
  string (REGEX REPLACE "\"" "" CUnit_VERSION_STRING
          ${CUnit_VERSION_STRING})
  string (REGEX REPLACE "-" "." CUnit_VERSION_STRING
          ${CUnit_VERSION_STRING})

  string (REGEX REPLACE ".*CU_VERSION[ ]+([0-9]+).*" "\\1"
          CUnit_VERSION_MAJOR "${CUnit_VERSION_STRING}")
  string (REGEX REPLACE ".*CU_VERSION[ ]+[0-9]+\\.([0-9]+).*" "\\1"
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
	      HINTS
	        "${CUnit_ROOT_DIR}"
		ENV CUnit_ROOT_DIR
	      PATHS
	        /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
	        /usr/lib64/${CMAKE_LIBRARY_ARCHITECTURE}
	        /usr/lib32/${CMAKE_LIBRARY_ARCHITECTURE}
	      DOC "CUnit Release Library.")

select_library_configurations (CUnit)

find_package_handle_standard_args (CUnit
                                   REQUIRED_VARS
				     CUnit_INCLUDE_DIR
				     CUnit_LIBRARY
				     CUnit_LIBRARY_RELEASE
				     CUnit_LIBRARIES
			           VERSION_VAR CUnit_VERSION)

if (CUnit_FOUND AND NOT TARGET CUnit::Library)
  add_library (CUnit::Library UNKNOWN IMPORTED)
  set_property (TARGET CUnit::Library APPEND
                PROPERTY
                  IMPORTED_CONFIGURATIONS RELEASE)

  set_target_properties (CUnit::Library
                         PROPERTIES
			   INTERFACE_LOCATION
			     "${CUnit_LIBRARY}"
                           IMPORTED_LOCATION_RELEASE
       			     "${CUnit_LIBRARY_RELEASE}"
   			   INTERFACE_INCLUDE_DIRECTORIES
			     "${CUnit_INCLUDE_DIR}")

  set (CUnit_INCLUDE_DIRS "${CUnit_INCLUDE_DIR}")
  set (CUnit_LIBRARIES CUnit::Library)
endif ()

mark_as_advanced (CUnit_LIBRARY
		  CUnit_LIBRARY_RELEASE
		  CUnit_LIBRARY_DEBUG
		  CUnit_INCLUDE_DIR)
