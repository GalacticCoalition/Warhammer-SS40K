/*
*	BOUNCE DISABLER
*	A disabler that will always ricochet.
*/


/obj/item/ammo_casing/energy/disabler/bounce
	projectile_type = /obj/projectile/beam/disabler/bounce
	select_name  = "disable"
	e_cost = 60
	fire_sound = 'sound/weapons/taser2.ogg'
	harmful = FALSE

/obj/effect/projectile/tracer/disabler/bounce
	name = "disabler"
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/projectiles.dmi'
	icon_state = "bouncebeam"

/obj/projectile/beam/disabler/bounce
	name = "disabler arc"
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/projectiles.dmi'
	icon_state = "bouncebeam"
	damage = 30
	damage_type = STAMINA
	armor_flag = ENERGY
	eyeblur = 1
	tracer_type = /obj/effect/projectile/tracer/disabler/bounce
	light_range = 5
	light_power = 0.75
	speed = 1.4
	ricochets_max = 6
	ricochet_incidence_leeway = 170
	ricochet_chance = 130
	ricochet_decay_damage = 0.9

// Allows the projectile to reflect on walls like how bullets ricochet.
/obj/projectile/beam/disabler/bounce/check_ricochet_flag(atom/A)
	return TRUE

/*
*	BOUNCE LASER
*	A laser that will always ricochet.
*/

/obj/item/ammo_casing/energy/laser/bounce
	projectile_type = /obj/projectile/beam/laser/bounce
	select_name = "lethal"
	e_cost = 100

/obj/projectile/beam/laser/bounce
	name = "energy arc"
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/projectiles.dmi'
	icon_state = "bouncebeam_red"
	damage = 20
	damage_type = BURN
	armor_flag = LASER
	light_range = 5
	light_power = 0.75
	speed = 1.4
	ricochets_max = 6
	ricochet_incidence_leeway = 170
	ricochet_chance = 130
	ricochet_decay_damage = 0.9

// Allows the projectile to reflect on walls like how bullets ricochet.
/obj/projectile/beam/laser/bounce/check_ricochet_flag(atom/A)
	return TRUE

/*
*	KNOCKDOWN BOLT
*	A taser that had the same stamina impact as a disabler, but a five-second knockdown and taser hitter effects.
*/

/obj/item/ammo_casing/energy/electrode/knockdown
	projectile_type = /obj/projectile/energy/electrode/knockdown
	select_name = "knockdown"
	fire_sound = 'sound/weapons/taser.ogg'
	e_cost = 200
	harmful = FALSE

/obj/projectile/energy/electrode/knockdown
	name = "electrobolt"
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/projectiles.dmi'
	icon_state = "electro_bolt"
	knockdown = 50
	stamina = 30
	range = 6

/*
*	SINGLE LASER
*	Has an unique sprite
*	Low-powered laser for rapid fire
*	Pea-shooter tier.
*/


/obj/item/ammo_casing/energy/laser/single
	projectile_type = /obj/projectile/beam/laser/single
	e_cost = 50
	select_name = "lethal"

/obj/projectile/beam/laser/single
	name = "laser bolt"
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/projectiles.dmi'
	icon_state = "single_laser"
	damage = 15
	eyeblur = 1
	light_range = 5
	light_power = 0.75
	speed = 0.5
	armour_penetration = 10

/*
*	DOUBLE LASER
*	Visually, this fires two lasers. In code, it's just one.
*	It's fast and great for turrets.
*/

/obj/item/ammo_casing/energy/laser/double
	projectile_type = /obj/projectile/beam/laser/double
	e_cost = 100
	select_name = "lethal"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/projectile/beam/laser/double
	name = "laser bolt"
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/projectiles.dmi'
	icon_state = "double_laser"
	damage = 40
	eyeblur = 1
	light_range = 5
	light_power = 0.75
	speed = 0.5
	armour_penetration = 10

/*
*	ENERGY BULLETS
*	Ballistic gunplay but it allows us to target a different part of the armour block.
*	Also allows the benefits of lasers (blobs strains, xenos) over bullets to be used with ballistic gunplay.
*/

/obj/item/ammo_casing/laser
	name = "type I plasma projectile"
	desc = "A chemical mixture that once triggered, creates a deadly projectile, melting it's own casing in the process."
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/ammo.dmi'
	icon_state = "plasma_shell"
	worn_icon_state = "shell"
	caliber = "Beam Shell"
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 2,/datum/material/plasma=HALF_SHEET_MATERIAL_AMOUNT)
	projectile_type = /obj/projectile/beam/laser/single

/obj/item/ammo_casing/laser/double
	name = "type II plasma projectile"
	desc = "A chemical mixture that once triggered, creates a deadly projectile, melting it's own casing in the process."
	icon_state = "plasma_shell2"
	worn_icon_state = "shell"
	caliber = "Beam Shell"
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 2,/datum/material/plasma=HALF_SHEET_MATERIAL_AMOUNT)
	projectile_type = /obj/projectile/beam/laser/double

/obj/item/ammo_casing/laser/bounce
	name = "type III reflective projectile (lethal)"
	desc = "A chemical mixture that once triggered, creates a deadly bouncing projectile, melting it's own casing in the process."
	icon_state = "bounce_shell"
	worn_icon_state = "shell"
	caliber = "Beam Shell"
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 2,/datum/material/plasma=HALF_SHEET_MATERIAL_AMOUNT)
	projectile_type = /obj/projectile/beam/laser/bounce

/obj/item/ammo_casing/laser/bounce/disabler
	name = "type III reflective projectile (disabler)"
	desc = "A chemical mixture that once triggered, creates bouncing disabler projectile, melting it's own casing in the process."
	icon_state = "disabler_shell"
	projectile_type = /obj/projectile/beam/disabler/bounce


