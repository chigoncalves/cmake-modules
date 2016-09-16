#include <stdlib.h>

#include <Imlib2.h>

int
main (int argc, char* argv[]) {
  Imlib_Image img = imlib_load_image(argv[1]);
  if (!img) return EXIT_FAILURE;

  imlib_context_set_image(img);
  char* suffix = strrchr(argv[2], '.');
  if(suffix)
    imlib_image_set_format(suffix + 1);

  imlib_save_image(argv[2]);

  return EXIT_SUCCESS;
}
