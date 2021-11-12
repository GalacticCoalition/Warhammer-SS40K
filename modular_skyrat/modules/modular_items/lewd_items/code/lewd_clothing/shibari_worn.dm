/obj/item/clothing/under/shibari
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_uniform.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-digi.dmi'
	worn_icon_taur_snake = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-snake.dmi'
	worn_icon_taur_paw = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-paw.dmi'
	worn_icon_taur_hoof = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-hoof.dmi'
	can_adjust = FALSE
	body_parts_covered = NONE
	strip_delay = 100
	mutant_variants = STYLE_DIGITIGRADE|STYLE_TAUR_ALL
	item_flags = DROPDEL
	var/current_color = "pink"
	var/tight = "low"
	var/rope_amount = 1

/obj/item/clothing/under/shibari/Destroy(force)
	if(!force)
		var/obj/item/stack/shibari_rope/ropes = new(get_turf(src))
		ropes.current_color = current_color
		ropes.amount = rope_amount
		ropes.update_icon_state()
		ropes.update_icon()
	. = ..()

/obj/item/clothing/under/shibari/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"
	worn_icon_state = "[initial(icon_state)]_[current_color]"

/obj/item/clothing/under/shibari/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/under/shibari/Initialize()
	. = ..()
	update_appearance()

/obj/item/clothing/under/shibari/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/human/hooman = user
		if(src == hooman.w_uniform)
			if(HAS_TRAIT(hooman, TRAIT_RIGGER))
				if(do_after(hooman, 20, target = src))
					qdel(src)
			else
				if(do_after(hooman, 100, target = src))
					qdel(src)
		else
			return
	. = ..()


//stuff to apply processing on equip and add mood event for perverts
/obj/item/clothing/under/shibari/equipped(mob/user, slot)
	.=..()
	var/mob/living/carbon/human/hooman = user
	if(src == hooman.w_uniform)
		START_PROCESSING(SSobj, src)
	if(HAS_TRAIT(hooman, TRAIT_ROPEBUNNY))
		hooman.apply_status_effect(/datum/status_effect/ropebunny)

//same stuff as above but for dropping item
/obj/item/clothing/under/shibari/dropped(mob/user, slot)
	.=..()
	STOP_PROCESSING(SSobj, src)
	var/mob/living/carbon/human/hooman = user
	if(HAS_TRAIT(hooman, TRAIT_ROPEBUNNY))
		hooman.remove_status_effect(/datum/status_effect/ropebunny)

////////////////
//BODY BONDAGE//
////////////////

/obj/item/clothing/under/shibari/torso
	name = "Shibari ropes"
	desc = "Nice looking rope bondage."
	icon_state = "shibari_body"

//processing stuff
/obj/item/clothing/under/shibari/torso/process(delta_time)
	var/mob/living/carbon/human/hooman = loc
	if(tight == "low" && hooman.arousal < 15)
		hooman.adjustArousal(0.6 * delta_time)
	if(tight == "medium" && hooman.arousal < 25)
		hooman.adjustArousal(0.6 * delta_time)
	if(tight == "hard" && hooman.arousal < 30)
		hooman.adjustArousal(0.6 * delta_time)
		if(hooman.pain < 25)
			hooman.adjustPain(0.6 * delta_time)
		if(prob(10))
			hooman.adjustOxyLoss(5)

/////////////////
//GROIN BONDAGE//
/////////////////

/obj/item/clothing/under/shibari/groin
	name = "Crotch rope shibari"
	desc = "A rope that teases the wearer's genitals."
	icon_state = "shibari_groin"

//stuff to apply processing on equip and add mood event for perverts
/obj/item/clothing/under/shibari/groin/equipped(mob/user, slot)
	var/mob/living/carbon/human/hooman = user
	if(hooman?.dna?.mutant_bodyparts["taur"])
		slowdown = 4
	else
		slowdown = 0
	. = ..()

//processing stuff
/obj/item/clothing/under/shibari/groin/process(delta_time)
	var/mob/living/carbon/human/hooman = loc
	if(tight == "low" && hooman.arousal < 20)
		hooman.adjustArousal(0.6 * delta_time)
		hooman.adjustPleasure(0.6 * delta_time)
	if(tight == "medium" && hooman.arousal < 40)
		hooman.adjustArousal(0.6 * delta_time)
		hooman.adjustPleasure(0.6 * delta_time)
	if(tight == "hard" && hooman.arousal < 60)
		hooman.adjustArousal(0.6 * delta_time)
		hooman.adjustPleasure(0.6 * delta_time)

////////////////////
//FULLBODY BONDAGE//
////////////////////

/obj/item/clothing/under/shibari/full
	name = "Shibari fullbody ropes"
	desc = "Bondage ropes that covers whole body"
	icon_state = "shibari_fullbody"
	rope_amount = 2

//processing stuff
/obj/item/clothing/under/shibari/full/process(delta_time)
	var/mob/living/carbon/human/hooman = loc
	if(tight == "low" && hooman.arousal < 20)
		hooman.adjustArousal(0.6 * delta_time)
		hooman.adjustPleasure(0.6 * delta_time)
	if(tight == "medium" && hooman.arousal < 40)
		hooman.adjustArousal(0.6 * delta_time)
		hooman.adjustPleasure(0.6 * delta_time)
	if(tight == "hard" && hooman.arousal < 70)
		hooman.adjustArousal(0.6 * delta_time)
		hooman.adjustPleasure(0.6 * delta_time)
		if(hooman.pain < 40)
			hooman.adjustPain(0.6 * delta_time)
		if(prob(10))
			hooman.adjustOxyLoss(5)

////////////////
//ARMS BONDAGE//
////////////////

/obj/item/clothing/gloves/shibari_hands
	name = "Shibari arms bondage"
	desc = "Bondage ropes that cover arms."
	icon_state = "shibari_arms"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_gloves.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_gloves.dmi'
	body_parts_covered = NONE
	strip_delay = 100
	breakouttime = 100
	item_flags = DROPDEL
	var/current_color = "pink"
	var/tight = "low" //can be low, medium and hard.

/obj/item/clothing/gloves/shibari_hands/Destroy()
	var/obj/item/stack/shibari_rope/ropes = new(get_turf(src))
	ropes.current_color = current_color
	ropes.update_icon_state()
	ropes.update_icon()
	. = ..()

//customization stuff
/obj/item/clothing/gloves/shibari_hands/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"
	worn_icon_state = "[initial(icon_state)]_[current_color]"

/obj/item/clothing/gloves/shibari_hands/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/gloves/shibari_hands/Initialize()
	. = ..()
	update_appearance()

//unequip stuff for adding rope to hands
/obj/item/clothing/gloves/shibari_hands/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/human/hooman = user
		if(src == hooman.gloves)
			if(HAS_TRAIT(hooman, TRAIT_RIGGER))
				if(do_after(hooman, 20, target = src))
					qdel(src)
			else
				if(do_after(hooman, 100, target = src))
					qdel(src)
		else
			return
	. = ..()

//stuff to apply mood event for perverts
/obj/item/clothing/gloves/shibari_hands/equipped(mob/user, slot)
	.=..()
	var/mob/living/carbon/human/hooman = user
	if(HAS_TRAIT(hooman, TRAIT_ROPEBUNNY))
		hooman.apply_status_effect(/datum/status_effect/ropebunny)

//same stuff as above but for dropping item
/obj/item/clothing/gloves/shibari_hands/dropped(mob/user, slot)
	.=..()
	var/mob/living/carbon/human/hooman = user
	if(HAS_TRAIT(hooman, TRAIT_ROPEBUNNY))
		hooman.remove_status_effect(/datum/status_effect/ropebunny)

////////////////
//LEGS BONDAGE//
////////////////

/obj/item/clothing/shoes/shibari_legs
	name = "Shibari arms bondage"
	desc = "Bondage ropes that cover arms."
	icon_state = "shibari_legs"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_shoes.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes_digi.dmi'
	body_parts_covered = NONE
	strip_delay = 100
	mutant_variants = STYLE_DIGITIGRADE|STYLE_TAUR_ALL
	slowdown = 4
	item_flags = DROPDEL
	var/current_color = "pink"
	var/tight = "low"

/obj/item/clothing/shoes/shibari_legs/Destroy()
	var/obj/item/stack/shibari_rope/ropes = new(get_turf(src))
	ropes.current_color = current_color
	ropes.update_icon_state()
	ropes.update_icon()
	. = ..()

//customization stuff
/obj/item/clothing/shoes/shibari_legs/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"
	worn_icon_state = "[initial(icon_state)]_[current_color]"

/obj/item/clothing/shoes/shibari_legs/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/shoes/shibari_legs/Initialize()
	. = ..()
	update_appearance()

//unequip stuff for adding rope to hands
/obj/item/clothing/shoes/shibari_legs/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/human/hooman = user
		if(src == hooman.shoes)
			if(HAS_TRAIT(hooman, TRAIT_RIGGER))
				if(do_after(hooman, 20, target = src))
					qdel(src)
			else
				if(do_after(hooman, 100, target = src))
					qdel(src)
		else
			return
	. = ..()

//stuff to apply mood event for perverts
/obj/item/clothing/shoes/shibari_legs/equipped(mob/user, slot)
	.=..()
	var/mob/living/carbon/human/hooman = user
	if(HAS_TRAIT(hooman, TRAIT_ROPEBUNNY))
		hooman.apply_status_effect(/datum/status_effect/ropebunny)

//same stuff as above but for dropping item
/obj/item/clothing/shoes/shibari_legs/dropped(mob/user, slot)
	.=..()
	var/mob/living/carbon/human/hooman = user
	if(HAS_TRAIT(hooman, TRAIT_ROPEBUNNY))
		hooman.remove_status_effect(/datum/status_effect/ropebunny)
