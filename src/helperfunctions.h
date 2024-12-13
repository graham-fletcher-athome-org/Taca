
#ifndef helperfunction_included
#define helperfunction_included

#define search_list_of_maps(list,key,value) coalesce([for x in list: ( x.key == value ) ? x : null]...)



#define assert_number(x) try((((x)-1) < ((x)+1)),file(format(" 'x' does not evaluate as a number. Its value is %s",(x))))












#define bob1(x) ((assert_number(x))?x:0)

#define bob(x) x

#endif
