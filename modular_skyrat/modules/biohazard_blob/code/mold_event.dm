/datum/round_event_control/mold
	name = "Moldies"
	typepath = /datum/round_event/mold
	weight = 5
	max_occurrences = 1
	earliest_start = 30 MINUTES
	category = EVENT_CATEGORY_ENTITIES

/datum/round_event/mold
	fakeable = FALSE
	var/list/available_molds_t1 = list(
		/obj/structure/biohazard_blob/structure/core/fire,
		/obj/structure/biohazard_blob/structure/core/toxic
	)
	var/list/available_molds_t2 = list(
		/obj/structure/biohazard_blob/structure/core/fire,
		/obj/structure/biohazard_blob/structure/core/toxic,
		/obj/structure/biohazard_blob/structure/core/fungus,
		/obj/structure/biohazard_blob/structure/core/emp,
	)

/datum/round_event/mold/start()
	var/list/turfs = list() //list of all the empty floor turfs in the hallway areas
	var/molds2spawn = 1
	if(get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE) >= 75 || (prob((get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)) * 1.3)))
		molds2spawn	= 2 //Guaranteedly worse

	var/obj/structure/biohazard_blob/resin/resintest = new()

	var/list/possible_spawn_areas = typecacheof(typesof(/area/station/maintenance, /area/station/security/prison, /area/station/construction))

	for(var/area/A as anything in GLOB.areas)
		if(!is_station_level(A.z))
			continue
		if(!is_type_in_typecache(A, possible_spawn_areas))
			continue
		for(var/turf/open/floor in A.get_contained_turfs())
			if(!floor.Enter(resintest))
				continue
			if(locate(/turf/closed) in range(2, floor))
				continue
			turfs += floor

	qdel(resintest)

	for(var/i in 1 to molds2spawn)
		var/picked_mold
		if(get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE) >= 75)
			picked_mold = pick(available_molds_t2)
		else
			picked_mold = pick(available_molds_t1)
		shuffle(turfs)
		var/turf/picked_turf = pick(turfs)
		if(turfs.len) //Pick a turf to spawn at if we can
			if(locate(/obj/structure/biohazard_blob/structure/core) in range(20, picked_turf))
				turfs -= picked_turf
				continue
			var/obj/structure/biohazard_blob/boob = new picked_mold(picked_turf)
			announce_to_ghosts(boob)
			turfs -= picked_turf
			i++
		else
			message_admins("Mold failed to spawn.")
			break
