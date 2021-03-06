/*****************************************************************************
 *  This file is part of the OpenDomo project.
 *  Copyright(C) 2011 OpenDomo Services SL
 *  
 *  Daniel Lerch Hostalot <dlerch@opendomo.com>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *****************************************************************************/
/** 
  @file util.c
  @brief Multipurpose functions
 */


#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "util.h"

// {{{ util_get_date()
/// Get the local time in the specified format (binary safe)
void util_get_date(char *datestr, size_t datestr_len, const char *format)
{
   struct tm date;
   time_t t;
   time(&t);

   localtime_r((const time_t *)&t, &date);

   strftime(datestr, datestr_len, format, &date);
   datestr[datestr_len-1]=0;
}
// }}}




