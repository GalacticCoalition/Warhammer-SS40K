/datum/element/snailcrawl
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/snailcrawl/Attach(datum/target)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	var/P
	if(iscarbon(target))
		P = PROC_REF(snail_crawl)
	else
		P = PROC_REF(lubricate)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, P)

/datum/element/snailcrawl/Detach(mob/living/carbon/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	if(istype(target))
		target.remove_movespeed_modifier(/datum/movespeed_modifier/snail_crawl)

/datum/element/snailcrawl/proc/snail_crawl(mob/living/carbon/snail)
	SIGNAL_HANDLER

	if(snail.resting && !snail.buckled && lubricate(snail))
		snail.add_movespeed_modifier(/datum/movespeed_modifier/snail_crawl)
		ADD_TRAIT(snail, TRAIT_NEGATES_GRAVITY, TRAIT_GENERIC) //SKYRAT EDIT BEGIN - This is to prevent snails from achieving FTL speeds without gravity, think of it like snails affixing to walls irl.
		snail.AddElement(/datum/element/forced_gravity, 0)
		if(HAS_TRAIT(snail, TRAIT_SETTLER)) //This is to keep settlers from reaching FTL speeds too.
			snail.remove_movespeed_modifier(/datum/movespeed_modifier/snail_crawl) //SKYRAT EDIT END
	else
		snail.remove_movespeed_modifier(/datum/movespeed_modifier/snail_crawl)
		REMOVE_TRAIT(snail, TRAIT_NEGATES_GRAVITY, TRAIT_GENERIC) //SKYRAT EDIT BEGIN - This clears the forced gravity so they're affected by it while standing.
		snail.RemoveElement(/datum/element/forced_gravity, 0) //SKYRAT EDIT END

/datum/element/snailcrawl/proc/lubricate(atom/movable/snail)
	SIGNAL_HANDLER

	var/turf/open/OT = get_turf(snail)
	if(istype(OT))
		OT.MakeSlippery(TURF_WET_WATER, 1 SECONDS) //SKYRAT EDIT: Roundstart Snails - No more lube
		OT.wash(CLEAN_WASH) //SKYRAT EDIT: Roundstart Snails - Snails Keep Clean
		return TRUE
