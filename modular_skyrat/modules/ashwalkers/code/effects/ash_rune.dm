/obj/effect/ash_rune
	name = "ash rune"
	desc = "A remnant of a civilization that was once powerful enough to harness strange energy for transmutations."
	icon = 'modular_skyrat/modules/ashwalkers/icons/ash_ritual.dmi'
	icon_state = "rune"

	/// the list of rituals
	var/list/rituals = list()

	/// the current chosen ritual
	var/datum/ash_ritual/current_ritual = null

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/effect/ash_rune/examine(mob/user)
	. = ..()
	if(!current_ritual)
		. += span_notice("<br>There is no selected ritual at this moment-- use the central rune to select a ritual.")
		return
	. += span_notice("<br>The current ritual is: [current_ritual.name]<br>")
	. += span_warning("The required components are as follows:")
	for(var/the_components in current_ritual.required_components)
		var/atom/component_name = current_ritual.required_components[the_components]
		. += span_warning("[dir_num_to_text(the_components, TRUE)] component is [initial(component_name.name)]")

/obj/effect/ash_rune/Initialize(mapload, spawn_runes = TRUE)
	. = ..()
	// this is just to spawn the "aesthetic" runes around
	if(spawn_runes)
		spawn_side_runes()
	if(!length(rituals))
		generate_rituals()

/obj/effect/ash_rune/Destroy(force)
	rituals = null
	current_ritual = null
	. = ..()

/obj/effect/ash_rune/proc/generate_rituals()
	for(var/type in subtypesof(/datum/ash_ritual))
		var/datum/ash_ritual/spawned_ritual = new type
		rituals[spawned_ritual.name] = spawned_ritual

/obj/effect/ash_rune/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(current_ritual && is_species(user, /datum/species/lizard/ashwalker))
		current_ritual.ritual_start(src)
		return
	current_ritual = tgui_input_list(user, "Choose the ritual to begin...", "Ritual Choice", rituals)
	if(!current_ritual)
		return
	current_ritual = rituals[current_ritual]
	balloon_alert_to_viewers("ritual has been chosen-- examine the central rune for more information.")

/// Used to create the side runes
/obj/effect/ash_rune/proc/spawn_side_runes()
	for(var/direction in GLOB.cardinals)
		var/obj/effect/side_rune/spawning_rune = new (get_step(src, direction))
		spawning_rune.icon_state = "[initial(icon_state)]_[direction]"
		spawning_rune.connected_rune = src

// this is solely for aesthetics... though the central rune will check the directions, of which this is on
/obj/effect/side_rune
	desc = "This rune seems to have some weird vacuum to it."
	icon = 'modular_skyrat/modules/ashwalkers/icons/ash_ritual.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	/// the central rune that this is connected to
	var/obj/effect/ash_rune/connected_rune

// just so that if you attack this, you actually attack the main rune
/obj/effect/side_rune/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(connected_rune)
		connected_rune.attack_hand(user, modifiers)

/obj/effect/side_rune/Destroy(force)
	connected_rune = null
	. = ..()
