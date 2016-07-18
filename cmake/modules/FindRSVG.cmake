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


  if (NOT TARGET RSVG::Cairo::Library)
    add_library (RSVG::Cairo::Library UNKNOWN IMPORTED)
    set_property (TARGET RSVG::Cairo::Library APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (RSVG::Cairo::Library
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${RSVG_Cairo_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${RSVG_Cairo_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			        "${RSVG_Cairo_LIBRARY_RELEASE}")
  endif ()

  if (NOT TARGET RSVG::Glib::Library)
    add_library (RSVG::Glib::Library UNKNOWN IMPORTED)
    set_property (TARGET RSVG::Glib::Library APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (RSVG::Glib::Library
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${RSVG_Glib_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${RSVG_Glib_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			        "${RSVG_Glib_LIBRARY_RELEASE}")
  endif ()

  if (NOT TARGET RSVG::Gobject::Library)
    add_library (RSVG::Gobject::Library UNKNOWN IMPORTED)
    set_property (TARGET RSVG::Gobject::Library APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (RSVG::Gobject::Library
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${RSVG_Gobject_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${RSVG_Gobject_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			        "${RSVG_Gobject_LIBRARY_RELEASE}"
		             INTERFACE_LINKE_LIBRARIES
			       RSVG::Glib::Library)
  endif ()

  if (NOT TARGET RSVG::GdkPixbuf::Library)
    add_library (RSVG::GdkPixbuf::Library UNKNOWN IMPORTED)
    set_property (TARGET RSVG::GdkPixbuf::Library APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (RSVG::GdkPixbuf::Library
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${RSVG_GdkPixbuf_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${RSVG_GdkPixbuf_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			        "${RSVG_GdkPixbuf_LIBRARY_RELEASE}"
			     INTERFACE_LINK_LIBRARIES
			       RSVG::Glib::Library
			     INTERFACE_LINK_LIBRARIES
			       RSVG::Gobject::Library)
  endif ()

  if (NOT TARGET RSVG::GIO::Library)
    add_library (RSVG::GIO::Library UNKNOWN IMPORTED)
    set_property (TARGET RSVG::GIO::Library APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (RSVG::GIO::Library
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${RSVG_GIO_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${RSVG_GIO_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			        "${RSVG_GIO_LIBRARY_RELEASE}"
			     INTERFACE_LINK_LIBRARIES
			       RSVG::Glib::Library
			     INTERFACE_LINK_LIBRARIES
			       RSVG::Gobject::Library)
  endif ()

  if (NOT TARGET RSVG::Math::Library)
    add_library (RSVG::Math::Library UNKNOWN IMPORTED)
    set_property (TARGET RSVG::Math::Library APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (RSVG::Math::Library
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${RSVG_Math_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${RSVG_Math_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			        "${RSVG_Math_LIBRARY_RELEASE}")
  endif ()

  if (NOT TARGET RSVG::Library)
    add_library (RSVG::Library UNKNOWN IMPORTED)
    set_property (TARGET RSVG::Library APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (RSVG::Library
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${RSVG_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${RSVG_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			        "${RSVG_LIBRARY_RELEASE}"
			     INTERFACE_LINK_LIBRARIES
  			       RSVG::Cairo::Library
			     INTERFACE_LINK_LIBRARIES
			       RSVG::Glib::Library
			     INTERFACE_LINK_LIBRARIES
			       RSVG::Gobject::Library
			     INTERFACE_LINK_LIBRARIES
			       RSVG::GdkPixbuf::Library
			     INTERFACE_LINK_LIBRARIES
			       RSVG::GIO::Library
			     INTERFACE_LINK_LIBRARIES
			       RSVG::Math::Library)
  endif ()

  set (_libs RSVG_Math RSVG_GIO RSVG_GdkPixbuf RSVG_Gobject
             RSVG_Glib RSVG_Cairo)
  set (RSVG_LIBRARIES RSVG::Library)
  list (APPEND RSVG_INCLUDE_DIRS "${RSVG_INCLUDE_DIR}")
  foreach (lib ${_libs})
    list (APPEND RSVG_INCLUDE_DIRS "${${lib}_INCLUDE_DIR}")
    string (REGEX REPLACE "([a-zA-Z]+)_([a-zA-Z]+)" "\\1::\\2" lib
                          "${lib}")
    list (APPEND RSVG_LIBRARIES ${lib}::Library)
  endforeach ()
  list (REMOVE_DUPLICATES RSVG_INCLUDE_DIRS)
endif ()
