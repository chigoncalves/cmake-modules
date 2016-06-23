#[[.rst

FindStartupNotification
-----------------------

Finds Startup Notifaction library.

Upon return it sets the following variables:

SN_FOUND
  With a ``true`` value if it manages to find the library.

SN_INCLUDE_DIRS

SN_LIBRARIES
#]]

include (SelectLibraryConfigurations)
include (FindPackageHandleStandardArgs)
include (CMakePrintHelpers)

function (__sn_find_include_dir)
  find_path (SN_INCLUDE_DIR
    libsn/sn.h
    PATH_SUFFIXES startup-notification-1.0 startup-notification-1 startup-notification)

  if (SN_INCLUDE_DIR)
    set (SN_INCLUDE_DIR ${SN_INCLUDE_DIR} PARENT_SCOPE)
  endif ()
endfunction ()

function (__sn_find_library)
  set (sn_suffixes 1.0 1)
  set (sn_names startup-notification)
  foreach (suffix ${sn_suffixes})
    list (APPEND sn_names startup-notification-${suffix})
  endforeach ()

  find_library (SN_LIBRARY_RELEASE
    ${sn_names}
    PATHS ${CMAKE_LIBRARY_ARCHITECTURE})

  if (SN_LIBRARY_RELEASE)
    select_library_configurations (SN)
    set (SN_LIBRARY ${SN_LIBRARY} PARENT_SCOPE)
    set (SN_LIBRARY_RELEASE ${SN_LIBRARY_RELEASE} PARENT_SCOPE)
    set (SN_LIBRARY_DEBUG ${SN_LIBRARY_DEBUG} PARENT_SCOPE)
endfunction ()


##### Entry Point #####


set (SN_INCLUDE_DIRS)
set (SN_LIBRARIES)
set (SN_VERSION 1.0)

if (SN_FIND_COMPONENTS)
  if (NOT SN_FIND_QUIETLY)
    message (WARNING "FindSN: Requested a component, but LibSN does not"
      " have any.")
  endif ()
endif ()

if (SN_FIND_VERSION)
  if (NOT SN_FIND_QUIETLY)
    message (WARNING "FindSN: Requested `version' but none will be"
      " inforced.")
  endif ()
endif ()

__sn_find_include_dir ()
__sn_find_library ()

select_library_configurations (SN
  FOUND_VAR SN_FOUND
  REQUIRED_VARS SN_INCLUDE_DIR SN_LIBRARY
)

if (SN_FOUND)
  set (SN_INCLUDE_DIRS ${SN_INCLUDE_DIR})
  set (SN_LIBRARIES ${SN_LIBRARY})
endif ()

mark_as_advanced (
  SN_INCLUDE_DIRS
  SN_INCLUDE_DIR
  SN_LIBRARY
  SN_LIBRARIES
  SN_FOUND
)
