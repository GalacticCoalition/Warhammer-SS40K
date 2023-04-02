/datum/round_event_control/wall_fungus
	name = "Wall Fungus Outbreak"
	typepath = /datum/round_event/wall_fungus
	weight = 20
	category = EVENT_CATEGORY_ENGINEERING
	max_occurrences = 4
	earliest_start = 20 MINUTES

/datum/round_event/wall_fungus/announce(fake)
	priority_announce("Harmful fungi has been detected on the station, deal with it before it becomes a problem!", "Harmful Fungi", ANNOUNCER_OUTBREAK6)

/datum/round_event/wall_fungus
	announce_when = 60 // 2 minutes
	announce_chance = 100


/datum/round_event/wall_fungus/start()
	var/list/possible_spawn_areas = typecacheof(typesof(/area/station/maintenance))
	var/list/possible_start_walls = list()

	for(var/area/iterating_area as anything in GLOB.areas)
		if(!is_station_level(iterating_area.z))
			continue
		if(!is_type_in_typecache(iterating_area, possible_spawn_areas))
			continue
		for(var/turf/closed/wall/iterating_wall in iterating_area)
			possible_start_walls += iterating_wall

	var/turf/closed/wall/picked_wall = pick(possible_start_walls)

	picked_wall.AddComponent(/datum/component/wall_fungus)

	announce_to_ghosts(picked_wall)
