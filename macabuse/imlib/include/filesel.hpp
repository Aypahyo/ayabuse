#ifndef __FSELECT_HPP_
#define __FSELECT_HPP_

#include "jwindow.hpp"



jwindow *file_dialog(window_manager *wm, const char *prompt, const char *def,
			 int ok_id, const char *ok_name, int cancel_id, const char *cancel_name,
			 const char *FILENAME_str,
			 int filename_id);

#endif




