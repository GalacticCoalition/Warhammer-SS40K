/datum/species/lizard/ashwalker
	mutanteyes = /obj/item/organ/internal/eyes/night_vision
	burnmod = 0.7
	brutemod = 0.8

/datum/species/lizard/ashwalker/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	ADD_TRAIT(C, TRAIT_ASHSTORM_IMMUNE, SPECIES_TRAIT)
	C.AddElement(/datum/element/ash_age)

/datum/species/lizard/ashwalker/on_species_loss(mob/living/carbon/C)
	. = ..()
	REMOVE_TRAIT(C, TRAIT_ASHSTORM_IMMUNE, SPECIES_TRAIT)


/**
 * 20 minutes = speed
 * 40 minutes = armor
 * 60 minutes = base punch
 * 80 minutes = lavaproof
 * 100 minutes = firebreath
 */

/datum/element/ash_age
	/// the amount of minutes after each upgrade
	var/stage_time = 20 MINUTES
	/// the current stage of the ash
	var/current_stage = 0
	/// the time when upgraded/attached
	var/evo_time = 0
	/// the human target the element is attached to
	var/mob/living/carbon/human/human_target

/datum/element/ash_age/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	// set the target for the element so we can reference in other parts
	human_target = target
	// set the time that it was attached then we will compare current world time versus the evo_time plus stage_time
	evo_time = world.time
	// when the rune successfully completes the age ritual, it will send the signal... do the proc when we receive the signal
	RegisterSignal(human_target, COMSIG_RUNE_EVOLUTION, .proc/check_evolution)

/datum/element/ash_age/proc/check_evolution()
	// if the world time hasn't yet passed the time required for evolution
	if(world.time < (evo_time + stage_time))
		to_chat(human_target, span_warning("More time is necessary to evolve-- twenty minutes between each evolution..."))
		return
	// since it was time, go up a stage and now we check what to add
	current_stage++
	// since we went up a stage, we need to update the evo_time for the next comparison
	evo_time = world.time
	var/datum/species/species_target = human_target.dna.species
	switch(current_stage)
		if(1)
			species_target.speedmod -= 0.2
			to_chat(human_target, span_notice("Your body seems lighter..."))
		if(2)
			species_target.armor += 10
			to_chat(human_target, span_notice("Your body seems to be sturdier..."))
		if(3)
			species_target.punchdamagelow += 5
			species_target.punchdamagehigh += 5
			to_chat(human_target, span_notice("Your arms seem denser..."))
		if(4)
			ADD_TRAIT(human_target, TRAIT_LAVA_IMMUNE, src)
			to_chat(human_target, span_notice("Your body feels hotter..."))
		if(5)
			var/datum/action/cooldown/mob_cooldown/fire_breath/granted_action
			granted_action = new()
			granted_action.Grant(human_target)
			to_chat(human_target, span_notice("Your throat feels larger..."))
		if(6 to INFINITY)
			to_chat(human_target, span_warning("You have already reached the pinnacle of your current body!"))
