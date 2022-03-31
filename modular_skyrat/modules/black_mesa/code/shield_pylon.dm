/mob/living/simple_animal/hostile/blackmesa/xen
	/// If we have support pylons, this is true.
	var/shielded = FALSE
	/// How many shields we have protecting us
	var/shield_count = 0

/mob/living/simple_animal/hostile/blackmesa/xen/update_overlays()
	. = ..()
	if(shielded)
		. += mutable_appearance('icons/effects/effects.dmi', "shield-yellow", MOB_SHIELD_LAYER)

/mob/living/simple_animal/hostile/blackmesa/xen/proc/lose_shield()
	shield_count--
	if(shield_count <= 0)
		shielded = FALSE
		update_appearance()

/mob/living/simple_animal/hostile/blackmesa/xen/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, attack_direction)
	if(shielded)
		balloon_alert_to_viewers("ineffective!")
		return FALSE
	return ..()

/obj/structure/xen_pylon
	name = "shield pylon"
	desc = "It seems to be some kind of force field generator."
	icon = 'modular_skyrat/modules/black_mesa/icons/plants.dmi'
	icon_state = "crystal_pylon"
	max_integrity = 350
	density = TRUE
	/// The range at which we provide shield support to a mob.
	var/shield_range = 6
	/// A list of mobs we are currently shielding with attached beams.
	var/list/shielded_mobs = list()

/obj/structure/xen_pylon/Initialize(mapload)
	. = ..()
	for(var/mob/living/simple_animal/hostile/blackmesa/xen/iterating_mob in circle_range(src, shield_range))
		register_mob(iterating_mob)


/obj/structure/xen_pylon/proc/register_mob(mob/living/simple_animal/hostile/blackmesa/xen/mob_to_register)
	shielded_mobs += mob_to_register
	mob_to_register.shielded = TRUE
	mob_to_register.shield_count++
	mob_to_register.update_appearance()
	var/datum/beam/created_beam = Beam(mob_to_register, icon_state = "red_lightning", time = 10 MINUTES, maxdistance = shield_range)
	shielded_mobs[mob_to_register] = created_beam
	RegisterSignal(created_beam, COMSIG_PARENT_QDELETING, .proc/beam_died)
	RegisterSignal(mob_to_register, COMSIG_PARENT_QDELETING, .proc/mob_died)

/obj/structure/xen_pylon/proc/mob_died(atom/movable/source, force)
	SIGNAL_HANDLER
	var/datum/beam/beam = shielded_mobs[source]
	qdel(beam)
	shielded_mobs[source] = null

/obj/structure/xen_pylon/proc/beam_died(atom/movable/source, force)
	SIGNAL_HANDLER
	for(var/mob/living/simple_animal/hostile/blackmesa/xen/iterating_mob as anything in shielded_mobs)
		if(shielded_mobs[iterating_mob] == source)
			iterating_mob.lose_shield()
			shielded_mobs[iterating_mob] = null
			shielded_mobs -= iterating_mob

/obj/structure/xen_pylon/Destroy()
	for(var/mob/living/simple_animal/hostile/blackmesa/xen/iterating_mob as anything in shielded_mobs)
		iterating_mob.lose_shield()
		shielded_mobs -= iterating_mob
		var/datum/beam/beam = shielded_mobs[iterating_mob]
		qdel(beam)
		shielded_mobs[iterating_mob] = null
	shielded_mobs = null
	playsound(src, 'sound/magic/lightningbolt.ogg', 100, TRUE)
	return ..()
