#[[.rst
#
# FindSN
# ------
#
# Finds Startup Notification library.
#
# The following variables will be set when FindSN has finished done its
# job.
#
# .. variable:: SN_FOUND
#
#    With a *true* value if Startup Notification was found.
#
# .. variable:: SN_INCLUDE_DIRS
#
#    With a list of include directories.
#
# .. variable:: SN_LIBRARIES
#
#    A list of libraries to link your application against.
#
# .. variable:: SN_DEFINITIONS
#
#    Will contain a list of compiler definitions.
#
# Variables tha provide hints
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# .. :envvar:`SN_ROOT_DIR`
#
#   Use this variable to provide hints to :filename:`find_{*}` commands,
#   you may pass it to :command:`cmake` or set the environtment variable.
#
# .. code-block:: cmake
#
#    % cmake . -Bbuild -DSN_ROOT_DIR=<extra-path>
#
#    # or
#    % export SN_ROOT_DIR=<extra-path>;
#    % cmake . -Bbuild
#
#    # or
#    % SN_ROOT_DIR=<extra-path> cmake . -Bbuild
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

function (_sn_find_include_dir)
  find_path (SN_INCLUDE_DIR
             libsn/sn.h
	     HINT
	       "${SN_ROOT_DIR}"
	       ENV SN_ROOT_DIR
	     PATH_SUFFIXES
	       startup-notification
   	       startup-notification-1
               startup-notification-1.0)

    set (SN_INCLUDE_DIR "${SN_INCLUDE_DIR}" PARENT_SCOPE)
endfunction ()

function (_sn_find_definitions)
  if (SN_INCLUDE_DIR)
    file (STRINGS "${SN_INCLUDE_DIR}/libsn/sn-common.h" _RESULTS REGEX
          "(#ifndef|#ifdef)[\t ]+[a-bA-Z0-9_-]+")

    set (SN_DEFINITIONS)
    foreach (DEFINITION ${_RESULTS})
      string (REPLACE "#ifndef" "" DEFINITION "${DEFINITION}")
      string (REPLACE "#ifdef" "" DEFINITION "${DEFINITION}")
      string (STRIP "${DEFINITION}" DEFINITION)
      string (REGEX MATCH "^_+|_+$" _MATCHED "${DEFINITION}")

      if (NOT _MATCHED)
	list (APPEND SN_DEFINITIONS "-D${DEFINITION}=1")
      endif ()
    endforeach ()
    string (REPLACE ";" " " SN_DEFINITIONS "${SN_DEFINITIONS}")
    list (REMOVE_DUPLICATES SN_DEFINITIONS)
    set (SN_DEFINITIONS "${SN_DEFINITIONS}" PARENT_SCOPE)
  endif ()
endfunction ()

function (_sn_find_library)
  set (_SUFFIXES 1.0 1)
  set (_SN_NAMES startup-notification)
  foreach (SUFFIX ${_SUFFIXES})
    list (APPEND _SN_NAMES startup-notification-${SUFFIX})
  endforeach ()

  find_library (SN_LIBRARY_RELEASE
                ${_SN_NAMES}
		HINT
		  "${SN_ROOT_DIR}"
		  ENV SN_ROOT_DIR
		PATHS
		  /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
		  /usr/lib64/${CMAKE_LIBRARY_ARCHITECTURE}
		  /usr/lib32/${CMAKE_LIBRARY_ARCHITECTURE})

  if (SN_LIBRARY_RELEASE)
    select_library_configurations (SN)
    set (SN_LIBRARY "${SN_LIBRARY}" PARENT_SCOPE)
    set (SN_LIBRARY_RELEASE "${SN_LIBRARY_RELEASE}" PARENT_SCOPE)
  endif ()
endfunction ()


##### Entry Point #####

set (SN_FOUND)
set (SN_INCLUDE_DIRS)
set (SN_LIBRARIES)
set (SN_DEFINITIONS)

_sn_find_include_dir ()
if (SN_INCLUDE_DIR)
  _sn_find_definitions ()
endif ()
_sn_find_library ()

find_package_handle_standard_args (SN
				   REQUIRED_VARS
 				     SN_INCLUDE_DIR
				     SN_LIBRARY
				     SN_DEFINITIONS)
if (SN_FOUND)
  set (SN_INCLUDE_DIRS ${SN_INCLUDE_DIR})

  if (NOT TARGET SN::Library)
    add_library (SN::Library UNKNOWN IMPORTED)
    set_property (TARGET SN::Library APPEND
                  PROPERTY
                    IMPORTED_CONFIGURATIONS RELEASE)

    set_target_properties (SN::Library
                         PROPERTIES
			   INTERFACE_INCLUDE_DIRECTORIES
			     "${SN_INCLUDE_DIR}"
			   INTERFACE_LOCATION "${SN_LIBRARY}"
			   IMPORTED_LOCATION_RELEASE
			     "${SN_LIBRARY_RELEASE}")
    set (SN_LIBRARIES SN::Library)
  endif ()
endif ()

mark_as_advanced (SN_INCLUDE_DIR
		  SN_LIBRARY
		  SN_LIBRARY_RELEASE)
