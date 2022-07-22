///Saves the NIF data for everyone inside of the server.
/datum/controller/subsystem/persistence/proc/save_nifs()
	for(var/i in GLOB.joined_player_list)
		var/mob/living/carbon/human/ending_human = get_mob_by_ckey(i)
		if(!istype(ending_human) || !ending_human.mind?.original_character_slot_index)
			continue

		var/mob/living/carbon/human/original_human = ending_human.mind.original_character.resolve()

		if(!original_human)
			continue

		original_human.save_nif_data()

///Saves the NIF data for a individual user.
/mob/living/carbon/human/proc/save_nif_data()
	if(!ckey || !mind?.original_character_slot_index)
		return

	var/path = "data/player_saves/[ckey[1]]/[ckey]/nif.sav"
	var/savefile/save = new /savefile(path)

	if(!installed_nif)
		WRITE_FILE(save["nif_path"], FALSE)
		return

	var/nif_path = installed_nif.type

	WRITE_FILE(save["nif_path"], nif_path)
	WRITE_FILE(save["nif_durability"], installed_nif.durability)
	WRITE_FILE(save["saved_nif_theme"], installed_nif.current_theme)

///Loads the NIF data for an individual user.
/mob/living/carbon/human/proc/load_nif_data()
	if(!ckey || !mind?.original_character_slot_index)
		return

	var/path = "data/player_saves/[ckey[1]]/[ckey]/nif.sav"
	var/savefile/save = new /savefile(path)

	var/nif_path
	READ_FILE(save["nif_path"], nif_path)

	if(!nif_path)
		return

	/obj/item/organ/internal/cyberimp/brain/nif
	var/obj/item/organ/internal/cyberimp/brain/nif/new_nif = new nif_path
	new_nif.Insert(src)

	new_nif.durability = save["nif_durability"]
	new_nif.current_theme = save["saved_nif_theme"]
