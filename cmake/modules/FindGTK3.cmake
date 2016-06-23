#.rst FindGTK3
#
# This module tries to find Gtk+3 package and its components.
#
# Usage
#
# .. code-block:: cmake
#
#    find_package (GTK3)
#
# FindGTK3 can find these Gtk+3 components:
#
# * gtk3
#
# * gdk3
#
# * pangocairo
#
# * pango
#
# * atk
#
# * cairogobject
#
# * cairo
#
# * gdkpixbuf
#
# * gio
#
# * gobject
#
# * glib
#
# Note that each component below has as dependent the component above.
# For instance:
#
#  .. code-block:: cmake
#
#     find_package (GTK3 3.8 COMPONENTS gio)
#
# Will try to find only glib, gobject and gio, which means that the
# invocation below has same effect as the former one.
#
# .. code-block:: cmake
#
#    find_package (GTK3 3.8 COMPONENTS gio glib gobject)
#
# Since ``gio`` depends on ``glib``, which in turn depends on ``gobject``,
# there is no need to passing them to ``find_package``.
#
# If you want to find ``gtk3`` you don't need to pass all the components, i.e.
# these to invocation of package are identical.
#
# .. code-block:: cmake
#
#    find_package (GTK3 3.8 COMPONENTS gtk3 gdk3 pangocairo pango atk
#                                      cairogobject cairo gdkpixbuf
#                                      gio gobject glib)
#
#    find_package (GTK3 3.8 COMPONENTS gtk3)
#
# As you can see the last invocation of ``find_package`` is more simple
#
# After a successful search this package sets these variables:
#
# GTK3_INCLUDE_DIRS
#   With all include location for the components passed to ``find_package``.
#
# GTK3_LIBRARIES
#   With all libraries of the components passed to ``find_package``.
#
# GTK3_DEFINITIONS
#   With definitions passed to the compiler.
#


#=======================================================================
# Copyright E. Gonçalves.
#
# Version 0.0.3
#=======================================================================


# Ver a implentação no FindPkgConfig.cmake, CMakePackageConfigHelpers.cmake
#
#
# I should export these variables.
# GTK3_INCLUDE_DIRS with the value of GTK3_INCLUDE_DIR
# GTK3_LIBRARY_DIRS with the value of GTK3_LIBRARY and its dependencies.
#
# Call the find_package_handle_standard_args() macro to set the
# <name>_FOUND variable and print a success or failure message.


include (SelectLibraryConfigurations)
include (CMakePrintHelpers)
include(FindPackageHandleStandardArgs)

function (_gtk3_find_component_include_dir component header_file)

  set (suffixes
    glib-2.0
    gdk-pixbuf-2.0
    cairo
    atk-1.0
    pango-1.0
    gtk-3.0)

  set (additional_paths)
  if (CMAKE_LIBRARY_ARCHITECTURE)
    set (base_include_dir /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE})
    foreach (suffix ${suffixes})
      list (APPEND additional_paths ${base_include_dir}/${suffix}/include)
    endforeach ()
  endif ()

  find_path (GTK3_${component}_INCLUDE_DIR ${header_file}
    PATHS
      /opt/include
      /opt/local/include
      ${additional_paths}
    PATH_SUFFIXES
      glib-2.0
      gdk-pixbuf-2.0
      cairo
      atk-1.0
      pango-1.0
      gtk-3.0)

set (GTK3_${component}_INCLUDE_DIR ${GTK3_${component}_INCLUDE_DIR} PARENT_SCOPE)
set (GTK3_INCLUDE_DIRS "${GTK3_INCLUDE_DIRS};${GTK3_${component}_INCLUDE_DIR}" PARENT_SCOPE)
mark_as_advanced (GTK3_${component}_INCLUDE_DIR)

endfunction ()

function (_gtk3_find_component_library_dir component library library_versions)

  set (library_name_with_version ${library})
  foreach (version ${library_versions})
    list (APPEND library_name_with_version "${library}-${version}")
  endforeach ()

  find_library (GTK3_${component}_LIBRARY_RELEASE
    NAMES ${library_name_with_version}
    PATHS
      /opt/lib
      /opt/local/lib)

  select_library_configurations (GTK3_${component})
  set (GTK3_${component}_LIBRARY ${GTK3_${component}_LIBRARY} PARENT_SCOPE)
  set (GTK3_${component}_FOUND ${GTK3_${component}_FOUND} PARENT_SCOPE)

  if (GTK3_${component}_FOUND)
    set (GTK3_LIBRARIES "${GTK3_${component}_LIBRARY};${GTK3_LIBRARIES}" PARENT_SCOPE)
    get_filename_component (lib_dir ${GTK3_${component}_LIBRARY} DIRECTORY)
    set (GTK3_LIBRARY_DIRS "${lib_dir};${GTK3_LIBRARY_DIRS}" PARENT_SCOPE)
  endif ()

endfunction ()


############## Entry Point ###############

set (GTK3_INCLUDE_DIRS)
set (GTK3_LIBRARIES)

if (NOT GTK3_FIND_COMPONENTS)
  set (GTK3_FIND_COMPONENTS gtk3)
endif ()

foreach (component ${GTK3_FIND_COMPONENTS})
  if (component STREQUAL "gtk3")
    if (NOT GTK3_GLIB_FOUND)
      set (versions 2.0)
      _gtk3_find_component_include_dir (GLIB glib.h)
      _gtk3_find_component_include_dir (GLIBCONFIG glibconfig.h)
      list (APPEND GTK3_GLIB_INCLUDE_DIR ${GTK3_GLIBCONFIG_INCLUDE_DIR})
      unset (GTK3_GLIBCONFIG_INCLUDE_DIR)
      _gtk3_find_component_library_dir (GLIB glib "${versions}")
    endif ()

    if (NOT GTK3_GOBJECT_FOUND)
      set (versions 2.0)
      _gtk3_find_component_include_dir (GIO gobject/gobject.h)
      _gtk3_find_component_library_dir (GOBJECT gobject ${versions})
    endif ()

    if (NOT GTK3_GIO_FOUND)
      _gtk3_find_component_include_dir (GIO gio/gio.h)
      _gtk3_find_component_library_dir (GIO gio ${versions})
    endif ()


    if (NOT GTK3_GDKPIXBUF_FOUND)
      set (versions 2.0)
      _gtk3_find_component_include_dir (GDKPIXBUF gdk-pixbuf/gdk-pixbuf.h)
      _gtk3_find_component_library_dir (gdkpixbuf gdk_pixbuf ${versions})
    endif ()

    if (NOT GTK3_CAIRO_FOUND)
      _gtk3_find_component_include_dir (CAIRO cairo.h)
      _gtk3_find_component_library_dir (CAIRO cairo off)
    endif ()

    if (NOT GTK3_CAIROGOBJECT_FOUND)
      _gtk3_find_component_include_dir (CAIROGOBJECT cairo-gobject.h)
      _gtk3_find_component_library_dir (CAIROGOBJECT cairo-gobject off)
    endif ()

    if (NOT GTK3_ATK_FOUND)
      set (versions 1.0)
      _gtk3_find_component_include_dir (ATK atk/atk.h)
      _gtk3_find_component_library_dir (ATK atk ${versions})
    endif ()

    if (NOT GTK3_PANGO_FOUND)
      set (versions 1.0)
      _gtk3_find_component_include_dir (PANGO pango/pango.h)
      _gtk3_find_component_library_dir (PANGO pango ${versions})
    endif ()

    if (NOT GTK3_PANGOCAIRO_FOUND)
      set (versions 1.0)
      _gtk3_find_component_include_dir (PANGOCAIRO pango/pangocairo.h)
      _gtk3_find_component_library_dir (PANGOCAIRO pangocairo ${versions})
    endif ()

    if (NOT GTK3_GDK3_FOUND)
      set (versions 3.0)
      _gtk3_find_component_include_dir (GDK3 gdk/gdk.h)
      _gtk3_find_component_library_dir (GDK3 gdk ${versions})
    endif ()

    set (versions 3)
    if (NOT GTK3_FOUND)
      _gtk3_find_component_include_dir (GDK3 gtk/gtk.h)
      _gtk3_find_component_library_dir (GTK3 gtk ${versions})
    endif ()

  endif ()

endforeach ()

foreach (component ${GTK3_FIND_COMPONENTS})
  if (component STREQUAL "gtk3")

  elseif (component STREQUAL "gdk3")

  elseif (component STREQUAL "pangocairo")

  elseif (component STREQUAL "cairo")

  elseif (component STREQUAL "atk")

  elseif (component STREQUAL "cairoobject")

  elseif (component STREQUAL "gdkpixbuf")

  elseif (component STREQUAL "gio")

  elseif (component STREQUAL "gobject")
    # find_package_handle_standard_args (gobject
    #   DEFAULT_MSG "Found gobject."
    #   FOUND_VAR GTK3_GOBJECT_FOUND
    #   REQUIRED_VARS
    # 	GTK3_GOBJECT_INCLUDE_DIRS GTK3_GOBJECT_LIBRARIES
    #     GTK3_GLIB_INCLUDE_DIRS GTK3_GLIB_LIBRARIES
    # )
  elseif (component STREQUAL "glib")
    # cmake_print_variables (GTK3_GLIB_INCLUDE_DIR GTK3_GLIB_LIBRARY)
    find_package_handle_standard_args (GTK3_GLIB
      DEFAULT_MSG "Found component glib."
      REQUIRED_VARS GTK3_GLIB_INCLUDE_DIR GTK3_GLIB_LIBRARY
    )
  endif ()

endforeach ()

if (GTK3_LIBRARY_DIRS)
  list (REMOVE_DUPLICATES GTK3_LIBRARY_DIRS)
endif ()

if (GTK3_INCLUDE_DIRS)
  list (REMOVE_DUPLICATES GTK3_INCLUDE_DIRS)
endif ()
