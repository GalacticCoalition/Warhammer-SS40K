#define SHAKE_ANIMATION_OFFSET 4
#define PERSONAL_SPACE_DAMAGE 2
#define ASS_SLAP_EXTRA_RANGE -1

/mob/living/carbon/get_eye_protection()
	. = ..()
	if(is_blind() && !is_blind_from(list(UNCONSCIOUS_TRAIT, HYPNOCHAIR_TRAIT)))
		return INFINITY //For all my homies that can not see in the world
	var/obj/item/organ/internal/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		. += eyes.flash_protect
	else
		return INFINITY //Can't get flashed without eyes
	if(isclothing(head)) //Adds head protection
		. += head.flash_protect
	if(isclothing(glasses)) //Glasses
		. += glasses.flash_protect
	if(isclothing(wear_mask)) //Mask
		. += wear_mask.flash_protect

/mob/living/carbon/get_ear_protection()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_DEAF))
		return INFINITY //For all my homies that can not hear in the world
	var/obj/item/organ/internal/ears/E = getorganslot(ORGAN_SLOT_EARS)
	if(!E)
		return INFINITY
	else
		. += E.bang_protect

/mob/living/carbon/is_mouth_covered(check_flags = ALL)
	if((check_flags & ITEM_SLOT_HEAD) && head && (head.flags_cover & HEADCOVERSMOUTH))
		return head
	if((check_flags & ITEM_SLOT_MASK) && wear_mask && (wear_mask.flags_cover & HEADCOVERSMOUTH))
		return wear_mask

	return null

/mob/living/carbon/is_eyes_covered(check_flags = ALL)
	if((check_flags & ITEM_SLOT_HEAD) && head && (head.flags_cover & HEADCOVERSEYES))
		return head
	if((check_flags & ITEM_SLOT_MASK) && wear_mask && (wear_mask.flags_cover & MASKCOVERSEYES))
		return wear_mask
	if((check_flags & ITEM_SLOT_EYES) && glasses && (glasses.flags_cover & GLASSESCOVERSEYES))
		return glasses

	return null

/mob/living/carbon/is_pepper_proof(check_flags = ALL)
	var/obj/item/organ/internal/eyes/eyes = getorgan(/obj/item/organ/internal/eyes)
	if(eyes && eyes.pepperspray_protect)
		return eyes
	if((check_flags & ITEM_SLOT_HEAD) && head && (head.flags_cover & PEPPERPROOF))
		return head
	if((check_flags & ITEM_SLOT_MASK) && wear_mask && (wear_mask.flags_cover & PEPPERPROOF))
		return wear_mask

	return null

/mob/living/carbon/check_projectile_dismemberment(obj/projectile/P, def_zone)
	var/obj/item/bodypart/affecting = get_bodypart(def_zone)
	if(affecting && affecting.dismemberable && affecting.get_damage() >= (affecting.max_damage - P.dismemberment))
		affecting.dismember(P.damtype)

/mob/living/carbon/proc/can_catch_item(skip_throw_mode_check)
	. = FALSE
	if(!skip_throw_mode_check && !throw_mode)
		return
	if(get_active_held_item())
		return
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	return TRUE

/mob/living/carbon/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(!skipcatch && can_catch_item() && isitem(AM) && !HAS_TRAIT(AM, TRAIT_UNCATCHABLE) && isturf(AM.loc))
		var/obj/item/I = AM
		I.attack_hand(src)
		if(get_active_held_item() == I) //if our attack_hand() picks up the item...
			visible_message(span_warning("[src] catches [I]!"), \
							span_userdanger("You catch [I] in mid-air!"))
			throw_mode_off(THROW_MODE_TOGGLE)
			return TRUE
	return ..()


/mob/living/carbon/attacked_by(obj/item/I, mob/living/user)
	var/obj/item/bodypart/affecting
	if(user == src)
		affecting = get_bodypart(check_zone(user.zone_selected)) //we're self-mutilating! yay!
	else
		var/zone_hit_chance = 80
		if(body_position == LYING_DOWN) // half as likely to hit a different zone if they're on the ground
			zone_hit_chance += 10
		affecting = get_bodypart(get_random_valid_zone(user.zone_selected, zone_hit_chance))
	if(!affecting) //missing limb? we select the first bodypart (you can never have zero, because of chest)
		affecting = bodyparts[1]
	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)
	send_item_attack_message(I, user, affecting.plaintext_zone, affecting)
	if(I.force)
		var/attack_direction = get_dir(user, src)
		apply_damage(I.force, I.damtype, affecting, wound_bonus = I.wound_bonus, bare_wound_bonus = I.bare_wound_bonus, sharpness = I.get_sharpness(), attack_direction = attack_direction)
		if(I.damtype == BRUTE && IS_ORGANIC_LIMB(affecting))
			if(prob(33))
				I.add_mob_blood(src)
				var/turf/location = get_turf(src)
				add_splatter_floor(location)
				if(get_dist(user, src) <= 1) //people with TK won't get smeared with blood
					user.add_mob_blood(src)
				if(affecting.body_zone == BODY_ZONE_HEAD)
					if(wear_mask)
						wear_mask.add_mob_blood(src)
						update_worn_mask()
					if(wear_neck)
						wear_neck.add_mob_blood(src)
						update_worn_neck()
					if(head)
						head.add_mob_blood(src)
						update_worn_head()

		return TRUE //successful attack

/mob/living/carbon/send_item_attack_message(obj/item/I, mob/living/user, hit_area, obj/item/bodypart/hit_bodypart)
	if(!I.force && !length(I.attack_verb_simple) && !length(I.attack_verb_continuous))
		return
	var/message_verb_continuous = length(I.attack_verb_continuous) ? "[pick(I.attack_verb_continuous)]" : "attacks"
	var/message_verb_simple = length(I.attack_verb_simple) ? "[pick(I.attack_verb_simple)]" : "attack"
	//SKYRAT EDIT ADDITION BEGIN
	if(I.force && !user.combat_mode && !length(I.attack_verb_simple) && !length(I.attack_verb_continuous))
		var/random = rand(1,2)
		switch(random)
			if(1)
				message_verb_continuous = "<font color='#ee00ff'>glances</font>"
				message_verb_simple = "<font color='#ee00ff'>glance</font>"
			if(2)
				message_verb_continuous = "<font color='#ee00ff'>maims</font>"
				message_verb_simple = "<font color='#ee00ff'>maim</font>"
	//SKYRAT EDIT ADDITION END

	var/extra_wound_details = ""
	if(I.damtype == BRUTE && hit_bodypart.can_dismember())
		var/mangled_state = hit_bodypart.get_mangled_state()
		var/bio_state = hit_bodypart.biological_state
		if((mangled_state & BODYPART_MANGLED_FLESH) && (mangled_state & BODYPART_MANGLED_BONE))
			extra_wound_details = ", threatening to sever it entirely"
		else if((mangled_state & BODYPART_MANGLED_FLESH && I.get_sharpness()) || ((mangled_state & BODYPART_MANGLED_BONE) && (bio_state & BIO_BONE) && !(bio_state & BIO_FLESH)))
			extra_wound_details = ", [I.get_sharpness() == SHARP_EDGED ? "slicing" : "piercing"] through to the bone"
		else if((mangled_state & BODYPART_MANGLED_BONE && I.get_sharpness()) || ((mangled_state & BODYPART_MANGLED_FLESH) && (bio_state & BIO_FLESH) && !(bio_state & BIO_BONE)))
			extra_wound_details = ", [I.get_sharpness() == SHARP_EDGED ? "slicing" : "piercing"] at the remaining tissue"

	var/message_hit_area = ""
	if(hit_area)
		message_hit_area = " in the [hit_area]"
	var/attack_message_spectator = "[src] [message_verb_continuous][message_hit_area] with [I][extra_wound_details]!"
	var/attack_message_victim = "You're [message_verb_continuous][message_hit_area] with [I][extra_wound_details]!"
	var/attack_message_attacker = "You [message_verb_simple] [src][message_hit_area] with [I]!"
	if(user in viewers(src, null))
		attack_message_spectator = "[user] [message_verb_continuous] [src][message_hit_area] with [I][extra_wound_details]!"
		attack_message_victim = "[user] [message_verb_continuous] you[message_hit_area] with [I][extra_wound_details]!"
	if(user == src)
		attack_message_victim = "You [message_verb_simple] yourself[message_hit_area] with [I][extra_wound_details]!"
	visible_message(span_danger("[attack_message_spectator]"),\
		span_userdanger("[attack_message_victim]"), null, COMBAT_MESSAGE_RANGE, user)
	if(user != src)
		to_chat(user, span_danger("[attack_message_attacker]"))
	return TRUE


/mob/living/carbon/attack_drone(mob/living/simple_animal/drone/user)
	return //so we don't call the carbon's attack_hand().

/mob/living/carbon/attack_drone_secondary(mob/living/simple_animal/drone/user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

//ATTACK HAND IGNORING PARENT RETURN VALUE
/mob/living/carbon/attack_hand(mob/living/carbon/human/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		. = TRUE
	for(var/thing in diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			user.ContactContractDisease(D)

	for(var/thing in user.diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			ContactContractDisease(D)

	for(var/datum/surgery/operations as anything in surgeries)
		if(user.combat_mode)
			break
		if(body_position != LYING_DOWN && (operations.surgery_flags & SURGERY_REQUIRE_RESTING))
			continue
		if(operations.next_step(user, modifiers))
			return TRUE

	for(var/datum/wound/wounds as anything in all_wounds)
		if(wounds.try_handling(user))
			return TRUE

	return FALSE


/mob/living/carbon/attack_paw(mob/living/carbon/human/user, list/modifiers)

	if(try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if((D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN) && prob(85))
				user.ContactContractDisease(D)

	for(var/thing in user.diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			ContactContractDisease(D)

	if(!user.combat_mode)
		help_shake_act(user)
		return FALSE

	if(..()) //successful monkey bite.
		for(var/thing in user.diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & (DISEASE_SPREAD_SPECIAL | DISEASE_SPREAD_NON_CONTAGIOUS))
				continue
			ForceContractDisease(D)
		return TRUE


/mob/living/carbon/attack_slime(mob/living/simple_animal/slime/M, list/modifiers)
	if(..()) //successful slime attack
		if(M.powerlevel > 0)
			var/stunprob = M.powerlevel * 7 + 10  // 17 at level 1, 80 at level 10
			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				visible_message(span_danger("The [M.name] shocks [src]!"), \
				span_userdanger("The [M.name] shocks you!"))

				do_sparks(5, TRUE, src)
				var/power = M.powerlevel + rand(0,3)
				Paralyze(power * 2 SECONDS)
				set_stutter_if_lower(power * 2 SECONDS)
				if (prob(stunprob) && M.powerlevel >= 8)
					adjustFireLoss(M.powerlevel * rand(6,10))
					updatehealth()
		return 1

/mob/living/carbon/proc/dismembering_strike(mob/living/attacker, dam_zone)
	if(!attacker.limb_destroyer)
		return dam_zone
	var/obj/item/bodypart/affecting
	if(dam_zone && attacker.client)
		affecting = get_bodypart(get_random_valid_zone(dam_zone))
	else
		var/list/things_to_ruin = shuffle(bodyparts.Copy())
		for(var/B in things_to_ruin)
			var/obj/item/bodypart/bodypart = B
			if(bodypart.body_zone == BODY_ZONE_HEAD || bodypart.body_zone == BODY_ZONE_CHEST)
				continue
			if(!affecting || ((affecting.get_damage() / affecting.max_damage) < (bodypart.get_damage() / bodypart.max_damage)))
				affecting = bodypart
	if(affecting)
		dam_zone = affecting.body_zone
		if(affecting.get_damage() >= affecting.max_damage)
			affecting.dismember()
			return null
		return affecting.body_zone
	return dam_zone

/**
 * Attempt to disarm the target mob.
 * Will shove the target mob back, and drop them if they're in front of something dense
 * or another carbon.
*/
/mob/living/carbon/proc/disarm(mob/living/carbon/target)
	if(zone_selected == BODY_ZONE_PRECISE_MOUTH)
		var/target_on_help_and_unarmed = !target.combat_mode && !target.get_active_held_item()
		if(target_on_help_and_unarmed || HAS_TRAIT(target, TRAIT_RESTRAINED))
			do_slap_animation(target)
			playsound(target.loc, 'sound/weapons/slap.ogg', 50, TRUE, -1)
			visible_message("<span class='danger'>[src] slaps [target] in the face!</span>",
				"<span class='notice'>You slap [target] in the face! </span>",\
			"You hear a slap.")
			target.dna?.species?.stop_wagging_tail(target)
			return
	//SKYRAT EDIT ADDITION BEGIN - EMOTES
	if(zone_selected == BODY_ZONE_PRECISE_GROIN && target.dir == src.dir)
		if(HAS_TRAIT(target, TRAIT_PERSONALSPACE) && (target.stat != UNCONSCIOUS) && (!target.handcuffed)) //You need to be conscious and uncuffed to use Personal Space
			if(target.combat_mode && (!HAS_TRAIT(target, TRAIT_PACIFISM))) //Being pacified prevents violent counters
				var/obj/item/bodypart/affecting = src.get_bodypart(BODY_ZONE_HEAD)
				if(affecting?.receive_damage(PERSONAL_SPACE_DAMAGE))
					src.update_damage_overlays()
				visible_message(span_danger("[src] tried slapping [target]'s ass, but they were slapped instead!"),
				span_danger("You tried slapping [target]'s ass, but they hit you back, ouch!"),
				"You hear a slap.", ignored_mobs = list(target))
				playsound(target.loc, 'sound/effects/snap.ogg', 50, TRUE, ASS_SLAP_EXTRA_RANGE)
				to_chat(target, span_danger("[src] tried slapping your ass, but you hit them back!"))
				return
			else
				visible_message(span_danger("[src] tried slapping [target]'s ass, but they were blocked!"),
				span_danger("You tried slapping [target]'s ass, but they blocked you!"),
				"You hear a slap.", ignored_mobs = list(target))
				playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, ASS_SLAP_EXTRA_RANGE)
				to_chat(target, span_danger("[src] tried slapping your ass, but you blocked them!"))
				return
		else
			do_ass_slap_animation(target)
			playsound(target.loc, 'sound/weapons/slap.ogg', 50, TRUE, ASS_SLAP_EXTRA_RANGE)
			visible_message("<span class='danger'>[src] slaps [target] right on the ass!</span>",\
				"<span class='notice'>You slap [target] on the ass, how satisfying.</span>",\
				"You hear a slap.", ignored_mobs = list(target))
			to_chat(target, "<span class='danger'>[src] slaps your ass!")
			return
	//SKYRAT EDIT END
	do_attack_animation(target, ATTACK_EFFECT_DISARM)
	playsound(target, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.w_uniform?.add_fingerprint(src)

	SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, src, zone_selected)
	var/shove_dir = get_dir(loc, target.loc)
	var/turf/target_shove_turf = get_step(target.loc, shove_dir)
	var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied
	var/turf/target_old_turf = target.loc

	//Are we hitting anything? or
	if(SEND_SIGNAL(target_shove_turf, COMSIG_CARBON_DISARM_PRESHOVE) & COMSIG_CARBON_ACT_SOLID)
		shove_blocked = TRUE
	else
		target.Move(target_shove_turf, shove_dir)
		if(get_turf(target) == target_old_turf)
			shove_blocked = TRUE

	if(!shove_blocked)
		target.setGrabState(GRAB_PASSIVE)

	if(target.IsKnockdown() && !target.IsParalyzed()) //KICK HIM IN THE NUTS
		target.Paralyze(SHOVE_CHAIN_PARALYZE)
		target.visible_message(span_danger("[name] kicks [target.name] onto [target.p_their()] side!"),
						span_userdanger("You're kicked onto your side by [name]!"), span_hear("You hear aggressive shuffling followed by a loud thud!"), COMBAT_MESSAGE_RANGE, src)
		to_chat(src, span_danger("You kick [target.name] onto [target.p_their()] side!"))
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, SetKnockdown), 0), SHOVE_CHAIN_PARALYZE)
		log_combat(src, target, "kicks", "onto their side (paralyzing)")

	var/directional_blocked = FALSE
	var/can_hit_something = (!target.is_shove_knockdown_blocked() && !target.buckled)

	//Directional checks to make sure that we're not shoving through a windoor or something like that
	if(shove_blocked && can_hit_something && (shove_dir in GLOB.cardinals))
		var/target_turf = get_turf(target)
		for(var/obj/obj_content in target_turf)
			if(obj_content.flags_1 & ON_BORDER_1 && obj_content.dir == shove_dir && obj_content.density)
				directional_blocked = TRUE
				break
		if(target_turf != target_shove_turf && !directional_blocked) //Make sure that we don't run the exact same check twice on the same tile
			for(var/obj/obj_content in target_shove_turf)
				if(obj_content.flags_1 & ON_BORDER_1 && obj_content.dir == turn(shove_dir, 180) && obj_content.density)
					directional_blocked = TRUE
					break

	if(can_hit_something)
		//Don't hit people through windows, ok?
		if(!directional_blocked && SEND_SIGNAL(target_shove_turf, COMSIG_CARBON_DISARM_COLLIDE, src, target, shove_blocked) & COMSIG_CARBON_SHOVE_HANDLED)
			return
		if(directional_blocked || shove_blocked)
			target.Knockdown(SHOVE_KNOCKDOWN_SOLID)
			target.visible_message(span_danger("[name] shoves [target.name], knocking [target.p_them()] down!"),
				span_userdanger("You're knocked down from a shove by [name]!"), span_hear("You hear aggressive shuffling followed by a loud thud!"), COMBAT_MESSAGE_RANGE, src)
			to_chat(src, span_danger("You shove [target.name], knocking [target.p_them()] down!"))
			log_combat(src, target, "shoved", "knocking them down")
			return

	target.visible_message(span_danger("[name] shoves [target.name]!"),
		span_userdanger("You're shoved by [name]!"), span_hear("You hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE, src)
	to_chat(src, span_danger("You shove [target.name]!"))

	//Take their lunch money
	var/target_held_item = target.get_active_held_item()
	var/append_message = ""
	if(!is_type_in_typecache(target_held_item, GLOB.shove_disarming_types)) //It's too expensive we'll get caught
		target_held_item = null

	if(!target.has_movespeed_modifier(/datum/movespeed_modifier/shove))
		target.add_movespeed_modifier(/datum/movespeed_modifier/shove)
		if(target_held_item)
			append_message = "loosening [target.p_their()] grip on [target_held_item]"
			target.visible_message(span_danger("[target.name]'s grip on \the [target_held_item] loosens!"), //He's already out what are you doing
				span_warning("Your grip on \the [target_held_item] loosens!"), null, COMBAT_MESSAGE_RANGE)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon, clear_shove_slowdown)), SHOVE_SLOWDOWN_LENGTH)

	else if(target_held_item)
		target.dropItemToGround(target_held_item)
		append_message = "causing [target.p_them()] to drop [target_held_item]"
		target.visible_message(span_danger("[target.name] drops \the [target_held_item]!"),
			span_warning("You drop \the [target_held_item]!"), null, COMBAT_MESSAGE_RANGE)

	log_combat(src, target, "shoved", append_message)

/mob/living/carbon/proc/is_shove_knockdown_blocked() //If you want to add more things that block shove knockdown, extend this
	for (var/obj/item/clothing/clothing in get_equipped_items())
		if(clothing.clothing_flags & BLOCKS_SHOVE_KNOCKDOWN)
			return TRUE
	return FALSE

/mob/living/carbon/proc/clear_shove_slowdown()
	remove_movespeed_modifier(/datum/movespeed_modifier/shove)
	var/active_item = get_active_held_item()
	if(is_type_in_typecache(active_item, GLOB.shove_disarming_types))
		visible_message(span_warning("[name] regains their grip on \the [active_item]!"), span_warning("You regain your grip on \the [active_item]"), null, COMBAT_MESSAGE_RANGE)

/mob/living/carbon/blob_act(obj/structure/blob/B)
	if (stat == DEAD)
		return
	else
		show_message(span_userdanger("The blob attacks!"))
		adjustBruteLoss(10)

/mob/living/carbon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/obj/item/organ/internal_organ as anything in internal_organs)
		internal_organ.emp_act(severity)

///Adds to the parent by also adding functionality to propagate shocks through pulling and doing some fluff effects.
/mob/living/carbon/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	. = ..()
	if(!.)
		return
	//Propagation through pulling, fireman carry
	if(!(flags & SHOCK_ILLUSION))
		if(undergoing_cardiac_arrest())
			set_heartattack(FALSE)
		var/list/shocking_queue = list()
		if(iscarbon(pulling) && source != pulling)
			shocking_queue += pulling
		if(iscarbon(pulledby) && source != pulledby)
			shocking_queue += pulledby
		if(iscarbon(buckled) && source != buckled)
			shocking_queue += buckled
		for(var/mob/living/carbon/carried in buckled_mobs)
			if(source != carried)
				shocking_queue += carried
		//Found our victims, now lets shock them all
		for(var/victim in shocking_queue)
			var/mob/living/carbon/C = victim
			C.electrocute_act(shock_damage*0.75, src, 1, flags)
	//Stun
	var/should_stun = (!(flags & SHOCK_TESLA) || siemens_coeff > 0.5) && !(flags & SHOCK_NOSTUN)
	if(should_stun)
		StaminaKnockdown(10, TRUE)
		//Paralyze(40) - SKYRAT EDIT REMOVAL
	//Jitter and other fluff.
	do_jitter_animation(300)
	adjust_jitter(20 SECONDS)
	adjust_stutter(4 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(secondary_shock), should_stun), 2 SECONDS)
	return shock_damage

///Called slightly after electrocute act to apply a secondary stun.
/mob/living/carbon/proc/secondary_shock(should_stun)
	if(should_stun)
		//Paralyze(60) - SKYRAT EDIT REMOVAL
		StaminaKnockdown(10, TRUE) //SKYRAT EDIT ADDITION

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/helper)
	var/nosound = FALSE //SKYRAT EDIT ADDITION - EMOTES
	if(on_fire)
		to_chat(helper, span_warning("You can't put [p_them()] out with just your bare hands!"))
		return

	if(SEND_SIGNAL(src, COMSIG_CARBON_PRE_MISC_HELP, helper) & COMPONENT_BLOCK_MISC_HELP)
		return

	if(helper == src)
		check_self_for_injuries()
		return

	if(body_position == LYING_DOWN)
		if(buckled)
			to_chat(helper, span_warning("You need to unbuckle [src] first to do that!"))
			return
		helper.visible_message(span_notice("[helper] shakes [src] trying to get [p_them()] up!"), \
						null, span_hear("You hear the rustling of clothes."), DEFAULT_MESSAGE_RANGE, list(helper, src))
		to_chat(helper, span_notice("You shake [src] trying to pick [p_them()] up!"))
		to_chat(src, span_notice("[helper] shakes you to get you up!"))
	//SKYRAT EDIT ADDITION BEGIN - EMOTES -- SENSITIVE SNOUT TRAIT ADDITION
	else if(helper.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		nosound = TRUE
		playsound(src, 'modular_skyrat/modules/emotes/sound/emotes/Nose_boop.ogg', 50, 0)
		if(HAS_TRAIT(src, TRAIT_SENSITIVESNOUT) && get_location_accessible(src, BODY_ZONE_PRECISE_MOUTH))
			to_chat(src, span_warning("[helper] boops you on your sensitive nose, sending you to the ground!"))
			src.Knockdown(20)
			src.apply_damage(30, STAMINA)
		helper.visible_message(span_notice("[helper] boops [src]'s nose."), span_notice("You boop [src] on the nose."))
	//SKYRAT EDIT ADDITION END
	else if(check_zone(helper.zone_selected) == BODY_ZONE_HEAD && get_bodypart(BODY_ZONE_HEAD)) //Headpats!
		//SKYRAT EDIT ADDITION BEGIN - OVERSIZED HEADPATS
		if(HAS_TRAIT(src, TRAIT_OVERSIZED) && !HAS_TRAIT(helper, TRAIT_OVERSIZED))
			visible_message(span_warning("[helper] tries to pat [src] on the head, but can't reach!"))
			return
		//SKYRAT EDIT ADDITION END
		helper.visible_message(span_notice("[helper] gives [src] a pat on the head to make [p_them()] feel better!"), \
					null, span_hear("You hear a soft patter."), DEFAULT_MESSAGE_RANGE, list(helper, src))
		to_chat(helper, span_notice("You give [src] a pat on the head to make [p_them()] feel better!"))
		to_chat(src, span_notice("[helper] gives you a pat on the head to make you feel better! "))

		if(HAS_TRAIT(src, TRAIT_BADTOUCH))
			to_chat(helper, span_warning("[src] looks visibly upset as you pat [p_them()] on the head."))
		//SKYRAT EDIT ADDITION BEGIN - EMOTES
		if(HAS_TRAIT(src, TRAIT_EXCITABLE))
			var/obj/item/organ/external/tail/src_tail = getorganslot(ORGAN_SLOT_EXTERNAL_TAIL)
			if(src_tail && !(src_tail.wag_flags & WAG_WAGGING))
				emote("wag")
		//SKYRAT EDIT ADDITION END
	else if ((helper.zone_selected == BODY_ZONE_PRECISE_GROIN) && !isnull(src.getorgan(/obj/item/organ/external/tail)))
		helper.visible_message(span_notice("[helper] pulls on [src]'s tail!"), \
					null, span_hear("You hear a soft patter."), DEFAULT_MESSAGE_RANGE, list(helper, src))
		to_chat(helper, span_notice("You pull on [src]'s tail!"))
		to_chat(src, span_notice("[helper] pulls on your tail!"))
		if(HAS_TRAIT(src, TRAIT_BADTOUCH)) //How dare they!
			to_chat(helper, span_warning("[src] makes a grumbling noise as you pull on [p_their()] tail."))
		else
			add_mood_event("tailpulled", /datum/mood_event/tailpulled)

	else if ((helper.zone_selected == BODY_ZONE_PRECISE_GROIN) && (istype(head, /obj/item/clothing/head/costume/kitty) || istype(head, /obj/item/clothing/head/collectable/kitty)))
		var/obj/item/clothing/head/faketail = head
		helper.visible_message(span_danger("[helper] pulls on [src]'s tail... and it rips off!"), \
					null, span_hear("You hear a ripping sound."), DEFAULT_MESSAGE_RANGE, list(helper, src))
		to_chat(helper, span_danger("You pull on [src]'s tail... and it rips off!"))
		to_chat(src, span_userdanger("[helper] pulls on your tail... and it rips off!"))
		playsound(loc, 'sound/effects/cloth_rip.ogg', 75, TRUE)
		dropItemToGround(faketail)
		helper.put_in_hands(faketail)
		helper.add_mood_event("rippedtail", /datum/mood_event/rippedtail)

	else
		if (helper.grab_state >= GRAB_AGGRESSIVE)
			helper.visible_message(span_notice("[helper] embraces [src] in a tight bear hug!"), \
						null, span_hear("You hear the rustling of clothes."), DEFAULT_MESSAGE_RANGE, list(helper, src))
			to_chat(helper, span_notice("You wrap [src] into a tight bear hug!"))
			to_chat(src, span_notice("[helper] squeezes you super tightly in a firm bear hug!"))
		else
			helper.visible_message(span_notice("[helper] hugs [src] to make [p_them()] feel better!"), \
						null, span_hear("You hear the rustling of clothes."), DEFAULT_MESSAGE_RANGE, list(helper, src))
			to_chat(helper, span_notice("You hug [src] to make [p_them()] feel better!"))
			to_chat(src, span_notice("[helper] hugs you to make you feel better!"))

		// Warm them up with hugs
		share_bodytemperature(helper)

		// No moodlets for people who hate touches
		if(!HAS_TRAIT(src, TRAIT_BADTOUCH))
			if (helper.grab_state >= GRAB_AGGRESSIVE)
				add_mood_event("hug", /datum/mood_event/bear_hug)
			else
				if(bodytemperature > helper.bodytemperature)
					if(!HAS_TRAIT(helper, TRAIT_BADTOUCH))
						helper.add_mood_event("hug", /datum/mood_event/warmhug, src) // Hugger got a warm hug (Unless they hate hugs)
					add_mood_event("hug", /datum/mood_event/hug) // Receiver always gets a mood for being hugged
				else
					add_mood_event("hug", /datum/mood_event/warmhug, helper) // You got a warm hug
		else
			if (helper.grab_state >= GRAB_AGGRESSIVE)
				add_mood_event("hug", /datum/mood_event/bad_touch_bear_hug)

		// Let people know if they hugged someone really warm or really cold
		if(helper.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
			to_chat(src, span_warning("It feels like [helper] is over heating as [helper.p_they()] hug[helper.p_s()] you."))
		else if(helper.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
			to_chat(src, span_warning("It feels like [helper] is freezing as [helper.p_they()] hug[helper.p_s()] you."))

		if(bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
			to_chat(helper, span_warning("It feels like [src] is over heating as you hug [p_them()]."))
		else if(bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
			to_chat(helper, span_warning("It feels like [src] is freezing as you hug [p_them()]."))

		if(HAS_TRAIT(helper, TRAIT_FRIENDLY))
			if (helper.mob_mood.sanity >= SANITY_GREAT)
				new /obj/effect/temp_visual/heart(loc)
				add_mood_event("friendly_hug", /datum/mood_event/besthug, helper)
			else if (helper.mob_mood.sanity >= SANITY_DISTURBED)
				add_mood_event("friendly_hug", /datum/mood_event/betterhug, helper)

		if(HAS_TRAIT(src, TRAIT_BADTOUCH))
			to_chat(helper, span_warning("[src] looks visibly upset as you hug [p_them()]."))

	SEND_SIGNAL(src, COMSIG_CARBON_HELP_ACT, helper)
	SEND_SIGNAL(helper, COMSIG_CARBON_HELPED, src)

	adjust_status_effects_on_shake_up()
	set_resting(FALSE)
	if(body_position != STANDING_UP && !resting && !buckled && !HAS_TRAIT(src, TRAIT_FLOORED))
		get_up(TRUE)

	if(!nosound) //SKYRAT EDIT ADDITION - EMOTES
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)

	// Shake animation
	if (incapacitated())
		var/direction = prob(50) ? -1 : 1
		animate(src, pixel_x = pixel_x + SHAKE_ANIMATION_OFFSET * direction, time = 1, easing = QUAD_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)
		animate(pixel_x = pixel_x - (SHAKE_ANIMATION_OFFSET * 2 * direction), time = 1)
		animate(pixel_x = pixel_x + SHAKE_ANIMATION_OFFSET * direction, time = 1, easing = QUAD_EASING | EASE_IN)

/// Check ourselves to see if we've got any shrapnel, return true if we do. This is a much simpler version of what humans do, we only indicate we're checking ourselves if there's actually shrapnel
/mob/living/carbon/proc/check_self_for_injuries()
	if(stat >= UNCONSCIOUS)
		return

	var/embeds = FALSE
	for(var/X in bodyparts)
		var/obj/item/bodypart/LB = X
		for(var/obj/item/I in LB.embedded_objects)
			if(!embeds)
				embeds = TRUE
				// this way, we only visibly try to examine ourselves if we have something embedded, otherwise we'll still hug ourselves :)
				visible_message(span_notice("[src] examines [p_them()]self."), \
					span_notice("You check yourself for shrapnel."))
			if(I.isEmbedHarmless())
				to_chat(src, "\t <a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] stuck to your [LB.name]!</a>")
			else
				to_chat(src, "\t <a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] embedded in your [LB.name]!</a>")

	return embeds


/mob/living/carbon/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash, length = 25)
	var/obj/item/organ/internal/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(!eyes) //can't flash what can't see!
		return

	. = ..()

	var/damage = intensity - get_eye_protection()
	if(.) // we've been flashed
		if(visual)
			return

		switch(damage)
			if(1)
				to_chat(src, span_warning("Your eyes sting a little."))
				if(prob(40))
					eyes.applyOrganDamage(1)

			if(2)
				to_chat(src, span_warning("Your eyes burn."))
				eyes.applyOrganDamage(rand(2, 4))

			if(3 to INFINITY)
				to_chat(src, span_warning("Your eyes itch and burn severely!"))
				eyes.applyOrganDamage(rand(12, 16))

		if(eyes.damage > 10)
			adjust_temp_blindness(damage * 2 SECONDS)
			set_eye_blur_if_lower(damage * rand(6 SECONDS, 12 SECONDS))

			if(eyes.damage > eyes.low_threshold)
				if(!is_nearsighted_from(EYE_DAMAGE) && prob(eyes.damage - eyes.low_threshold))
					to_chat(src, span_warning("Your eyes start to burn badly!"))
					eyes.applyOrganDamage(eyes.low_threshold)

				else if(!is_blind() && prob(eyes.damage - eyes.high_threshold))
					to_chat(src, span_warning("You can't see anything!"))
					eyes.applyOrganDamage(eyes.maxHealth)

			else
				to_chat(src, span_warning("Your eyes are really starting to hurt. This can't be good for you!"))
		return TRUE

	else if(damage == 0 && prob(20)) // just enough protection
		to_chat(src, span_notice("Something bright flashes in the corner of your vision!"))


/mob/living/carbon/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	var/list/reflist = list(intensity) // Need to wrap this in a list so we can pass a reference
	SEND_SIGNAL(src, COMSIG_CARBON_SOUNDBANG, reflist)
	intensity = reflist[1]
	var/ear_safety = get_ear_protection()
	var/obj/item/organ/internal/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	var/effect_amount = intensity - ear_safety
	if(effect_amount > 0)
		if(stun_pwr)
			Paralyze((stun_pwr*effect_amount)*0.1)
			Knockdown(stun_pwr*effect_amount)

		if(ears && (deafen_pwr || damage_pwr))
			var/ear_damage = damage_pwr * effect_amount
			var/deaf = deafen_pwr * effect_amount
			ears.adjustEarDamage(ear_damage,deaf)

			if(ears.damage >= 15)
				to_chat(src, span_warning("Your ears start to ring badly!"))
				if(prob(ears.damage - 5))
					to_chat(src, span_userdanger("You can't hear anything!"))
					// Makes you deaf, enough that you need a proper source of healing, it won't self heal
					// you need earmuffs, inacusiate, or replacement
					ears.setOrganDamage(ears.maxHealth)
			else if(ears.damage >= 5)
				to_chat(src, span_warning("Your ears start to ring!"))
			SEND_SOUND(src, sound('sound/weapons/flash_ring.ogg',0,1,0,250))
		return effect_amount //how soundbanged we are


/mob/living/carbon/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5 //0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		var/obj/item/clothing/hit_clothes
		if(wear_mask)
			hit_clothes = wear_mask
		if(wear_neck)
			hit_clothes = wear_neck
		if(head)
			hit_clothes = head
		if(hit_clothes)
			hit_clothes.take_damage(damage_amount, damage_type, damage_flag, 0)

/mob/living/carbon/can_hear()
	. = FALSE
	var/obj/item/organ/internal/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	if(ears && !HAS_TRAIT(src, TRAIT_DEAF))
		. = TRUE
	if(health <= hardcrit_threshold && !HAS_TRAIT(src, TRAIT_NOHARDCRIT))
		. = FALSE


/mob/living/carbon/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype)
	. = ..()
	check_passout(.)

/mob/living/carbon/proc/get_interaction_efficiency(zone)
	var/obj/item/bodypart/limb = get_bodypart(zone)
	if(!limb)
		return

/mob/living/carbon/setOxyLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype)
	. = ..()
	check_passout(.)

/**
* Check to see if we should be passed out from oyxloss
*/
/mob/living/carbon/proc/check_passout(oxyloss)
	if(!isnum(oxyloss))
		return
	if(oxyloss <= 50)
		if(getOxyLoss() > 50)
			ADD_TRAIT(src, TRAIT_KNOCKEDOUT, OXYLOSS_TRAIT)
	else if(getOxyLoss() <= 50)
		REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, OXYLOSS_TRAIT)

/mob/living/carbon/get_organic_health()
	. = health
	for (var/_limb in bodyparts)
		var/obj/item/bodypart/limb = _limb
		if (!IS_ORGANIC_LIMB(limb))
			. += (limb.brute_dam * limb.body_damage_coeff) + (limb.burn_dam * limb.body_damage_coeff)

/mob/living/carbon/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	if(user != src)
		return ..()

	var/obj/item/bodypart/grasped_part = get_bodypart(zone_selected)
	//SKYRAT EDIT CHANGE BEGIN - MEDICAL
	/*
	if(!grasped_part?.get_modified_bleed_rate())
		return
	var/starting_hand_index = active_hand_index
	if(starting_hand_index == grasped_part.held_index)
		to_chat(src, span_danger("You can't grasp your [grasped_part.name] with itself!"))
		return

	to_chat(src, span_warning("You try grasping at your [grasped_part.name], trying to stop the bleeding..."))
	if(!do_after(src, 0.75 SECONDS))
		to_chat(src, span_danger("You fail to grasp your [grasped_part.name]."))
		return

	var/obj/item/hand_item/self_grasp/grasp = new
	if(starting_hand_index != active_hand_index || !put_in_active_hand(grasp))
		to_chat(src, span_danger("You fail to grasp your [grasped_part.name]."))
		QDEL_NULL(grasp)
		return
	grasp.grasp_limb(grasped_part)
	*/
	self_grasp_bleeding_limb(grasped_part, supress_message)
	//SKYRAT EDIT CHANGE END

/// an abstract item representing you holding your own limb to staunch the bleeding, see [/mob/living/carbon/proc/grabbedby] will probably need to find somewhere else to put this.
/obj/item/hand_item/self_grasp
	name = "self-grasp"
	desc = "Sometimes all you can do is slow the bleeding."
	icon_state = "latexballon"
	inhand_icon_state = "nothing"
	slowdown = 0.5
	item_flags = DROPDEL | ABSTRACT | NOBLUDGEON | SLOWS_WHILE_IN_HAND | HAND_ITEM
	/// The bodypart we're staunching bleeding on, which also has a reference to us in [/obj/item/bodypart/var/grasped_by]
	var/obj/item/bodypart/grasped_part
	/// The carbon who owns all of this mess
	var/mob/living/carbon/user

/obj/item/hand_item/self_grasp/Destroy()
	if(user)
		to_chat(user, span_warning("You stop holding onto your[grasped_part ? " [grasped_part.name]" : "self"]."))
		UnregisterSignal(user, COMSIG_PARENT_QDELETING)
	if(grasped_part)
		UnregisterSignal(grasped_part, list(COMSIG_CARBON_REMOVE_LIMB, COMSIG_PARENT_QDELETING))
		grasped_part.grasped_by = null
		grasped_part.refresh_bleed_rate()
	grasped_part = null
	user = null
	return ..()

/// The limb or the whole damn person we were grasping got deleted or dismembered, so we don't care anymore
/obj/item/hand_item/self_grasp/proc/qdel_void()
	SIGNAL_HANDLER
	qdel(src)

/// We've already cleared that the bodypart in question is bleeding in [the place we create this][/mob/living/carbon/proc/grabbedby], so set up the connections
/obj/item/hand_item/self_grasp/proc/grasp_limb(obj/item/bodypart/grasping_part)
	user = grasping_part.owner
	if(!istype(user))
		stack_trace("[src] attempted to try_grasp() with [isdatum(user) ? user.type : isnull(user) ? "null" : user] user")
		qdel(src)
		return

	grasped_part = grasping_part
	grasped_part.grasped_by = src
	grasped_part.refresh_bleed_rate()
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(qdel_void))
	RegisterSignals(grasped_part, list(COMSIG_CARBON_REMOVE_LIMB, COMSIG_PARENT_QDELETING), PROC_REF(qdel_void))

	user.visible_message(span_danger("[user] grasps at [user.p_their()] [grasped_part.name], trying to stop the bleeding."), span_notice("You grab hold of your [grasped_part.name] tightly."), vision_distance=COMBAT_MESSAGE_RANGE)
	playsound(get_turf(src), 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	return TRUE

#undef SHAKE_ANIMATION_OFFSET
#undef PERSONAL_SPACE_DAMAGE
#undef ASS_SLAP_EXTRA_RANGE
