//Donator reward for Otome
//give it to them in the loadout or something similar, if you ever remove these cigs from the vending machine
/obj/item/clothing/mask/cigarette/khi
	name = "\improper Kitsuhana Singularity cigarette"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "khioff"
	icon_on = "khion"
	icon_off = "khioff"
	type_butt = /obj/item/cigbutt
	list_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/toxin/mindbreaker = 5, /datum/reagent/serotrotium = 5, /datum/reagent/impedrezene = 5,  /datum/reagent/drug/space_drugs = 5)

/obj/item/cigbutt/khi
	icon = 'modular_skyrat/master_files/icons/obj/cigarettes_khi.dmi'
	icon_state = "khibutt"

/obj/item/storage/fancy/cigarettes/khi
	name = "\improper Kitsuhana Singularity packet"
	icon = 'modular_skyrat/master_files/icons/obj/cigarettes_khi.dmi'
	icon_state = "khi_cig_packet"
	base_icon_state = "khi_cig_packet"
	spawn_type = /obj/item/clothing/mask/cigarette/khi
