/obj/item/card/id/advanced/centcom/ert/nri
	name = "\improper NRI ID"
	desc = "An ID straight from the NRI."
	icon_state = "card_black"
	worn_icon_state = "card_black"
	assigned_icon_state = "assigned_centcom"

/datum/id_trim/nri
	assignment = "NRI Soldier"
	trim_icon = 'modular_skyrat/master_files/icons/obj/card.dmi'
	trim_state = "trim_nri"
	sechud_icon_state = "hud_nri"

/datum/id_trim/nri/New()
	. = ..()
	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))


/datum/id_trim/nri/commander
	assignment = "NRI Platoon Commander"
	trim_state = "trim_nri_commander"
	sechud_icon_state = "hud_nri_commander"

/datum/id_trim/nri/heavy
	assignment = "NRI Heavy Soldier"

/datum/id_trim/nri/medic
	assignment = "NRI Corpsman"

/datum/id_trim/nri/engineer
	assignment = "NRI Combat Engineer"

/datum/id_trim/nri/diplomat
	assignment = "NRI Diplomat"
	trim_state = "trim_nri_commander"
	sechud_icon_state = "hud_nri_commander"

/datum/id_trim/nri/diplomat/major
	assignment = "NRI Major"

/datum/id_trim/nri/diplomat/scientist
	assignment = "NRI Research Inspector"

/datum/id_trim/nri/diplomat/doctor
	assignment = "NRI Medical Inspector"
