/obj/item/clothing/head/helmet/rus_helmet/nri
	name = "Russian L47 helmet"
	desc = "A Type 47 light helmet, it looks like it has a pocket for a bottle of vodka."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	icon_state = "russian_green_helmet"
	mutant_variants = NONE
	armor = list("melee" = 40, "bullet" = 35, "laser" = 15, "energy" = 30, "bomb" = 25, "bio" = 0, "rad" = 20, "fire" = 50, "acid" = 50, "wound" = 20)

/obj/item/clothing/head/beret/sec/nri
	name = "commander's beret"
	desc = "Za rodinu!!"
	armor = list("melee" = 40, "bullet" = 35, "laser" = 15, "energy" = 30, "bomb" = 25, "bio" = 0, "rad" = 20, "fire" = 50, "acid" = 50, "wound" = 20)

/obj/item/clothing/head/helmet/nri_heavy
	name = "altyn helmet"
	desc = "A heavy Russian combat helmet with a strong ballistic visor. Alt+click to adjust."
	icon_state = "russian_heavy_helmet"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	armor = list(MELEE = 70, BULLET = 60, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, FIRE = 90, ACID = 90)
	/// What position the helmet is in, TRUE = DOWN, FALSE = UP
	var/helmet_position = TRUE

/obj/item/clothing/head/helmet/nri_heavy/AltClick(mob/user)
	. = ..()
	helmet_position = !helmet_position
	to_chat(user, span_notice("You flip [src] [helmet_position ? "down" : "up"] with a heavy clunk!"))
	update_appearance()

/obj/item/clothing/head/helmet/nri_heavy/update_icon_state()
	. = ..()
	var/state = "[initial(icon_state)]"
	if(helmet_position)
		state += "-down"
	else
		state += "-up"
	icon_state = state

/obj/item/clothing/head/helmet/nri_heavy/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning, bypass_equip_delay_self)
	if(is_species(M, /datum/species/teshari))
		to_chat(M, span_warning("[src] is far too big for you!"))
		return FALSE
	return ..()
