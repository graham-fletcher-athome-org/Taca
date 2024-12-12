#ifndef place_included
#define place_included

#define place_type {\
    name:string,\
    id:string, \
    type:string\
    }

#define place_new(p_name,p_id,p_type) {name=p_name, id=p_id, type=p_type}
#define place_get_id(p) (p.id)


#endif

