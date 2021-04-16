SUBSYSTEM_DEF(randommining)
	name = "Random Mining"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TICKER

	var/list/possible_names = list()
	var/previous_map
	var/chosen_map
	var/traits
	var/voted_next_map
	var/voted_map

/datum/controller/subsystem/randommining/Initialize()

	var/list/possible_choices = list()

	if(fexists("data/next_mining.dat"))
		var/_voted_map = file2text("data/next_mining.dat")
		if(istext(_voted_map))
			voted_map = _voted_map

	if(fexists("data/previous_mining.dat"))
		var/_previous_map = file2text("data/previous_mining.dat")
		if(istext(_previous_map))
			previous_map = _previous_map

	if(!fexists("config/skyrat/mining_levels.txt"))
		add_startupmessage("RANDOM MINING ERROR: mining_levels.txt does not exist, unable to load mining level!")
		return ..()

	var/list/lines = world.file2list("config/skyrat/mining_levels.txt")
	for(var/line in lines)
		if(!length(line))
			continue
		if(findtextEx(line, "#", 1, 2))
			continue
		var/list/L = splittext(line,"+")
		if(L.len < 2)
			continue
		var/name = L[1]
		var/traits = L[2]
		if(!voted_map && name == previous_map && lines.len > 1)
			continue
		possible_choices[name] = traits
		possible_names += name
		add_startupmessage("RANDOM MINING: [uppertext(name)] Level loaded!")

	if(voted_map)
		chosen_map = possible_choices[voted_map]
		traits = possible_choices[chosen_map]
	else
		chosen_map = pick(possible_choices)
		traits = possible_choices[chosen_map]

	if(!chosen_map)
		add_startupmessage("RANDOM MINING: Error, no map was chosen!")
	else
		add_startupmessage("RANDOM MINING: Map randomly picked!")

	return ..()

/datum/controller/subsystem/randommining/Shutdown()
	if(chosen_map)
		var/F = file("data/previous_mining.dat")
		WRITE_FILE(F, chosen_map)
