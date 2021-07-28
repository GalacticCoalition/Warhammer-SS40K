/datum/job/cargo_technician
	title = "Deck Crewman"
	//department_head = list("Head of Personnel") //ORIGINAL
	department_head = list("Deck Officer") //SKYRAT EDIT CHANGE
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 2
	//supervisors = "the quartermaster and the head of personnel" //ORIGINAL
	supervisors = "the deck officer" //SKYRAT EDIT CHANGE
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/cargo_tech
	plasmaman_outfit = /datum/outfit/plasmaman/cargo

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CAR
	display_order = JOB_DISPLAY_ORDER_CARGO_TECHNICIAN
	bounty_types = CIV_JOB_RANDOM
	departments = DEPARTMENT_CARGO

	family_heirlooms = list(/obj/item/clipboard)

	mail_goodies = list(
		/obj/item/pizzabox = 10,
		/obj/item/stack/sheet/mineral/gold = 5,
		/obj/item/stack/sheet/mineral/uranium = 4,
		/obj/item/stack/sheet/mineral/diamond = 3,
		/obj/item/gun/ballistic/rifle/boltaction = 1
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE


/datum/outfit/job/cargo_tech
	name = "Cargo Technician"
	jobtype = /datum/job/cargo_technician

	belt = /obj/item/pda/cargo
	ears = /obj/item/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/utility/cargo/syndicate
	l_hand = /obj/item/export_scanner
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/cargo = 1)
	id_trim = /datum/id_trim/job/cargo_technician
