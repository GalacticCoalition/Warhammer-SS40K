#define CUFF_MAXIMUM 3
#define MUTE_CYCLES 5

/obj/item/melee/baton/telescopic/contractor_baton
	/// Ref to the baton holster, should the baton have one.
	var/obj/item/mod/module/baton_holster/holster
	/// Bitflags for what upgrades the baton has
	var/upgrade_flags

/obj/item/melee/baton/telescopic/contractor_baton/dropped(mob/user, silent)
	. = ..()
	if(!holster)
		return
	holster.undeploy()

/obj/item/melee/baton/telescopic/contractor_baton/attack_secondary(mob/living/victim, mob/living/user, params)
	if(!(upgrade_flags & BATON_CUFF_UPGRADE) || !active)
		return
	for(var/obj/item/restraints/handcuffs/cuff in src.contents)
		cuff.attack(victim, user)
		break

/obj/item/melee/baton/telescopic/contractor_baton/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/baton_upgrade))
		var/obj/item/baton_upgrade/upgrade = attacking_item
		if(!(upgrade_flags & upgrade.upgrade_flag))
			if(!upgrade_flags)
				desc += "<br><br>[span_boldnotice("[src] has the following upgrades attached:")]"
			upgrade_flags |= upgrade.upgrade_flag
			desc += "<br>[span_notice("[attacking_item].")]"
			attacking_item.forceMove(src)
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
	if(!(upgrade_flags & BATON_MUTE_UPGRADE) || !istype(target))
		return
	if(target.silent >= (MUTE_CYCLES * 2))
		return
	target.silent += MUTE_CYCLES //10 seconds of mute a hit up to 20 max

/obj/item/baton_upgrade
	icon = 'modular_skyrat/modules/contractor/icons/baton_upgrades.dmi'
	var/upgrade_flag
	var/upgrade_info = ""

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

#undef CUFF_MAXIMUM
#undef MUTE_CYCLES
