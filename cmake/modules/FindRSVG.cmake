#[[.rst

FindRSVG
--------

.. variable:: RSVG_FOUND

.. variable:: RSVG_INCLUDE_DIRS

.. variable:: RSVG_LIBRARIES

.. variable:: RSVG_VERSION_STRING


#]]

#=====================================================================
# Copyright 2016 chigoncalves <Edelcides Gonçalves>
#
# This file is not part of CMake
#
#=====================================================================


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
    set (${component_name}_LIBRARIES
         "${${component_name}_LIBRARIES}" PARENT_SCOPE)

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
endfunction ()

#### Entry Point #####

set (RSVG_FOUND)
set (RSVG_INCLUDE_DIRS)
set (RSVG_LIBRARIES)
set (RSVG_VERSION_STRING)

_rsvg_find_component_include_dir (RSVG_Cairo cairo.h)
_rsvg_find_component_library (RSVG_Cairo cairo)
find_package_handle_standard_args (Cairo
                                   "FindRSVG: Failed to find \
component Cairo."
				   RSVG_Cairo_INCLUDE_DIR
				   RSVG_Cairo_LIBRARY
				   RSVG_Cairo_LIBRARY_RELEASE
				   RSVG_Cairo_LIBRARIES)

_rsvg_find_component_include_dir (RSVG_Glib glib.h)
_rsvg_find_component_library (RSVG_Glib glib)
find_package_handle_standard_args (Glib
                                   "FindRSVG: Failed to find \
component Glib."
				   RSVG_Glib_INCLUDE_DIR
				   RSVG_Glib_LIBRARY
				   RSVG_Glib_LIBRARY_RELEASE
				   RSVG_Glib_LIBRARIES)


_rsvg_find_component_include_dir (RSVG_Gobject gobject.h)
_rsvg_find_component_library (RSVG_Gobject gobject)
find_package_handle_standard_args (Gobject
                                   "FindRSVG: Failed to find \
component Gobjet."
				   RSVG_Gobject_INCLUDE_DIR
				   RSVG_Gobject_LIBRARY
				   RSVG_Gobject_LIBRARY_RELEASE
				   RSVG_Gobject_LIBRARIES)

_rsvg_find_component_include_dir (RSVG_GdkPixbuf gdk-pixbuf.h)
_rsvg_find_component_library (RSVG_GdkPixbuf gdk-pixbuf)
find_package_handle_standard_args (GdkPixbuf
                                   "FindRSVG: Failed to find \
component GdkPixbuf."
				   RSVG_GdkPixbuf_INCLUDE_DIR
				   RSVG_GdkPixbuf_LIBRARY
				   RSVG_GdkPixbuf_LIBRARY_RELEASE
				   RSVG_GdkPixbuf_LIBRARIES)

_rsvg_find_component_include_dir (RSVG_GIO gio.h)
_rsvg_find_component_library (RSVG_GIO gio)
find_package_handle_standard_args (GIO
                                   "FindRSVG: Failed to find \
component GIO."
				   RSVG_GIO_INCLUDE_DIR
				   RSVG_GIO_LIBRARY
				   RSVG_GIO_LIBRARY_RELEASE
				   RSVG_GIO_LIBRARIES)

_rsvg_find_component_include_dir (RSVG_Math math.h)
_rsvg_find_component_library (RSVG_Math m)
find_package_handle_standard_args (Math
                                   "FindRSVG: Failed to find \
component Math."
				   RSVG_Math_INCLUDE_DIR
				   RSVG_Math_LIBRARY
				   RSVG_Math_LIBRARY_RELEASE
				   RSVG_Math_LIBRARIES)

_rsvg_find_component_include_dir (RSVG rsvg.h)
_rsvg_find_component_library (RSVG rsvg)
find_package_handle_standard_args (RSVG
                                   "FindRSVG: Failed to find \
component RSVG."
				   RSVG_INCLUDE_DIR
				   RSVG_LIBRARY
				   RSVG_LIBRARY_RELEASE
				   RSVG_LIBRARIES Cairo_FOUND
				   Glib_FOUND Gobject_FOUND
				   GdkPixbuf_FOUND GIO_FOUND
				   MATH_FOUND)

if (RSVG_FOUND)
  set (_libs RSVG_Cairo RSVG_Glib RSVG_Gobject RSVG_GdkPixbuf
             RSVG_GIO RSVG_Math RSVG)
  set (_lib_dependencies)
  set (RSVG_LIBRARIES)
  foreach (lib ${_libs})
    # Piggy backing on this loop.
    list (APPEND RSVG_INCLUDE_DIRS "${${lib}_INCLUDE_DIR}")

    if (${lib} STREQUAL RSVG_Cairo)
      set (_lib_dependencies)
    elseif (${lib} STREQUAL RSVG_Glib)
      set (_lib_dependencies)
    elseif (${lib} STREQUAL RSVG_Gobject)
      set (_lib_dependencies RSVG_Glib)
    elseif (${lib} STREQUAL RSVG_GdkPixbuf)
      set (_lib_dependencies RSVG_Glib RSVG_Gobject)
    elseif (${lib} STREQUAL RSVG_GIO)
      set (_lib_dependencies RSVG_Glib RSVG_Gobject)
    elseif (${lib} STREQUAL RSVG_Math)
      set (_lib_dependencies)
    elseif (${lib} STREQUAL RSVG)
      set (_lib_dependencies RSVG_Cairo RSVG_Glib RSVG_Gobject
	                     RSVG_GdkPixbuf RSVG_GIO RSVG_Math)
    endif ()

    _rsvg_add_library (${lib} DEPEND_ON ${_lib_dependencies})
  endforeach ()

  list (REMOVE_DUPLICATES RSVG_INCLUDE_DIRS)
endif ()
