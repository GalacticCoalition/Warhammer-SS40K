/datum/element/clockwork_pickup
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	/// What slots will attempt to shock the equpper
	var/list/equip_slots = list()


/datum/element/clockwork_pickup/Attach(datum/target, list/slots_to_count)
	. = ..()

	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/attempt_shock)

	if(slots_to_count && !length(equip_slots))
		equip_slots = slots_to_count


/datum/element/clockwork_pickup/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_ITEM_EQUIPPED)

/**
 *
 * This proc is called when the user picks or equips up an item with the associated element. This will shock them if they are not a clock cultist, and moreso if they are a blood cultist.
 *
 * Arguments:
 * 	* source - The item being picked up
 *  * equipper - The mob that picked up the item
 * 	* slot - The slot the item was equipped in, unused
 */


/datum/element/clockwork_pickup/proc/attempt_shock(obj/item/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(IS_CLOCK(equipper) || !isliving(equipper) || (length(equip_slots) && !(slot in equip_slots)))
		return

	var/mob/living/equipper_living = equipper
	var/power_multiplier = 1

	if(IS_CULTIST(equipper_living))
		power_multiplier = 2

	to_chat(equipper_living, span_warning("As you [slot == ITEM_SLOT_HANDS ? "touch" : "equip"] [source], you feel a jolt course through you!"))

	equipper_living.dropItemToGround(source, TRUE)
	equipper_living.electrocute_act(25 * power_multiplier, src, 1, SHOCK_NOGLOVES)
