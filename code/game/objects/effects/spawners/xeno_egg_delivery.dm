/obj/effect/spawner/xeno_egg_delivery
	name = "xeno egg delivery"
	icon = 'icons/mob/alien.dmi'
	icon_state = "egg_growing"
	var/announcement_time = 1200

/obj/effect/spawner/borer_egg_delivery/Initialize(mapload) // SkyRat Edit: Swaps Xeno egg for Borer egg
	..()
	var/turf/T = get_turf(src)

	new /obj/structure/alien/egg(T)
	new /obj/effect/temp_visual/gravpush(T)
	playsound(T, 'sound/items/party_horn.ogg', 50, TRUE, -1)

	message_admins("A borer egg has been delivered to [ADMIN_VERBOSEJMP(T)].") // SkyRat Edit: Adjusts verbiage to match egg type
	log_game("A borer egg has been delivered to [AREACOORD(T)]") // SkyRat Edit: Adjusts verbiage to match egg type
	var/message = "Attention [station_name()], we have entrusted you with a research specimen in [get_area_name(T, TRUE)]. Remember to follow all safety precautions when dealing with the specimen."
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/_addtimer, CALLBACK(GLOBAL_PROC, /proc/print_command_report, message), announcement_time))
	return INITIALIZE_HINT_QDEL
