/datum/action/cooldown/mob_cooldown/meteors
	name = "Meteors"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	desc = "Allows you to rain meteors down around yourself."
	cooldown_time = 3 SECONDS
	shared_cooldown = MOB_SHARED_COOLDOWN_1

/datum/action/cooldown/mob_cooldown/meteors/Activate(atom/target_atom)
<<<<<<< HEAD
	StartCooldown(10 SECONDS)
=======
	StartCooldown(360 SECONDS, 360 SECONDS)
>>>>>>> c9e16c44bf5 (Fixes some alien actions not working.  (#68625))
	create_meteors(target_atom)
	StartCooldown()

/datum/action/cooldown/mob_cooldown/meteors/proc/create_meteors(atom/target)
	if(!target)
		return
	target.visible_message(span_boldwarning("Fire rains from the sky!"))
	var/turf/targetturf = get_turf(target)
	for(var/turf/turf as anything in RANGE_TURFS(9,targetturf))
		if(prob(11))
			new /obj/effect/temp_visual/target(turf)
