/obj/item/device/custom_kit
    name = "modification kit" 
    desc = "A box of parts for modifying a certain object."
    icon = 'modular_skyrat/master_files/icons/donator/obj/custom.dmi'
    icon_state = "partskit"
    var/from_obj = null //The base object to be converted
    var/to_obj = null //The object to turn it into

/obj/item/device/custom_kit/afterattack(obj/O, mob/user as mob, proximity_flag)
    if(!proximity_flag) //Gotta be adjacent to your target
        return
    if(isturf(O)) //This shouldn't be needed, but apparently it throws runtimes otherwise.
        return
    else if(O.type == from_obj) //Checks whether the item is eligible to be converted
        var/obj/item/converted_item = new to_obj(get_turf(src))
        user.put_in_hands(converted_item)
        qdel(O)
        qdel(src)
        user.visible_message("You modify [O] into [converted_item].")
    else
        user.visible_message(span_warning("It looks like this kit won't work on [O]..."))
