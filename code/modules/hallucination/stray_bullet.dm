//hallucination projectile code in code/modules/projectiles/projectile/special.dm
/datum/hallucination/stray_bullet

/datum/hallucination/stray_bullet/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/turf/startlocs = list()
	for(var/turf/open/T in view(world.view+1,target)-view(world.view,target))
		startlocs += T
	if(!startlocs.len)
		qdel(src)
		return
	var/turf/start = pick(startlocs)
	var/proj_type = pick(subtypesof(/obj/projectile/hallucination))
	feedback_details += "Type: [proj_type]"
	var/obj/projectile/hallucination/H = new proj_type(start)
	target.playsound_local(start, H.hal_fire_sound, 60, 1)
	H.hal_target = target
	H.preparePixelProjectile(target, start)
	H.fire()
	qdel(src)
<<<<<<< HEAD
=======

/obj/projectile/hallucination/fire()
	if(hal_fire_sound)
		parent.hallucinator.playsound_local(get_turf(src), hal_fire_sound, 60, TRUE)

	fake_bullet = image(hal_icon, src, hal_icon_state, ABOVE_MOB_LAYER)
	parent.hallucinator.client?.images += fake_bullet
	return ..()

/obj/projectile/hallucination/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return

	if(ismob(target))
		if(hal_hitsound)
			parent.hallucinator.playsound_local(target, hal_hitsound, 100, 1)
		on_mob_hit(target)

	else
		if(hal_hitsound_wall)
			parent.hallucinator.playsound_local(loc, hal_hitsound_wall, 40, 1)
		if(hal_impact_effect_wall)
			spawn_hit(target, TRUE)

	qdel(src)
	return TRUE

/// Called when a mob is hit by the fake projectile
/obj/projectile/hallucination/proc/on_mob_hit(mob/living/hit_mob)
	if(hit_mob == parent.hallucinator)
		to_chat(parent.hallucinator, span_userdanger("[hit_mob] is hit by \a [src] in the chest!"))
		apply_effect_to_hallucinator(parent.hallucinator)

	else if(hit_mob in view(parent.hallucinator))
		to_chat(parent.hallucinator, span_danger("[hit_mob] is hit by \a [src] in the chest!"))

	if(damage_type == BRUTE)
		var/splatter_dir = dir
		if(starting)
			splatter_dir = get_dir(starting, get_turf(hit_mob))
		spawn_blood(hit_mob, splatter_dir)

	else if(hal_impact_effect)
		spawn_hit(hit_mob, FALSE)

/// Called when the hallucinator themselves are hit by the fake projectile
/obj/projectile/hallucination/proc/apply_effect_to_hallucinator(mob/living/afflicted)
	return

/// Called after a mob is hit by the fake projectile, and our fake projectile is of brute type, to create fake blood
/obj/projectile/hallucination/proc/spawn_blood(mob/living/bleeding, set_dir)
	if(!parent.hallucinator.client) // Purely visual, don't need to do this for clientless mobs
		return

	var/splatter_icon_state
	if(ISDIAGONALDIR(set_dir))
		splatter_icon_state = "splatter[pick(1, 2, 6)]"
	else
		splatter_icon_state = "splatter[pick(3, 4, 5)]"

	var/image/blood = image('icons/effects/blood.dmi', bleeding, splatter_icon_state, ABOVE_MOB_LAYER)
	var/target_pixel_x = 0
	var/target_pixel_y = 0
	switch(set_dir)
		if(NORTH)
			target_pixel_y = 16
		if(SOUTH)
			target_pixel_y = -16
			layer = ABOVE_MOB_LAYER
		if(EAST)
			target_pixel_x = 16
		if(WEST)
			target_pixel_x = -16
		if(NORTHEAST)
			target_pixel_x = 16
			target_pixel_y = 16
		if(NORTHWEST)
			target_pixel_x = -16
			target_pixel_y = 16
		if(SOUTHEAST)
			target_pixel_x = 16
			target_pixel_y = -16
			layer = ABOVE_MOB_LAYER
		if(SOUTHWEST)
			target_pixel_x = -16
			target_pixel_y = -16
			layer = ABOVE_MOB_LAYER

	parent.hallucinator.client?.images |= blood
	animate(blood, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = 5)
	addtimer(CALLBACK(src, .proc/clean_up_blood, blood), 0.5 SECONDS)

/obj/projectile/hallucination/proc/clean_up_blood(image/blood)
	parent.hallucinator.client?.images -= blood

/// Called with a non-mob atom was hit by our fake projectile, or a mob was hit and our damge type is not brute
/obj/projectile/hallucination/proc/spawn_hit(atom/hit_atom, is_wall)
	if(!parent.hallucinator.client) // Purely visual, don't need to do this for clientless mobs
		return

	var/image/hit_effect = image('icons/effects/blood.dmi', hit_atom, is_wall ? hal_impact_effect_wall : hal_impact_effect, ABOVE_MOB_LAYER)
	hit_effect.pixel_x = hit_atom.pixel_x + rand(-4,4)
	hit_effect.pixel_y = hit_atom.pixel_y + rand(-4,4)
	parent.hallucinator.client.images |= hit_effect
	addtimer(CALLBACK(src, .proc/clean_up_hit, hit_effect), is_wall ? hit_duration_wall : hit_duration)

/obj/projectile/hallucination/proc/clean_up_hit(image/hit_effect)
	parent.hallucinator.client?.images -= hit_effect

/obj/projectile/hallucination/bullet
	name = "bullet"
	hal_icon_state = "bullet"
	hal_fire_sound = "gunshot"
	hal_hitsound = 'sound/weapons/pierce.ogg'
	hal_hitsound_wall = SFX_RICOCHET
	hal_impact_effect = "impact_bullet"
	hal_impact_effect_wall = "impact_bullet"
	hit_duration = 5
	hit_duration_wall = 5

/obj/projectile/hallucination/bullet/apply_effect_to_hallucinator(mob/living/afflicted)
	afflicted.adjustStaminaLoss(60)

/obj/projectile/hallucination/laser
	name = "laser"
	damage_type = BURN
	hal_icon_state = "laser"
	hal_fire_sound = 'sound/weapons/laser.ogg'
	hal_hitsound = 'sound/weapons/sear.ogg'
	hal_hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	hal_impact_effect = "impact_laser"
	hal_impact_effect_wall = "impact_laser_wall"
	hit_duration = 4
	hit_duration_wall = 10
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

	ricochets_max = 50
	ricochet_chance = 80
	reflectable = REFLECT_NORMAL // No idea if this works

/obj/projectile/hallucination/laser/apply_effect_to_hallucinator(mob/living/afflicted)
	afflicted.adjustStaminaLoss(20)
	afflicted.blur_eyes(2)

/obj/projectile/hallucination/taser
	name = "electrode"
	damage_type = BURN
	hal_icon_state = "spark"
	color = "#FFFF00"
	hal_fire_sound = 'sound/weapons/taser.ogg'
	hal_hitsound = 'sound/weapons/taserhit.ogg'
	hal_hitsound_wall = null
	hal_impact_effect = null
	hal_impact_effect_wall = null

/obj/projectile/hallucination/taser/apply_effect_to_hallucinator(mob/living/afflicted)
	afflicted.Paralyze(10 SECONDS)
	afflicted.adjust_stutter(40 SECONDS)
	if(HAS_TRAIT(afflicted, TRAIT_HULK))
		afflicted.say(pick(
			";RAAAAAAAARGH!",
			";HNNNNNNNNNGGGGGGH!",
			";GWAAAAAAAARRRHHH!",
			"NNNNNNNNGGGGGGGGHH!",
			";AAAAAAARRRGH!"),
			forced = "hulk (hallucinating)",
		)
	else if((afflicted.status_flags & CANKNOCKDOWN) && !HAS_TRAIT(afflicted, TRAIT_STUNIMMUNE))
		addtimer(CALLBACK(afflicted, /mob/living/carbon.proc/do_jitter_animation, 20), 0.5 SECONDS)

/obj/projectile/hallucination/disabler
	name = "disabler beam"
	damage_type = STAMINA
	hal_icon_state = "omnilaser"
	hal_fire_sound = 'sound/weapons/taser2.ogg'
	hal_hitsound = 'sound/weapons/tap.ogg'
	hal_hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	hal_impact_effect = "impact_laser_blue"
	hal_impact_effect_wall = null
	hit_duration = 4
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

	ricochets_max = 50
	ricochet_chance = 80
	reflectable = REFLECT_NORMAL // No idea if this works

/obj/projectile/hallucination/disabler/apply_effect_to_hallucinator(mob/living/afflicted)
	afflicted.adjustStaminaLoss(30)

/obj/projectile/hallucination/ebow
	name = "bolt"
	damage_type = TOX
	hal_icon_state = "cbbolt"
	hal_fire_sound = 'sound/weapons/genhit.ogg'
	hal_hitsound = null
	hal_hitsound_wall = null
	hal_impact_effect = null
	hal_impact_effect_wall = null

/obj/projectile/hallucination/ebow/apply_effect_to_hallucinator(mob/living/afflicted)
	afflicted.adjust_slurring(10 SECONDS)
	afflicted.Knockdown(1 SECONDS)
	afflicted.adjustStaminaLoss(75) // 60 stam + 15 tox
	afflicted.blur_eyes(10)

/obj/projectile/hallucination/change
	name = "bolt of change"
	damage_type = BURN
	hal_icon_state = "ice_1"
	hal_fire_sound = 'sound/magic/staff_change.ogg'
	hal_hitsound = null
	hal_hitsound_wall = null
	hal_impact_effect = null
	hal_impact_effect_wall = null

/obj/projectile/hallucination/change/apply_effect_to_hallucinator(mob/living/afflicted)
	// Future idea: Make it so any other mob hit appear to be polymorphed to the hallucinator
	afflicted.cause_hallucination( \
		get_random_valid_hallucination_subtype(/datum/hallucination/delusion/preset), \
		"fake [name]", \
		duration = 30 SECONDS, \
		affects_us = TRUE, \
		affects_others = FALSE, \
		skip_nearby = FALSE, \
		play_wabbajack = TRUE, \
	)

/obj/projectile/hallucination/death
	name = "bolt of death"
	damage_type = BURN
	hal_icon_state = "pulse1_bl"
	hal_fire_sound = 'sound/magic/wandodeath.ogg'
	hal_hitsound = null
	hal_hitsound_wall = null
	hal_impact_effect = null
	hal_impact_effect_wall = null

/obj/projectile/hallucination/death/apply_effect_to_hallucinator(mob/living/afflicted)
	afflicted.cause_hallucination(/datum/hallucination/death, "fake [name]")
>>>>>>> 45516f47414 (Adds macros to help with common `set_`- and `adjust_timed_status_effect` uses (#69951))
