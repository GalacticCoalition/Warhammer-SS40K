/datum/job/research_director
	title = "Research Director"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Captain")
	head_announce = list("Science")
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddff"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_required_type_department = EXP_TYPE_SCIENCE
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/rd
	plasmaman_outfit = /datum/outfit/plasmaman/research_director
	departments_list = list(
		/datum/job_department/science,
		/datum/job_department/command,
		)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SCI

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_RESEARCH_DIRECTOR
	bounty_types = CIV_JOB_SCI

	mail_goodies = list(
		/obj/item/storage/box/monkeycubes = 30,
		/obj/item/circuitboard/machine/sleeper/party = 3,
		/obj/item/borg/upgrade/ai = 2
	)

	family_heirlooms = list(/obj/item/toy/plush/slimeplushie)
	rpg_title = "Archmagister"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_BOLD_SELECT_TEXT | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS

	voice_of_god_power = 1.4 //Command staff has authority


/datum/job/research_director/get_captaincy_announcement(mob/living/captain)
	return "Due to staffing shortages, newly promoted Acting Captain [captain.real_name] on deck!"


/datum/outfit/job/rd
	name = "Research Director"
	jobtype = /datum/job/research_director

	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/job/research_director
	uniform = /obj/item/clothing/under/rank/rnd/research_director
	suit = /obj/item/clothing/suit/toggle/labcoat
	backpack_contents = list(
		/obj/item/melee/baton/telescopic = 1,
		/obj/item/modular_computer/tablet/preset/advanced/command = 1,
		)
	belt = /obj/item/pda/heads/rd
	ears = /obj/item/radio/headset/heads/rd
<<<<<<< HEAD
	uniform = /obj/item/clothing/under/rank/rnd/research_director
	shoes = /obj/item/clothing/shoes/jackboots //SKYRAT EDIT CHANGE
	suit = /obj/item/clothing/suit/toggle/labcoat/rd //SKYRAT EDIT CHANGE
	l_hand = /obj/item/clipboard
=======
	shoes = /obj/item/clothing/shoes/sneakers/brown
>>>>>>> 8e6f4375be6 (Reorganizes the order of items in job outfits (#61553))
	l_pocket = /obj/item/laser_pointer
	l_hand = /obj/item/clipboard

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/science
	duffelbag = /obj/item/storage/backpack/duffelbag/science

	chameleon_extras = /obj/item/stamp/rd
	skillchips = list(/obj/item/skillchip/job/research_director)

/datum/outfit/job/rd/rig
	name = "Research Director (Hardsuit)"

	suit = /obj/item/clothing/suit/space/hardsuit/rd
	suit_store = /obj/item/tank/internals/oxygen
	mask = /obj/item/clothing/mask/breath
	l_hand = null
	internals_slot = ITEM_SLOT_SUITSTORE
