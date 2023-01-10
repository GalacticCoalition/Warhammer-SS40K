
/**
 * Called when the projectile hits something
 *
 * @params
 * target - thing hit
 * blocked - percentage of hit blocked
 * pierce_hit - are we piercing through or regular hitting
 */
/obj/projectile/proc/on_hit(atom/target, blocked = FALSE, pierce_hit)
	if(fired_from)
		SEND_SIGNAL(fired_from, COMSIG_PROJECTILE_ON_HIT, firer, target, Angle)
	// i know that this is probably more with wands and gun mods in mind, but it's a bit silly that the projectile on_hit signal doesn't ping the projectile itself.
	// maybe we care what the projectile thinks! See about combining these via args some time when it's not 5AM
	var/obj/item/bodypart/hit_limb
	if(isliving(target))
		var/mob/living/L = target
		hit_limb = L.check_limb_hit(def_zone)
	SEND_SIGNAL(src, COMSIG_PROJECTILE_SELF_ON_HIT, firer, target, Angle, hit_limb)

	if(QDELETED(src)) // in case one of the above signals deleted the projectile for whatever reason
		return
	var/turf/target_loca = get_turf(target)

	var/hitx
	var/hity
	if(target == original)
		hitx = target.pixel_x + p_x - 16
		hity = target.pixel_y + p_y - 16
	else
		hitx = target.pixel_x + rand(-8, 8)
		hity = target.pixel_y + rand(-8, 8)

	var/impact_sound
	if(hitsound)
		impact_sound = hitsound
	else
		impact_sound = target.impact_sound
		get_sfx()
	playsound(src, get_sfx_skyrat(impact_sound), vol_by_damage(), TRUE, -1)

	if(!nodamage && (damage_type == BRUTE || damage_type == BURN) && iswallturf(target_loca) && prob(75))
		var/turf/closed/wall/W = target_loca
		if(impact_effect_type && !hitscan)
			new impact_effect_type(target_loca, hitx, hity)

		W.add_dent(WALL_DENT_SHOT, hitx, hity)

		return BULLET_ACT_HIT

	if(!isliving(target))
		if(impact_effect_type && !hitscan)
			new impact_effect_type(target_loca, hitx, hity)
		return BULLET_ACT_HIT

	var/mob/living/L = target

	if(blocked != 100) // not completely blocked
		if(damage && L.blood_volume && damage_type == BRUTE)
			var/splatter_dir = dir
			if(starting)
				splatter_dir = get_dir(starting, target_loca)
			if(isalien(L))
				new /obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter(target_loca, splatter_dir)
			else
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(target_loca, splatter_dir)
			if(prob(33))
				L.add_splatter_floor(target_loca)
		else if(impact_effect_type && !hitscan)
			new impact_effect_type(target_loca, hitx, hity)

		var/organ_hit_text = ""
		var/limb_hit = hit_limb
		if(limb_hit)
			organ_hit_text = " in \the [parse_zone(limb_hit)]"
		else if(suppressed && suppressed != SUPPRESSED_VERY)
			to_chat(L, span_userdanger("You're shot by \a [src][organ_hit_text]!"))
		else
			L.visible_message(span_danger("[L] is hit by \a [src][organ_hit_text]!"), \
					span_userdanger("You're hit by \a [src][organ_hit_text]!"), null, COMBAT_MESSAGE_RANGE)
		L.on_hit(src)

	var/reagent_note
	if(reagents?.reagent_list)
		reagent_note = " REAGENTS:"
		for(var/datum/reagent/R in reagents.reagent_list)
			reagent_note += "[R.name] ([num2text(R.volume)])"

	if(ismob(firer))
		log_combat(firer, L, "shot", src, reagent_note)
	else
		L.log_message("has been shot by [firer] with [src]", LOG_ATTACK, color="orange")

	return BULLET_ACT_HIT

/obj/projectile/bullet
	tracer_type = /obj/effect/projectile/tracer/sniper ///It's, really, just a straight line; might as well reuse it until I get some proper smoke tracer.
	hitscan = TRUE
	hitscan_light_intensity = 0.5

/obj/projectile/beam
	tracer_type = /obj/effect/projectile/tracer/laser
	hitscan = TRUE
	hitscan_light_intensity = 0.75

///Literally felt like it; changes nothing but it looks cool.
/obj/projectile/plasma
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	hitscan = TRUE
	hitscan_light_intensity = 0.75

///It's not a bullet it's a coin and its purpose is quite literally being hit consistently visibly not instantly.
/obj/projectile/bullet/coin
	hitscan = FALSE

///Those three're possibly the last ones you'd wanna be instantly hit with.
/obj/projectile/bullet/gyro
	hitscan = FALSE

/obj/projectile/bullet/rocket
	hitscan = FALSE

/obj/projectile/bullet/a40mm
	hitscan = FALSE

///At the moment, all of them are too low-velocity to be even remotely hitscan. I mean, come on, a lollipop/gumball, a foam darn, and an arrow.
/obj/projectile/bullet/reusable
	hitscan = FALSE

/obj/projectile/bullet/ciws
	hitscan = FALSE

/obj/projectile/energy/bolt
	hitscan = FALSE

/obj/projectile/beam/laser/accelerator
	hitscan = FALSE
