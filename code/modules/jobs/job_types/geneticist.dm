/datum/job/geneticist
	title = "Geneticist"
	department_head = list("Chief Research Officer")
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief research officer"
	selection_color = "#ffeeff"
	exp_type = EXP_TYPE_CREW
	exp_requirements = 60

	outfit = /datum/outfit/job/geneticist
	plasmaman_outfit = /datum/outfit/plasmaman/genetics
	departments = DEPARTMENT_MEDICAL //Fukken what

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_GENETICIST
	bounty_types = CIV_JOB_SCI

	mail_goodies = list(
		/obj/item/storage/box/monkeycubes = 10
	)

	family_heirlooms = list(/obj/item/clothing/under/shorts/purple)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE


/datum/outfit/job/geneticist
	name = "Geneticist"
	jobtype = /datum/job/geneticist

	belt = /obj/item/pda/geneticist
	ears = /obj/item/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/utility/sci/syndicate
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/genetics
	suit_store =  /obj/item/flashlight/pen
	l_pocket = /obj/item/sequence_scanner

	backpack = /obj/item/storage/backpack/genetics
	satchel = /obj/item/storage/backpack/satchel/gen
	duffelbag = /obj/item/storage/backpack/duffelbag/genetics

	id_trim = /datum/id_trim/job/geneticist
