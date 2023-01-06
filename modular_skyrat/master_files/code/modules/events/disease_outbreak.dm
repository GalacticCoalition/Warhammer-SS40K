//We pick 2 symptoms from a defined list (removing the really bad ones like deafness, blindness, spontaneous combustion etc.)
/datum/round_event/disease_outbreak/advanced/start()
	var/datum/round_event_control/disease_outbreak/advanced/disease_event = control
	afflicted += disease_event.disease_candidates
	disease_event.disease_candidates.Cut() //Clean the list after use

	if(disease_event.chosen_max_symptoms)
		max_symptoms = disease_event.chosen_max_symptoms
		disease_event.chosen_max_symptoms = null
	else
		max_symptoms = 2 //Consistent symptoms taking into account severity

	if(disease_event.chosen_severity)
		max_severity = disease_event.chosen_severity
		disease_event.chosen_severity = null
	else
		max_severity = 4 //Don't make it too severe

	var/datum/disease/advance/advanced_disease = new /datum/disease/advance/random/event(max_symptoms, max_severity)

	var/list/name_symptoms = list() //for feedback
	for(var/datum/symptom/new_symptom in advanced_disease.symptoms)
		name_symptoms += new_symptom.name

	var/mob/living/carbon/human/victim = pick_n_take(afflicted)
	if(victim.ForceContractDisease(advanced_disease, FALSE))
		message_admins("An event has triggered a random advanced virus outbreak on [ADMIN_LOOKUPFLW(victim)]! It has these symptoms: [english_list(name_symptoms)]")
		log_game("An event has triggered a random advanced virus outbreak on [key_name(victim)]! It has these symptoms: [english_list(name_symptoms)].")
		announce_to_ghosts(victim)
	else
		log_game("An event attempted to trigger a random advanced virus outbreak on [key_name(victim)], but failed.")

/datum/disease/advance/random/event
	name = "Experimental Disease"
	copy_type = /datum/disease/advance

/datum/disease/advance/random/event/New(max_symptoms, max_level = 6)
	if(!max_symptoms)
		max_symptoms = rand(1, VIRUS_SYMPTOM_LIMIT)
	var/list/datum/symptom/possible_symptoms = list(
		/datum/symptom/chills,
		/datum/symptom/choking,
		/datum/symptom/confusion,
		/datum/symptom/cough,
		/datum/symptom/disfiguration,
		/datum/symptom/dizzy,
		/datum/symptom/fever,
		/datum/symptom/hallucigen,
		/datum/symptom/headache,
		/datum/symptom/narcolepsy,
		/datum/symptom/polyvitiligo,
		/datum/symptom/sneeze,
		/datum/symptom/vomit,
		/datum/symptom/weight_loss,
	)

	for(var/i in 1 to max_symptoms)
		var/datum/symptom/chosen_symptom = pick_n_take(possible_symptoms)
		if(chosen_symptom)
			var/datum/symptom/S = new chosen_symptom
			symptoms += S
	Refresh()

	name = "Sample #[rand(1,10000)]"

// Assign the properties that are in the list.
/datum/disease/advance/random/event/AssignProperties()
	visibility_flags &= ~HIDDEN_SCANNER
	var/transmissibility = rand(3, 11)
	message_admins("Transmissibility rolled a [transmissibility]")

	if(properties?.len)
		if(transmissibility >= 11)
			SetSpread(DISEASE_SPREAD_AIRBORNE)

		else if(transmissibility >= 7)
			SetSpread(DISEASE_SPREAD_CONTACT_SKIN)

		else
			SetSpread(DISEASE_SPREAD_CONTACT_FLUIDS)

		spreading_modifier = max(CEILING(0.4 * properties["transmittable"], 1), 1)
		cure_chance = clamp(7.5 - (0.5 * properties["resistance"]), 5, 10) // can be between 5 and 10
		stage_prob = max(0.5 * properties["stage_rate"], 1)
		SetSeverity(properties["severity"])
		GenerateCure(properties)
	else
		CRASH("Our properties were empty or null!")


// Assign the spread type and give it the correct description.
/datum/disease/advance/random/event/SetSpread(spread_id)
	switch(spread_id)
		if(DISEASE_SPREAD_CONTACT_FLUIDS)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS
			spread_text = "Fluids"
		if(DISEASE_SPREAD_CONTACT_SKIN)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
			spread_text = "On contact"
		if(DISEASE_SPREAD_AIRBORNE)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_AIRBORNE
			spread_text = "Airborne"
