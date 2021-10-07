//THIS FILE HAS BEEN EDITED BY SKYRAT EDIT

/datum/preference/color_legacy/underwear_color
	savefile_key = "underwear_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES

/datum/preference/color_legacy/underwear_color/apply_to_human(mob/living/carbon/human/target, value)
	target.underwear_color = value

/datum/preference/color_legacy/underwear_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)

//SKYRAT EDIT ADDITION BEGIN - Colorable Undershirt/Socks
/datum/preference/color_legacy/undershirt_color
	savefile_key = "undershirt_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES

/datum/preference/color_legacy/undershirt_color/apply_to_human(mob/living/carbon/human/target, value)
	target.undershirt_color = value

/datum/preference/color_legacy/undershirt_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)

/datum/preference/color_legacy/socks_color
	savefile_key = "socks_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES

/datum/preference/color_legacy/socks_color/apply_to_human(mob/living/carbon/human/target, value)
	target.socks_color = value

/datum/preference/color_legacy/socks_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)
//SKYRAT EDIT ADDITION END - Colorable Undershirt/Socks
