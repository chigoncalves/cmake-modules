#[[.rst

FindGuile
---------
Find the development libraries for Guile.

Exported Vars
~~~~~~~~~~~~~

Guile_FOUND

Guile_INCLUDE_DIRS

Guile_LIBRARIES

Guile_VERSION_STRING

Guile_VERSION_MAJOR

Guile_VERSION_MINOR

Guile_VERSION_PATCH

Guile_PROGRAM

Control VARS
~~~~~~~~~~~~

Guile_ROOT_DIR

#]]

include (SelectLibraryConfigurations)
include (FindPackageHandleStandardArgs)

function (_guile_find_component_include_dir component header)
  find_path ("${component}_INCLUDE_DIR"
             ${header}
	     HINTS "${GUile_ROOT_DIR}" ENV Guile_ROOT_DIR
	     PATH_SUFFIXES Guile guile Guile-2.0 guile-2.0 Guile/2.0
	                   guile/2.0 GC gc)

  set ("${component}_INCLUDE_DIR" "${${component}_INCLUDE_DIR}"
       PARENT_SCOPE)

endfunction ()

function (_guile_find_component_library component_name component)

  find_library ("${component_name}_LIBRARY_RELEASE"
                NAMES "${component}" "${component}-2.0"
		PATHS  /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
		       /usr/lib32/${CMAKE_LIBRARY_ARCHITECTURE}
		       /usr/lib64/${CMAKE_LIBRARY_ARCHITECTURE})

  set (_component_library "${component_name}_LIBRARY_RELEASE")
  if  (${_component_library})
    select_library_configurations (${component_name})
    set ("${component_name}_LIBRARY_RELEASE"
         "${${component_name}_LIBRARY_RELEASE}" PARENT_SCOPE)
    set ("${component_name}_LIBRARY"
         "${${component_name}_LIBRARY}" PARENT_SCOPE)
    set ("${component_name}_LIBRARIES"
         "${${component_name}_LIBRARIES}" PARENT_SCOPE)
  endif ()
endfunction ()


function (_guile_find_version_2 header_file macro_name)
  file (STRINGS "${header_file}" _VERSION
        REGEX "#define[\t ]+${macro_name}[t\ ]+[0-9]+")

  if (_VERSION)
    string (REGEX REPLACE
            ".*#define[\t ]+${macro_name}[t\ ]+([0-9]+).*"
            "\\1" _VERSION_VALUE "${_VERSION}")
    if ("${_VERSION}" STREQUAL "${_VERSION_VALUE}")
      set (_VERSION_FOUND 0 PARENT_SCOPE)
    else ()
      set (_VERSION_FOUND 1 PARENT_SCOPE)
      set (_VERSION "${_VERSION_VALUE}" PARENT_SCOPE)
    endif ()
  else ()
    set (_VERSION_FOUND 0 PARENT_SCOPE)
  endif ()

  # cmake_print_variables (_VERSION)
endfunction ()


##### Entry Point #####

set (Guile_FOUND)
set (Guile_INCLUDE_DIRS)
set (Guile_LIBRARIES)
set (Guile_VERSION_STRING)
set (Guile_VERSION_MAJOR)
set (Guile_VERSION_MINOR)
set (Guile_VERSION_PATCH)
set (Guile_PROGRAM)

_guile_find_component_include_dir (Guile "libguile.h")
if (Guile_INCLUDE_DIR)
  _guile_find_version_2 ("${Guile_INCLUDE_DIR}/libguile/version.h"
                         "SCM_MAJOR_VERSION")
   if (_VERSION_FOUND)
     set (Guile_VERSION_MAJOR "${_VERSION}")
   else ()
     message (FATAL_ERROR "FindGuile: Failed to find \
Guile_MAJOR_VERSION.")
   endif ()

  _guile_find_version_2 ("${Guile_INCLUDE_DIR}/libguile/version.h"
                         "SCM_MINOR_VERSION")
   if (_VERSION_FOUND)
     set (Guile_VERSION_MINOR "${_VERSION}")
   else ()
     message (FATAL_ERROR "FindGuile: Failed to find \
Guile_MINOR_VERSION.")
   endif ()

  _guile_find_version_2 ("${Guile_INCLUDE_DIR}/libguile/version.h"
                         "SCM_MICRO_VERSION")
   if (_VERSION_FOUND)
     set (Guile_VERSION_PATCH "${_VERSION}")
   else ()
     message (FATAL_ERROR "FindGuile: Failed to find \
Guile_MICRO_VERSION.")
   endif ()
   set (Guile_VERSION_STRING "${Guile_VERSION_MAJOR}.\
${Guile_VERSION_MINOR}.${Guile_VERSION_PATCH}")
endif ()

_guile_find_component_include_dir (GC "gc.h")
_guile_find_component_library (Guile guile)
_guile_find_component_library (GC gc)

find_program (Guile_PROGRAM
              guile
              DOC "Guile executable.")

find_package_handle_standard_args (GC
                                   "FindGuile: Failed to find \
dependency GC."
				   GC_INCLUDE_DIR GC_LIBRARY
				   GC_LIBRARIES GC_LIBRARY_RELEASE)

find_package_handle_standard_args (Guile
                                   FOUND_VAR Guile_FOUND
				   REQUIRED_VARS Guile_INCLUDE_DIR
				   Guile_LIBRARY Guile_VERSION_STRING
				   Guile_LIBRARIES
				   Guile_LIBRARY_RELEASE
				   GC_LIBRARY GC_INCLUDE_DIR
				   GC_INCLUDE_DIR GC_LIBRARIES
				   VERSION_VAR Guile_VERSION_STRING)
if (Guile_FOUND)
  list (APPEND Guile_INCLUDE_DIRS "${Guile_INCLUDE_DIR}"
        "${GC_INCLUDE_DIR}")
  list (APPEND Guile_LIBRARIES "${GC_LIBRARY}")
  if (NOT TARGET Guile::Library AND NOT TARGET GC::Library)

    add_library (GC::Library UNKNOWN IMPORTED)
    set_target_properties (GC::Library PROPERTIES
                           INTERFACE_INCLUDE_DIRS "${GC_INCLUDE_DIR}")

    set_property (TARGET GC::Library APPEND PROPERTY
                  IMPORTED_CONFIGURATIONS RELEASE)

    set_target_properties (GC::Library PROPERTIES
                           IMPORTED_LOCATION_RELEASE
			   "${GC_LIBRARY_RELEASE}"
			   IMPORTED_LOCATION "${GC_LIBRARY}")

    add_library (Guile::Library UNKNOWN IMPORTED)
    set_target_properties (Guile::Library PROPERTIES
                           INTERFACE_INCLUDE_DIRS "${Guile_INCLUDE_DIR}")

    set_property (TARGET Guile::Library APPEND PROPERTY
                  IMPORTED_CONFIGURATIONS RELEASE)

    set_target_properties (Guile::Library PROPERTIES
                           IMPORTED_LOCATION_RELEASE
			   "${Guile_LIBRARY_RELEASE}"
			   IMPORTED_LOCATION "${Guile_LIBRARY}")
  endif ()
endif ()

unset (_VERSION_FOUND)
unset (_VERSION)

mark_as_advanced (Guile_FOUND
                  Guile_INCLUDE_DIRS
                  Guile_LIBRARIES
                  Guile_VERSION_STRING
                  Guile_VERSION_MAJOR
                  Guile_VERSION_MINOR
                  Guile_VERSION_PATCH
                  Guile_PROGRAM
		  GC_INCLUDE_DIR
		  GC_LIBRARY
		  GC_LIBRARY_RELEASE
		  GC_LIBRARIES)
