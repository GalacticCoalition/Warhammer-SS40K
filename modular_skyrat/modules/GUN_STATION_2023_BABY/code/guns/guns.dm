#define CALIBER_BLOODVIAL "bloodvial"

// Cargovolver

/obj/item/gun/ballistic/revolver/cargovolver
	name = "\improper 'Crush' 12 GA revolver"
	desc = "Not so classic anymore, this baby is plated in the finest fake gold there is and fires shotgun shells."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev12ga
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/guns.dmi'
	icon_state = "cargovolver"
	fire_sound = 'modular_skyrat/modules/sec_haul/sound/revolver_fire.ogg'

/obj/item/ammo_box/magazine/internal/cylinder/rev12ga
	name = "\improper 12 GA revolver cylinder"
	ammo_type = /obj/item/ammo_casing/shotgun
	caliber = CALIBER_SHOTGUN
	max_ammo = 3
	multiload = FALSE

// Engineering Laser Cutter

/obj/item/gun/ballistic/automatic/pistol/laser_cutter
	name = "\improper 'Serra' cutting laser"
	desc = "Basically, a tube with a big heat sink attached to it. It fires lasers originally meant for cutting metals, but armor works too."
	icon = 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/guns.dmi'
	icon_state = "cargovolver"
	fire_sound = 'modular_skyrat/modules/microfusion/sound/laser_1.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/recharge/engilaser
	can_suppress = FALSE
	show_bolt_icon = FALSE
	casing_ejector = FALSE
	empty_indicator = FALSE
	bolt_type = BOLT_TYPE_OPEN
	fire_delay = 4

/obj/item/ammo_box/magazine/recharge/engilaser
	name = "industrial power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser cutters."
	icon_state = "energizer"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/caseless/laser/engicutter
	caliber = CALIBER_LASER
	max_ammo = 10

/obj/item/ammo_casing/caseless/laser/engicutter
	projectile_type = /obj/projectile/beam/laser/engicutter
	fire_sound = 'modular_skyrat/modules/microfusion/sound/laser_1.ogg'

/obj/projectile/beam/laser/engicutter
	name = "cutting laser"
	icon = 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/projectiles.dmi'
	icon_state = "engilaser"
	damage = 20
	armour_penetration = 75

	/// Reference to the beam following the projectile.
	var/line

/obj/projectile/beam/laser/engicutter/fire(setAngle)
	if(firer)
		line = firer.Beam(src, "engilaser_trail", 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/projectiles.dmi', emissive = TRUE)
	..()

/obj/projectile/beam/laser/engicutter/Destroy()
	QDEL_NULL(line)
	return ..()

// Science Plasma Gun

/obj/item/gun/ballistic/automatic/pistol/plasma_thrower
	name = "\improper 'Solis' plasma projector"
	desc = "Utilizing the power of really strong magnets, and a couple million volts of electricity, this 'gun' throws searing globs of plasma in the general direction of wherever you aim."
	icon = 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/guns.dmi'
	icon_state = "plasmasci"
	fire_sound = 'modular_skyrat/modules/microfusion/sound/incinerate.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/recharge/plasmasci
	can_suppress = FALSE
	show_bolt_icon = FALSE
	casing_ejector = FALSE
	empty_indicator = FALSE
	bolt_type = BOLT_TYPE_OPEN
	fire_delay = 3
	spread = 15

/obj/item/gun/ballistic/automatic/pistol/plasma_thrower/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/automatic_fire, fire_delay, TRUE, 0.25, 3)

/obj/item/ammo_box/magazine/recharge/plasmasci
	name = "plasma power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for plasma projectors."
	icon = 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/magazines.dmi'
	icon_state = "scibattery"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/caseless/laser/plasma_glob
	caliber = CALIBER_LASER

/obj/item/ammo_casing/caseless/laser/plasma_glob
	projectile_type = /obj/projectile/beam/laser/plasma_glob
	fire_sound = 'modular_skyrat/modules/microfusion/sound/incinerate.ogg'

/obj/projectile/beam/laser/plasma_glob
	name = "plasma globule"
	icon = 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/projectiles.dmi'
	icon_state = "plasmasci"
	damage = 10
	speed = 1.5
	bare_wound_bonus = 75
	wound_bonus = -50

// Medical Cruelty Squad Ass Weapon

/obj/item/gun/ballistic/revolver/harmacist
	name = "\improper 'Harmacist' bone fragment launcher"
	desc = "Through technology you REALLY do not want to know the inner workings of, this gun consumes single shot blood cartridges and fires a barrage of razor sharp bone fragments."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/bloodvolver
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/guns.dmi'
	icon_state = "harmacist"
	fire_sound = 'modular_skyrat/modules/sec_haul/sound/rail.ogg'

/obj/item/ammo_box/magazine/internal/cylinder/bloodvolver
	name = "\improper Harmacist vial store"
	ammo_type = /obj/item/ammo_casing/bloodvial
	caliber = CALIBER_BLOODVIAL
	max_ammo = 3
	multiload = FALSE

/obj/item/ammo_casing/bloodvial
	projectile_type = /obj/projectile/bullet/pellet/bone_fragment/strong
	icon = 'modular_skyrat/modules/GUN_STATION_2023_BABY/icons/guns/magazines.dmi'
	icon_state = "vial"
	fire_sound = 'modular_skyrat/modules/sec_haul/sound/rail.ogg'

/obj/item/ammo_casing/bloodvial/attack(mob/living/carbon/affected_mob, mob/user)
	if(loaded_projectile)
		balloon_alert(user, "already loaded")
		return FALSE
	if(!iscarbon(affected_mob))
		return FALSE

	if(affected_mob != user)
		affected_mob.visible_message(span_danger("[user] is trying to take a blood sample from [affected_mob]!"), \
						span_userdanger("[user] is trying to take a blood sample from you!"))
		if(!do_after(user, CHEM_INTERACT_DELAY(3 SECONDS, user), affected_mob, extra_checks = CALLBACK(affected_mob, TYPE_PROC_REF(/mob/living, try_inject), user, null, INJECT_TRY_SHOW_ERROR_MESSAGE|NONE)))
			return FALSE
	if(affected_mob.bleed(10))
		user.visible_message(span_notice("[user] takes a blood sample from [affected_mob]."))
	else
		to_chat(user, span_warning("You are unable to draw any blood from [affected_mob]!"))
		return FALSE

	newshot()

/obj/projectile/bullet/pellet/bone_fragment/strong
	damage = 25

#undef CALIBER_BLOODVIAL
