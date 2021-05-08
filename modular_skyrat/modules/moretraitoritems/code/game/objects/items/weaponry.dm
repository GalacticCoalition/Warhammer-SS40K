/obj/item/vibro_weapon/ninjasr
	block_chance = 25
	force = 13

/obj/item/clothing/head/susp_bowler
	name = "Odd Bowler"
	desc = "A deep black bowler. Inside the hat, there is a sleek red S, with a smaller X insignia embroidered within. On closer inspection, the brim feels oddly weighted..."
	icon_state = "bowler"
	inhand_icon_state = "bowler"
	force = 3
	throwforce = 45
	throw_speed = 5
	throw_range = 9
	w_class = WEIGHT_CLASS_SMALL
	armour_penetration = 30 //5 points less then a double esword!
	sharpness = SHARP_EDGED

/obj/item/clothing/head/susp_bowler/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, gentle = FALSE, quickstart = TRUE)
	if(ishuman(thrower))
		var/mob/living/carbon/human/I = thrower
		I.throw_mode_off(THROW_MODE_TOGGLE) //so they can catch it on the return.
	return ..()


