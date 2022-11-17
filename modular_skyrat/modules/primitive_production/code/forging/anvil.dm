/obj/structure/reagent_anvil
	name = "smithing anvil"
	desc = "Essentially a big block of metal that you can hammer other metals on top of, crucial for anyone working metal by hand."
	icon = 'modular_skyrat/modules/primitive_production/icons/forge_structures.dmi'
	icon_state = "anvil_empty"

	anchored = TRUE
	density = TRUE

/obj/structure/reagent_anvil/Initialize(mapload)
	. = ..()

/obj/structure/reagent_anvil/update_appearance()
	. = ..()
	cut_overlays()
	if(!length(contents))
		return

	var/image/overlayed_item = image(icon = contents[1].icon, icon_state = contents[1].icon_state)
	overlayed_item.transform = matrix(, 0, 0, 0, 0.8, 0)
	add_overlay(overlayed_item)

/obj/structure/reagent_anvil/examine(mob/user)
	. = ..()
	. += span_notice("You can place <b>hot metal objects</b> on this using some <b>tongs</b>.")
	. += span_notice("It can be (un)secured with <b>Right Click</b>")

	if(length(contents))
		. += span_notice("It has [contents[1]] sitting on it.")

/obj/structure/reagent_anvil/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!can_interact(user) || !user.canUseTopic(src, be_close = TRUE))
		return

	set_anchored(!anchored)
	balloon_alert_to_viewers(anchored ? "secured" : "unsecured")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/reagent_anvil/wrench_act(mob/living/user, obj/item/tool)
	balloon_alert_to_viewers("deconstructing...")

	if(!do_after(user, 2 SECONDS, src))
		balloon_alert_to_viewers("stopped deconstructing")
		return TRUE

	tool.play_tool_sound(src)
	deconstruct(TRUE)
	return TRUE

/obj/structure/reagent_anvil/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/iron/ten(get_turf(src))
	return ..()

/obj/structure/reagent_anvil/tong_act(mob/living/user, obj/item/tool)
	var/obj/item/forging/forge_item = tool
	var/obj/obj_anvil_search = locate() in contents

	if(forge_item.in_use)
		balloon_alert(user, "already in use")
		return TOOL_ACT_TOOLTYPE_SUCCESS

	var/obj/obj_tong_search = locate() in forge_item.contents
	if(obj_anvil_search && !obj_tong_search)
		obj_anvil_search.forceMove(forge_item)
		update_appearance()
		forge_item.icon_state = "tong_full"
		return TOOL_ACT_TOOLTYPE_SUCCESS

	if(!obj_anvil_search && obj_tong_search)
		obj_tong_search.forceMove(src)
		update_appearance()
		forge_item.icon_state = "tong_empty"
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/reagent_anvil/hammer_act(mob/living/user, obj/item/tool)
	//regardless, we will make a sound
	playsound(src, 'modular_skyrat/modules/primitive_production/sound/hammer_clang.ogg', 50, TRUE, ignore_walls = FALSE)

	//do we have an incomplete item to hammer out? if so, here is our block of code
	var/obj/item/forging/incomplete/locate_incomplete = locate() in contents
	if(locate_incomplete)
		if(COOLDOWN_FINISHED(locate_incomplete, heating_remainder))
			balloon_alert(user, "metal too cool")
			locate_incomplete.times_hit -= 3
			return TOOL_ACT_TOOLTYPE_SUCCESS

		if(COOLDOWN_FINISHED(locate_incomplete, striking_cooldown))
			var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER) * locate_incomplete.average_wait
			COOLDOWN_START(locate_incomplete, striking_cooldown, skill_modifier)
			locate_incomplete.times_hit++
			balloon_alert(user, "good hit")
			user.mind.adjust_experience(/datum/skill/smithing, 1) //A good hit gives minimal experience

			if(locate_incomplete.times_hit >= locate_incomplete.average_hits)
				user.balloon_alert(user, "[locate_incomplete] sounds ready")

			return TOOL_ACT_TOOLTYPE_SUCCESS

		locate_incomplete.times_hit -= 3
		balloon_alert(user, "bad hit")

		if(locate_incomplete.times_hit <= -locate_incomplete.average_hits)
			balloon_alert_to_viewers("[locate_incomplete] breaks")
			qdel(locate_incomplete)
			update_appearance()

		return TOOL_ACT_TOOLTYPE_SUCCESS

	//okay, so we didn't find an incomplete item to hammer, do we have a hammerable item?
	var/obj/locate_obj = locate() in contents
	if(locate_obj && (locate_obj.skyrat_obj_flags & ANVIL_REPAIR))
		if(locate_obj.get_integrity() >= locate_obj.max_integrity)
			balloon_alert(user, "already repaired")
			return TOOL_ACT_TOOLTYPE_SUCCESS

		while(locate_obj.get_integrity() < locate_obj.max_integrity)
			if(!do_after(user, 1 SECONDS, src))
				balloon_alert(user, "stopped repairing")
				return TOOL_ACT_TOOLTYPE_SUCCESS

			locate_obj.repair_damage(locate_obj.get_integrity() + 10)
			user.mind.adjust_experience(/datum/skill/smithing, 5) //repairing does give some experience
			playsound(src, 'modular_skyrat/modules/primitive_production/sound/hammer_clang.ogg', 50, TRUE, ignore_walls = FALSE)

	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/reagent_anvil/hammer_act_secondary(mob/living/user, obj/item/tool)
	hammer_act(user, tool)

/obj/structure/reagent_anvil/onZImpact(turf/impacted_turf, levels, message = TRUE)
	var/mob/living/poor_target = locate(/mob/living) in impacted_turf
	if(!poor_target)
		return ..()

	poor_target.apply_damage(60 * levels, forced = TRUE)

	if(istype(poor_target, /mob/living/carbon)) //If this mob is a carbon, break a few of their limbs
		poor_target.take_bodypart_damage(40 * levels, wound_bonus = 5 * levels)
		poor_target.take_bodypart_damage(40 * levels, wound_bonus = 5 * levels)

	poor_target.AddElement(/datum/element/squish, 30 SECONDS)
	poor_target.visible_message(
		span_bolddanger("[src] falls on [poor_target], crushing them!"),
		span_userdanger("You are crushed by [src]!")
	)
	poor_target.Paralyze(5 SECONDS)
	poor_target.emote("scream")
	playsound(poor_target, 'sound/magic/clockwork/fellowship_armory.ogg', 50, TRUE)
	add_memory_in_range(poor_target, 7, MEMORY_VENDING_CRUSHED, list(DETAIL_PROTAGONIST = poor_target, DETAIL_WHAT_BY = src), story_value = STORY_VALUE_AMAZING, memory_flags = MEMORY_CHECK_BLINDNESS, protagonist_memory_flags = MEMORY_SKIP_UNCONSCIOUS)
	return TRUE
