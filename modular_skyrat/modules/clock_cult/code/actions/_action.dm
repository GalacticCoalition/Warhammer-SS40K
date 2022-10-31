/datum/action/innate/clockcult
	icon_icon = 'modular_skyrat/modules/clock_cult/icons/actions_clock.dmi'
	button_icon = 'modular_skyrat/modules/clock_cult/icons/background_clock.dmi'
	background_icon_state = "bg_clock"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS

/datum/action/innate/clockcult/quick_bind
	name = "Quick Bind"
	button_icon_state = "telerune"
	desc = "A quick bound spell."
	/// Ref to the relevant slab
	var/obj/item/clockwork/clockwork_slab/activation_slab
	/// Ref to the relevant scripture
	var/datum/scripture/scripture

/datum/action/innate/clockcult/quick_bind/Destroy()
	activation_slab = null
	scripture = null
	return ..()

/datum/action/innate/clockcult/quick_bind/Grant(mob/living/recieving_mob)
	name = scripture.name
	desc = scripture.tip
	button_icon_state = scripture.button_icon_state
	if(scripture.power_cost)
		desc += "<br>Draws <b>[scripture.power_cost]W</b> from the ark per use."
	..(recieving_mob)

/datum/action/innate/clockcult/quick_bind/Remove(mob/losing_mob)
	if(activation_slab.invoking_scripture == scripture)
		activation_slab.invoking_scripture = null
	..(losing_mob)

/datum/action/innate/clockcult/quick_bind/IsAvailable()
	if(!(IS_CLOCK(owner)) || owner.incapacitated())
		return FALSE
	return ..()

/datum/action/innate/clockcult/quick_bind/Activate()
	if(!activation_slab)
		return
	if(!activation_slab.invoking_scripture)
		scripture.begin_invoke(owner, activation_slab)
	else
		to_chat(owner, span_brass("You fail to invoke [name]."))

/datum/action/item_action/toggle/clock
	button_icon = 'modular_skyrat/modules/clock_cult/icons/background_clock.dmi'
	background_icon_state = "bg_clock"
