
#ifndef helperfunction_included
#define helperfunction_included

#define search_list_of_maps(list,key,value) coalesce([for x in list: ( x.key == value ) ? x : null]...)

#endif
