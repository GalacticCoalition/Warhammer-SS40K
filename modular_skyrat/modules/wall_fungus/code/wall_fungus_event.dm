/datum/round_event_control/wall_fungus
	name = "Wall Fungus Outbreak"
	typepath = /datum/round_event/wall_fungus
	category = EVENT_CATEGORY_ENGINEERING
	max_occurrences = 2
	earliest_start = 30 MINUTES
	description = "A wall fungus will infest a random wall on the station, eating away at it. If left unchecked, it will spread to other walls and eventually destroy the station."

/datum/round_event/wall_fungus/announce(fake)
	priority_announce("Harmful fungi detected on the station, station structures may be contaminated. Enabling emergency maintenance access is advised to provide immediate response in [get_area(starting_wall)].", "Harmful Fungi", ANNOUNCER_FUNGI)

/datum/round_event/wall_fungus
	announce_when = 180 EVENT_SECONDS
	announce_chance = 100
	var/turf/closed/wall/starting_wall

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

	starting_wall = pick(possible_start_walls)

	starting_wall.AddComponent(/datum/component/wall_fungus)

	notify_ghosts("[starting_wall] has been infested with wall eating mushrooms!!", source = starting_wall, action = NOTIFY_JUMP, header = "Fungus Amongus!")
