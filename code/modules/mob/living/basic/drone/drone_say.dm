/**
 * Broadcast a message to all drones in a faction
 *
 * Arguments:
 * * msg - The message to send
 * * dead_can_hear - Boolean that determines if ghosts can hear the message (`FALSE` by default)
 * * source - [/atom] source that created the message
 * * faction_checked_mob - [/mob/living] to determine faction matches from
 * * exact_faction_match - Passed to [/mob/proc/faction_check_atom]
 */
/proc/_alert_drones(msg, dead_can_hear = FALSE, atom/source, mob/living/faction_checked_mob, exact_faction_match)
	if (dead_can_hear && source)
		for (var/mob/dead_mob in GLOB.dead_mob_list)
			var/link = FOLLOW_LINK(dead_mob, source)
			to_chat(dead_mob, "[link] [msg]")
	for(var/global_drone in GLOB.drones_list)
		var/mob/living/basic/drone/drone = global_drone
		if(istype(drone) && drone.stat != DEAD)
			if(faction_checked_mob)
				if(drone.faction_check_atom(faction_checked_mob, exact_faction_match))
					to_chat(drone, msg)
			else
				to_chat(drone, msg)



/**
 * Wraps [/proc/_alert_drones] with defaults
 *
 * * source - `src`
 * * faction_check_atom - `src`
 * * dead_can_hear - `TRUE`
 */
/mob/living/basic/drone/proc/alert_drones(msg, dead_can_hear = FALSE)
	_alert_drones(msg, dead_can_hear, src, src, TRUE)

/**
 * Wraps [/mob/living/basic/drone/proc/alert_drones] as a Drone Chat
 *
 * Shares the same radio code with binary
 */
/mob/living/basic/drone/proc/drone_chat(msg)
	alert_drones("<i>Drone Chat: [span_name("[name]")] <span class='message'>[say_quote(msg)]</span></i>", TRUE)
