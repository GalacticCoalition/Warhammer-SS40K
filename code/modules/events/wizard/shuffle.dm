/datum/round_event/wizard/shuffle/start()


/datum/round_event_control/wizard/shuffleloc //Somewhere an AI is crying
	name = "Change Places!"
	weight = 2
	typepath = /datum/round_event/wizard/shuffleloc
	max_occurrences = 5
	earliest_start = 0 MINUTES

/datum/round_event/wizard/shuffleloc/start()
	var/list/moblocs = list()
	var/list/mobs = list()

	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(!is_station_level(H.z))
			continue //lets not try to strand people in space or stuck in the wizards den
		moblocs += H.loc
		mobs += H

	if(!mobs)
		return

	shuffle_inplace(moblocs)
	shuffle_inplace(mobs)

	for(var/mob/living/carbon/human/victim in mobs)
		if(!moblocs)
			break //locs aren't always unique, so this may come into play
		do_teleport(victim, moblocs[moblocs.len], channel = TELEPORT_CHANNEL_MAGIC)
		moblocs.len -= 1

	for(var/mob/living/carbon/human/victim in GLOB.alive_mob_list)
		var/datum/effect_system/fluid_spread/smoke/smoke = new
		smoke.set_up(0, holder = victim, location = victim.loc)
		smoke.start()

//---//

/datum/round_event_control/wizard/shufflenames //Face/off joke
	name = "Change Faces!"
	weight = 0 //SKYRAT EDIT CHANGE - WIZARD CHANGE - ORIGINAL weight = 4
	typepath = /datum/round_event/wizard/shufflenames
	max_occurrences = 5
	earliest_start = 0 MINUTES

/datum/round_event/wizard/shufflenames/start()
	var/list/mobnames = list()
	var/list/mobs = list()

	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		mobnames += H.real_name
		mobs += H

	if(!mobs)
		return

	shuffle_inplace(mobnames)
	shuffle_inplace(mobs)

	for(var/mob/living/carbon/human/victim in mobs)
		if(!mobnames)
			break
		victim.real_name = mobnames[mobnames.len]
		mobnames.len -= 1

	for(var/mob/living/carbon/human/victim in GLOB.alive_mob_list)
		var/datum/effect_system/fluid_spread/smoke/smoke = new
		smoke.set_up(0, holder = victim, location = victim.loc)
		smoke.start()

//---//

/datum/round_event_control/wizard/shuffleminds //Basically Mass Ranged Mindswap
	name = "Change Minds!"
	weight = 0 //SKYRAT EDIT CHANGE - WIZARD CHANGE - ORIGINAL weight = 1
	typepath = /datum/round_event/wizard/shuffleminds
	max_occurrences = 3
	earliest_start = 0 MINUTES

/datum/round_event/wizard/shuffleminds/start()
	var/list/mobs = list()

	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(H.stat || !H.mind || IS_WIZARD(H))
			continue //the wizard(s) are spared on this one
		mobs += H

	if(!mobs)
		return

	shuffle_inplace(mobs)

	var/obj/effect/proc_holder/spell/pointed/mind_transfer/swapper = new
	while(mobs.len > 1)
		var/mob/living/carbon/human/victim = pick(mobs)
		mobs -= victim
		swapper.cast(list(victim), mobs[mobs.len], TRUE)
		mobs -= mobs[mobs.len]

	for(var/mob/living/carbon/human/victim in GLOB.alive_mob_list)
		var/datum/effect_system/fluid_spread/smoke/smoke = new
		smoke.set_up(0, holder = victim, location = victim.loc)
		smoke.start()
