/datum/preferences/proc/load_character_skyrat(savefile/S)

	READ_FILE(S["loadout_list"], loadout_list)

	READ_FILE(S["augments"] , augments)
	READ_FILE(S["augment_limb_styles"] , augment_limb_styles)

	augments = SANITIZE_LIST(augments)
	//validating augments
	for(var/aug_slot in augments)
		var/datum/augment_item/aug = GLOB.augment_items[augments[aug_slot]]
		if(!aug)
			augments -= aug_slot
	augment_limb_styles = SANITIZE_LIST(augment_limb_styles)
	//validating limb styles
	for(var/key in augment_limb_styles)
		if(!GLOB.robotic_styles_list[key])
			augment_limb_styles -= key

	READ_FILE(S["features"], features)
	READ_FILE(S["mutant_bodyparts"], mutant_bodyparts)
	READ_FILE(S["body_markings"], body_markings)


/datum/preferences/proc/save_character_skyrat(savefile/S)

	WRITE_FILE(S["loadout_list"], loadout_list)
	WRITE_FILE(S["augments"] , augments)
	WRITE_FILE(S["augment_limb_styles"] , augment_limb_styles)
	WRITE_FILE(S["features"] , features)
	WRITE_FILE(S["mutant_bodyparts"] , mutant_bodyparts)
	WRITE_FILE(S["body_markings"] , body_markings)
