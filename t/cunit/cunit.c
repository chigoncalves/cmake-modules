#include <stdlib.h>

#include <CUnit/Basic.h>

int
main (void) {
  if (CU_initialize_registry () != CUE_SUCCESS)
    return CU_get_error ();

  CU_ASSERT_STRING_NOT_EQUAL ("frobz?", "frobz!");

  CU_basic_set_mode (CU_BRM_SILENT);
  CU_basic_run_tests ();
  CU_basic_show_failures(CU_get_failure_list());

  CU_cleanup_registry ();

  return EXIT_SUCCESS;
}
