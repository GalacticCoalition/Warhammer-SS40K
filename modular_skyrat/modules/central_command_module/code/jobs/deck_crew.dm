
/datum/job/deck_crew
	title = "Deck Crewman"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Fleet Admiral", "Bridge Officer")
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	supervisors = "Fleet Admiral"
	selection_color = "#6969f8"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 6000
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_NANOTRASEN_FLEET_COMMAND
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/deck_crew
	plasmaman_outfit = /datum/outfit/plasmaman/centcom_official

	paycheck = PAYCHECK_NANOTRASEN_FLEET_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_DECK_CREW
	departments_list = list(
		/datum/job_department/nanotrasen_fleet_command,
		)

	family_heirlooms = list(/obj/item/wrench)

	mail_goodies = list(
		/obj/item/wrench/combat,
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE

	veteran_only = TRUE

/datum/outfit/job/deck_crew
	name = "Deck Crewman"

	jobtype = /datum/job/deck_crew

	implants = list(/obj/item/implant/mindshield)

	id = /obj/item/card/id/advanced/centcom
	belt = /obj/item/pda/nanotrasen_representative
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/headset_cent/alt_with_Key
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/utility/eng
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/soft/enclave
	back = /obj/item/storage/backpack/satchel/leather

	implants = list(/obj/item/implant/mindshield)

	id_trim = /datum/id_trim/centcom/deck_crew

/datum/id_trim/centcom/deck_crew
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	assignment = "Deck Crewman"

/obj/effect/landmark/start/deck_crew
	name = "Deck Crewman"
	icon_state = "Captain"
	delete_after_roundstart = FALSE
	jobspawn_override = TRUE
