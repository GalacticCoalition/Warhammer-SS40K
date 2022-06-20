#define CUFF_MAXIMUM 3
#define MUTE_CYCLES 5
#define MUTE_MAX_MOD 2
#define BONUS_STAMINA_DAM 35
#define BONUS_STUTTER 10

/obj/item/melee/baton/telescopic/contractor_baton
	/// Bitflags for what upgrades the baton has
	var/upgrade_flags
	/// If the baton lists its upgrades
	var/lists_upgrades = TRUE
	/// Allows you to disguise the contractor baton as something else until you hit something
	var/datum/action/item_action/disguise/baton_disguise

/obj/item/melee/baton/telescopic/contractor_baton/Initialize(mapload)
	. = ..()
	baton_disguise = new(src)
	RegisterSignal(src, COMSIG_ITEM_AFTERATTACK, .proc/undisguise)

/obj/item/melee/baton/telescopic/contractor_baton/attack_secondary(mob/living/victim, mob/living/user, params)
	if(!(upgrade_flags & BATON_CUFF_UPGRADE) || !active)
		return
	for(var/obj/item/restraints/handcuffs/cuff in src.contents)
		cuff.attack(victim, user)
		break
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/melee/baton/telescopic/contractor_baton/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/baton_upgrade))
		add_upgrade(attacking_item)
		balloon_alert(user, "[attacking_item] attached")
	if(!(upgrade_flags & BATON_CUFF_UPGRADE))
		return
	if(!istype(attacking_item, /obj/item/restraints/handcuffs/cable))
		return
	var/cuffcount = 0
	for(var/obj/item/restraints/handcuffs/cuff in src.contents)
		cuffcount++
	if(cuffcount >= CUFF_MAXIMUM)
		balloon_alert(user, "baton at maximum cuffs")
		return
	attacking_item.forceMove(src)
	balloon_alert(user, "[attacking_item] inserted")

/obj/item/melee/baton/telescopic/contractor_baton/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	for(var/obj/item/baton_upgrade/upgrade in src.contents)
		upgrade.forceMove(get_turf(src))
		upgrade_flags &= ~upgrade.upgrade_flag
	tool.play_tool_sound(src)
	desc = initial(desc)

/obj/item/melee/baton/telescopic/contractor_baton/additional_effects_non_cyborg(mob/living/carbon/target, mob/living/user)
	. = ..()
	if(!istype(target))
		return
	if((upgrade_flags & BATON_MUTE_UPGRADE))
		if(target.silent < (MUTE_CYCLES * MUTE_MAX_MOD))
			target.silent = min((target.silent + MUTE_CYCLES), (MUTE_CYCLES * MUTE_MAX_MOD))
	if((upgrade_flags & BATON_FOCUS_UPGRADE))
		if(target == user.mind?.opposing_force?.contractor_hub?.current_contract?.contract.target?.current) // Pain
			target.apply_damage(BONUS_STAMINA_DAM, STAMINA, BODY_ZONE_CHEST)
			target.adjust_timed_status_effect(10 SECONDS, /datum/status_effect/speech/stutter)

/obj/item/melee/baton/telescopic/contractor_baton/examine(mob/user)
	. = ..()
	if(upgrade_flags && lists_upgrades)
		. += "<br><br>[span_boldnotice("[src] has the following upgrades attached:")]"
	for(var/obj/item/baton_upgrade/upgrade in contents)
		. += "<br>[span_notice("[upgrade].")]"

/obj/item/melee/baton/telescopic/contractor_baton/on_transform(obj/item/source, mob/user, active)
	if(baton_disguise.disguised)
		lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
		righthand_file = 'icons/mob/inhands/items_righthand.dmi'
		icon = 'icons/obj/stack_objects.dmi'
		icon_state = "rods"
		inhand_icon_state = "rods"
		user.regenerate_icons()
		update_appearance()
	else
		lefthand_file = initial(lefthand_file)
		righthand_file = initial(righthand_file)
		inhand_icon_state = active ? on_inhand_icon_state : null // When inactive, there is no inhand icon_state.
		icon = initial(icon)
		icon_state = active ? "[initial(icon_state)]_on" : initial(icon_state)
	src.active = active
	playsound(user ? user : src, on_sound, 50, TRUE)
	balloon_alert(user, active ? "extended" : "collapsed")
	return COMPONENT_NO_DEFAULT_MESSAGE


/obj/item/melee/baton/telescopic/contractor_baton/proc/undisguise(datum/source, atom/target, mob/user)
	SIGNAL_HANDLER

	if(!baton_disguise.disguised)
		return
	inhand_icon_state = active ? on_inhand_icon_state : null
	lefthand_file = initial(lefthand_file)
	righthand_file = initial(righthand_file)
	name = initial(name)
	icon = initial(icon)
	icon_state = active ? "[initial(icon_state)]_on" : initial(icon_state)
	desc = initial(desc)
	cooldown = initial(cooldown)
	baton_disguise.disguised = FALSE
	user.regenerate_icons()
	update_appearance()
	balloon_alert(user, "baton undisguised")

/obj/item/melee/baton/telescopic/contractor_baton/proc/disguise(datum/source, mob/user)
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	inhand_icon_state = "rods"
	name = "iron rod"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "rods"
	desc = "Some rods. Can be used for building or something."
	cooldown = initial(cooldown) * 2
	baton_disguise.disguised = TRUE
	user.regenerate_icons()
	update_appearance()
	balloon_alert(user, "baton disguised")

/obj/item/melee/baton/telescopic/contractor_baton/proc/add_upgrade(obj/item/baton_upgrade/upgrade)
	if(!(upgrade_flags & upgrade.upgrade_flag))
		upgrade_flags |= upgrade.upgrade_flag
		upgrade.forceMove(src)

/obj/item/melee/baton/telescopic/contractor_baton/upgraded
	desc = "A compact, specialised baton assigned to Syndicate contractors. Applies light electrical shocks to targets. This one seems to have unremovable parts."

/obj/item/melee/baton/telescopic/contractor_baton/upgraded/Initialize(mapload)
	. = ..()
	var/list/upgrade_subtypes = subtypesof(/obj/item/baton_upgrade)
	for(var/upgrade in upgrade_subtypes)
		var/obj/item/baton_upgrade/the_upgrade = new upgrade()
		add_upgrade(the_upgrade)
	for(var/i in 1 to CUFF_MAXIMUM)
		new/obj/item/restraints/handcuffs/cable(src)

/obj/item/melee/baton/telescopic/contractor_baton/upgraded/wrench_act(mob/living/user, obj/item/tool)
	return

/obj/item/baton_upgrade
	icon = 'modular_skyrat/modules/contractor/icons/baton_upgrades.dmi'
	var/upgrade_flag

/obj/item/baton_upgrade/cuff
	name = "handcuff baton upgrade"
	desc = "Allows the user to apply restraints to a target via baton, requires to be loaded with up to three prior."
	icon_state = "cuff_upgrade"
	upgrade_flag = BATON_CUFF_UPGRADE

/obj/item/baton_upgrade/mute
	name = "mute baton upgrade"
	desc = "Use of the baton on a target will mute them for a short period."
	icon_state = "mute_upgrade"
	upgrade_flag = BATON_MUTE_UPGRADE

/obj/item/baton_upgrade/focus
	name = "focus baton upgrade"
	desc = "Use of the baton on a target, should they be the subject of your contract, will be extra exhausted."
	icon_state = "focus_upgrade"
	upgrade_flag = BATON_FOCUS_UPGRADE

#undef CUFF_MAXIMUM
#undef MUTE_CYCLES
#undef MUTE_MAX_MOD
#undef BONUS_STAMINA_DAM
#undef BONUS_STUTTER
