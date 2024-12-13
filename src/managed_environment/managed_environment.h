


#ifndef managed_environment_included
#define managed_environment_included
#include "../helperfunctions.h"
#include "./place.h"
#define me_type {\
    places : list(object(place_type)), \
    git_hub_connection : string, \
    builder_project : string, \
    default_location : string, \
    location_build_triggers : string, \
    foundation_code : string, \
    git_hub_enabled : bool, \
    github_identity_token_secret : string \
  }

#define me_name_to_place(me,n) (search_list_of_maps(me.places,name,n))



#endif