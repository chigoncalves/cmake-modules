#[[.rst

Exported
--------

Imlib2_FOUND

Imlib2_INCLUDE_DIRS

Imlib2_LIBRARIES

Imlib2 does not provide version number.

External Var
~~~~~~~~~~~~

Imlib2_ROOT_DIR

#]]

#=====================================================================
# Copyright 2016 chigoncalves <Edelcides Gonçalves>
#
# This file is not part of CMake
#
#=====================================================================


include (SelectLibraryConfigurations)
include (FindPackageHandleStandardArgs)

function (_imlib2_find_include_dir)
  find_path (Imlib2_INCLUDE_DIR
             Imlib2.h
	     HINT "${Imlib2_ROOT_DIR}" ENV Imlib2_ROOT_DIR
	     PATH_SUFIXES Imlib imlib Imlib2 imlib2 Imlib-2
	     imlib-2 Imlib-2.0 imlib-2.0
	     DOC "Imlib2 Include directory.")

  if (Imlib2_INCLUDE_DIR)
    set (Imlib2_INCLUDE_DIR "${Imlib2_INCLUDE_DIR}" PARENT_SCOPE)
  endif ()
endfunction ()

function (_imlib2_find_library)
  find_library (Imlib2_LIBRARY_RELEASE
                imlib2
		NAMES Imlib2 Imlib-2 Imlib-2.0
		PATHS /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
		/usr/lib64/${CMAKE_LIBRARY_ARCHITECTURE}
		/usr/lib32/${CMAKE_LIBRARY_ARCHITECTURE})

  if (Imlib2_LIBRARY_RELEASE)
    select_library_configurations (Imlib2)

    set (Imlib2_LIBRARY_RELEASE "${Imlib2_LIBRARY_RELEASE}"
         PARENT_SCOPE)
    set (Imlib2_LIBRARY "${Imlib2_LIBRARY}" PARENT_SCOPE)

    set (Imlib2_LIBRARIES "${Imlib2_LIBRARIES}" PARENT_SCOPE)
  endif ()
endfunction ()


#### Entry Point ####

set (Imlib2_FOUND)
set (Imlib2_INCLUDE_DIRS)

_imlib2_find_include_dir ()
_imlib2_find_library ()
find_package_handle_standard_args (Imlib2
                                   FOUND_VAR Imlib2_FOUND
				   REQUIRED_VARS Imlib2_INCLUDE_DIR
				   Imlib2_LIBRARY
				   Imlib2_LIBRARY_RELEASE
				   Imlib2_LIBRARIES)

if (Imlib2_FOUND)
  set (Imlib2_INCLUDE_DIRS "${Imlib2_INCLUDE_DIRS}")
  if (NOT TARGET Imlib2::Library)
    add_library (Imlib2::Library UNKNOWN IMPORTED)
    set_target_properties (Imlib2::Library PROPERTIES
                           INTERFACE_INCLUDE_DIRS
			   "${Imlib2_INCLUDE_DIR}")

    set_property (TARGET Imlib2::Library APPEND PROPERTY
                  IMPORTED_CONFIGURATIONS RELEASE)

    set_target_properties (Imlib2::Library PROPERTIES
                           IMPORTED_LOCATION_RELEASE
			   "${Imlib2_LIBRARY_RELEASE}"
			   IMPORTED_LOCATION "${Imlib2_LIBRARY}")
   endif ()
endif ()

mark_as_advanced (Imlib2_FOUND
                  Imlib2_INCLUDE_DIRS
                  Imlib2_INCLUDE_DIR
		  Imlib2_LIBRARY
		  Imlib2_LIBRARY_RELEASE
		  Imlib2_LIBRARIES)
