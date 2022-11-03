// Ghouls!
/obj/item/bodypart/head/mutant/ghoul
	icon_greyscale = BODYPART_ICON_GHOUL
	is_dimorphic = FALSE
	limb_id = SPECIES_GHOUL

/obj/item/bodypart/chest/mutant/ghoul
	icon_greyscale = BODYPART_ICON_GHOUL
	limb_id = SPECIES_GHOUL
	is_dimorphic = FALSE

/obj/item/bodypart/arm/left/mutant/ghoul
	icon_greyscale = BODYPART_ICON_GHOUL
	limb_id = SPECIES_GHOUL

/obj/item/bodypart/arm/right/mutant/ghoul
	icon_greyscale = BODYPART_ICON_GHOUL
	limb_id = SPECIES_GHOUL

/obj/item/bodypart/leg/left/mutant/ghoul
	icon_greyscale = BODYPART_ICON_GHOUL
	limb_id = SPECIES_GHOUL

/obj/item/bodypart/leg/right/mutant/ghoul
	icon_greyscale = BODYPART_ICON_GHOUL
	limb_id = SPECIES_GHOUL

// LIMBS

/obj/item/bodypart/arm/right/mutant/ghoul/drop_limb(special)
	..() // Create Meat, Remove Limb
	var/percentHealth = 1 - (brute_dam + burn_dam) / max_damage
	if (percentHealth > 0)
		// Create Meat
		var/obj/item/food/meat/slab/newMeat = new /obj/item/food/meat/slab(src.loc)

		. = newMeat // Return MEAT

	qdel(src)

/obj/item/bodypart/arm/left/mutant/ghoul/drop_limb(special)
	..() // Create Meat, Remove Limb
	var/percentHealth = 1 - (brute_dam + burn_dam) / max_damage
	if (percentHealth > 0)
		// Create Meat
		var/obj/item/food/meat/slab/newMeat = new /obj/item/food/meat/slab(src.loc)

		. = newMeat // Return MEAT

	qdel(src)

/obj/item/bodypart/leg/right/mutant/ghoul/drop_limb(special)
	..() // Create Meat, Remove Limb
	var/percentHealth = 1 - (brute_dam + burn_dam) / max_damage
	if (percentHealth > 0)
		// Create Meat
		var/obj/item/food/meat/slab/newMeat = new /obj/item/food/meat/slab(src.loc)

		. = newMeat // Return MEAT

	qdel(src)

/obj/item/bodypart/leg/left/mutant/ghoul/drop_limb(special)
	..() // Create Meat, Remove Limb
	var/percentHealth = 1 - (brute_dam + burn_dam) / max_damage
	if (percentHealth > 0)
		// Create Meat
		var/obj/item/food/meat/slab/newMeat = new /obj/item/food/meat/slab(src.loc)

		. = newMeat // Return MEAT

	qdel(src)
