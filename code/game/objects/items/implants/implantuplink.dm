/obj/item/implant/uplink
	name = "uplink implant"
	desc = "Sneeki breeki."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	var/starting_tc = 0

/obj/item/implant/uplink/Initialize(mapload, _owner)
	. = ..()
	AddComponent(/datum/component/uplink, _owner, TRUE, FALSE, null, starting_tc)
	RegisterSignal(src, COMSIG_COMPONENT_REMOVING, .proc/_component_removal)

/**
 * Proc called when component is removed; ie. uplink component
 *
 * Callback catching if the underlying uplink component has been removed,
 * generally by admin verbs or var editing. Implant does nothing without
 * the component, so delete itself.
 */
/obj/item/implant/uplink/proc/_component_removal(datum/source, datum/component/component)
	if(istype(component, /datum/component/uplink))
		qdel(src)

/obj/item/implanter/uplink
	name = "implanter" // Skyrat edit , original was implanter (uplink)
	imp_type = /obj/item/implant/uplink
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // Skyrat edit
	special_desc = "A Syndicate implanter for an uplink" // Skyrat edit

/obj/item/implanter/uplink/precharged
	name = "implanter" // Skyrat edit , original was implanter (precharged uplink)
	imp_type = /obj/item/implant/uplink/precharged
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // Skyrat edit
	special_desc = "A Syndicate implanter for a precharged uplink" // Skyrat edit

/obj/item/implant/uplink/precharged
	starting_tc = TELECRYSTALS_PRELOADED_IMPLANT

/obj/item/implant/uplink/starting
	starting_tc = TELECRYSTALS_DEFAULT - UPLINK_IMPLANT_TELECRYSTAL_COST
