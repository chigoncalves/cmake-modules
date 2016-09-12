#[[.rst
#
# FindImlib2
# ----------
# Finds Imlib2.
#
# .. varname:: Imlib2_FOUND
#
#    Set to *true* if Imlib2 was found.
#
# .. varname:: Imlib2_INCLUDE_DIRS
#
#    Set to list of include directories.
#
# .. varname:: Imlib2_LIBRARIES
#
#    Set o a list of libraries.
#
# External Var
# ~~~~~~~~~~~~
# :envvar:`Imlib2_ROOT_DIR`
#
#
#   Use this variable to provide hints to :filename:`find_{*}` commands,
#   you may pass it to :command:`cmake` or set the environtment variable.
#
# .. code-block:: cmake
#
#    % cmake . -Bbuild -DImlib2_ROOT_DIR=<extra-path>
#
#    # or
#    % export Imlib2_ROOT_DIR=<extra-path>;
#    % cmake . -Bbuild
#
#    # or
#    % Imlib2_ROOT_DIR=<extra-path> cmake . -Bbuild
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


include (SelectLibraryConfigurations)
include (FindPackageHandleStandardArgs)

function (_imlib2_find_include_dir)
  find_path (Imlib2_INCLUDE_DIR
             Imlib2.h
	     HINT
	       "${Imlib2_ROOT_DIR}"
	       ENV Imlib2_ROOT_DIR
	     PATH_SUFIXES
	       Imlib imlib Imlib2 imlib2 Imlib-2 imlib-2 Imlib-2.0
	       imlib-2.0
	     DOC "Imlib2 Include directory.")

  if (Imlib2_INCLUDE_DIR)
    set (Imlib2_INCLUDE_DIR "${Imlib2_INCLUDE_DIR}" PARENT_SCOPE)
  endif ()
endfunction ()

function (_imlib2_find_library)
  find_library (Imlib2_LIBRARY_RELEASE
                imlib2
		NAMES
		  imlib2 Imlib2 imlib-2 Imlib-2 imlib-2.0 Imlib-2.0
		HINT "${Imlib2_ROOT_DIR}"
		  ENV Imlib2_ROOT_DIR
		PATHS
		  /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
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
				   REQUIRED_VARS
				     Imlib2_INCLUDE_DIR
				     Imlib2_LIBRARY
				     Imlib2_LIBRARY_RELEASE
				     Imlib2_LIBRARIES)

if (Imlib2_FOUND)
  set (Imlib2_INCLUDE_DIRS "${Imlib2_INCLUDE_DIRS}")
  if (NOT TARGET Imlib2::Library)
    add_library (Imlib2::Library UNKNOWN IMPORTED)
    set_property (TARGET Imlib2::Library APPEND
                  PROPERTY
                    IMPORTED_CONFIGURATIONS RELEASE)

    set_target_properties (Imlib2::Library
                           PROPERTIES
                             INTERFACE_INCLUDE_DIRS
			       "${Imlib2_INCLUDE_DIR}"
			     IMPORTED_LOCATION "${Imlib2_LIBRARY}"
                             IMPORTED_LOCATION_RELEASE
  			       "${Imlib2_LIBRARY_RELEASE}")

     set (Imlib2_LIBRARIES Imlib2::Library)
   endif ()
endif ()

mark_as_advanced (Imlib2_FOUND
                  Imlib2_INCLUDE_DIRS
                  Imlib2_INCLUDE_DIR
		  Imlib2_LIBRARY
		  Imlib2_LIBRARY_RELEASE
		  Imlib2_LIBRARIES)
