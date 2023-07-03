/datum/surgery_step
	var/name
	var/list/implements = list() //format is path = probability of success. alternatively
	var/implement_type = null //the current type of implement used. This has to be stored, as the actual typepath of the tool may not match the list type.
	var/accept_hand = FALSE //does the surgery step require an open hand? If true, ignores implements. Compatible with accept_any_item.
	var/accept_any_item = FALSE //does the surgery step accept any item? If true, ignores implements. Compatible with require_hand.
	var/time = 10 //how long does the step take?
	var/repeatable = FALSE //can this step be repeated? Make shure it isn't last step, or else the surgeon will be stuck in the loop
	var/list/chems_needed = list()  //list of chems needed to complete the step. Even on success, the step will have no effect if there aren't the chems required in the mob.
	var/require_all_chems = TRUE    //any on the list or all on the list?
	var/silicons_obey_prob = FALSE
	var/preop_sound //Sound played when the step is started
	var/success_sound //Sound played if the step succeeded
	var/failure_sound //Sound played if the step fails

/datum/surgery_step/proc/try_op(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	var/success = FALSE
	if(surgery.organ_to_manipulate && !target.get_organ_slot(surgery.organ_to_manipulate))
		to_chat(user, span_warning("[target] seems to be missing the organ necessary to complete this surgery!"))
		return FALSE

	if(accept_hand)
		if(!tool)
			success = TRUE
		if(iscyborg(user))
			success = TRUE

	if(accept_any_item)
		if(tool && tool_check(user, tool))
			success = TRUE

	else if(tool)
		for(var/key in implements)
			var/match = FALSE

			if(ispath(key) && istype(tool, key))
				match = TRUE
			else if(tool.tool_behaviour == key)
				match = TRUE

			if(match)
				implement_type = key
				if(tool_check(user, tool))
					success = TRUE
					break

	if(success)
		if(target_zone == surgery.location)
			if(get_location_accessible(target, target_zone) || (surgery.surgery_flags & SURGERY_IGNORE_CLOTHES))
				initiate(user, target, target_zone, tool, surgery, try_to_fail)
			else
				to_chat(user, span_warning("You need to expose [target]'s [parse_zone(target_zone)] to perform surgery on it!"))
			return TRUE //returns TRUE so we don't stab the guy in the dick or wherever.

	if(repeatable)
		var/datum/surgery_step/next_step = surgery.get_surgery_next_step()
		if(next_step)
			surgery.status++
			if(next_step.try_op(user, target, user.zone_selected, user.get_active_held_item(), surgery))
				return TRUE
			else
				surgery.status--

	return FALSE

#define SURGERY_SLOWDOWN_CAP_MULTIPLIER 2 //increase to make surgery slower but fail less, and decrease to make surgery faster but fail more
#define SURGERY_SPEEDUP_AREA 0.5 // Skyrat Edit Addition - reward for doing surgery in surgery
///Modifier given to surgery speed for dissected bodies.
#define SURGERY_DISSECTION_MODIFIER 1.2

/datum/surgery_step/proc/initiate(mob/living/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	// Only followers of Asclepius have the ability to use Healing Touch and perform miracle feats of surgery.
	// Prevents people from performing multiple simultaneous surgeries unless they're holding a Rod of Asclepius.

	surgery.step_in_progress = TRUE
	var/speed_mod = 1
	var/fail_prob = 0//100 - fail_prob = success_prob
	var/advance = FALSE

	if(preop(user, target, target_zone, tool, surgery) == SURGERY_STEP_FAIL)
		surgery.step_in_progress = FALSE
		return FALSE

	play_preop_sound(user, target, target_zone, tool, surgery) // Here because most steps overwrite preop

	if(tool)
		speed_mod = tool.toolspeed

	if(HAS_TRAIT(target, TRAIT_DISSECTED))
		speed_mod /= SURGERY_DISSECTION_MODIFIER

	var/implement_speed_mod = 1
	if(implement_type) //this means it isn't a require hand or any item step.
		implement_speed_mod = implements[implement_type] / 100.0

	speed_mod /= (get_location_modifier(target) * (1 + surgery.speed_modifier) * implement_speed_mod) * target.mob_surgery_speed_mod
	var/modded_time = time * speed_mod


	fail_prob = min(max(0, modded_time - (time * SURGERY_SLOWDOWN_CAP_MULTIPLIER)),99)//if modded_time > time * modifier, then fail_prob = modded_time - time*modifier. starts at 0, caps at 99
	modded_time = min(modded_time, time * SURGERY_SLOWDOWN_CAP_MULTIPLIER)//also if that, then cap modded_time at time*modifier

	var/was_sleeping = (target.stat != DEAD && target.IsSleeping())

	// Skyrat Edit Addition - reward for doing surgery on calm patients, and for using surgery rooms(ie. surgerying alone)
	if(was_sleeping || HAS_TRAIT(target, TRAIT_NUMBED) || target.stat == DEAD)
		modded_time *= SURGERY_SPEEDUP_AREA
		to_chat(user, span_notice("You are able to work faster due to the patient's calm attitude!"))
	var/quiet_enviromnent = TRUE
	for(var/mob/living/carbon/human/loud_people in view(3, target))
		if(loud_people != user && loud_people != target)
			quiet_enviromnent = FALSE
			break
	if(quiet_enviromnent)
		modded_time *= SURGERY_SPEEDUP_AREA
		to_chat(user, span_notice("You are able to work faster due to the quiet environment!"))
	// Skyrat Edit End
	// Skyrat Edit: Cyborgs are no longer immune to surgery speedups.
	//if(iscyborg(user))//any immunities to surgery slowdown should go in this check.
		//modded_time = time
	// Skyrat Edit End

	if(do_after(user, modded_time, target = target, interaction_key = user.has_status_effect(/datum/status_effect/hippocratic_oath) ? target : DOAFTER_SOURCE_SURGERY)) //If we have the hippocratic oath, we can perform one surgery on each target, otherwise we can only do one surgery in total.

		var/chem_check_result = chem_check(target)
		if((prob(100-fail_prob) || (iscyborg(user) && !silicons_obey_prob)) && chem_check_result && !try_to_fail)

			if(success(user, target, target_zone, tool, surgery))
				play_success_sound(user, target, target_zone, tool, surgery)
				advance = TRUE
		else
			if(failure(user, target, target_zone, tool, surgery, fail_prob))
				play_failure_sound(user, target, target_zone, tool, surgery)
				advance = TRUE
			if(chem_check_result)
				return .(user, target, target_zone, tool, surgery, try_to_fail) //automatically re-attempt if failed for reason other than lack of required chemical
		if(advance && !repeatable)
			surgery.status++
			if(surgery.status > surgery.steps.len)
				surgery.complete(user)

	if(target.stat == DEAD && was_sleeping && user.client)
		user.client.give_award(/datum/award/achievement/misc/sandman, user)

	surgery.step_in_progress = FALSE
	return advance

#undef SURGERY_SPEEDUP_AREA // SKYRAT EDIT ADDITION

/datum/surgery_step/proc/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to perform surgery on [target]..."),
		span_notice("[user] begins to perform surgery on [target]."),
		span_notice("[user] begins to perform surgery on [target]."),
	)

/datum/surgery_step/proc/play_preop_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!preop_sound)
		return
	var/sound_file_use
	if(islist(preop_sound))
		for(var/typepath in preop_sound)//iterate and assign subtype to a list, works best if list is arranged from subtype first and parent last
			if(istype(tool, typepath))
				sound_file_use = preop_sound[typepath]
				break
	else
		sound_file_use = preop_sound
	playsound(get_turf(target), sound_file_use, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/datum/surgery_step/proc/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = TRUE)
	SEND_SIGNAL(user, COMSIG_MOB_SURGERY_STEP_SUCCESS, src, target, target_zone, tool, surgery, default_display_results)
	if(default_display_results)
		display_results(
			user,
			target,
			span_notice("You succeed."),
			span_notice("[user] succeeds!"),
			span_notice("[user] finishes."),
		)
	return TRUE

/datum/surgery_step/proc/play_success_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!success_sound)
		return
	playsound(get_turf(target), success_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/datum/surgery_step/proc/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	var/screwedmessage = ""
	switch(fail_prob)
		if(0 to 24)
			screwedmessage = " You almost had it, though."
		if(50 to 74)//25 to 49 = no extra text
			screwedmessage = " This is hard to get right in these conditions..."
		if(75 to 99)
			screwedmessage = " This is practically impossible in these conditions..."

	display_results(
		user,
		target,
		span_warning("You screw up![screwedmessage]"),
		span_warning("[user] screws up!"),
		span_notice("[user] finishes."), TRUE) //By default the patient will notice if the wrong thing has been cut
	return FALSE

/datum/surgery_step/proc/play_failure_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!failure_sound)
		return
	playsound(get_turf(target), failure_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/datum/surgery_step/proc/tool_check(mob/user, obj/item/tool)
	return TRUE

/datum/surgery_step/proc/chem_check(mob/living/target)
	if(!LAZYLEN(chems_needed))
		return TRUE

	if(require_all_chems)
		. = TRUE
		for(var/reagent in chems_needed)
			if(!target.reagents.has_reagent(reagent))
				return FALSE
	else
		. = FALSE
		for(var/reagent in chems_needed)
			if(target.reagents.has_reagent(reagent))
				return TRUE

/datum/surgery_step/proc/get_chem_list()
	if(!LAZYLEN(chems_needed))
		return
	var/list/chems = list()
	for(var/reagent in chems_needed)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[reagent]
		if(temp)
			var/chemname = temp.name
			chems += chemname
	return english_list(chems, and_text = require_all_chems ? " and " : " or ")

<<<<<<< HEAD
=======
// Check if we are entitled to morbid bonuses
/datum/surgery_step/proc/check_morbid_curiosity(mob/user, obj/item/tool, datum/surgery/surgery)
	if(!(user.mind && HAS_TRAIT(user.mind, TRAIT_MORBID)))
		return FALSE
	if(tool && !(tool.item_flags & CRUEL_IMPLEMENT))
		return FALSE
	if(!(surgery.surgery_flags & SURGERY_MORBID_CURIOSITY))
		return FALSE
	return TRUE

>>>>>>> ec86ed37f98 (Increases morbidity factor (fix morbid surgery boost) (#76497))
//Replaces visible_message during operations so only people looking over the surgeon can see them.
/datum/surgery_step/proc/display_results(mob/user, mob/living/target, self_message, detailed_message, vague_message, target_detailed = FALSE)
	user.visible_message(detailed_message, self_message, vision_distance = 1, ignored_mobs = target_detailed ? null : target)
	if(!target_detailed)
		var/you_feel = pick("a brief pain", "your body tense up", "an unnerving sensation")
		if(!vague_message)
			if(detailed_message)
				stack_trace("DIDN'T GET PASSED A VAGUE MESSAGE.")
				vague_message = detailed_message
			else
				stack_trace("NO MESSAGES TO SEND TO TARGET!")
				vague_message = span_notice("You feel [you_feel] as you are operated on.")
		target.show_message(vague_message, MSG_VISUAL, span_notice("You feel [you_feel] as you are operated on."))
/**
 * Sends a pain message to the target, including a chance of screaming.
 *
 * Arguments:
 * * target - Who the message will be sent to
 * * pain_message - The message to be displayed
 * * mechanical_surgery - Boolean flag that represents if a surgery step is done on a mechanical limb (therefore does not force scream)
 */
//SKYRAT EDIT START: Fixes painkillers not actually stopping pain. Adds mood effects to painful surgeries.
/datum/surgery_step/proc/display_pain(mob/living/target, pain_message, mechanical_surgery = FALSE)
	if(target.stat >= UNCONSCIOUS) //the unconscious do not worry about pain
		return
	if(HAS_TRAIT(target, TRAIT_NUMBED)) //numbing helps but is not perfect - this is the tradeoff for being awake
		target.add_mood_event("mild_surgery", /datum/mood_event/mild_surgery)
		return
	if(mechanical_surgery == TRUE) //robots can't benefit from numbing agents like most but have no reason not to sleep - their debuff falls in-between
		target.add_mood_event("robot_surgery", /datum/mood_event/robot_surgery)
		return
	to_chat(target, span_userdanger(pain_message))
	target.add_mood_event("severe_surgery", /datum/mood_event/severe_surgery)
	if(prob(30))
		target.emote("scream")
//SKYRAT EDIT END

#undef SURGERY_DISSECTION_MODIFIER
#undef SURGERY_SLOWDOWN_CAP_MULTIPLIER
