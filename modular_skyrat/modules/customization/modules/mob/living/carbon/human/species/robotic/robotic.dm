/datum/species/robotic
	name = "Synthetic Humanoid"
	id = SPECIES_SYNTH
	say_mod = "beeps"
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	inherent_traits = list(
		TRAIT_CAN_STRIP,
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCLONELOSS,
		TRAIT_GENELESS,
		TRAIT_STABLEHEART,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NO_HUSK,
		TRAIT_OXYIMMUNE,
		TRAIT_LITERATE,
	)
	mutant_bodyparts = list()
	default_mutant_bodyparts = list(
		"tail" = "None",
		"snout" = "None",
		"ears" = "None",
		"wings" = "None",
		"taur" = "None",
		"horns" = "None",
		MUTANT_SYNTH_ANTENNA = ACC_RANDOM,
		MUTANT_SYNTH_SCREEN = "None",
		MUTANT_SYNTH_CHASSIS = "None",
		MUTANT_SYNTH_HEAD = "None",
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	reagent_flags = PROCESS_SYNTHETIC
	burnmod = 1.3 // Every 0.1% is 10% above the base.
	brutemod = 1.3
	coldmod = 1.2
	heatmod = 2
	siemens_coeff = 1.4 //Not more because some shocks will outright crit you, which is very unfun
	payday_modifier = 0.75 // Matches the rest of the pay penalties the non-human crew have
	species_language_holder = /datum/language_holder/machine
	mutant_organs = list(/obj/item/organ/internal/cyberimp/arm/power_cord)
	mutantbrain = /obj/item/organ/internal/brain/ipc_positron
	mutantstomach = /obj/item/organ/internal/stomach/synth
	mutantears = /obj/item/organ/internal/ears/synth
	mutanttongue = /obj/item/organ/internal/tongue/synth
	mutanteyes = /obj/item/organ/internal/eyes/synth
	mutantlungs = /obj/item/organ/internal/lungs/synth
	mutantheart = /obj/item/organ/internal/heart/synth
	mutantliver = /obj/item/organ/internal/liver/synth
	exotic_blood = /datum/reagent/fuel/oil
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/synth,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/synth,
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/robot/synth,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/robot/synth,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/robot/synth,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/robot/synth,
	)
	var/datum/action/innate/monitor_change/screen
	var/saved_screen = "Blank"

/datum/species/robotic/spec_life(mob/living/carbon/human/H)
	if(H.stat == SOFT_CRIT || H.stat == HARD_CRIT)
		H.adjustFireLoss(1) //Still deal some damage in case a cold environment would be preventing us from the sweet release to robot heaven
		H.adjust_bodytemperature(13) //We're overheating!!
		if(prob(10))
			to_chat(H, span_warning("Alert: Critical damage taken! Cooling systems failing!"))
			do_sparks(3, TRUE, H)

/datum/species/robotic/spec_revival(mob/living/carbon/human/transformer)
	switch_to_screen(transformer, "Console")
	addtimer(CALLBACK(src, .proc/switch_to_screen, transformer, saved_screen), 5 SECONDS)
	playsound(transformer.loc, 'sound/machines/chime.ogg', 50, TRUE)
	transformer.visible_message(span_notice("[transformer]'s [screen ? "monitor lights up" : "eyes flicker to life"]!"), span_notice("All systems nominal. You're back online!"))

/datum/species/robotic/spec_death(gibbed, mob/living/carbon/human/transformer)
	. = ..()
	saved_screen = screen
	switch_to_screen(transformer, "BSOD")
	addtimer(CALLBACK(src, .proc/switch_to_screen, transformer, "Blank"), 5 SECONDS)

/datum/species/robotic/on_species_gain(mob/living/carbon/human/transformer)
	. = ..()
	var/obj/item/organ/internal/appendix/appendix = transformer.getorganslot(ORGAN_SLOT_APPENDIX)
	if(appendix)
		appendix.Remove(transformer)
		qdel(appendix)

	if(!screen && transformer.dna.mutant_bodyparts[MUTANT_SYNTH_SCREEN][MUTANT_INDEX_NAME] != "None")
		screen = new
		screen.Grant(transformer)

	var/chassis = transformer.dna.mutant_bodyparts[MUTANT_SYNTH_CHASSIS]
	var/head = transformer.dna.mutant_bodyparts[MUTANT_SYNTH_HEAD]
	if(!chassis && !head)
		return

	var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = GLOB.sprite_accessories[MUTANT_SYNTH_CHASSIS][chassis["name"]]
	var/datum/sprite_accessory/ipc_head/head_of_choice = GLOB.sprite_accessories[MUTANT_SYNTH_HEAD][head["name"]]
	if(chassis_of_choice || head_of_choice)
		examine_limb_id = chassis_of_choice?.icon_state ? chassis_of_choice.icon_state : head_of_choice.icon_state
		// We want to ensure that the IPC gets their chassis and their head correctly.
		for(var/obj/item/bodypart/limb as anything in transformer.bodyparts)
			if(chassis && limb.body_part == CHEST)
				limb.change_appearance(chassis_of_choice.icon, chassis_of_choice.icon_state, chassis_of_choice.color_src)
				continue

			if(head && limb.body_part == HEAD)
				limb.change_appearance(head_of_choice.icon, head_of_choice.icon_state, head_of_choice.color_src)

		if(chassis_of_choice.color_src)
			species_traits += MUTCOLORS
		transformer.update_body()

/datum/species/robotic/on_species_loss(mob/living/carbon/human/C)
	. = ..()
	if(screen)
		screen.Remove(C)

/**
 * Simple proc to switch the screen of a monitor-enabled synth, while updating their appearance.
 *
 * Arguments:
 * * transformer - The human that will be affected by the screen change (read: IPC).
 * * screen_name - The name of the screen to switch the ipc_screen mutant bodypart to.
 */
/datum/species/robotic/proc/switch_to_screen(mob/living/carbon/human/tranformer, screen_name)
	tranformer.dna.mutant_bodyparts[MUTANT_SYNTH_SCREEN][MUTANT_INDEX_NAME] = screen_name
	tranformer.update_body()

/datum/species/robotic/random_name(gender, unique, lastname)
	var/randname = pick(GLOB.posibrain_names)
	randname = "[randname]-[rand(100, 999)]"
	return randname

/datum/species/robotic/get_types_to_preload()
	return ..() - typesof(/obj/item/organ/internal/cyberimp/arm/power_cord) // Don't cache things that lead to hard deletions.

/datum/species/robotic/replace_body(mob/living/carbon/target, datum/species/new_species)
	..()
	var/chassis = target.dna.mutant_bodyparts[MUTANT_SYNTH_CHASSIS]
	if(!chassis)
		return
	var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = GLOB.sprite_accessories[MUTANT_SYNTH_CHASSIS][chassis["name"]]

	for(var/obj/item/bodypart/iterating_bodypart as anything in target.bodyparts) //Override bodypart data as necessary
		if(chassis_of_choice.color_src)
			iterating_bodypart.should_draw_greyscale = TRUE
			iterating_bodypart.species_color = target.dna?.features["mcolor"]
		iterating_bodypart.limb_id = chassis_of_choice.icon_state
		iterating_bodypart.name = "\improper[chassis_of_choice.name] [parse_zone(iterating_bodypart.body_zone)]"
		iterating_bodypart.update_limb()

// Not sure about this one.
/*
/datum/species/robotic/randomize_features(mob/living/carbon/human/human_mob)
	var/main_color
	var/second_color
	var/third_color
	var/random = rand(1,7)
	switch(random)
		if(1)
			main_color = "#FFFFFF"
			second_color = "#333333"
			third_color = "#333333"
		if(2)
			main_color = "#FFFFDD"
			second_color = "#DD6611"
			third_color = "#AA5522"
		if(3)
			main_color = "#DD6611"
			second_color = "#FFFFFF"
			third_color = "#DD6611"
		if(4)
			main_color = "#CCCCCC"
			second_color = "#FFFFFF"
			third_color = "#FFFFFF"
		if(5)
			main_color = "#AA5522"
			second_color = "#CC8833"
			third_color = "#FFFFFF"
		if(6)
			main_color = "#FFFFDD"
			second_color = "#FFEECC"
			third_color = "#FFDDBB"
		if(7) //Oh no you've rolled the sparkle dog
			main_color = "#[random_color()]"
			second_color = "#[random_color()]"
			third_color = "#[random_color()]"
	human_mob.dna.features["mcolor"] = main_color
	human_mob.dna.features["mcolor2"] = second_color
	human_mob.dna.features["mcolor3"] = third_color
*/
