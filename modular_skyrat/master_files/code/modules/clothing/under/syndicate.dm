/obj/item/clothing/under/syndicate
	worn_icon_digi = 'modular_skyrat/master_files/icons/mob/clothing/under/syndicate_digi.dmi' // Anything that was in the syndicate.dmi, should be in the syndicate_digi.dmi


/obj/item/clothing/under/syndicate/skyrat
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/syndicate.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/under/syndicate.dmi'
	//These are pre-set for ease and reference, as syndie under items SHOULDNT have sensors and should have similar stats; also its better to start with adjust = false
	has_sensor = NO_SENSORS
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 50, ACID = 40)
	can_adjust = FALSE

//Related files:
// modular_skyrat\modules\Syndie_edits\code\syndie_edits.dm (this has the Overalls and non-Uniforms)
// modular_skyrat\modules\novaya_ert\code\uniform.dm (NRI uniform(s))

/*
*	TACTICOOL
*/

//This is an overwrite, not a fully new item, but still fits best here.
/obj/item/clothing/under/syndicate/tacticool //Overwrites the 'fake' one. Zero armor, sensors, and default blue. More Balanced to make station-available.
	name = "tacticool turtleneck"
	desc = "A snug turtleneck, in fabulous Nanotrasen-blue. Just looking at it makes you want to buy a NT-certifed coffee, go into the office, and -work-."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/syndicate.dmi' //Since its an overwrite it needs new icon linking. Woe.
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/under/syndicate.dmi'
	icon_state = "tactifool_blue"
	inhand_icon_state = "b_suit"
	can_adjust = TRUE
	has_sensor = HAS_SENSORS
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	unique_reskin = list("NT Blue" = "tactifool_blue",
						"Charcoal" = "tactifool"
						)

/obj/item/clothing/under/syndicate/tacticool/reskin_obj(mob/M)
	..()
	if(current_skin && current_skin == "Charcoal")
		desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-." //Default decription of the normal tacticool
		inhand_icon_state = "bl_suit" //May as well, while we're updating it

/obj/item/clothing/under/syndicate/tacticool/skirt //Overwrites the 'fake' one. Zero armor, sensors, and default blue. More Balanced to make station-available.
	name = "tacticool skirtleneck"
	desc = "A snug skirtleneck, in fabulous Nanotrasen-blue. Just looking at it makes you want to buy a NT-certifed coffee, go into the office, and -work-."
	icon_state = "tactifool_blue_skirt"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	unique_reskin = list("NT Blue" = "tactifool_blue_skirt",
						"Charcoal" = "tactifool_skirt"
						)

/obj/item/clothing/under/syndicate/bloodred/sleepytime/sensors //Halloween-only
	has_sensor = HAS_SENSORS
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/*
*	TACTICAL (Real)
*/
//The red alts, for BLATANTLY syndicate stuff (Like DS2)
// (Multiple non-syndicate things use the base tactical turtleneck, they cant have it red nor reskinnable. OUR version, however, can be.)
/obj/item/clothing/under/syndicate/skyrat/tactical
	name = "tactical turtleneck"
	desc = "A snug syndicate-red turtleneck with carcoal-black cargo pants. Good luck arguing allegiance with this on."
	icon_state = "syndicate_red"
	inhand_icon_state = "r_suit"
	can_adjust = TRUE
	alt_covers_chest = TRUE
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 50, ACID = 40)
	unique_reskin = list("Syndicate Red" = "syndicate_red",
						"Charcoal" = "syndicate"
						)

/obj/item/clothing/under/syndicate/skyrat/tactical/reskin_obj(mob/M)
	..()
	if(current_skin && current_skin == "Charcoal")
		desc = "A non-descript and slightly suspicious looking turtleneck with digital camouflage cargo pants." //(Digital camo? Brown? What?)
		inhand_icon_state = "bl_suit"

/obj/item/clothing/under/syndicate/skyrat/tactical/skirt
	name = "tactical skirtleneck"
	desc = "A snug syndicate-red skirtleneck with a carcoal-black skirt. Good luck arguing allegiance with this on."
	icon_state = "syndicate_red_skirt"
	inhand_icon_state = "r_suit"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	unique_reskin = list("Syndicate Red" = "syndicate_red_skirt",
						"Charcoal" = "syndicate_skirt"
						)

/obj/item/clothing/under/syndicate/skyrat/tactical/skirt/reskin_obj(mob/M)
	..()
	if(current_skin && current_skin == "Charcoal")
		desc = "A non-descript and slightly suspicious looking skirtleneck."
		inhand_icon_state = "bl_suit"

/*
*	ENCLAVE
*/
/obj/item/clothing/under/syndicate/skyrat/enclaveo
	name = "neo american officer uniform"
	desc = "Throughout the stars, rumors of mad scientists and angry drill sergeant run rampent, of creatures in armor black as night being led by men or women wearing this uniform, they share one thing, a deep, natonalistic zeal of the dream of America."
	icon_state = "enclaveo"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0, WOUND = 0)

/obj/item/clothing/under/syndicate/skyrat/enclave
	name = "neo american sergeant uniform"
	desc = "Throughout the stars, rumors of mad scientists and angry drill sergeant run rampent, of creatures in armor black as night being led by men or women wearing this uniform, they share one thing, a deep, natonalistic zeal of the dream of America."
	icon_state = "enclave"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0, WOUND = 0)

/obj/item/clothing/under/syndicate/skyrat/enclaveo/real
	name = "neo american officer uniform"
	desc = "Throughout the stars, rumors of mad scientists and angry drill sergeant run rampent, of creatures in armor black as night being led by men or women wearing this uniform, they share one thing, a deep, natonalistic zeal of the dream of America."
	icon_state = "enclaveo"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 50, ACID = 40)

/obj/item/clothing/under/syndicate/skyrat/enclave/real
	name = "neo american sergeant uniform"
	desc = "Throughout the stars, rumors of mad scientists and angry drill sergeant run rampent, of creatures in armor black as night being led by men or women wearing this uniform, they share one thing, a deep, natonalistic zeal of the dream of America."
	icon_state = "enclave"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 50, ACID = 40)
