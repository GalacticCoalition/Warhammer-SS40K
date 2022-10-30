///NIFSoft Remover. This is mostly here so that security and antags have a way to remove NIFSofts from someome
/obj/item/nifsoft_remover
	name = "Lopland 'Wrangler' NIF-Cutter"
	desc = "Given the relatively recent and sudden proliferation of NIFs, their use in crime both petty and organized has skyrocketed in recent years. The existence of nanomachine-based real-time burst communication that cannot be effectively monitored or hacked into has given most PMCs cause enough for concern to invent their own devices. This one is a 'Wrangler' model NIF-Cutter, used for crudely wiping programs directly off a user's Framework.."
	icon = 'modular_skyrat/modules/modular_implants/icons/obj/devices.dmi'
	icon_state = "nifsoft_remover"

	///Is a disk with the corresponding NIFSoft created when said NIFSoft is removed?
	var/create_disk = FALSE

/obj/item/nifsoft_remover/attack(mob/living/carbon/human/target_mob, mob/living/user)
	. = ..()
	var/obj/item/organ/internal/cyberimp/brain/nif/target_nif = target_mob.installed_nif

	if(!target_nif || !length(target_nif.loaded_nifsofts))
		to_chat(user, span_warning("[user] does not posses a NIF with any installed NIFSofts"))
		return

	var/list/installed_nifsofts = target_nif.loaded_nifsofts
	var/datum/nifsoft/nifsoft_to_remove = tgui_input_list(user, "Chose a NIFSoft to remove", "[src]", installed_nifsofts)

	if(!nifsoft_to_remove)
		return FALSE

	user.visible_message(span_warning("[user] starts to use the [src] on [target_mob]"), span_notice("You start to use the [src] on [target_mob]"))
	if(!do_after(user, 5 SECONDS, target_mob))
		return FALSE

	if(!target_nif.remove_nifsoft(nifsoft_to_remove))
		return FALSE

	to_chat(user, span_notice("You successfully remove the [nifsoft_to_remove.name]"))
	user.log_message("[user] removed [nifsoft_to_remove.name] from [target_mob]",LOG_GAME)

	if(create_disk)
		var/obj/item/disk/nifsoft_uploader/new_disk = new /obj/item/disk/nifsoft_uploader
		new_disk.loaded_nifsoft = nifsoft_to_remove.type
		new_disk.name = "[nifsoft_to_remove] datadisk"

		user.put_in_hands(new_disk)

	qdel(nifsoft_to_remove)

	return TRUE

/obj/item/nifsoft_remover/syndie
	name = "Cybersun 'Scalpel' NIF-Cutter"
	desc = "In the upper echelons of the Corporate world, Nanite Implant Frameworks are everywhere. Valuable targets will almost always be in constant NIF communication with at least one or two points of contact in the event of an emergency. To bypass this unfortunate conundrum, Cybersun Industries invented the 'Scalpel' NIF-Cutter. A device no larger than a PDA, this gift to the field of neurological theft is capable of extracting specific programs from a target in five seconds or less. On top of that, high-grade programming allows for the tool to copy the specific 'soft to a disk for the wielder's own use."
	icon_state =  "nifsoft_remover_syndie"

	create_disk = TRUE

/datum/design/nifsoft_remover
	name = "Lopland 'Wrangler' NIF-Cutter"
	desc = "A small device that lets the user remove NIFSofts from a NIF user"
	id = "nifsoft_remover"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/nifsoft_remover
	materials = list(/datum/material/iron = 200, /datum/material/silver = 500, /datum/material/uranium = 500)
	category = list(RND_CATEGORY_EQUIPMENT)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/uplink_item/device_tools/nifsoft_remover
	name = "Cybersun 'Scalpel' NIF-Cutter"
	desc = "A modified version of a NIFSoft remover that allows the user to remove a NIFSoft and have a blank copy of the removed NIFSoft saved to a disk"
	item = /obj/item/nifsoft_remover/syndie
	cost = 3

///NIF Repair Kit.
/obj/item/nif_repair_kit
	name = "Cerulean NIF Regenerator"
	desc = "The effects of capitalism and industry run deep, and they run within the Nanite Implant Framework industry as well. Frameworks, complicated devices as they are, are normally locked at the firmware level to requiring specific 'approved' brands of repair paste or repair-docks. This hacked-kit has been developed by the Altspace Coven as a freeware alternative, spread far and wide throughout extra-Solarian space for quality of life for users located on the peripheries of society." //Placeholder
	icon = 'modular_skyrat/modules/modular_implants/icons/obj/devices.dmi'
	icon_state = "repair_paste"
	w_class = WEIGHT_CLASS_SMALL
	///How much does this repair each time it is used?
	var/repair_amount = 20
	///How many times can this be used?
	var/uses = 5

/obj/item/nif_repair_kit/attack(mob/living/carbon/human/mob_to_repair, mob/living/user)
	. = ..()
	if(!mob_to_repair.installed_nif)
		to_chat(user, span_warning("[mob_to_repair] lacks a NIF"))

	if(!do_after(user, 5 SECONDS, mob_to_repair))
		return FALSE

	if(!mob_to_repair.installed_nif.repair_nif(repair_amount))
		to_chat(user, span_warning("The NIF you are trying to repair is already at max durbility"))
		return FALSE

	to_chat(user, span_notice("You successfully repair [mob_to_repair]'s NIF"))
	to_chat(mob_to_repair, span_notice("[user] successfully repairs your NIF"))

	--uses
	if(!uses)
		qdel(src)

