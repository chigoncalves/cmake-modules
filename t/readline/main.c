#include <stdlib.h>
#include <stdio.h>

#include <readline/readline.h>

int
main (void) {
  char* name = readline ("name> ");

  printf ("You said your name was \"%s\".\n", name);

  return EXIT_SUCCESS;
}
