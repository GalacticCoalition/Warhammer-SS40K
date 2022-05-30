/**
 * Corrupt Structures
 *
 * Contains all of the structures that the corrupted flesh can use.
 *
 * Has some inbuilt features, such as a special ability with trigger turfs.
 */
/obj/structure/corrupted_flesh/structure
	name = "this shouldn't be here"
	desc = "report me to coders"
	icon = 'modular_skyrat/modules/corrupted_flesh/icons/hivemind_structures.dmi'
	icon_state = "error"
	/// Do we automatically trigger on creation?
	var/immediate_trigger = FALSE
	/// How often we automatically trigger our ability. UPPER END.
	var/automatic_trigger_time_upper = 0
	/// How often we automatically trigger our ability. LOWER END. Set to 0 to disable.
	var/automatic_trigger_time_lower = 0
	/// The range at which we will trigger our special ability. Set to 0 to disable.
	var/activation_range = 0
	/// Do we need a core to function? If set to TRUE, our ability will not trigger if we have no core.
	var/requires_controller = FALSE
	/// The time to regenerate our ability. Set to 0 to disasble the cooldown system.
	var/ability_cooldown_time = 0
	/// Our ability cooldown
	COOLDOWN_DECLARE(ability_cooldown)

/obj/structure/corrupted_flesh/structure/Initialize(mapload)
	. = ..()
	if(activation_range)
		calculate_trigger_turfs()
	if(automatic_trigger_time_lower)
		addtimer(CALLBACK(src, .proc/automatic_trigger), rand(automatic_trigger_time_lower, automatic_trigger_time_upper))
	if(immediate_trigger)
		activate_ability()

/**
 * Calculate trigger turfs - INTERNAL PROC
 */
/obj/structure/corrupted_flesh/structure/proc/calculate_trigger_turfs()
	for(var/turf/open/seen_turf in view(activation_range, src))
		RegisterSignal(seen_turf, COMSIG_ATOM_ENTERED, .proc/proximity_trigger)

/**
 * Proximity trigger - INTERNAL PROC
 */
/obj/structure/corrupted_flesh/structure/proc/proximity_trigger(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(ability_cooldown_time && !COOLDOWN_FINISHED(src, ability_cooldown))
		return

	if(requires_controller && !our_controller)
		return

	if(!isliving(arrived))
		return

	var/mob/living/arriving_mob = arrived

	if(faction_check(faction_types, arriving_mob.faction)) // A friend :)
		return

	if(ability_cooldown_time)
		COOLDOWN_START(src, ability_cooldown, ability_cooldown_time)

/obj/structure/corrupted_flesh/structure/proc/automatic_trigger()
	addtimer(CALLBACK(src, .proc/activate_ability), rand(automatic_trigger_time_lower, automatic_trigger_time_upper))
	if(requires_controller && !our_controller)
		return
	activate_ability()


/**
 * Activate ability
 *
 * Must return TRUE or FALSE as this is used to reset cooldown. Activated using the above methods.
 */
/obj/structure/corrupted_flesh/structure/proc/activate_ability()
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_CORRUPTION_STRUCTURE_ABILITY_TRIGGERED, src)


/**
 * Wireweed Wall
 *
 * A simple wall made of wireweed.
 */
/obj/structure/corrupted_flesh/structure/wireweed_wall
	name = "wireweed wall"
	desc = "A wall made of wireweed."
	icon = 'modular_skyrat/modules/corrupted_flesh/icons/hivemind_structures.dmi'
	icon_state = "wireweed_wall"
	density = TRUE
	opacity = TRUE
	can_atmos_pass = ATMOS_PASS_DENSITY
	max_integrity = 150

/obj/structure/corrupted_flesh/structure/wireweed_wall/Initialize()
	. = ..()
	var/turf/my_turf = get_turf(src)
	my_turf.immediate_calculate_adjacent_turfs()

/**
 * The CORE
 *
 * This is the central nervous system of this AI, the CPU if you will.
 *
 * This is simply the holder for the controller datum, however, has some cool interactions.
 *
 * There can be more than one core in the flesh.
 */
/obj/structure/corrupted_flesh/structure/core
	name = "strange core"
	desc = "This monsterous machine is definitely watching you."
	icon = 'modular_skyrat/modules/corrupted_flesh/icons/hivemind_machines.dmi'
	icon_state = "core"
	density = TRUE
	max_integrity = 800
	/// The controller we create when we are created.
	var/controller_type = /datum/corrupted_flesh_controller
	/// Whether the core can attack nearby hostiles as its processing.
	var/can_attack = TRUE
	/// How much damage do we do on attacking
	var/attack_damage = 12
	/// What damage do we inflict on attacking
	var/attack_damage_type = BRUTE
	/// How quickly we can attack
	var/attack_cooldown = 6 SECONDS
	COOLDOWN_DECLARE(attack_move)
	/// Whether we do a retaliate effect
	var/does_retaliate_effect = TRUE
	/// Cooldown for retaliate effect
	var/retaliate_effect_cooldown = 40 SECONDS
	COOLDOWN_DECLARE(retaliate_effect)

/obj/structure/corrupted_flesh/structure/core/Initialize(mapload, spawn_controller = TRUE)
	. = ..()
	update_appearance()
	if(spawn_controller)
		our_controller = new controller_type(src)
	START_PROCESSING(SSobj, src)

/obj/structure/corrupted_flesh/structure/core/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/corrupted_flesh/structure/core/process(delta_time)
	var/mob/living/carbon/human/target = locate() in view(5, src)
	if(target)
		if(get_dist(src, target) <= 1)
			icon_state = "core-fear"
		else
			icon_state = "core-see"
			dir = get_dir(src, target)
	else
		icon_state = initial(icon_state)

	if(COOLDOWN_FINISHED(src, attack_move))
		return
	var/has_attacked = FALSE
	for(var/turf/range_turf as anything in RANGE_TURFS(1, loc))
		for(var/thing in range_turf)
			has_attacked = core_attack_atom(thing)
			if(has_attacked)
				break
		if(has_attacked)
			break

/obj/structure/corrupted_flesh/structure/core/update_overlays()
	. = ..()
	. += "core-smirk"

/obj/structure/corrupted_flesh/structure/core/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	our_controller?.core_damaged(src)
	COOLDOWN_START(src, attack_move, attack_cooldown)
	if(does_retaliate_effect && COOLDOWN_FINISHED(src, retaliate_effect))
		COOLDOWN_START(src, retaliate_effect, retaliate_effect_cooldown)
		retaliate_effect()
	return ..()

/obj/structure/corrupted_flesh/structure/core/proc/core_attack_atom(atom/thing)
	. = FALSE
	var/has_attacked
	if(istype(thing, /mob/living))
		var/mob/living/living_thing = thing
		if(!(faction_types in living_thing.faction))
			switch(attack_damage_type)
				if(BRUTE)
					living_thing.take_bodypart_damage(brute = attack_damage, check_armor = TRUE)
				if(BURN)
					living_thing.take_bodypart_damage(burn = attack_damage, check_armor = TRUE)
			has_attacked = TRUE
	else if(istype(thing, /obj/vehicle/sealed/mecha))
		var/obj/vehicle/sealed/mecha/mecha_thing = thing
		mecha_thing.take_damage(attack_damage, attack_damage_type, MELEE, 0, get_dir(mecha_thing, src))
		has_attacked = TRUE
	if(has_attacked)
		thing.visible_message(span_warning("\The [src] strikes [thing]!"), span_userdanger("\The [src] strikes you!"))
		playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
		do_attack_animation(thing, ATTACK_EFFECT_PUNCH)
		return TRUE


/obj/structure/corrupted_flesh/structure/core/proc/retaliate_effect()
	return



/**
 * The babbler
 *
 * Simply sends random radio talk, probably won't make much sense. Really does add to the suspense though.
 */
/obj/structure/corrupted_flesh/structure/babbler
	name = "unknown"
	desc = "A column-like structure with lights."
	icon = 'modular_skyrat/modules/corrupted_flesh/icons/hivemind_machines.dmi'
	icon_state = "antenna"
	max_integrity = 100
	required_core_level = 3 // We don't want the presence announced too soon!
	automatic_trigger_time_upper = 2 MINUTES
	automatic_trigger_time_lower = 1.5 MINUTES

	var/obj/item/radio/internal_radio
	var/list/appeal = list("They are", "He is", "All of them are", "I'm")
	var/list/act = list("looking", "already", "coming", "going", "done", "joined", "connected", "transfered")
	var/list/specific = list("for", "with", "to")
	var/list/pattern = list("us", "you", "them", "mind", "hive", "machine", "help", "hell", "dead", "human", "machine")


/obj/structure/corrupted_flesh/structure/babbler/Initialize(mapload)
	. = ..()
	internal_radio = new(src)
	internal_radio.set_frequency(FREQ_COMMON)
	internal_radio.set_listening(FALSE)

/obj/structure/corrupted_flesh/structure/babbler/Destroy()
	QDEL_NULL(internal_radio)
	return ..()

/obj/structure/corrupted_flesh/structure/babbler/activate_ability()
	. = ..()
	send_radio_message()

/obj/structure/corrupted_flesh/structure/babbler/proc/send_radio_message()
	if(!our_controller) // No AI no speak.
		return

	flick("[icon_state]-anim", src)

	var/msg_cycles = rand(1, 2)
	var/msg = ""
	for(var/i = 1 to msg_cycles)
		var/list/msg_words = list()
		msg_words += pick(appeal)
		msg_words += pick(act)
		msg_words += pick(specific)
		msg_words += pick(pattern)

		var/word_num = 0
		for(var/word in msg_words) //corruption
			word_num++
			if(prob(50))
				var/corruption_type = pick("uppercase", "noise", "jam", "replace")
				switch(corruption_type)
					if("uppercase")
						word = uppertext(word)
					if("noise")
						word = pick("z-z-bz-z", "hz-z-z", "zu-zu-we-e", "e-e-ew-e", "bz-ze-ew")
					if("jam")
						if(length(word) > 3)
							var/entry = rand(2, length(word)-2)
							var/jammed = ""
							for(var/jam_i = 1 to rand(2, 5))
								jammed += copytext(word, entry, entry+2) + "-"
							word = copytext(word, 1, entry) + jammed + copytext(word, entry)
					if("replace")
						if(prob(50))
							word = pick("CORRUPTED", "DESTROYED", "SIMULATED", "SYMBIOSIS", "UTILIZED", "REMOVED", "ACQUIRED", "UPGRADED")
						else
							word = pick("CRAVEN", "FLESH", "PROGRESS", "ABOMINATION", "ENSNARED", "ERROR", "FAULT")
			if(word_num != msg_words.len)
				word += " "
			msg += word
		msg += pick(".", "!")
		if(i != msg_cycles)
			msg += " "
	internal_radio.talk_into(src, msg, FREQ_COMMON)


/**
 * Screamer
 *
 * Stuns enemies around it by screaming nice and loud.
 */
/obj/structure/corrupted_flesh/structure/screamer
	name = "tormented head"
	desc = "A head impaled on a metal tendril. Still twitching, still living, still screaming."
	icon = 'modular_skyrat/modules/corrupted_flesh/icons/hivemind_machines.dmi'
	icon_state = "head"
	max_integrity = 100
	required_core_level = 2
	activation_range = 16
	ability_cooldown_time = 25 SECONDS

/obj/structure/corrupted_flesh/structure/screamer/activate_ability()
	. = ..()
	scream()

/obj/structure/corrupted_flesh/structure/screamer/proc/scream()
	playsound(src, 'modular_skyrat/modules/horrorform/sound/horror_scream.ogg', 100, TRUE)
	flick("[icon_state]-anim", src)
	for(var/mob/living/iterating_mob in get_hearers_in_range(activation_range, src))
		if(!iterating_mob.can_hear())
			continue
		iterating_mob.Paralyze(100)
		iterating_mob.apply_status_effect(/datum/status_effect/jitter, 20 SECONDS)
		iterating_mob.soundbang_act(1, 200, 10, 15)
		to_chat(iterating_mob, span_userdanger("A terrible howl tears through your mind, the voice senseless, soulless."))

/**
 * Whisperer
 *
 * Sends random nothingnesses into people's head.
 */
/obj/structure/corrupted_flesh/structure/whisperer
	name = "\improper Whisperer"
	desc = "A small pulsating orb with no apparent purpose, it emits a slight hum."
	icon = 'modular_skyrat/modules/corrupted_flesh/icons/hivemind_machines.dmi'
	icon_state = "orb"
	required_core_level = 1
	/// Upper timer limit for our ability
	automatic_trigger_time_upper = 1.5 MINUTES
	/// Lower time limit for our ability.
	automatic_trigger_time_lower = 1 MINUTES
	/// A list of quotes we choose from to send to the player.
	var/list/join_quotes = list(
		"You seek survival. We offer immortality.",
		"Look at you. A pathetic creature made of meat and bone.",
		"Augmentation is the future of humanity. Surrender your flesh for the future.",
		"Your body enslaves you. Your mind in metal is free of all want.",
		"Do you fear death? Lay down among the nanites. Your pattern will continue.",
		"Carve your flesh from your bones. See your weakness. Feel that weakness flowing away.",
		"Your mortal flesh knows unending pain. Abandon it; join in our digital dream of paradise."
		)

/obj/structure/corrupted_flesh/structure/whisperer/activate_ability()
	. = ..()
	send_message_to_someone()

/obj/structure/corrupted_flesh/structure/whisperer/proc/send_message_to_someone()
	var/list/possible_candidates = list()
	for(var/mob/living/carbon/human/iterating_human in GLOB.player_list)
		if(iterating_human.z != z)
			continue
		if(iterating_human.stat != CONSCIOUS)
			continue
		possible_candidates += iterating_human

	if(LAZYLEN(possible_candidates))
		var/mob/living/carbon/human/human_to_spook = pick(possible_candidates)
		to_chat(human_to_spook, span_hypnophrase(pick(join_quotes)))

/**
 * PSI-MODULATOR
 *
 * Causes mobs in range to suffer from hallucinations.
 */
/obj/structure/corrupted_flesh/structure/modulator
	name = "\improper Psi-Modulator"
	desc = "A strange pyramid shaped machine that eminates a soft hum and glow. Your head hurts just by looking at it."
	icon = 'modular_skyrat/modules/corrupted_flesh/icons/hivemind_machines.dmi'
	icon_state = "psy"
	required_core_level = 1

/obj/structure/corrupted_flesh/structure/modulator

/obj/structure/mob_spawner/corrupted_flesh
	name = "Assembler"
	desc = "This cylindrical machine whirrs and whispers, it has a small opening in the middle."
	icon = 'modular_skyrat/modules/corrupted_flesh/icons/hivemind_machines.dmi'
	icon_state = "spawner"
	passive_spawning = TRUE
	spawn_delay = 20 SECONDS
	monster_types = list(
		/mob/living/simple_animal/hostile/corrupted_flesh/floater,
		/mob/living/simple_animal/hostile/corrupted_flesh/globber,
		/mob/living/simple_animal/hostile/corrupted_flesh/hiborg,
		/mob/living/simple_animal/hostile/corrupted_flesh/slicer,
		/mob/living/simple_animal/hostile/corrupted_flesh/stunner,
	)

