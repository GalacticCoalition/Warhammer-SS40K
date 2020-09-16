/datum/dna
	var/list/list/mutant_bodyparts = list()
	features = MANDATORY_FEATURE_LIST
	///Body markings of the DNA's owner. This is for storing their original state for re-creating the character. They'll get changed on species mutation
	var/list/list/body_markings = list()

/datum/dna/proc/initialize_dna(newblood_type, skip_index = FALSE)
	if(newblood_type)
		blood_type = newblood_type
	unique_enzymes = generate_unique_enzymes()
	uni_identity = generate_uni_identity()
	if(!skip_index) //I hate this
		generate_dna_blocks()
	features = species.get_random_features()
	mutant_bodyparts = species.get_random_mutant_bodyparts(features)

/mob/living/carbon/set_species(datum/species/mrace, icon_update = TRUE, var/datum/preferences/pref_load)
	if(mrace && has_dna())
		var/datum/species/new_race
		if(ispath(mrace))
			new_race = new mrace
		else if(istype(mrace))
			new_race = mrace
		else
			return
		deathsound = new_race.deathsound
		dna.species.on_species_loss(src, new_race, pref_load)
		var/datum/species/old_species = dna.species
		dna.species = new_race
		//BODYPARTS AND FEATURES
		var/list/bodyparts_to_add
		if(pref_load)
			dna.features = pref_load.features.Copy()
			dna.real_name = pref_load.real_name
			dna.mutant_bodyparts = pref_load.mutant_bodyparts.Copy()
			dna.body_markings = pref_load.body_markings.Copy()
			dna.species.body_markings = pref_load.body_markings.Copy()
		else
			dna.features = new_race.get_random_features()
			dna.mutant_bodyparts = new_race.get_random_mutant_bodyparts(dna.features)
			dna.body_markings = new_race.get_random_body_markings(dna.features)
			dna.species.body_markings = dna.body_markings.Copy()

		bodyparts_to_add = dna.mutant_bodyparts.Copy()

		for(var/key in bodyparts_to_add)
			var/datum/sprite_accessory/SP = GLOB.sprite_accessories[key][bodyparts_to_add[key][MUTANT_INDEX_NAME]]
			if(!SP.factual)
				bodyparts_to_add -= key
				continue

		dna.species.mutant_bodyparts = bodyparts_to_add.Copy()

		dna.species.on_species_gain(src, old_species, pref_load)
		//END OF BODYPARTS AND FEATURES
		if(ishuman(src))
			qdel(language_holder)
			var/species_holder = initial(mrace.species_language_holder)
			language_holder = new species_holder(src)
		update_atom_languages()
