

//////////////////////////////////////////////////////////////////////////////////////////
					// MEDICINE REAGENTS
//////////////////////////////////////////////////////////////////////////////////////

// where all the reagents related to medicine go.

/datum/reagent/medicine
	taste_description = "bitterness"

/datum/reagent/medicine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	current_cycle++
	if(length(reagent_removal_skip_list))
		return
	holder.remove_reagent(type, metabolization_rate * delta_time / M.metabolism_efficiency) //medicine reagents stay longer if you have a better metabolism

/datum/reagent/medicine/leporazine
	name = "Leporazine"
	description = "Leporazine will effectively regulate a patient's body temperature, ensuring it never leaves safe levels."
	ph = 8.4
	color = "#DB90C6"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/leporazine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/target_temp = M.get_body_temp_normal(apply_change=FALSE)
	if(M.bodytemperature > target_temp)
		M.adjust_bodytemperature(-40 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, target_temp)
	else if(M.bodytemperature < (target_temp + 1))
		M.adjust_bodytemperature(40 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, 0, target_temp)
	if(ishuman(M))
		var/mob/living/carbon/human/humi = M
		if(humi.coretemperature > target_temp)
			humi.adjust_coretemperature(-40 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, target_temp)
		else if(humi.coretemperature < (target_temp + 1))
			humi.adjust_coretemperature(40 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, 0, target_temp)
	..()

/datum/reagent/medicine/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	description = "It's magic. We don't have to explain it."
	color = "#E0BB00" //golden for the gods
	taste_description = "badmins"
	chemical_flags = REAGENT_DEAD_PROCESS

// The best stuff there is. For testing/debugging.
/datum/reagent/medicine/adminordrazine/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.adjust_waterlevel(round(chems.get_reagent_amount(type) * 1))
		mytray.adjust_plant_health(round(chems.get_reagent_amount(type) * 1))
		mytray.adjust_pestlevel(-rand(1,5))
		mytray.adjust_weedlevel(-rand(1,5))
	if(chems.has_reagent(type, 3))
		switch(rand(100))
			if(66  to 100)
				mytray.mutatespecie()
			if(33 to 65)
				mytray.mutateweed()
			if(1   to 32)
				mytray.mutatepest(user)
			else
				if(prob(20))
					mytray.visible_message(span_warning("Nothing happens..."))

/datum/reagent/medicine/adminordrazine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.heal_bodypart_damage(5 * REM * delta_time, 5 * REM * delta_time)
	M.adjustToxLoss(-5 * REM * delta_time, FALSE, TRUE)
	M.setOxyLoss(0, 0)
	M.setCloneLoss(0, 0)

	M.set_blurriness(0)
	M.set_blindness(0)
	M.SetKnockdown(0)
	M.SetStun(0)
	M.SetUnconscious(0)
	M.SetParalyzed(0)
	M.SetImmobilized(0)
	M.remove_status_effect(/datum/status_effect/confusion)
	M.SetSleeping(0)

	M.silent = FALSE
	M.remove_status_effect(/datum/status_effect/dizziness)
	M.disgust = 0
	M.drowsyness = 0
	// Remove all speech related status effects
	for(var/effect in typesof(/datum/status_effect/speech))
		M.remove_status_effect(effect)
	M.remove_status_effect(/datum/status_effect/jitter)
	M.hallucination = 0
	REMOVE_TRAITS_NOT_IN(M, list(SPECIES_TRAIT, ROUNDSTART_TRAIT, ORGAN_TRAIT))
	M.reagents.remove_all_type(/datum/reagent/toxin, 5 * REM * delta_time, FALSE, TRUE)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = BLOOD_VOLUME_NORMAL

	M.cure_all_traumas(TRAUMA_RESILIENCE_MAGIC)
	for(var/obj/item/organ/organ as anything in M.internal_organs)
		organ.setOrganDamage(0)
	for(var/thing in M.diseases)
		var/datum/disease/D = thing
		if(D.severity == DISEASE_SEVERITY_POSITIVE)
			continue
		D.cure()
	..()
	. = TRUE

/datum/reagent/medicine/adminordrazine/quantum_heal
	name = "Quantum Medicine"
	description = "Rare and experimental particles, that apparently swap the user's body with one from an alternate dimension where it's completely healthy."
	taste_description = "science"

/datum/reagent/medicine/synaptizine
	name = "Synaptizine"
	description = "Increases resistance to stuns as well as reducing drowsiness and hallucinations."
	color = "#FF00FF"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/synaptizine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_drowsyness(-5 * REM * delta_time)
	M.AdjustStun(-20 * REM * delta_time)
	M.AdjustKnockdown(-20 * REM * delta_time)
	M.AdjustUnconscious(-20 * REM * delta_time)
	M.AdjustImmobilized(-20 * REM * delta_time)
	M.AdjustParalyzed(-20 * REM * delta_time)
	if(holder.has_reagent(/datum/reagent/toxin/mindbreaker))
		holder.remove_reagent(/datum/reagent/toxin/mindbreaker, 5 * REM * delta_time)
	M.hallucination = max(M.hallucination - (10 * REM * delta_time), 0)
	if(DT_PROB(16, delta_time))
		M.adjustToxLoss(1, 0)
		. = TRUE
	..()

/datum/reagent/medicine/synaphydramine
	name = "Diphen-Synaptizine"
	description = "Reduces drowsiness, hallucinations, and Histamine from body."
	color = "#EC536D" // rgb: 236, 83, 109
	ph = 5.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/synaphydramine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_drowsyness(-5 * REM * delta_time)
	if(holder.has_reagent(/datum/reagent/toxin/mindbreaker))
		holder.remove_reagent(/datum/reagent/toxin/mindbreaker, 5 * REM * delta_time)
	if(holder.has_reagent(/datum/reagent/toxin/histamine))
		holder.remove_reagent(/datum/reagent/toxin/histamine, 5 * REM * delta_time)
	M.hallucination = max(M.hallucination - (10 * REM * delta_time), 0)
	if(DT_PROB(16, delta_time))
		M.adjustToxLoss(1, 0)
		. = TRUE
	..()

/datum/reagent/medicine/cryoxadone
	name = "Cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the patient's body temperature must be under 270K for it to metabolise correctly."
	color = "#0000C8"
	taste_description = "blue"
	ph = 11
	burning_temperature = 20 //cold burning
	burning_volume = 0.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/cryoxadone/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	metabolization_rate = REAGENTS_METABOLISM * (0.00001 * (M.bodytemperature ** 2) + 0.5)
	if(M.bodytemperature >= T0C || !HAS_TRAIT(M, TRAIT_KNOCKEDOUT))
		..()
		return
	var/power = -0.00003 * (M.bodytemperature ** 2) + 3
	M.adjustOxyLoss(-3 * power * REM * delta_time, 0)
	M.adjustBruteLoss(-power * REM * delta_time, 0)
	M.adjustFireLoss(-power * REM * delta_time, 0)
	M.adjustToxLoss(-power * REM * delta_time, 0, TRUE) //heals TOXINLOVERs
	M.adjustCloneLoss(-power * REM * delta_time, 0)
	for(var/i in M.all_wounds)
		var/datum/wound/iter_wound = i
		iter_wound.on_xadone(power * REAGENTS_EFFECT_MULTIPLIER * delta_time)
	REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC) //fixes common causes for disfiguration
	..()
	return TRUE

// Healing
/datum/reagent/medicine/cryoxadone/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	mytray.adjust_plant_health(round(chems.get_reagent_amount(type) * 3))
	mytray.adjust_toxic(-round(chems.get_reagent_amount(type) * 3))

/datum/reagent/medicine/clonexadone
	name = "Clonexadone"
	description = "A chemical that derives from Cryoxadone. It specializes in healing clone damage, but nothing else. Requires very cold temperatures to properly metabolize, and metabolizes quicker than cryoxadone."
	color = "#3D3DC6"
	taste_description = "muscle"
	ph = 13
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/clonexadone/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.bodytemperature < T0C)
		M.adjustCloneLoss((0.00006 * (M.bodytemperature ** 2) - 6) * REM * delta_time, 0)
		REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC)
		. = TRUE
	metabolization_rate = REAGENTS_METABOLISM * (0.000015 * (M.bodytemperature ** 2) + 0.75)
	..()

/datum/reagent/medicine/pyroxadone
	name = "Pyroxadone"
	description = "A mixture of cryoxadone and slime jelly, that apparently inverses the requirement for its activation."
	color = "#f7832a"
	taste_description = "spicy jelly"
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/pyroxadone/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
		var/power = 0
		switch(M.bodytemperature)
			if(BODYTEMP_HEAT_DAMAGE_LIMIT to 400)
				power = 2
			if(400 to 460)
				power = 3
			else
				power = 5
		if(M.on_fire)
			power *= 2

		M.adjustOxyLoss(-2 * power * REM * delta_time, FALSE)
		M.adjustBruteLoss(-power * REM * delta_time, FALSE)
		M.adjustFireLoss(-1.5 * power * REM * delta_time, FALSE)
		M.adjustToxLoss(-power * REM * delta_time, FALSE, TRUE)
		M.adjustCloneLoss(-power * REM * delta_time, FALSE)
		for(var/i in M.all_wounds)
			var/datum/wound/iter_wound = i
			iter_wound.on_xadone(power * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC)
		. = TRUE
	..()

/datum/reagent/medicine/rezadone
	name = "Rezadone"
	description = "A powder derived from fish toxin, Rezadone can effectively treat genetic damage as well as restoring minor wounds and restoring corpses husked by burns. Overdose will cause intense nausea and minor toxin damage."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose_threshold = 30
	ph = 12.2
	taste_description = "fish"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/rezadone/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.setCloneLoss(0) //Rezadone is almost never used in favor of cryoxadone. Hopefully this will change that. // No such luck so far
	M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
	REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC)
	..()
	. = TRUE

/datum/reagent/medicine/rezadone/overdose_process(mob/living/M, delta_time, times_fired)
	M.adjustToxLoss(1 * REM * delta_time, 0)
	M.set_timed_status_effect(10 SECONDS * REM * delta_time, /datum/status_effect/dizziness, only_if_higher = TRUE)
	M.set_timed_status_effect(10 SECONDS * REM * delta_time, /datum/status_effect/jitter, only_if_higher = TRUE)
	..()
	. = TRUE

/datum/reagent/medicine/rezadone/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob))
		return

	var/mob/living/carbon/patient = exposed_mob
	if(reac_volume >= 5 && HAS_TRAIT_FROM(patient, TRAIT_HUSK, BURN) && patient.getFireLoss() < UNHUSK_DAMAGE_THRESHOLD) //One carp yields 12u rezadone.
		patient.cure_husk(BURN)
		patient.visible_message(span_nicegreen("[patient]'s body rapidly absorbs moisture from the environment, taking on a more healthy appearance."))
	// SKYRAT EDIT ADDITION BEGIN - non-modular changeling balancing
	if(HAS_TRAIT_FROM(exposed_mob, TRAIT_HUSK, CHANGELING_DRAIN) && (patient.reagents.get_reagent_amount(/datum/reagent/medicine/rezadone) + reac_volume >= SYNTHFLESH_LING_UNHUSK_AMOUNT))//Costs a little more than a normal husk
		patient.cure_husk(CHANGELING_DRAIN)
		patient.visible_message("<span class='nicegreen'>A rubbery liquid coats [patient]'s tissues. [patient] looks a lot healthier!")
	// SKYRAT EDIT ADDITION END

/datum/reagent/medicine/spaceacillin
	name = "Spaceacillin"
	description = "Spaceacillin will provide limited resistance against disease and parasites. Also reduces infection in serious burns."
	color = "#E1F2E6"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	ph = 8.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Goon Chems. Ported mainly from Goonstation. Easily mixable (or not so easily) and provide a variety of effects.

/datum/reagent/medicine/oxandrolone
	name = "Oxandrolone"
	description = "Stimulates the healing of severe burns. Extremely rapidly heals severe burns and slowly heals minor ones. Overdose will worsen existing burns."
	reagent_state = LIQUID
	color = "#1E8BFF"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25
	ph = 10.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/oxandrolone/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getFireLoss() > 25)
		M.adjustFireLoss(-4 * REM * delta_time, 0) //Twice as effective as AIURI for severe burns
	else
		M.adjustFireLoss(-0.5 * REM * delta_time, 0) //But only a quarter as effective for more minor ones
	..()
	. = TRUE

/datum/reagent/medicine/oxandrolone/overdose_process(mob/living/M, delta_time, times_fired)
	if(M.getFireLoss()) //It only makes existing burns worse
		M.adjustFireLoss(4.5 * REM * delta_time, FALSE, FALSE, BODYTYPE_ORGANIC) // it's going to be healing either 4 or 0.5
		. = TRUE
	..()

/datum/reagent/medicine/salglu_solution
	name = "Saline-Glucose Solution"
	description = "Has a 33% chance per metabolism cycle to heal brute and burn damage. Can be used as a temporary blood substitute, as well as slowly speeding blood regeneration."
	reagent_state = LIQUID
	color = "#DCDCDC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 60
	taste_description = "sweetness and salt"
	var/last_added = 0
	var/maximum_reachable = BLOOD_VOLUME_NORMAL - 10 //So that normal blood regeneration can continue with salglu active
	var/extra_regen = 0.25 // in addition to acting as temporary blood, also add about half this much to their actual blood per second
	ph = 5.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/salglu_solution/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(last_added)
		M.blood_volume -= last_added
		last_added = 0
	if(M.blood_volume < maximum_reachable) //Can only up to double your effective blood level.
		var/amount_to_add = min(M.blood_volume, 5*volume)
		var/new_blood_level = min(M.blood_volume + amount_to_add, maximum_reachable)
		last_added = new_blood_level - M.blood_volume
		M.blood_volume = new_blood_level + (extra_regen * REM * delta_time)
	if(DT_PROB(18, delta_time))
		M.adjustBruteLoss(-0.5, 0)
		M.adjustFireLoss(-0.5, 0)
		. = TRUE
	..()

/datum/reagent/medicine/salglu_solution/overdose_process(mob/living/M, delta_time, times_fired)
	if(DT_PROB(1.5, delta_time))
		to_chat(M, span_warning("You feel salty."))
		holder.add_reagent(/datum/reagent/consumable/salt, 1)
		holder.remove_reagent(/datum/reagent/medicine/salglu_solution, 0.5)
	else if(DT_PROB(1.5, delta_time))
		to_chat(M, span_warning("You feel sweet."))
		holder.add_reagent(/datum/reagent/consumable/sugar, 1)
		holder.remove_reagent(/datum/reagent/medicine/salglu_solution, 0.5)
	if(DT_PROB(18, delta_time))
		M.adjustBruteLoss(0.5, FALSE, FALSE, BODYTYPE_ORGANIC)
		M.adjustFireLoss(0.5, FALSE, FALSE, BODYTYPE_ORGANIC)
		. = TRUE
	..()

/datum/reagent/medicine/mine_salve
	name = "Miner's Salve"
	description = "A powerful painkiller. Restores bruising and burns in addition to making the patient believe they are fully healed. Also great for treating severe burn wounds in a pinch."
	reagent_state = LIQUID
	color = "#6D6374"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	ph = 2.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/mine_salve/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	C.hal_screwyhud = SCREWYHUD_HEALTHY
	C.adjustBruteLoss(-0.25 * REM * delta_time, 0)
	C.adjustFireLoss(-0.25 * REM * delta_time, 0)
	..()
	return TRUE

/datum/reagent/medicine/mine_salve/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE)
	. = ..()
	if(!iscarbon(exposed_mob) || (exposed_mob.stat == DEAD))
		return

	if(methods & (INGEST|VAPOR|INJECT))
		exposed_mob.adjust_nutrition(-5)
		if(show_message)
			to_chat(exposed_mob, span_warning("Your stomach feels empty and cramps!"))

	if(methods & (PATCH|TOUCH))
		var/mob/living/carbon/exposed_carbon = exposed_mob
		for(var/s in exposed_carbon.surgeries)
			var/datum/surgery/surgery = s
			surgery.speed_modifier = max(0.1, surgery.speed_modifier)

		if(show_message)
			to_chat(exposed_carbon, span_danger("You feel your injuries fade away to nothing!") )

/datum/reagent/medicine/mine_salve/on_mob_end_metabolize(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_NUMBED, src) // SKYRAT EDIT ADD -- ANAESTHETIC FOR SURGERY PAIN
	M.clear_alert("numbed") // SKYRAT EDIT ADD END
	if(iscarbon(M))
		var/mob/living/carbon/N = M
		N.hal_screwyhud = SCREWYHUD_NONE
	..()

/datum/reagent/medicine/omnizine
	name = "Omnizine"
	description = "Slowly heals all damage types. Overdose will cause damage in all types instead."
	reagent_state = LIQUID
	color = "#DCDCDC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	var/healing = 0.5
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/omnizine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustToxLoss(-healing * REM * delta_time, 0)
	M.adjustOxyLoss(-healing * REM * delta_time, 0)
	M.adjustBruteLoss(-healing * REM * delta_time, 0)
	M.adjustFireLoss(-healing * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/medicine/omnizine/overdose_process(mob/living/M, delta_time, times_fired)
	M.adjustToxLoss(1.5 * REM * delta_time, FALSE)
	M.adjustOxyLoss(1.5 * REM * delta_time, FALSE)
	M.adjustBruteLoss(1.5 * REM * delta_time, FALSE, FALSE, BODYTYPE_ORGANIC)
	M.adjustFireLoss(1.5 * REM * delta_time, FALSE, FALSE, BODYTYPE_ORGANIC)
	..()
	. = TRUE

/datum/reagent/medicine/omnizine/protozine
	name = "Protozine"
	description = "A less environmentally friendly and somewhat weaker variant of omnizine."
	color = "#d8c7b7"
	healing = 0.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/calomel
	name = "Calomel"
	description = "Quickly purges the body of toxic chemicals. Toxin damage is dealt if the patient is in good condition."
	reagent_state = LIQUID
	color = "#19C832"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "acid"
	ph = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/calomel/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	for(var/datum/reagent/toxin/R in M.reagents.reagent_list)
		M.reagents.remove_reagent(R.type, 3 * REM * delta_time)
	if(M.health > 20)
		M.adjustToxLoss(1 * REM * delta_time, 0)
		. = TRUE
	..()

/datum/reagent/medicine/potass_iodide
	name = "Potassium Iodide"
	description = "Heals low toxin damage while the patient is irradiated, and will halt the damaging effects of radiation."
	reagent_state = LIQUID
	color = "#BAA15D"
	metabolization_rate = 2 * REAGENTS_METABOLISM
	ph = 12 //It's a reducing agent
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/potass_iodide/on_mob_metabolize(mob/living/L)
	. = ..()
	ADD_TRAIT(L, TRAIT_HALT_RADIATION_EFFECTS, "[type]")

/datum/reagent/medicine/potass_iodide/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_HALT_RADIATION_EFFECTS, "[type]")
	return ..()

/datum/reagent/medicine/potass_iodide/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if (HAS_TRAIT(M, TRAIT_IRRADIATED))
		M.adjustToxLoss(-1 * REM * delta_time)

	..()

/datum/reagent/medicine/pen_acid
	name = "Pentetic Acid"
	description = "Reduces massive amounts of toxin damage while purging other chemicals from the body."
	reagent_state = LIQUID
	color = "#E6FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 1 //One of the best buffers, NEVERMIND!
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/pen_acid/on_mob_metabolize(mob/living/L)
	. = ..()
	ADD_TRAIT(L, TRAIT_HALT_RADIATION_EFFECTS, "[type]")

/datum/reagent/medicine/pen_acid/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_HALT_RADIATION_EFFECTS, "[type]")
	return ..()

/datum/reagent/medicine/pen_acid/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustToxLoss(-2 * REM * delta_time, 0)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.type, 2 * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/medicine/sal_acid
	name = "Salicylic Acid"
	description = "Stimulates the healing of severe bruises. Extremely rapidly heals severe bruising and slowly heals minor ones. Overdose will worsen existing bruising."
	reagent_state = LIQUID
	color = "#D2D2D2"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25
	ph = 2.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/sal_acid/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getBruteLoss() > 25)
		M.adjustBruteLoss(-4 * REM * delta_time, 0)
	else
		M.adjustBruteLoss(-0.5 * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/medicine/sal_acid/overdose_process(mob/living/M, delta_time, times_fired)
	if(M.getBruteLoss()) //It only makes existing bruises worse
		M.adjustBruteLoss(4.5 * REM * delta_time, FALSE, FALSE, BODYTYPE_ORGANIC) // it's going to be healing either 4 or 0.5
		. = TRUE
	..()

/datum/reagent/medicine/salbutamol
	name = "Salbutamol"
	description = "Rapidly restores oxygen deprivation as well as preventing more of it to an extent."
	reagent_state = LIQUID
	color = "#00FFFF"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/salbutamol/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustOxyLoss(-3 * REM * delta_time, 0)
	if(M.losebreath >= 4)
		M.losebreath -= 2 * REM * delta_time
	..()
	. = TRUE

/datum/reagent/medicine/ephedrine
	name = "Ephedrine"
	description = "Increases resistance to batons and movement speed, giving you hand cramps. Overdose deals toxin damage and inhibits breathing."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	ph = 12
	purity = REAGENT_STANDARD_PURITY
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/stimulants = 4) //1.6 per 2 seconds
	inverse_chem = /datum/reagent/inverse/corazargh
	inverse_chem_val = 0.4

/datum/reagent/medicine/ephedrine/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/ephedrine)
	ADD_TRAIT(L, TRAIT_BATON_RESISTANCE, type)

/datum/reagent/medicine/ephedrine/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/ephedrine)
	REMOVE_TRAIT(L, TRAIT_BATON_RESISTANCE, type)
	..()

/datum/reagent/medicine/ephedrine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(10 * (1-creation_purity), delta_time) && iscarbon(M))
		var/obj/item/I = M.get_active_held_item()
		if(I && M.dropItemToGround(I))
			to_chat(M, span_notice("Your hands spaz out and you drop what you were holding!"))
			M.set_timed_status_effect(20 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)

	M.AdjustAllImmobility(-20 * REM * delta_time * normalise_creation_purity())
	M.adjustStaminaLoss(-1 * REM * delta_time * normalise_creation_purity(), FALSE)
	..()
	return TRUE

/datum/reagent/medicine/ephedrine/overdose_process(mob/living/M, delta_time, times_fired)
	if(DT_PROB(1 * normalise_creation_purity(), delta_time) && iscarbon(M))
		var/datum/disease/D = new /datum/disease/heart_failure
		M.ForceContractDisease(D)
		to_chat(M, span_userdanger("You're pretty sure you just felt your heart stop for a second there.."))
		M.playsound_local(M, 'sound/effects/singlebeat.ogg', 100, 0)

	if(DT_PROB(3.5 * normalise_creation_purity(), delta_time))
		to_chat(M, span_notice("[pick("Your head pounds.", "You feel a tight pain in your chest.", "You find it hard to stay still.", "You feel your heart practically beating out of your chest.")]"))

	if(DT_PROB(18 * normalise_creation_purity(), delta_time))
		M.adjustToxLoss(1, 0)
		M.losebreath++
		. = TRUE
	return TRUE

/datum/reagent/medicine/diphenhydramine
	name = "Diphenhydramine"
	description = "Rapidly purges the body of Histamine and reduces jitteriness. Slight chance of causing drowsiness."
	reagent_state = LIQUID
	color = "#64FFE6"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 11.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/diphenhydramine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(5, delta_time))
		M.adjust_drowsyness(1)
	M.adjust_timed_status_effect(-2 SECONDS * REM * delta_time, /datum/status_effect/jitter)
	holder.remove_reagent(/datum/reagent/toxin/histamine, 3 * REM * delta_time)
	..()

/datum/reagent/medicine/morphine
	name = "Morphine"
	description = "A painkiller that allows the patient to move at full speed even when injured. Causes drowsiness and eventually unconsciousness in high doses. Overdose will cause a variety of effects, ranging from minor to lethal."
	reagent_state = LIQUID
	color = "#A9FBFB"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	ph = 8.96
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/opioids = 10)

/datum/reagent/medicine/morphine/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	ADD_TRAIT(L, TRAIT_NUMBED, src) // SKYRAT EDIT ADD -- ANAESTHETIC FOR SURGERY PAIN
	L.throw_alert("numbed", /atom/movable/screen/alert/numbed) // SKYRAT EDIT ADD END -- i should probably have worked these both into a status effect, maybe

/datum/reagent/medicine/morphine/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	REMOVE_TRAIT(L, TRAIT_NUMBED, src) // SKYRAT EDIT ADD -- ANAESTHETIC FOR SURGERY PAIN
	L.clear_alert("numbed") // SKYRAT EDIT ADD END
	..()

/datum/reagent/medicine/morphine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle >= 5)
		M.add_mood_event("numb", /datum/mood_event/narcotic_medium, name)
	switch(current_cycle)
		if(11)
			to_chat(M, span_warning("You start to feel tired...") )
		if(12 to 24)
			M.adjust_drowsyness(1 * REM * delta_time)
		if(24 to INFINITY)
			M.Sleeping(40 * REM * delta_time)
			. = TRUE
	..()

/datum/reagent/medicine/morphine/overdose_process(mob/living/M, delta_time, times_fired)
	if(DT_PROB(18, delta_time))
		M.drop_all_held_items()
		M.set_timed_status_effect(4 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)
		M.set_timed_status_effect(4 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	..()


/datum/reagent/medicine/oculine
	name = "Oculine"
	description = "Quickly restores eye damage, cures nearsightedness, and has a chance to restore vision to the blind."
	reagent_state = LIQUID
	color = "#404040" //oculine is dark grey, inacusiate is light grey
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "dull toxin"
	purity = REAGENT_STANDARD_PURITY
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem = /datum/reagent/inverse/oculine
	inverse_chem_val = 0.45
	///The lighting alpha that the mob had on addition
	var/delta_light

/datum/reagent/medicine/oculine/on_mob_add(mob/living/owner)
	if(!iscarbon(owner))
		return
	RegisterSignal(owner, COMSIG_CARBON_GAIN_ORGAN, .proc/on_gained_organ)
	RegisterSignal(owner, COMSIG_CARBON_LOSE_ORGAN, .proc/on_removed_organ)
	var/obj/item/organ/internal/eyes/eyes = owner.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	improve_eyesight(owner, eyes)

/datum/reagent/medicine/oculine/proc/improve_eyesight(mob/living/carbon/owner, obj/item/organ/internal/eyes/eyes)
	delta_light = creation_purity*30
	if(eyes.lighting_alpha)
		eyes.lighting_alpha -= delta_light
	else
		eyes.lighting_alpha = 255 - delta_light
	eyes.see_in_dark += 3
	owner.update_sight()

/datum/reagent/medicine/oculine/proc/restore_eyesight(mob/living/carbon/owner, obj/item/organ/internal/eyes/eyes)
	eyes.lighting_alpha += delta_light
	eyes.see_in_dark -= 3
	owner.update_sight()

/datum/reagent/medicine/oculine/proc/on_gained_organ(mob/owner, obj/item/organ/organ)
	SIGNAL_HANDLER
	if(!istype(organ, /obj/item/organ/internal/eyes))
		return
	var/obj/item/organ/internal/eyes/eyes = organ
	improve_eyesight(owner, eyes)

/datum/reagent/medicine/oculine/proc/on_removed_organ(mob/prev_owner, obj/item/organ/organ)
	SIGNAL_HANDLER
	if(!istype(organ, /obj/item/organ/internal/eyes))
		return
	var/obj/item/organ/internal/eyes/eyes = organ
	restore_eyesight(prev_owner, eyes)

/datum/reagent/medicine/oculine/on_mob_life(mob/living/carbon/owner, delta_time, times_fired)
	owner.adjust_blindness(-2 * REM * delta_time * normalise_creation_purity())
	owner.adjust_blurriness(-2 * REM * delta_time * normalise_creation_purity())
	var/obj/item/organ/internal/eyes/eyes = owner.getorganslot(ORGAN_SLOT_EYES)
	if (!eyes)
		return ..()
	var/fix_prob = 10
	if(creation_purity >= 1)
		fix_prob = 100
	eyes.applyOrganDamage(-2 * REM * delta_time * normalise_creation_purity())
	if(HAS_TRAIT_FROM(owner, TRAIT_BLIND, EYE_DAMAGE))
		if(DT_PROB(fix_prob, delta_time))
			to_chat(owner, span_warning("Your vision slowly returns..."))
			owner.cure_blind(EYE_DAMAGE)
			owner.cure_nearsighted(EYE_DAMAGE)
			owner.blur_eyes(35)
	else if(HAS_TRAIT_FROM(owner, TRAIT_NEARSIGHT, EYE_DAMAGE))
		to_chat(owner, span_warning("The blackness in your peripheral vision fades."))
		owner.cure_nearsighted(EYE_DAMAGE)
		owner.blur_eyes(10)
	..()

/datum/reagent/medicine/oculine/on_mob_delete(mob/living/owner)
	var/obj/item/organ/internal/eyes/eyes = owner.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	restore_eyesight(owner, eyes)
	..()

/datum/reagent/medicine/inacusiate
	name = "Inacusiate"
	description = "Rapidly repairs damage to the patient's ears to cure deafness, assuming the source of said deafness isn't from genetic mutations, chronic deafness, or a total defecit of ears." //by "chronic" deafness, we mean people with the "deaf" quirk
	color = "#606060" // ditto
	ph = 2
	purity = REAGENT_STANDARD_PURITY
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem_val = 0.3
	inverse_chem = /datum/reagent/impurity/inacusiate

/datum/reagent/medicine/inacusiate/on_mob_add(mob/living/owner, amount)
	. = ..()
	if(creation_purity >= 1)
		RegisterSignal(owner, COMSIG_MOVABLE_HEAR, .proc/owner_hear)

//Lets us hear whispers from far away!
/datum/reagent/medicine/inacusiate/proc/owner_hear(datum/source, message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	SIGNAL_HANDLER
	if(!isliving(holder.my_atom))
		return
	var/mob/living/owner = holder.my_atom
	var/atom/movable/composer = holder.my_atom
	if(message_mods[WHISPER_MODE])
		message = composer.compose_message(owner, message_language, message, , spans, message_mods)

/datum/reagent/medicine/inacusiate/on_mob_life(mob/living/carbon/owner, delta_time, times_fired)
	var/obj/item/organ/internal/ears/ears = owner.getorganslot(ORGAN_SLOT_EARS)
	if(!ears)
		return ..()
	ears.adjustEarDamage(-4 * REM * delta_time * normalise_creation_purity(), -4 * REM * delta_time * normalise_creation_purity())
	..()

/datum/reagent/medicine/inacusiate/on_mob_delete(mob/living/owner)
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)

/datum/reagent/medicine/atropine
	name = "Atropine"
	description = "If a patient is in critical condition, rapidly heals all damage types as well as regulating oxygen in the body. Excellent for stabilizing wounded patients."
	reagent_state = LIQUID
	color = "#1D3535" //slightly more blue, like epinephrine
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 35
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/atropine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.health <= M.crit_threshold)
		M.adjustToxLoss(-2 * REM * delta_time, 0)
		M.adjustBruteLoss(-2* REM * delta_time, 0)
		M.adjustFireLoss(-2 * REM * delta_time, 0)
		M.adjustOxyLoss(-5 * REM * delta_time, 0)
		. = TRUE
	M.losebreath = 0
	if(DT_PROB(10, delta_time))
		M.set_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)
		M.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	..()

/datum/reagent/medicine/atropine/overdose_process(mob/living/M, delta_time, times_fired)
	M.adjustToxLoss(0.5 * REM * delta_time, 0)
	. = TRUE
	M.set_timed_status_effect(2 SECONDS * REM * delta_time, /datum/status_effect/dizziness, only_if_higher = TRUE)
	M.set_timed_status_effect(2 SECONDS * REM * delta_time, /datum/status_effect/jitter, only_if_higher = TRUE)
	..()

/datum/reagent/medicine/epinephrine
	name = "Epinephrine"
	description = "Very minor boost to stun resistance. Slowly heals damage if a patient is in critical condition, as well as regulating oxygen loss. Overdose causes weakness and toxin damage."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	ph = 10.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/epinephrine/on_mob_metabolize(mob/living/carbon/M)
	..()
	ADD_TRAIT(M, TRAIT_NOCRITDAMAGE, type)

/datum/reagent/medicine/epinephrine/on_mob_end_metabolize(mob/living/carbon/M)
	REMOVE_TRAIT(M, TRAIT_NOCRITDAMAGE, type)
	..()

/datum/reagent/medicine/epinephrine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = TRUE
	if(holder.has_reagent(/datum/reagent/toxin/lexorin))
		holder.remove_reagent(/datum/reagent/toxin/lexorin, 2 * REM * delta_time)
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 1 * REM * delta_time)
		if(DT_PROB(10, delta_time))
			holder.add_reagent(/datum/reagent/toxin/histamine, 4)
		..()
		return
	if(M.health <= M.crit_threshold)
		M.adjustToxLoss(-0.5 * REM * delta_time, 0)
		M.adjustBruteLoss(-0.5 * REM * delta_time, 0)
		M.adjustFireLoss(-0.5 * REM * delta_time, 0)
		M.adjustOxyLoss(-0.5 * REM * delta_time, 0)
	if(M.losebreath >= 4)
		M.losebreath -= 2 * REM * delta_time
	if(M.losebreath < 0)
		M.losebreath = 0
	M.adjustStaminaLoss(-0.5 * REM * delta_time, 0)
	if(DT_PROB(10, delta_time))
		M.AdjustAllImmobility(-20)
	..()

/datum/reagent/medicine/epinephrine/overdose_process(mob/living/M, delta_time, times_fired)
	if(DT_PROB(18, REM * delta_time))
		M.adjustStaminaLoss(2.5, 0)
		M.adjustToxLoss(1, 0)
		M.losebreath++
		. = TRUE
	..()

/datum/reagent/medicine/strange_reagent
	name = "Strange Reagent"
	description = "A miracle drug capable of bringing the dead back to life. Works topically unless anotamically complex, in which case works orally. Only works if the target has less than 200 total brute and burn damage and hasn't been husked and requires more reagent depending on damage inflicted. Causes damage to the living."
	reagent_state = LIQUID
	color = "#A0E85E"
	metabolization_rate = 1.25 * REAGENTS_METABOLISM
	taste_description = "magnets"
	harmful = TRUE
	ph = 0.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


// FEED ME SEYMOUR
/datum/reagent/medicine/strange_reagent/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.spawnplant()

/datum/reagent/medicine/strange_reagent/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	if(exposed_mob.stat != DEAD)
		return ..()
	if(exposed_mob.suiciding) //they are never coming back
		exposed_mob.visible_message(span_warning("[exposed_mob]'s body does not react..."))
		return
	if(iscarbon(exposed_mob) && !(methods & INGEST)) //simplemobs can still be splashed
		return ..()
	var/amount_to_revive = round((exposed_mob.getBruteLoss()+exposed_mob.getFireLoss())/20)
	if(exposed_mob.getBruteLoss()+exposed_mob.getFireLoss() >= 200 || HAS_TRAIT(exposed_mob, TRAIT_HUSK) || reac_volume < amount_to_revive) //body will die from brute+burn on revive or you haven't provided enough to revive.
		exposed_mob.visible_message(span_warning("[exposed_mob]'s body convulses a bit, and then falls still once more."))
		exposed_mob.do_jitter_animation(10)
		return
	exposed_mob.visible_message(span_warning("[exposed_mob]'s body starts convulsing!"))
	exposed_mob.notify_ghost_cloning("Your body is being revived with Strange Reagent!")
	exposed_mob.do_jitter_animation(10)
	var/excess_healing = 5*(reac_volume-amount_to_revive) //excess reagent will heal blood and organs across the board
	addtimer(CALLBACK(exposed_mob, /mob/living/carbon.proc/do_jitter_animation, 10), 40) //jitter immediately, then again after 4 and 8 seconds
	addtimer(CALLBACK(exposed_mob, /mob/living/carbon.proc/do_jitter_animation, 10), 80)
	addtimer(CALLBACK(exposed_mob, /mob/living.proc/revive, FALSE, FALSE, excess_healing), 79)
	..()

/datum/reagent/medicine/strange_reagent/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/damage_at_random = rand(0, 250)/100 //0 to 2.5
	M.adjustBruteLoss(damage_at_random * REM * delta_time, FALSE)
	M.adjustFireLoss(damage_at_random * REM * delta_time, FALSE)
	..()
	. = TRUE

/datum/reagent/medicine/mannitol
	name = "Mannitol"
	description = "Efficiently restores brain damage."
	taste_description = "pleasant sweetness"
	color = "#A0A0A0" //mannitol is light grey, neurine is lighter grey
	ph = 10.4
	overdose_threshold = 15
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	purity = REAGENT_STANDARD_PURITY
	inverse_chem = /datum/reagent/inverse
	inverse_chem_val = 0.45

/datum/reagent/medicine/mannitol/on_mob_life(mob/living/carbon/owner, delta_time, times_fired)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2 * REM * delta_time * normalise_creation_purity())
	..()

//Having mannitol in you will pause the brain damage from brain tumor (so it heals an even 2 brain damage instead of 1.8)
/datum/reagent/medicine/mannitol/on_mob_metabolize(mob/living/carbon/owner)
	. = ..()
	ADD_TRAIT(owner, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)

/datum/reagent/medicine/mannitol/on_mob_end_metabolize(mob/living/carbon/owner)
	REMOVE_TRAIT(owner, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)
	. = ..()

/datum/reagent/medicine/mannitol/overdose_start(mob/living/owner)
	to_chat(owner, span_notice("You suddenly feel <span class='purple'>E N L I G H T E N E D!</span>"))

/datum/reagent/medicine/mannitol/overdose_process(mob/living/owner, delta_time, times_fired)
	if(DT_PROB(65, delta_time))
		return
	var/list/tips
	if(DT_PROB(50, delta_time))
		tips = world.file2list("strings/tips.txt")
	if(DT_PROB(50, delta_time))
		tips = world.file2list("strings/sillytips.txt")
	else
		tips = world.file2list("strings/chemistrytips.txt")
	var/message = pick(tips)
	send_tip_of_the_round(owner, message)
	return ..()

/datum/reagent/medicine/neurine
	name = "Neurine"
	description = "Reacts with neural tissue, helping reform damaged connections. Can cure minor traumas."
	color = "#C0C0C0" //ditto
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED | REAGENT_DEAD_PROCESS
	purity = REAGENT_STANDARD_PURITY
	inverse_chem_val = 0.5
	inverse_chem = /datum/reagent/inverse/neurine
	///brain damage level when we first started taking the chem
	var/initial_bdamage = 200

/datum/reagent/medicine/neurine/on_mob_add(mob/living/owner, amount)
	. = ..()
	ADD_TRAIT(owner, TRAIT_ANTICONVULSANT, name)
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon = owner
	if(creation_purity >= 1)
		initial_bdamage = carbon.getOrganLoss(ORGAN_SLOT_BRAIN)

/datum/reagent/medicine/neurine/on_mob_delete(mob/living/owner)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ANTICONVULSANT, name)
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon = owner
	if(initial_bdamage < carbon.getOrganLoss(ORGAN_SLOT_BRAIN))
		carbon.setOrganLoss(ORGAN_SLOT_BRAIN, initial_bdamage)

/datum/reagent/medicine/neurine/on_mob_life(mob/living/carbon/owner, delta_time, times_fired)
	if(holder.has_reagent(/datum/reagent/consumable/ethanol/neurotoxin))
		holder.remove_reagent(/datum/reagent/consumable/ethanol/neurotoxin, 5 * REM * delta_time * normalise_creation_purity())
	if(DT_PROB(8 * normalise_creation_purity(), delta_time))
		owner.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)
	..()

/datum/reagent/medicine/neurine/on_mob_dead(mob/living/carbon/owner, delta_time)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1 * REM * delta_time * normalise_creation_purity())
	..()

/datum/reagent/medicine/mutadone
	name = "Mutadone"
	description = "Removes jitteriness and restores genetic defects."
	color = "#5096C8"
	taste_description = "acid"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/mutadone/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.remove_status_effect(/datum/status_effect/jitter)
	if(M.has_dna())
		M.dna.remove_all_mutations(list(MUT_NORMAL, MUT_EXTRA), TRUE)
	if(!QDELETED(M)) //We were a monkey, now a human
		..()

/datum/reagent/medicine/antihol
	name = "Antihol"
	description = "Purges alcoholic substance from the patient's body and eliminates its side effects."
	color = "#00B4C8"
	taste_description = "raw egg"
	ph = 4
	purity = REAGENT_STANDARD_PURITY
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem_val = 0.35
	inverse_chem = /datum/reagent/inverse/antihol

/datum/reagent/medicine/antihol/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.remove_status_effect(/datum/status_effect/dizziness)
	M.set_drowsyness(0)
	M.remove_status_effect(/datum/status_effect/speech/slurring/drunk)
	M.remove_status_effect(/datum/status_effect/confusion)
	M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 3 * REM * delta_time * normalise_creation_purity(), FALSE, TRUE)
	M.adjustToxLoss(-0.2 * REM * delta_time, 0)
	M.adjust_drunk_effect(-10 * REM * delta_time * normalise_creation_purity())
	..()
	. = TRUE

/datum/reagent/medicine/stimulants
	name = "Stimulants"
	description = "Increases resistance to batons and movement speed in addition to restoring minor damage and weakness. Overdose causes weakness and toxin damage."
	color = "#78008C"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 60
	ph = 8.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	addiction_types = list(/datum/addiction/stimulants = 4) //0.8 per 2 seconds

/datum/reagent/medicine/stimulants/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/stimulants)
	ADD_TRAIT(L, TRAIT_BATON_RESISTANCE, type)

/datum/reagent/medicine/stimulants/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/stimulants)
	REMOVE_TRAIT(L, TRAIT_BATON_RESISTANCE, type)
	..()

/datum/reagent/medicine/stimulants/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.health < 50 && M.health > 0)
		M.adjustOxyLoss(-1 * REM * delta_time, 0)
		M.adjustToxLoss(-1 * REM * delta_time, 0)
		M.adjustBruteLoss(-1 * REM * delta_time, 0)
		M.adjustFireLoss(-1 * REM * delta_time, 0)
	M.AdjustAllImmobility(-60  * REM * delta_time)
	M.adjustStaminaLoss(-5 * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/medicine/stimulants/overdose_process(mob/living/M, delta_time, times_fired)
	if(DT_PROB(18, delta_time))
		M.adjustStaminaLoss(2.5, 0)
		M.adjustToxLoss(1, 0)
		M.losebreath++
		. = TRUE
	..()

/datum/reagent/medicine/insulin
	name = "Insulin"
	description = "Increases sugar depletion rates."
	reagent_state = LIQUID
	color = "#FFFFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 6.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/insulin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.AdjustSleeping(-20 * REM * delta_time))
		. = TRUE
	holder.remove_reagent(/datum/reagent/consumable/sugar, 3 * REM * delta_time)
	..()

//Trek Chems, used primarily by medibots. Only heals a specific damage type, but is very efficient.

/datum/reagent/medicine/inaprovaline //is this used anywhere?
	name = "Inaprovaline"
	description = "Stabilizes the breathing of patients. Good for those in critical condition."
	reagent_state = LIQUID
	color = "#A4D8D8"
	ph = 8.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/inaprovaline/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.losebreath >= 5)
		M.losebreath -= 5 * REM * delta_time
	..()

/datum/reagent/medicine/regen_jelly
	name = "Regenerative Jelly"
	description = "Gradually regenerates all types of damage, without harming slime anatomy."
	reagent_state = LIQUID
	color = "#CC23FF"
	taste_description = "jelly"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/regen_jelly/expose_mob(mob/living/exposed_mob, reac_volume)
	. = ..()
	if(!ishuman(exposed_mob) || (reac_volume < 0.5))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	exposed_human.hair_color = "#CC22FF"
	exposed_human.facial_hair_color = "#CC22FF"
<<<<<<< HEAD
	exposed_human.update_hair()
	// SKYRAT EDIT ADDITION BEGIN
	exposed_human.update_mutant_bodyparts(force_update=TRUE)
	// SKYRAT EDIT END
=======
	exposed_human.update_body_parts()
>>>>>>> dcd84e1bdc7 (It's 2 am and im having a manic episode so i fixed hair (#69092))

/datum/reagent/medicine/regen_jelly/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustBruteLoss(-1.5 * REM * delta_time, 0)
	M.adjustFireLoss(-1.5 * REM * delta_time, 0)
	M.adjustOxyLoss(-1.5 * REM * delta_time, 0)
	M.adjustToxLoss(-1.5 * REM * delta_time, 0, TRUE) //heals TOXINLOVERs
	..()
	. = TRUE

/datum/reagent/medicine/syndicate_nanites //Used exclusively by Syndicate medical cyborgs
	name = "Restorative Nanites"
	description = "Miniature medical robots that swiftly restore bodily damage."
	reagent_state = SOLID
	color = "#555555"
	overdose_threshold = 30
	ph = 11
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/medicine/syndicate_nanites/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustBruteLoss(-5 * REM * delta_time, 0) //A ton of healing - this is a 50 telecrystal investment.
	M.adjustFireLoss(-5 * REM * delta_time, 0)
	M.adjustOxyLoss(-15 * REM * delta_time, 0)
	M.adjustToxLoss(-5 * REM * delta_time, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -15 * REM * delta_time)
	M.adjustCloneLoss(-3 * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/medicine/syndicate_nanites/overdose_process(mob/living/carbon/M, delta_time, times_fired) //wtb flavortext messages that hint that you're vomitting up robots
	if(DT_PROB(13, delta_time))
		M.reagents.remove_reagent(type, metabolization_rate*15) // ~5 units at a rate of 0.4 but i wanted a nice number in code
		M.vomit(20) // nanite safety protocols make your body expel them to prevent harmies
	..()
	. = TRUE

/datum/reagent/medicine/earthsblood //Created by ambrosia gaia plants
	name = "Earthsblood"
	description = "Ichor from an extremely powerful plant. Great for restoring wounds, but it's a little heavy on the brain. For some strange reason, it also induces temporary pacifism in those who imbibe it and semi-permanent pacifism in those who overdose on it."
	color = "#FFAF00"
	metabolization_rate = REAGENTS_METABOLISM //Math is based on specific metab rate so we want this to be static AKA if define or medicine metab rate changes, we want this to stay until we can rework calculations.
	overdose_threshold = 25
	ph = 11
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 14)

/datum/reagent/medicine/earthsblood/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle <= 25) //10u has to be processed before u get into THE FUN ZONE
		M.adjustBruteLoss(-1 * REM * delta_time, 0)
		M.adjustFireLoss(-1 * REM * delta_time, 0)
		M.adjustOxyLoss(-0.5 * REM * delta_time, 0)
		M.adjustToxLoss(-0.5 * REM * delta_time, 0)
		M.adjustCloneLoss(-0.1 * REM * delta_time, 0)
		M.adjustStaminaLoss(-0.5 * REM * delta_time, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1 * REM * delta_time, 150) //This does, after all, come from ambrosia, and the most powerful ambrosia in existence, at that!
	else
		M.adjustBruteLoss(-5 * REM * delta_time, 0) //slow to start, but very quick healing once it gets going
		M.adjustFireLoss(-5 * REM * delta_time, 0)
		M.adjustOxyLoss(-3 * REM * delta_time, 0)
		M.adjustToxLoss(-3 * REM * delta_time, 0)
		M.adjustCloneLoss(-1 * REM * delta_time, 0)
		M.adjustStaminaLoss(-3 * REM * delta_time, 0)
		M.adjust_timed_status_effect(6 SECONDS * REM * delta_time, /datum/status_effect/jitter, max_duration = 1 MINUTES)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2 * REM * delta_time, 150)
		if(DT_PROB(5, delta_time))
			M.say(pick("Yeah, well, you know, that's just, like, uh, your opinion, man.", "Am I glad he's frozen in there and that we're out here, and that he's the sheriff and that we're frozen out here, and that we're in there, and I just remembered, we're out here. What I wanna know is: Where's the caveman?", "It ain't me, it ain't me...", "Make love, not war!", "Stop, hey, what's that sound? Everybody look what's going down...", "Do you believe in magic in a young girl's heart?"), forced = /datum/reagent/medicine/earthsblood)
	M.adjust_timed_status_effect(20 SECONDS * REM * delta_time, /datum/status_effect/drugginess, max_duration = 30 SECONDS * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/medicine/earthsblood/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_PACIFISM, type)

/datum/reagent/medicine/earthsblood/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_PACIFISM, type)
	..()

/datum/reagent/medicine/earthsblood/overdose_process(mob/living/M, delta_time, times_fired)
	M.hallucination = clamp(M.hallucination + (5 * REM * delta_time), 0, 60)
	if(current_cycle > 25)
		M.adjustToxLoss(4 * REM * delta_time, 0)
		if(current_cycle > 100) //podpeople get out reeeeeeeeeeeeeeeeeeeee
			M.adjustToxLoss(6 * REM * delta_time, 0)
	if(iscarbon(M))
		var/mob/living/carbon/hippie = M
		hippie.gain_trauma(/datum/brain_trauma/severe/pacifism)
	..()
	. = TRUE

/datum/reagent/medicine/haloperidol
	name = "Haloperidol"
	description = "Increases depletion rates for most stimulating/hallucinogenic drugs. Reduces druggy effects and jitteriness. Severe stamina regeneration penalty, causes drowsiness. Small chance of brain damage."
	reagent_state = LIQUID
	color = "#27870a"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	ph = 4.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	harmful = TRUE

/datum/reagent/medicine/haloperidol/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	for(var/datum/reagent/drug/R in M.reagents.reagent_list)
		M.reagents.remove_reagent(R.type, 5 * REM * delta_time)
	M.adjust_drowsyness(2 * REM * delta_time)

	if(M.get_timed_status_effect_duration(/datum/status_effect/jitter) >= 6 SECONDS)
		M.adjust_timed_status_effect(-6 SECONDS * REM * delta_time, /datum/status_effect/jitter)

	if (M.hallucination >= 5)
		M.hallucination -= 5 * REM * delta_time
	if(DT_PROB(10, delta_time))
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1, 50)
	M.adjustStaminaLoss(2.5 * REM * delta_time, 0)
	..()
	return TRUE

//used for changeling's adrenaline power
/datum/reagent/medicine/changelingadrenaline
	name = "Changeling Adrenaline"
	description = "Reduces the duration of unconciousness, knockdown and stuns. Restores stamina, but deals toxin damage when overdosed."
	color = "#C1151D"
	overdose_threshold = 30
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/medicine/changelingadrenaline/on_mob_life(mob/living/carbon/metabolizer, delta_time, times_fired)
	..()
	metabolizer.AdjustAllImmobility(-20 * REM * delta_time)
	metabolizer.adjustStaminaLoss(-10 * REM * delta_time, 0)
	metabolizer.set_timed_status_effect(20 SECONDS * REM * delta_time, /datum/status_effect/jitter, only_if_higher = TRUE)
	metabolizer.set_timed_status_effect(20 SECONDS * REM * delta_time, /datum/status_effect/dizziness, only_if_higher = TRUE)
	return TRUE

/datum/reagent/medicine/changelingadrenaline/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	ADD_TRAIT(L, TRAIT_BATON_RESISTANCE, type)
	L.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)

/datum/reagent/medicine/changelingadrenaline/on_mob_end_metabolize(mob/living/L)
	..()
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_BATON_RESISTANCE, type)
	L.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	L.remove_status_effect(/datum/status_effect/dizziness)
	L.remove_status_effect(/datum/status_effect/jitter)

/datum/reagent/medicine/changelingadrenaline/overdose_process(mob/living/metabolizer, delta_time, times_fired)
	metabolizer.adjustToxLoss(1 * REM * delta_time, 0)
	..()
	return TRUE

/datum/reagent/medicine/changelinghaste
	name = "Changeling Haste"
	description = "Drastically increases movement speed, but deals toxin damage."
	color = "#AE151D"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/medicine/changelinghaste/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/changelinghaste)

/datum/reagent/medicine/changelinghaste/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/changelinghaste)
	..()

/datum/reagent/medicine/changelinghaste/on_mob_life(mob/living/carbon/metabolizer, delta_time, times_fired)
	metabolizer.adjustToxLoss(2 * REM * delta_time, 0)
	..()
	return TRUE

/datum/reagent/medicine/higadrite
	name = "Higadrite"
	description = "A medication utilized to treat ailing livers."
	color = "#FF3542"
	self_consuming = TRUE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/higadrite/on_mob_metabolize(mob/living/M)
	. = ..()
	ADD_TRAIT(M, TRAIT_STABLELIVER, type)

/datum/reagent/medicine/higadrite/on_mob_end_metabolize(mob/living/M)
	..()
	REMOVE_TRAIT(M, TRAIT_STABLELIVER, type)

/datum/reagent/medicine/cordiolis_hepatico
	name = "Cordiolis Hepatico"
	description = "A strange, pitch-black reagent that seems to absorb all light. Effects unknown."
	color = "#000000"
	self_consuming = TRUE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/medicine/cordiolis_hepatico/on_mob_add(mob/living/M)
	..()
	ADD_TRAIT(M, TRAIT_STABLELIVER, type)
	ADD_TRAIT(M, TRAIT_STABLEHEART, type)

/datum/reagent/medicine/cordiolis_hepatico/on_mob_end_metabolize(mob/living/M)
	..()
	REMOVE_TRAIT(M, TRAIT_STABLEHEART, type)
	REMOVE_TRAIT(M, TRAIT_STABLELIVER, type)

/datum/reagent/medicine/muscle_stimulant
	name = "Muscle Stimulant"
	description = "A potent chemical that allows someone under its influence to be at full physical ability even when under massive amounts of pain."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/medicine/muscle_stimulant/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)

/datum/reagent/medicine/muscle_stimulant/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)

/datum/reagent/medicine/modafinil
	name = "Modafinil"
	description = "Long-lasting sleep suppressant that very slightly reduces stun and knockdown times. Overdosing has horrendous side effects and deals lethal oxygen damage, will knock you unconscious if not dealt with."
	reagent_state = LIQUID
	color = "#BEF7D8" // palish blue white
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	overdose_threshold = 20 // with the random effects this might be awesome or might kill you at less than 10u (extensively tested)
	taste_description = "salt" // it actually does taste salty
	var/overdose_progress = 0 // to track overdose progress
	ph = 7.89
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/modafinil/on_mob_metabolize(mob/living/M)
	ADD_TRAIT(M, TRAIT_SLEEPIMMUNE, type)
	..()

/datum/reagent/medicine/modafinil/on_mob_end_metabolize(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, type)
	..()

/datum/reagent/medicine/modafinil/on_mob_life(mob/living/carbon/metabolizer, delta_time, times_fired)
	if(!overdosed) // We do not want any effects on OD
		overdose_threshold = overdose_threshold + ((rand(-10, 10) / 10) * REM * delta_time) // for extra fun
		metabolizer.AdjustAllImmobility(-5 * REM * delta_time)
		metabolizer.adjustStaminaLoss(-0.5 * REM * delta_time, 0)
		metabolizer.set_timed_status_effect(1 SECONDS * REM * delta_time, /datum/status_effect/jitter, only_if_higher = TRUE)
		metabolization_rate = 0.005 * REAGENTS_METABOLISM * rand(5, 20) // randomizes metabolism between 0.02 and 0.08 per second
		. = TRUE
	..()

/datum/reagent/medicine/modafinil/overdose_start(mob/living/M)
	to_chat(M, span_userdanger("You feel awfully out of breath and jittery!"))
	metabolization_rate = 0.025 * REAGENTS_METABOLISM // sets metabolism to 0.005 per second on overdose

/datum/reagent/medicine/modafinil/overdose_process(mob/living/M, delta_time, times_fired)
	overdose_progress++
	switch(overdose_progress)
		if(1 to 40)
			M.adjust_timed_status_effect(2 SECONDS * REM * delta_time, /datum/status_effect/jitter, max_duration = 20 SECONDS)
			M.adjust_timed_status_effect(2 SECONDS * REM * delta_time, /datum/status_effect/speech/stutter, max_duration = 20 SECONDS)
			M.set_timed_status_effect(10 SECONDS * REM * delta_time, /datum/status_effect/dizziness, only_if_higher = TRUE)
			if(DT_PROB(30, delta_time))
				M.losebreath++
		if(41 to 80)
			M.adjustOxyLoss(0.1 * REM * delta_time, 0)
			M.adjustStaminaLoss(0.1 * REM * delta_time, 0)
			M.adjust_timed_status_effect(2 SECONDS * REM * delta_time, /datum/status_effect/jitter, max_duration = 40 SECONDS)
			M.adjust_timed_status_effect(2 SECONDS * REM * delta_time, /datum/status_effect/speech/stutter, max_duration = 40 SECONDS)
			M.set_timed_status_effect(20 SECONDS * REM * delta_time, /datum/status_effect/dizziness, only_if_higher = TRUE)
			if(DT_PROB(30, delta_time))
				M.losebreath++
			if(DT_PROB(10, delta_time))
				to_chat(M, span_userdanger("You have a sudden fit!"))
				M.emote("moan")
				M.Paralyze(20) // you should be in a bad spot at this point unless epipen has been used
		if(81)
			to_chat(M, span_userdanger("You feel too exhausted to continue!")) // at this point you will eventually die unless you get charcoal
			M.adjustOxyLoss(0.1 * REM * delta_time, 0)
			M.adjustStaminaLoss(0.1 * REM * delta_time, 0)
		if(82 to INFINITY)
			REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, type)
			M.Sleeping(100 * REM * delta_time)
			M.adjustOxyLoss(1.5 * REM * delta_time, 0)
			M.adjustStaminaLoss(1.5 * REM * delta_time, 0)
	..()
	return TRUE

/datum/reagent/medicine/psicodine
	name = "Psicodine"
	description = "Suppresses anxiety and other various forms of mental distress. Overdose causes hallucinations and minor toxin damage."
	reagent_state = LIQUID
	color = "#07E79E"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	ph = 9.12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/psicodine/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_FEARLESS, type)

/datum/reagent/medicine/psicodine/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_FEARLESS, type)
	..()

/datum/reagent/medicine/psicodine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_timed_status_effect(-12 SECONDS * REM * delta_time, /datum/status_effect/jitter)
	M.adjust_timed_status_effect(-12 SECONDS * REM * delta_time, /datum/status_effect/dizziness)
	M.adjust_timed_status_effect(-6 SECONDS * REM * delta_time, /datum/status_effect/confusion)
	M.disgust = max(M.disgust - (6 * REM * delta_time), 0)
	if(M.mob_mood != null && M.mob_mood.sanity <= SANITY_NEUTRAL) // only take effect if in negative sanity and then...
		M.mob_mood.set_sanity(min(M.mob_mood.sanity + (5 * REM * delta_time), SANITY_NEUTRAL)) // set minimum to prevent unwanted spiking over neutral
	..()
	. = TRUE

/datum/reagent/medicine/psicodine/overdose_process(mob/living/M, delta_time, times_fired)
	M.hallucination = clamp(M.hallucination + (5 * REM * delta_time), 0, 60)
	M.adjustToxLoss(1 * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/medicine/metafactor
	name = "Mitogen Metabolism Factor"
	description = "This enzyme catalyzes the conversion of nutricious food into healing peptides."
	metabolization_rate = 0.0625  * REAGENTS_METABOLISM //slow metabolism rate so the patient can self heal with food even after the troph has metabolized away for amazing reagent efficency.
	reagent_state = SOLID
	color = "#FFBE00"
	overdose_threshold = 10
	inverse_chem_val = 0.1 //Shouldn't happen - but this is so looking up the chem will point to the failed type
	inverse_chem = /datum/reagent/impurity/probital_failed
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/metafactor/overdose_start(mob/living/carbon/M)
	metabolization_rate = 2  * REAGENTS_METABOLISM

/datum/reagent/medicine/metafactor/overdose_process(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(13, delta_time))
		M.vomit()
	..()

/datum/reagent/medicine/silibinin
	name = "Silibinin"
	description = "A thistle derrived hepatoprotective flavolignan mixture that help reverse damage to the liver."
	reagent_state = SOLID
	color = "#FFFFD0"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/silibinin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustOrganLoss(ORGAN_SLOT_LIVER, -2 * REM * delta_time)//Add a chance to cure liver trauma once implemented.
	..()
	. = TRUE

/datum/reagent/medicine/polypyr  //This is intended to be an ingredient in advanced chems.
	name = "Polypyrylium Oligomers"
	description = "A purple mixture of short polyelectrolyte chains not easily synthesized in the laboratory. It is valued as an intermediate in the synthesis of the cutting edge pharmaceuticals."
	reagent_state = SOLID
	color = "#9423FF"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 50
	taste_description = "numbing bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/polypyr/on_mob_life(mob/living/carbon/M, delta_time, times_fired) //I wanted a collection of small positive effects, this is as hard to obtain as coniine after all.
	. = ..()
	M.adjustOrganLoss(ORGAN_SLOT_LUNGS, -0.25 * REM * delta_time)
	M.adjustBruteLoss(-0.35 * REM * delta_time, 0)
	return TRUE

/datum/reagent/medicine/polypyr/expose_mob(mob/living/carbon/human/exposed_human, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_human) || (reac_volume < 0.5))
		return
	exposed_human.hair_color = "#9922ff"
	exposed_human.facial_hair_color = "#9922ff"
	exposed_human.update_body_parts()

/datum/reagent/medicine/polypyr/overdose_process(mob/living/M, delta_time, times_fired)
	M.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.5 * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/medicine/granibitaluri
	name = "Granibitaluri" //achieve "GRANular" amounts of C2
	description = "A mild painkiller useful as an additive alongside more potent medicines. Speeds up the healing of small wounds and burns, but is ineffective at treating severe injuries. Extremely large doses are toxic, and may eventually cause liver failure."
	color = "#E0E0E0"
	reagent_state = LIQUID
	overdose_threshold = 50
	metabolization_rate = 0.5 * REAGENTS_METABOLISM //same as C2s
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/granibitaluri/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/healamount = max(0.5 - round(0.01 * (M.getBruteLoss() + M.getFireLoss()), 0.1), 0) //base of 0.5 healing per cycle and loses 0.1 healing for every 10 combined brute/burn damage you have
	M.adjustBruteLoss(-healamount * REM * delta_time, 0)
	M.adjustFireLoss(-healamount * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/medicine/granibitaluri/overdose_process(mob/living/M, delta_time, times_fired)
	. = TRUE
	M.adjustOrganLoss(ORGAN_SLOT_LIVER, 0.2 * REM * delta_time)
	M.adjustToxLoss(0.2 * REM * delta_time, FALSE) //Only really deadly if you eat over 100u
	..()

// helps bleeding wounds clot faster
/datum/reagent/medicine/coagulant
	name = "Sanguirite"
	description = "A proprietary coagulant used to help bleeding wounds clot faster."
	reagent_state = LIQUID
	color = "#bb2424"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 20
	/// The bloodiest wound that the patient has will have its blood_flow reduced by about half this much each second
	var/clot_rate = 0.3
	/// While this reagent is in our bloodstream, we reduce all bleeding by this factor
	var/passive_bleed_modifier = 0.7
	/// For tracking when we tell the person we're no longer bleeding
	var/was_working
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/coagulant/on_mob_metabolize(mob/living/M)
	ADD_TRAIT(M, TRAIT_COAGULATING, /datum/reagent/medicine/coagulant)

	if(ishuman(M))
		var/mob/living/carbon/human/blood_boy = M
		blood_boy.physiology?.bleed_mod *= passive_bleed_modifier

	return ..()

/datum/reagent/medicine/coagulant/on_mob_end_metabolize(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_COAGULATING, /datum/reagent/medicine/coagulant)

	if(was_working)
		to_chat(M, span_warning("The medicine thickening your blood loses its effect!"))
	if(ishuman(M))
		var/mob/living/carbon/human/blood_boy = M
		blood_boy.physiology?.bleed_mod /= passive_bleed_modifier

	return ..()

/datum/reagent/medicine/coagulant/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = ..()
	if(!M.blood_volume || !M.all_wounds)
		return

	var/datum/wound/bloodiest_wound

	for(var/i in M.all_wounds)
		var/datum/wound/iter_wound = i
		if(iter_wound.blood_flow)
			if(iter_wound.blood_flow > bloodiest_wound?.blood_flow)
				bloodiest_wound = iter_wound

	if(bloodiest_wound)
		if(!was_working)
			to_chat(M, span_green("You can feel your flowing blood start thickening!"))
			was_working = TRUE
		bloodiest_wound.adjust_blood_flow(-clot_rate * REM * delta_time)
	else if(was_working)
		was_working = FALSE

/datum/reagent/medicine/coagulant/overdose_process(mob/living/M, delta_time, times_fired)
	. = ..()
	if(!M.blood_volume)
		return

	if(DT_PROB(7.5, delta_time))
		M.losebreath += rand(2, 4)
		M.adjustOxyLoss(rand(1, 3))
		if(prob(30))
			to_chat(M, span_danger("You can feel your blood clotting up in your veins!"))
		else if(prob(10))
			to_chat(M, span_userdanger("You feel like your blood has stopped moving!"))
			M.adjustOxyLoss(rand(3, 4))

		if(prob(50))
			var/obj/item/organ/internal/lungs/our_lungs = M.getorganslot(ORGAN_SLOT_LUNGS)
			our_lungs.applyOrganDamage(1)
		else
			var/obj/item/organ/internal/heart/our_heart = M.getorganslot(ORGAN_SLOT_HEART)
			our_heart.applyOrganDamage(1)

// i googled "natural coagulant" and a couple of results came up for banana peels, so after precisely 30 more seconds of research, i now dub grinding banana peels good for your blood
/datum/reagent/medicine/coagulant/banana_peel
	name = "Pulped Banana Peel"
	description = "Ancient Clown Lore says that pulped banana peels are good for your blood, but are you really going to take medical advice from a clown about bananas?"
	color = "#50531a" // rgb: 175, 175, 0
	taste_description = "horribly stringy, bitter pulp"
	glass_name = "glass of banana peel pulp"
	glass_desc = "Ancient Clown Lore says that pulped banana peels are good for your blood, but are you really going to take medical advice from a clown about bananas?"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	clot_rate = 0.2
	passive_bleed_modifier = 0.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/coagulant/seraka_extract
	name = "Seraka Extract"
	description = "A deeply coloured oil present in small amounts in Seraka Mushrooms. Acts as an effective blood clotting agent, but has a low overdose threshold."
	color = "#00767C"
	taste_description = "intensely savoury bitterness"
	glass_name = "glass of seraka extract"
	glass_desc = "Deeply savoury, bitter, and makes your blood clot up in your veins. A great drink, all things considered."
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	clot_rate = 0.4 //slightly better than regular coagulant
	passive_bleed_modifier = 0.5
	overdose_threshold = 10 //but easier to overdose on
