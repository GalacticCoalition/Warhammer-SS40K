/obj/item/ammo_casing/b10mm/b460
	name = "A .460 Rowland Magnum casing."
	desc = "A .460 Rowland Magnum casing."
	icon = 'modular_skyrat/modules/sec_haul/icons/guns/ammo_cartridges.dmi'
	icon_state = "sl-casing"
	caliber = "10mm"
	projectile_type = /obj/projectile/bullet/advanced/b10mm/b460

/obj/projectile/bullet/advanced/b10mm/b460
	name = ".460 RM JHP bullet"
	damage = 42
	stamina = 15
	wound_bonus = 30
	armour_penetration = -30
	speed = 1

/obj/item/gun/ballistic/automatic/pistol/blueshield
	name = "\improper M45A5 Elite"
	desc = "A hand-assembled custom sporting handgun by Alpha Centauri Armories, chambered in .460 Rowland Magnum. This model has modular caliber magazines, to accomodate  for ammo costs."
	icon = 'modular_skyrat/modules/blueshield/icons/obj/guns/M45A5.dmi'
	icon_state = "m45a5"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/multi_sprite/ladon/blueshield
	can_suppress = FALSE
	fire_delay = 3
	fire_sound_volume = 30
	spread = 2
	force = 10
	recoil = 1
	realistic = TRUE
	dirt_modifier = 0.1
	can_flashlight = TRUE
	emp_damageable = FALSE

/obj/item/ammo_box/magazine/multi_sprite/ladon/blueshield
	name = "ACA 460-10 modular magazine"
	desc = "A magazine normally chambered in .460, able to chamber Peacekeeper 10mm rounds as an alternative by its length switch. Made for the M45A5, as it's the only available sidearm with a smart multi-caliber mechanism."
	icon = 'modular_skyrat/modules/blueshield/icons/obj/guns/M45A5.dmi'
	icon_state = "rowlandmodular"
	ammo_type = /obj/item/ammo_casing/b10mm/b460
	caliber = "10mm"
	max_ammo = 15 //Tactical mags.
	multiple_sprites = AMMO_BOX_FULL_EMPTY_BASIC

/obj/item/ammo_box/magazine/multi_sprite/ladon/blueshield/b460
	name = "ACA 460-10 modular magazine"
	desc = "A hand-assembled custom sporting handgun by Alpha Centauri Armories, chambered in .460 Rowland Magnum. Loaded with 460 by default."
	ammo_type = /obj/item/ammo_casing/b10mm/b460
	icon_state = "rowlandmodular_hollowpoint-full"

/obj/item/ammo_box/magazine/multi_sprite/ladon/blueshield/hp
	ammo_type = /obj/item/ammo_casing/b10mm/hp
	icon_state = "rowlandmodular_hollowpoint-full"

/obj/item/ammo_box/magazine/multi_sprite/ladon/blueshield/rubber
	ammo_type = /obj/item/ammo_casing/b10mm/rubber
	icon_state = "rowlandmodular_rubber-full"

/obj/item/ammo_box/magazine/multi_sprite/ladon/blueshield/ihdf
	ammo_type = /obj/item/ammo_casing/b10mm/ihdf
	icon_state = "rowlandmodular_ihdf-full"

