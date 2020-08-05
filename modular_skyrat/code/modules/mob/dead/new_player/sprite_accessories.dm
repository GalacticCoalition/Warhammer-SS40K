/datum/sprite_accessory
	///Unique key of an accessroy. All tails should have "tail", ears "ears" etc.
	var/key = null
	///If an accessory is special, it wont get included in the normal accessory lists
	var/special = FALSE
	var/list/recommended_species
	///Which color we default to on acquisition of the accessory (such as switching species, default color for character customization etc)
	///You can also put down a a HEX color, to be used instead as the default
	var/default_color = DEFAULT_PRIMARY
	///Set this to a name, then the accessory will be shown in preferences, if a species can have it. Most accessories have this
	///Notable things that have it set to FALSE are things that need special setup, such as genitals
	var/generic

	var/skip_type = /datum/sprite_accessory

	color_src = USE_ONE_COLOR

	var/extra = FALSE
	var/extra_color_src
	var/extra2 = FALSE
	var/extra2_color_src
	//TODO: Add a factual variable for sprite accessories that shouldn't be imprinted on the species mutant bodyparts, but still stay in DNA
	//That would be useful for making sure no weird stuff happens with sprite accessories that are associated with organs
	//Due to the lack of it, possibly making "Empty" mutant bodyparts, if a specie can have it, but the preference is chosen to "None"

/datum/sprite_accessory/proc/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/BP)
	return FALSE

/datum/sprite_accessory/proc/get_default_color(var/list/features) //Needs features for the color information
	if(color_src != USE_ONE_COLOR && color_src != USE_MATRIXED_COLORS) //We're not using a custom color key, return white
		return list("FFF")
	var/list/colors
	switch(default_color)
		if(DEFAULT_PRIMARY)
			colors = list(features["mcolor"])
		if(DEFAULT_SECONDARY)
			colors = list(features["mcolor2"])
		if(DEFAULT_TERTIARY)
			colors = list(features["mcolor3"])
		if(DEFAULT_MATRIXED)
			colors = list(features["mcolor"], features["mcolor2"], features["mcolor3"])
		else
			colors = default_color

	//Someone set up an accessory wrong. Lets do a fallback
	if(color_src == USE_ONE_COLOR && colors.len != 1)
		colors = list("FFF")
	if(color_src == USE_MATRIXED_COLORS && colors.len != 3)
		colors = list("FFF", "FFF", "FFF")
	return colors

/datum/sprite_accessory/moth_wings
	key = "moth_wings"
	skip_type = /datum/sprite_accessory/moth_wings

/datum/sprite_accessory/moth_wings/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if((H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(H.dna.species, H.wear_suit.species_exception))))
		return TRUE
	return FALSE

/datum/sprite_accessory/moth_markings
	key = "moth_markings"
	generic = "Moth markings"
	skip_type = /datum/sprite_accessory/moth_markings

/datum/sprite_accessory/spines
	key = "spines"
	generic = "Spines"
	skip_type = /datum/sprite_accessory/spines

/datum/sprite_accessory/spines/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
		return TRUE
	return FALSE

/datum/sprite_accessory/caps
	key = "caps"
	generic = "Caps"
	skip_type = /datum/sprite_accessory/caps

/datum/sprite_accessory/frills
	key = "frills"
	generic = "Frills"
	skip_type = /datum/sprite_accessory/frills

/datum/sprite_accessory/frills/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.head && (H.head.flags_inv & HIDEEARS) || !HD || HD.status == BODYPART_ROBOTIC)
		return TRUE
	return FALSE

/datum/sprite_accessory/horns
	key = "horns"
	generic = "Horns"
	skip_type = /datum/sprite_accessory/horns

/datum/sprite_accessory/horns/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
		return TRUE
	return FALSE

/datum/sprite_accessory/ears
	key = "ears"
	generic = "Ears"
	skip_type = /datum/sprite_accessory/ears

/datum/sprite_accessory/ears/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
		return TRUE
	return FALSE

/datum/sprite_accessory/snouts
	key = "snout"
	generic = "Snout"
	skip_type = /datum/sprite_accessory/snouts

/datum/sprite_accessory/snouts/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)) || !HD || HD.status == BODYPART_ROBOTIC)
		return TRUE
	return FALSE

/datum/sprite_accessory/tails
	key = "tail"
	generic = "Tail"
	skip_type = /datum/sprite_accessory/tails

/datum/sprite_accessory/tails/lizard
	recommended_species = list("lizard", "ashwalker")

/datum/sprite_accessory/tails/human
	recommended_species = list("human", "felinid")

/datum/sprite_accessory/tails/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
		return TRUE
	return FALSE

/datum/sprite_accessory/body_markings
	key = "body_markings"
	generic = "Body Markings"
	skip_type = /datum/sprite_accessory/body_markings

/datum/sprite_accessory/legs
	key = "legs"
	generic = "Leg Type"
	skip_type = /datum/sprite_accessory/legs
	color_src = null
