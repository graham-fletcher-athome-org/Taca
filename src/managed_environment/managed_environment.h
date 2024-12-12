#define me_type object({\
    places : any, \
    git_hub_connection : string, \
    builder_project : string, \
    default_location : string, \
    location_build_triggers : string, \
    foundation_code : string, \
    git_hub_enabled : bool, \
    github_identity_token_secret : string \
  })

#define me_deref_place(me,x) try(me.places[x],null)