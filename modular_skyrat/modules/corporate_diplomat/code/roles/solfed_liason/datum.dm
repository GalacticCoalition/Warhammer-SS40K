/datum/corporate_diplomat_role/solfed_liason
	title = JOB_SOLFED_LIASON
	description = "Make sure law and order is upheld on the station, report the Head of Security abusing the Clown, bore people to death with your ballpoint pen collection."
	department_head = list(
		"Solar Federation",
	)
	supervisors = "Solar Federation"
	selection_color = "#c39c00"
	departments_list = list(
		/datum/job_department/command,
	)

	outfit = /datum/outfit/job/solfed_liason
	plasmaman_outfit = /datum/outfit/plasmaman/solfed_liason
	department_for_prefs = /datum/job_department/captain

	display_order = JOB_DISPLAY_ORDER_SOLFED_LIASON

	family_heirlooms = list(
		/obj/item/pen/fountain,
		/obj/item/pen/screwdriver,
		/obj/item/pen/survival,
	) // I WAS NOT LYING ABOUT THE BALLPOINT PEN COLLECTION

	mail_goodies = list(
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 15,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 10,
		/obj/item/clothing/accessory/pocketprotector/full = 10,
	)

