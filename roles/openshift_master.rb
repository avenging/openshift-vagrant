name "openshift_master"
description "recipies required for openshift master setup"
run_list "recipe[openshiftcommon]", "recipe[openshiftmaster]"
default_attributes "node" => { 
    "attribute" => [ "value", "value", "etc." ]
}
override_attributes "node" => {
     "attribute" => [ "value", "value", "etc." ]
}