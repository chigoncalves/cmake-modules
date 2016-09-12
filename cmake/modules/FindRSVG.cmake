#[[.rst
#
# FindRSVG
# --------
#
# .. variable:: RSVG_FOUND
#
# .. variable:: RSVG_INCLUDE_DIRS
#
# .. variable:: RSVG_LIBRARIES
#
# .. variable:: RSVG_VERSION_STRING
#
#
#]]


#[[.rst
#
# Copyright © 2016, Edelcides Gonçalves <eatg75 |0x40| gmail>
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all
# copies.
#
# *THE SOFTWARE IS PROVIDED* **AS IS** *AND ISC DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL ISC BE
# LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
# PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE*.
#
# This file is not part of CMake
#
#]]


include (CMakePrintHelpers)
include (SelectLibraryConfigurations)
include (FindPackageHandleStandardArgs)

function (_rsvg_find_component_include_dir component_name header)
  find_path (${component_name}_INCLUDE_DIR
             ${header}
	     PATH_SUFFIXES
	       cairo Cairo glib Glib glib-2.0  Glib-2.0 glib/gobject
	       Glib/gobject glib-2.0/gobject Glib-2.0/gobject gdk-pixbuf
	       gdk-pixbuf-2.0 gdk-pixbuf-2.0/gdk-pixbuf
	       glib Glib/gio glib-2.0/gio  Glib-2.0/gio
	       rsvg-2/librsvg rsvg-2.0/librsvg librsvg-2/librsvg
	       librsvg-2.0/librsvg)

  if (${component_name}_INCLUDE_DIR)
    set (${component_name}_INCLUDE_DIR
         "${${component_name}_INCLUDE_DIR}" PARENT_SCOPE)
    mark_as_advanced (${component_name}_INCLUDE_DIR)
  endif ()
endfunction ()

function (_rsvg_find_component_library component_name component)
  set (_names glib rsvg gio gobject gdk-pixbuf gdk_pixbuf
                         cairo)

  set (_names_with_version)
  foreach (name ${_names})
    list (APPEND _names_with_version ${name}-2.0)
  endforeach ()
  find_library (${component_name}_LIBRARY_RELEASE
                ${component}
                NAMES ${_names_with_version}
		PATHS
		  /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
		  /usr/lib64/${CMAKE_LIBRARY_ARCHITECTURE}
		  /usr/lib32/${CMAKE_LIBRARY_ARCHITECTURE})

  if (${component_name}_LIBRARY_RELEASE)
    select_library_configurations (${component_name})
    set (${component_name}_LIBRARY
         "${${component_name}_LIBRARY}" PARENT_SCOPE)
    set (${component_name}_LIBRARY_RELEASE
         "${${component_name}_LIBRARY_RELEASE}" PARENT_SCOPE)

    mark_as_advanced (${component_name}_LIBRARY
                      ${component_name}_LIBRARY_RELEASE)
  endif ()
endfunction ()

function (_rsvg_get_library_name name)
  set (LIBRARY_NAME ${name})
  string (REGEX MATCH "_" _matched ${name})
  if (_matched)
    string (REGEX REPLACE "([a-zA-Z]+)_([a-zA-Z]+)" "\\1::\\2"
                          LIBRARY_NAME
                          "${name}")
  endif ()

  set (LIBRARY_NAME ${LIBRARY_NAME}::Library PARENT_SCOPE)
endfunction ()

function (_rsvg_add_library name)
  cmake_parse_arguments (_RSVG "" "" "DEPEND_ON" ${ARGN})

  _rsvg_get_library_name (${name})
  if (NOT TARGET ${LIBRARY_NAME})
    add_library (${LIBRARY_NAME} UNKNOWN IMPORTED)
    set_property (TARGET ${LIBRARY_NAME} APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (${LIBRARY_NAME}
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${${name}_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${${name}_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			       "${${name}_LIBRARY_RELEASE}")

    set (_SELF ${LIBRARY_NAME})
    foreach (DEPENDENCY ${_RSVG_DEPEND_ON})
      _rsvg_get_library_name (${DEPENDENCY})
      set_property (TARGET ${_SELF} APPEND
	            PROPERTY
		    INTERFACE_LINK_LIBRARIES
		      ${LIBRARY_NAME})
    endforeach ()
    set (RSVG_LIBRARIES "${RSVG_LIBRARIES};${_SELF}" PARENT_SCOPE)
  endif ()
  unset (LIBRARY_NAME)
endfunction ()

function (_rsvg_library_remove_module_prefix NAME)
  set (LIBRARY_NAME_SANS_PREFIX ${NAME})
  string (REGEX MATCH "RSVG_" _MATCHED ${NAME})
  if (_MATCHED)
    string (REPLACE "RSVG_" "" LIBRARY_NAME_SANS_PREFIX ${NAME})
  endif ()
  set (LIBRARY_NAME_SANS_PREFIX ${LIBRARY_NAME_SANS_PREFIX}
       PARENT_SCOPE)
endfunction ()

function (_rsvg_find_version HEADER_FILE MACRO_NAME)
  file (STRINGS "${HEADER_FILE}" _VERSION
        REGEX "#define[\t ]+${MACRO_NAME}[\t ]+\\(?[0-9]+\\)?")

  if (_VERSION)
    string (REGEX REPLACE
            ".*#define[\t ]+${MACRO_NAME}[\t ]+.\\(?([0-9]+)\\)?.*"
            "\\1" _VERSION_VALUE "${_VERSION}")
    if ("${_VERSION}" STREQUAL "${_VERSION_VALUE}")
      set (VERSION_FOUND 0 PARENT_SCOPE)
    else ()
      set (VERSION_FOUND 1 PARENT_SCOPE)
      set (VERSION "${_VERSION_VALUE}" PARENT_SCOPE)
    endif ()
  else ()
    set (VERSION_FOUND 0 PARENT_SCOPE)
  endif ()
endfunction ()


#### Entry Point #####

set (RSVG_FOUND)
set (RSVG_INCLUDE_DIRS)
set (RSVG_LIBRARIES)
set (RSVG_VERSION_STRING)

set (_LIBRARIES RSVG_Cairo RSVG_Glib RSVG_Gobject RSVG_GdkPixbuf
           RSVG_GIO RSVG_Math)
foreach (LIBRARY ${_LIBRARIES})
  if (${LIBRARY} STREQUAL RSVG_Cairo)
    set (_LIBRARY_HEADER cairo.h)
    set (_LIBRARY_DEPENDENCIES)
    set (_LIBRARY_NAME cairo)
  elseif (${LIBRARY} STREQUAL RSVG_Glib)
    set (_LIBRARY_HEADER glib.h)
    set (_LIBRARY_DEPENDENCIES)
    set (_LIBRARY_NAME glib)
  elseif (${LIBRARY} STREQUAL RSVG_Gobject)
    set (_LIBRARY_HEADER gobject.h)
    set (_LIBRARY_DEPENDENCIES Glib_FOUND)
    set (_LIBRARY_NAME gobject)
  elseif (${LIBRARY} STREQUAL RSVG_GdkPixbuf)
    set (_LIBRARY_HEADER gdk-pixbuf.h)
    set (_LIBRARY_NAME gdk-pixbuf)
    set (_LIBRARY_DEPENDENCIES Glib_FOUND Gobject_FOUND)
  elseif (${LIBRARY} STREQUAL RSVG_GIO)
    set (_LIBRARY_HEADER gio.h)
    set (_LIBRARY_DEPENDENCIES Glib_FOUND Gobject_FOUND)
    set (_LIBRARY_NAME gio)
  elseif (${LIBRARY} STREQUAL RSVG_Math)
    set (_LIBRARY_HEADER math.h)
    set (_LIBRARY_DEPENDENCIES)
    set (_LIBRARY_NAME m)
  endif ()
  _rsvg_find_component_include_dir (${LIBRARY} ${_LIBRARY_HEADER})
  _rsvg_find_component_library (${LIBRARY} ${_LIBRARY_NAME})
  _rsvg_library_remove_module_prefix (${LIBRARY})
  find_package_handle_standard_args (${LIBRARY_NAME_SANS_PREFIX}
                                     DEFAULT_MESSAGE
				     ${LIBRARY}_INCLUDE_DIR
				     ${LIBRARY}_LIBRARY
				     ${LIBRARY}_LIBRARY_RELEASE
				     ${LIBRARY_DEPENDENCIES})
endforeach ()
unset (LIBRARY_NAME_SANS_PREFIX)

_rsvg_find_component_include_dir (RSVG rsvg.h)
_rsvg_find_component_library (RSVG rsvg)

_rsvg_find_version ("${RSVG_INCLUDE_DIR}/librsvg-features.h"
                    "LIBRSVG_MAJOR_VERSION")
if (VERSION_FOUND)
  set (RSVG_VERSION_MAJOR ${VERSION})
endif ()

_rsvg_find_version ("${RSVG_INCLUDE_DIR}/librsvg-features.h"
                    "LIBRSVG_MINOR_VERSION")
if (VERSION_FOUND)
  set (RSVG_VERSION_MINOR ${VERSION})
endif ()

_rsvg_find_version ("${RSVG_INCLUDE_DIR}/librsvg-features.h"
                    "LIBRSVG_MICRO_VERSION")
if (VERSION_FOUND)
  set (RSVG_VERSION_PATCH ${VERSION})
endif ()

set (RSVG_VERSION_STRING "${RSVG_VERSION_MAJOR}.\
${RSVG_VERSION_MINOR}.${RSVG_VERSION_PATCH}")

find_package_handle_standard_args (RSVG
                                   REQUIRED_VARS
				     RSVG_INCLUDE_DIR
				     RSVG_LIBRARY
				     RSVG_LIBRARY_RELEASE
				     Glib_FOUND
				     Gobject_FOUND
				     Cairo_FOUND
				     GdkPixbuf_FOUND
				     GIO_FOUND MATH_FOUND
				   VERSION_VAR RSVG_VERSION_STRING)

if (RSVG_FOUND)
  set (_LIBS RSVG_Cairo RSVG_Glib RSVG_Gobject RSVG_GdkPixbuf
             RSVG_GIO RSVG_Math RSVG)
  set (_LIB_DEPENDENCIES)
  set (RSVG_LIBRARIES)
  foreach (LIB ${_LIBS})
    # Piggy backing on this loop.
    list (APPEND RSVG_INCLUDE_DIRS "${${LIB}_INCLUDE_DIR}")

    if (${LIB} STREQUAL RSVG_Cairo)
      set (_LIB_DEPENDENCIES)
    elseif (${LIB} STREQUAL RSVG_Glib)
      set (_LIB_DEPENDENCIES)
    elseif (${LIB} STREQUAL RSVG_Gobject)
      set (_LIB_DEPENDENCIES RSVG_Glib)
    elseif (${LIB} STREQUAL RSVG_GdkPixbuf)
      set (_LIB_DEPENDENCIES RSVG_Glib RSVG_Gobject)
    elseif (${LIB} STREQUAL RSVG_GIO)
      set (_LIB_DEPENDENCIES RSVG_Glib RSVG_Gobject)
    elseif (${LIB} STREQUAL RSVG_Math)
      set (_LIB_DEPENDENCIES)
    elseif (${LIB} STREQUAL RSVG)
      set (_LIB_DEPENDENCIES RSVG_Cairo RSVG_Glib RSVG_Gobject
	                     RSVG_GdkPixbuf RSVG_GIO RSVG_Math)
    endif ()

    _rsvg_add_library (${LIB} DEPEND_ON ${_LIB_DEPENDENCIES})
  endforeach ()

  list (REMOVE_DUPLICATES RSVG_INCLUDE_DIRS)
endif ()
