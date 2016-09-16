#include <stdlib.h>

#include <gtk/gtk.h>

#define progn

static void
applicaton_initialize (GtkApplication* self, gpointer data) {
  GtkWindow* window;

  progn {
    GtkWidget* w = gtk_application_window_new (self);
    if (!w) return;

    window = GTK_WINDOW (w);
  }

  gtk_window_set_title (window, "FindGtk3 test.");
  gtk_window_set_default_size (window, 400, 320);
  gtk_widget_show (GTK_WIDGET (window));
}

int
main (int argc, char* argv[]) {

  GtkApplication* app = gtk_application_new (NULL,
					     G_APPLICATION_FLAGS_NONE);

  if (!app) return EXIT_FAILURE;
  g_signal_connect (app, "activate", G_CALLBACK (applicaton_initialize),
		    NULL);

  int status = g_application_run (G_APPLICATION (app), argc, argv);
  g_object_unref (app);

  return status;
}
