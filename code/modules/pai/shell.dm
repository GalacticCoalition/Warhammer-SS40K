/mob/living/silicon/pai/mob_try_pickup(mob/living/user, instant=FALSE)
	if(!possible_chassis[chassis])
		to_chat(user, span_warning("[src]'s current form isn't able to be carried!"))
		return FALSE
	return ..()

/mob/living/silicon/pai/start_pulling(atom/movable/thing, state, force = move_force, supress_message = FALSE)
	return FALSE


/mob/living/silicon/pai/update_resting()
	. = ..()
	if(resting)
		icon_state = "[chassis]_rest"
	else
		icon_state = "[chassis]"
	if(loc != card)
		visible_message(span_notice("[src] [resting? "lays down for a moment..." : "perks up from the ground."]"))

/mob/living/silicon/pai/wabbajack(what_to_randomize, change_flags = WABBAJACK)
	if(length(possible_chassis) < 2)
		return FALSE
	var/holochassis = pick(possible_chassis - chassis)
	set_holochassis(holochassis)
	balloon_alert(src, "[holochassis] composite engaged")
	return TRUE

/**
 * Checks if we are allowed to interact with a radial menu
 *
 * @param {atom} anchor - The atom that is anchoring the menu.
 *
 * @returns {boolean} - TRUE if we are allowed to interact with the menu,
 * 	FALSE otherwise.
 */
/mob/living/silicon/pai/proc/check_menu(atom/anchor)
	if(incapacitated())
		return FALSE
	if(get_turf(src) != get_turf(anchor))
		return FALSE
	if(!isturf(loc) && loc != card)
		balloon_alert(src, "can't do that here")
		return FALSE
	return TRUE

/**
 * Sets a new holochassis skin based on a pAI's choice.
 *
 * @returns {boolean} - True if the skin was successfully set.
 * 	FALSE otherwise.
 */
/mob/living/silicon/pai/proc/choose_chassis()
	var/list/skins = list()
	for(var/holochassis_option in possible_chassis)
		var/image/item_image = image(icon = src.icon, icon_state = holochassis_option)
		skins += list("[holochassis_option]" = item_image)
	sort_list(skins)
	var/atom/anchor = get_atom_on_turf(src)
	var/choice = show_radial_menu(src, anchor, skins, custom_check = CALLBACK(src, .proc/check_menu, anchor), radius = 40, require_near = TRUE)
	if(!choice)
		return FALSE
	set_holochassis(choice)
	balloon_alert(src, "[choice] composite engaged")
	update_resting()
	return TRUE

/**
 * Returns the pAI to card mode.
 *
 * @param {boolean} force - If TRUE, the pAI will be forced to card mode.
 *
 * @returns {boolean} - TRUE if the pAI was forced to card mode.
 * 	FALSE otherwise.
 */
/mob/living/silicon/pai/proc/fold_in(force = FALSE)
	holochassis_ready = FALSE
	if(!force)
		addtimer(VARSET_CALLBACK(src, holochassis_ready, TRUE), HOLOCHASSIS_COOLDOWN)
	else
		addtimer(VARSET_CALLBACK(src, holochassis_ready, TRUE), HOLOCHASSIS_OVERLOAD_COOLDOWN)
	icon_state = "[chassis]"
	if(!holoform)
		. = fold_out(force)
		return FALSE
	visible_message(span_notice("[src] deactivates its holochassis emitter and folds back into a compact card!"))
	stop_pulling()
	if(ispickedupmob(loc))
		var/obj/item/clothing/head/mob_holder/mob_head = loc
		mob_head.release(display_messages = FALSE)
	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = card
	var/turf/target = drop_location()
	card.forceMove(target)
	forceMove(card)
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, PAI_FOLDED)
	ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, PAI_FOLDED)
	set_density(FALSE)
	set_light_on(FALSE)
	holoform = FALSE
	set_resting(resting)
	return TRUE

/**
 * Engage holochassis form.
 *
 * @param {boolean} force - Force the form to engage.
 *
 * @returns {boolean} - TRUE if the form was successfully engaged.
 * 	FALSE otherwise.
 */
/mob/living/silicon/pai/proc/fold_out(force = FALSE)
	if(holochassis_health < 0)
		balloon_alert(src, "emitter repair incomplete")
		return FALSE
	if(!can_holo && !force)
		balloon_alert(src, "emitters are disabled")
		return FALSE
	if(holoform)
		. = fold_in(force)
		return
	if(!holochassis_ready)
		balloon_alert(src, "emitters recycling...")
		return FALSE
	holochassis_ready = FALSE
	addtimer(VARSET_CALLBACK(src, holochassis_ready, TRUE), HOLOCHASSIS_COOLDOWN)
	REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, PAI_FOLDED)
	REMOVE_TRAIT(src, TRAIT_HANDS_BLOCKED, PAI_FOLDED)
	set_density(TRUE)
	if(istype(card.loc, /obj/item/modular_computer))
		var/obj/item/modular_computer/pc = card.loc
		pc.inserted_pai = null
		pc.visible_message(span_notice("[src] ejects itself from [pc]!"))
	if(isliving(card.loc))
		var/mob/living/living_holder = card.loc
		if(!living_holder.temporarilyRemoveItemFromInventory(card))
			balloon_alert(src, "unable to expand")
			return FALSE
	forceMove(get_turf(card))
	card.forceMove(src)
	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = src
	set_light_on(FALSE)
	icon_state = "[chassis]"
	held_state = "[chassis]"
	visible_message(span_boldnotice("[src] folds out its holochassis emitter and forms a holoshell around itself!"))
	holoform = TRUE
	return TRUE

/**
 * Sets the holochassis skin and updates the icons
 *
 * @param {string} choice - The skin that will be used for the pAI holoform
 *
 * @returns {boolean} - TRUE if the skin was successfully set. FALSE otherwise.
 */
/mob/living/silicon/pai/proc/set_holochassis(choice)
	if(!choice)
		return FALSE
	chassis = choice
	icon_state = "[chassis]"
	held_state = "[chassis]"
	desc = "A pAI mobile hard-light holographics emitter. This one appears in the form of a [chassis]."
	return TRUE

/**
 * Toggles the onboard light
 *
 * @returns {boolean} - TRUE if the light was toggled.
 */
/mob/living/silicon/pai/proc/toggle_integrated_light()
	set_light_on(!light_on)
	return TRUE
