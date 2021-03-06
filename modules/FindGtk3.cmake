#[[.rst FindGtk3.cmake

# FindGtk3
# --------
#
# THIS MODULE TRIES TO FIND GTK+3 PACKAGE AND ITS COMPONENTS.
#
# USAGE
# ^^^^^
# .. CODE::
#
#    FIND_PACKAGE (GTK3)
#
# FINDGTK3 CAN FIND THESE GTK+3 COMPONENTS:
#
# * GTK3
# * GDK3
# * PANGOCAIRO
# * PANGO
# * ATK
# * CAIROGOBJECT
# * CAIRO
# * GDKPIXBUF
# * GIO
# * GOBJECT
# * GLIB
#
# NOTE THAT EACH COMPONENT BELOW HAS AS DEPENDENT THE COMPONENT ABOVE.
# FOR INSTANCE:
#
#  .. CODE::
#
#     FIND_PACKAGE (GTK3 3.8 COMPONENTS GIO)
#
# WILL TRY TO FIND ONLY GLIB, GOBJECT AND GIO, WHICH MEANS THAT THE
# INVOCATION BELOW HAS SAME EFFECT AS THE FORMER ONE.
#
# .. CODE::
#
#     FIND_PACKAGE (GTK3 3.8 COMPONENTS GIO GLIB GOBJECT)
#
# SINCE ``GIO`` DEPENDS ON ``GLIB``, WHICH IN TURN DEPENDS ON
# ``GOBJECT``,
#  THERE IS NO NEED TO PASSING THEM TO :COMMAND:`FIND_PACKAGE`\.
#
# IF YOU WANT TO FIND ``GTK3`` YOU DON'T NEED TO PASS ALL THE
# COMPONENTS, I.E. THESE TO INVOCATION OF PACKAGE ARE IDENTICAL.
#
# .. CODE::
#
#    FIND_PACKAGE (GTK3 3.8 COMPONENTS GTK3 GDK3 PANGOCAIRO PANGO ATK
#                                       CAIROGOBJECT CAIRO GDKPIXBUF
#                                       GIO GOBJECT GLIB)
#
#    FIND_PACKAGE (GTK3 3.8 COMPONENTS GTK3)
#
#    # OR EVEN BETTER.
#    FIND_PACKAGE (GTK3 3.8)
#
#
# AS YOU CAN SEE THE LAST INVOCATION OF :COMMAND:`FIND_PACKAGE`
# IS MORE SIMPLE.
#
# AFTER A SUCCESSFUL SEARCH THIS PACKAGE SETS THESE VARIABLES:
#
# .. VARIABLE:: GTK3_FOUND
#
#    WILL BE SET TO *TRUE* IF IT MANAGES TO FIND GTK+3.
#
# .. VARIABLE:: GTK3_INCLUDE_DIRS
#
#    WITH ALL INCLUDE LOCATION FOR THE COMPONENTS PASSED TO
#    :COMMAND:``FIND_PACKAGE``\.
#
# .. VARIABLE:: GTK3_LIBRARIES
#
#   WITH ALL LIBRARIES OF THE COMPONENTS PASSED TO
# :COMMAND:`FIND_PACKAGE``\.
#
#
# #]]


#[[.RST
#
# COPYRIGHT © 2016, EDELCIDES GONÇALVES <EATG75 |0X40| GMAIL>
#
# PERMISSION TO USE, COPY, MODIFY, AND/OR DISTRIBUTE THIS SOFTWARE FOR
# ANY PURPOSE WITH OR WITHOUT FEE IS HEREBY GRANTED, PROVIDED THAT THE
# ABOVE COPYRIGHT NOTICE AND THIS PERMISSION NOTICE APPEAR IN ALL
# COPIES.
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
# THIS FILE IS NOT PART OF CMAKE
#
#]]


include (SelectLibraryConfigurations)
include(FindPackageHandleStandardArgs)

function (_gtk3_find_component_include_dir COMPONENT HEADER_FILE)
  set (_NAMES glib-2.0
              gdk-pixbuf-2.0
	      cairo
	      atk-1.0
	      pango-1.0
	      gtk-3.0)

  set (_ADDITONAL_SEARCH_PATHS)
  foreach (NAME ${_NAMES})
    list (APPEND _ADDITIONAL_SEARCH_PATHS
          /usr/lib/${NAME}/include
	  /usr/lib64/${NAME}/include
	  /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}/${NAME}/include
	  /usr/lib64/${CMAKE_LIBRARY_ARCHITECTURE}/${NAME}/include)
  endforeach ()

  find_path (${COMPONENT}_INCLUDE_DIR ${HEADER_FILE}
    PATHS
      /opt/include
      /opt/local/include
      ${_ADDITIONAL_SEARCH_PATHS}

    HINT
      "${Gtk3_ROOT_DIR}"
      ENV Gtk3_ROOT_DIR

    PATH_SUFFIXES
      glib-2.0
      gdk-pixbuf-2.0
      cairo
      atk-1.0
      pango-1.0
      gtk-3.0)

  set (${COMPONENT}_INCLUDE_DIR ${${COMPONENT}_INCLUDE_DIR} PARENT_SCOPE)
  mark_as_advanced (${COMPONENT}_INCLUDE_DIR)
endfunction ()

function (_gtk3_find_component_library COMPONENT LIBRARY)
  cmake_parse_arguments (_Gtk3 "" "" "VERSIONS" "${ARGN}")
  set (_LIBRARY_NAME_WITH_VERSION)
  foreach (VERSION ${_Gtk3_VERSIONS})
    list (APPEND _LIBRARY_NAME_WITH_VERSION "${LIBRARY}-${VERSION}")
  endforeach ()

  find_library (${COMPONENT}_LIBRARY_RELEASE
    ${LIBRARY}
    NAMES ${_LIBRARY_NAME_WITH_VERSION}
    PATHS
      /opt/lib
      /opt/local/lib)


  select_library_configurations (${COMPONENT})
  set (${COMPONENT}_LIBRARY ${${COMPONENT}_LIBRARY} PARENT_SCOPE)
  set (${COMPONENT}_LIBRARY_RELEASE ${${COMPONENT}_LIBRARY_RELEASE}
       PARENT_SCOPE)
endfunction ()

function (_gtk3_get_components )
  set (_Gtk3_COMPONENTS Glib Gobject GIO GdkPixbuf Cairo CairoGobject
                        Atk Pango PangoCairo Gdk3 Gtk3)
  if (NOT Gtk3_FIND_COMPONENTS)
    set (Gtk3_FIND_COMPONENTS ${_Gtk3_COMPONENTS} PARENT_SCOPE)
    return ()
  endif ()

  set (_MAX_INDEX 0)
  foreach (COMPONENT ${Gtk3_FIND_COMPONENTS})
    list (FIND _Gtk3_COMPONENTS ${COMPONENT} _INDEX)
    if (_INDEX GREATER _MAX_INDEX)
      set (_MAX_INDEX ${_INDEX})
    elseif (_INDEX EQUAL -1)
      message (FATAL_ERROR "FindGtk3: This module does not have any\
 component named ${COMPONENT}.")
    endif ()
  endforeach ()

  list (LENGTH _Gtk3_COMPONENTS _LEN)
  math (EXPR _LEN "${_LEN} - 1")
  while (NOT _LEN EQUAL _MAX_INDEX)
    list (REMOVE_AT _Gtk3_COMPONENTS ${_LEN})
    list (LENGTH _Gtk3_COMPONENTS _LEN)
    math (EXPR _LEN "${_LEN} - 1")
  endwhile ()
  set (Gtk3_FIND_COMPONENTS ${_Gtk3_COMPONENTS} PARENT_SCOPE)
endfunction ()

function (_gtk3_find_version HEADER_FILE MACRO_NAME)
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

function (_gtk3_add_library NAME)
  cmake_parse_arguments (_Gtk3 "" "" "DEPENDS_ON" ${ARGN})

  set (_LIBRARY_NAME ${NAME}::Library)
  if (NOT TARGET ${_LIBRARY_NAME})
    add_library (${_LIBRARY_NAME} UNKNOWN IMPORTED)
    set_property (TARGET ${_LIBRARY_NAME} APPEND
                  PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties (${_LIBRARY_NAME}
                           PROPERTIES
			     INTERFACE_INCLUDE_DIRS
			       "${${NAME}_INCLUDE_DIR}"
			     IMPORTED_LOCATION
			       "${${NAME}_LIBRARY}"
			     IMPORTED_LOCATION_RELEASE
			       "${${NAME}_LIBRARY_RELEASE}")

    set (_SELF ${_LIBRARY_NAME})
    foreach (DEPENDENCY ${_Gtk3_DEPEND_ON})
      set (_LIBRARY_NAME ${DEPENDENCY}::Library)
      set_property (TARGET ${_SELF} APPEND
	            PROPERTY
		    INTERFACE_LINK_LIBRARIES
		      ${_LIBRARY_NAME})
    endforeach ()
    set (Gtk3_LIBRARIES "${Gtk3_LIBRARIES};${_SELF}" PARENT_SCOPE)
  endif ()
  unset (_LIBRARY_NAME)
endfunction ()


############## Entry Point ###############

_gtk3_get_components ()
list (LENGTH Gtk3_FIND_COMPONENTS _LEN)
math (EXPR _LEN "${_LEN} - 1")
list (GET Gtk3_FIND_COMPONENTS ${_LEN} _TOPMOST_COMPONENT)

foreach (COMPONENT ${Gtk3_FIND_COMPONENTS})

  if (COMPONENT STREQUAL Glib)
    _gtk3_find_component_include_dir (GlibConfig glibconfig.h)
    find_package_handle_standard_args (GlibConfig
                                       DEFAULT_MESSAGE
				       GlibConfig_INCLUDE_DIR)

    list (APPEND Gtk3_INCLUDE_DIRS "${GlibConfig_INCLUDE_DIR}")
    set (_HEADER glib.h)
    set (_LIB_NAME glib)
    set (_LIB_VERSION 2.0)
    set (_DEPENDS_ON GlibConfig_FOUND)
  elseif (COMPONENT STREQUAL Gobject)
    set (_HEADER gobject/gobject.h)
    set (_LIB_NAME gobject)
    set (_LIB_VERSION 2.0)
    set (_DEPENDS_ON Glib_FOUND)
  elseif (COMPONENT STREQUAL GIO)
    set (_HEADER gio/gio.h)
    set (_LIB_NAME gio)
    set (_LIB_VERSION 2.0)
    set (_DEPENDS_ON Gobject_FOUND)
  elseif (COMPONENT STREQUAL GdkPixbuf)
    set (_HEADER gdk-pixbuf/gdk-pixbuf.h)
    set (_LIB_NAME gdk_pixbuf)
    set (_LIB_VERSION 2.0)
    set (_DEPENDS_ON GIO_FOUND)
  elseif (COMPONENT STREQUAL Cairo)
    set (_HEADER cairo.h)
    set (_LIB_NAME cairo)
    set (_LIB_VERSION)
    set (_DEPENDS_ON)
  elseif (COMPONENT STREQUAL CairoGobject)
    set (_HEADER cairo-gobject.h)
    set (_LIB_NAME cairo-gobject)
    set (_LIB_VERSION)
    set (_DEPENDS_ON Cairo_FOUND)
  elseif (COMPONENT STREQUAL Atk)
    set (_HEADER atk/atk.h)
    set (_LIB_NAME atk)
    set (_LIB_VERSION 1.0)
    set (_DEPENDS_ON Gobject_FOUND)
  elseif (COMPONENT STREQUAL Pango)
    set (_HEADER pango/pango.h)
    set (_LIB_NAME pango)
    set (_LIB_VERSION 1.0)
    set (_DEPENDS_ON Gobject_FOUND)
  elseif (COMPONENT STREQUAL PangoCairo)
    set (_HEADER pango/pangocairo.h)
    set (_LIB_NAME pangocairo)
    set (_LIB_VERSION 1.0)
    set (_DEPENDS_ON CairoGobject_FOUND Pango_FOUND)
  elseif (COMPONENT STREQUAL Gdk3)
    set (_HEADER gdk/gdk.h)
    set (_LIB_NAME gdk)
    set (_LIB_VERSION 3 3.0)
    set (_DEPENDS_ON PangoCairo_FOUND)
 else ()
   continue ()
  endif ()

  _gtk3_find_component_include_dir (${COMPONENT}
                                    ${_HEADER})
  _gtk3_find_component_library (${COMPONENT}
                                ${_LIB_NAME} VERSIONS "${_LIB_VERSION}")
  find_package_handle_standard_args (${COMPONENT}
                                       DEFAULT_MESSAGE
				       ${COMPONENT}_INCLUDE_DIR
				       ${COMPONENT}_LIBRARY
				       ${COMPONENT}_LIBRARY_RELEASE
				       ${_DEPENDS_ON})
endforeach ()

if (_TOPMOST_COMPONENT STREQUAL Gtk3)
  _gtk3_find_component_include_dir (Gtk3 gtk/gtk.h)
  _gtk3_find_component_library (Gtk3 gtk VERSIONS 3 3.0)

  _gtk3_find_version ("${Gtk3_INCLUDE_DIR}/gtk/gtkversion.h" GTK_MAJOR_VERSION)
  if (VERSION_FOUND)
    set (Gtk3_VERSION_MAJOR ${VERSION})
  endif ()

  _gtk3_find_version ("${Gtk3_INCLUDE_DIR}/gtk/gtkversion.h" GTK_MINOR_VERSION)
  if (VERSION_FOUND)
    set (Gtk3_VERSION_MINOR ${VERSION})
  endif ()

  _gtk3_find_version ("${Gtk3_INCLUDE_DIR}/gtk/gtkversion.h" GTK_MICRO_VERSION)
  if (VERSION_FOUND)
    set (Gtk3_VERSION_PATCH ${VERSION})
  endif ()

  set (Gtk3_VERSION_STRING "${Gtk3_VERSION_MAJOR}.\
${Gtk3_VERSION_MINOR}.${Gtk3_VERSION_PATCH}")

  find_package_handle_standard_args (Gtk3
                                     REQUIRED_VARS
 				       Gtk3_INCLUDE_DIR
				       Gtk3_LIBRARY
				       Gtk3_LIBRARY_RELEASE
				       Gdk3_FOUND
				     VERSION_VAR Gtk3_VERSION_STRING)
endif ()

set (Gtk3_LIBRARIES)
foreach (COMPONENT ${Gtk3_FIND_COMPONENTS})
  list (APPEND Gtk3_INCLUDE_DIRS "${${COMPONENT}_INCLUDE_DIR}")
  if (COMPONENT STREQUAL Glib)
    set (_LIB_DEPENDENCIES)
  elseif (COMPONENT STREQUAL Gobject)
    set (_LIB_DEPENDENCIES Glib)
  elseif (COMPONENT STREQUAL GIO)
    set (_LIB_DEPENDENCIES Glib Gobject)
  elseif (COMPONENT STREQUAL GdkPixbuf)
    set (_LIB_DEPENDENCIES Glib Gobject)
  elseif (COMPONENT STREQUAL Cairo)
    set (_LIB_DEPENDENCIES)
  elseif (COMPONENT STREQUAL CairoGobject)
    set (_LIB_DEPENDENCIES Glib Gobject Cairo)
  elseif (COMPONENT STREQUAL Atk)
    set (_LIB_DEPENDENCIES Glib Gobject)
  elseif (COMPONENT STREQUAL Pango)
    set (_LIB_DEPENDENCIES Glib Gobject)
  elseif (COMPONENT STREQUAL PangoCairo)
    set (_LIB_DEPENDENCIES Glib Gobject Cairo Pango)
  elseif (COMPONENT STREQUAL Gdk3)
    set (_LIB_DEPENDENCIES Glib Gobject Cairo CairoGobject GdkPixbuf
                           Pango PangoCairo)
  elseif (COMPONENT STREQUAL Gtk3)
    set (_LIB_DEPENDENCIES Glib Gobject Cairo CairoGobject GdkPixbuf
                           Pango PangoCairo Gdk3)
  endif ()

  _gtk3_add_library (${COMPONENT} DEPENDS_ON ${_LIB_DEPENDENCIES})
endforeach ()

if (Gtk3_INCLUDE_DIRS)
  list (REMOVE_DUPLICATES Gtk3_INCLUDE_DIRS)
endif ()
