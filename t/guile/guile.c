#include <stdlib.h>

#include <libguile.h>

int
main (int argc, char* argv[]) {
  scm_init_guile ();
  scm_shell (argc, argv);
  return EXIT_SUCCESS;
}
