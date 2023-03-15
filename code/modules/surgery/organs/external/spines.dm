/obj/item/organ/external/spines
	name = "lizard spines"
	desc = "Not an actual spine, obviously."
	icon_state = "spines"

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_SPINES
	layers = EXTERNAL_ADJACENT|EXTERNAL_BEHIND

	feature_key = "spines"
	render_key = "spines"
	preference = "feature_lizard_spines"
	//dna_block = DNA_SPINES_BLOCK // SKYRAT EDIT REMOVAL - Customization - We have our own system to handle DNA.
	restyle_flags = EXTERNAL_RESTYLE_FLESH

	///A two-way reference between the tail and the spines because of wagging sprites. Bruh.
	var/obj/item/organ/external/tail/lizard/paired_tail

/obj/item/organ/external/spines/get_global_feature_list()
	return GLOB.sprite_accessories["spines"] // SKYRAT EDIT - Customization - ORIGINAL: return GLOB.spines_list

/obj/item/organ/external/spines/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
		return FALSE

/obj/item/organ/external/spines/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	. = ..()
	if(.)
<<<<<<< HEAD
		paired_tail = locate(/obj/item/organ/external/tail/lizard) in reciever.external_organs //We want specifically a lizard tail, so we don't use the slot.
=======
		paired_tail = locate(/obj/item/organ/external/tail/lizard) in receiver.organs //We want specifically a lizard tail, so we don't use the slot.
>>>>>>> 9843c236572 (Replaces internal_organs with organs (#73918))

/obj/item/organ/external/spines/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()
	if(paired_tail)
		paired_tail.paired_spines = null
		paired_tail = null
