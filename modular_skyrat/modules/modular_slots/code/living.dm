/// Gets the mob's current passport, if present. Purposefully doesn't support PDAs or wallets. Beware, it is possible via var edits for non-passport items to be in this slot!
/mob/living/proc/get_passport()
	if(!length(held_items)) // Early return for mobs without hands.
		return
	// Check hands
	var/obj/item/held_item = get_active_held_item()
	return held_item? held_item : get_inactive_held_item()
