/obj/item/clothing/head/cowboy
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/cowboy/skyrat
	name = "SR COWBOY HAT DEBUG"
	desc = "REPORT THIS IF FOUND"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/head/cowboy.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head/cowboy.dmi'
	icon_state = null //Keeps this from showing up under the chameleon hat
	worn_icon_state = null //TG defaults this to "hunter" and breaks our items
	flags_inv = SHOWSPRITEEARS
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0) //TG defaults cowboy hats with armor
	resistance_flags = NONE //TG defaults cowboy hats to fireproof/acidproof

/obj/item/clothing/head/cowboy/skyrat/wide
	name = "wide brimmed hat"
	desc = "A wide-brimmed hat, to keep the sun out of your eyes in style."
	icon_state = "widebrim"
	greyscale_colors = "#4D4D4D#DE9754"
	greyscale_config = /datum/greyscale_config/cowboy_wide
	greyscale_config_worn = /datum/greyscale_config/cowboy_wide/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/cowboy/skyrat/wide/feathered
	name = "wide brimmed feathered hat"
	desc = "A wide-brimmed hat adorned with a feather, the perfect flourish to a rugged outfit."
	icon_state = "widebrim_feathered"
	greyscale_colors = "#4D4D4D#DE9754#D5D5B9"
	greyscale_config = /datum/greyscale_config/cowboy_wide_feathered
	greyscale_config_worn = /datum/greyscale_config/cowboy_wide_feathered/worn

/obj/item/clothing/head/cowboy/skyrat/flat
	name = "flat brimmed hat"
	desc = "A finely made hat with a short flat brim, perfect for an old fashioned shootout."
	icon_state = "flatbrim"
	greyscale_colors = "#BE925B#914C2F"
	greyscale_config = /datum/greyscale_config/cowboy_flat
	greyscale_config_worn = /datum/greyscale_config/cowboy_flat/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/cowboy/skyrat/cattleman
	name = "cattleman hat"
	desc = "A hat with a creased brim and a tall crown, intended to be pushed down further on the head to stay on in harsh weather. Not as relevant in space but still comes in handy."
	icon_state = "cattleman"
	greyscale_colors = "#725443#B2977C"
	greyscale_config = /datum/greyscale_config/cowboy_cattleman
	greyscale_config_worn = /datum/greyscale_config/cowboy_cattleman/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/cowboy/skyrat/cattleman/wide
	name = "wide brimmed cattleman hat"
	desc = "A hat with a wide, slightly creased brim. Good for working in the sun, not so much for fitting through tight gaps."
	icon_state = "cattleman_wide"
	greyscale_colors = "#4D4D4D#5F666E"
	greyscale_config = /datum/greyscale_config/cowboy_cattleman_wide
	greyscale_config_worn = /datum/greyscale_config/cowboy_cattleman_wide/worn
	flags_1 = IS_PLAYER_COLORABLE_1

//Presets
/obj/item/clothing/head/cowboy/skyrat/flat/sheriff
	name = "sheriff hat"
	desc = "A dark brown hat with a smell of whiskey. There's a small set of antlers embroidered on the inside."
	greyscale_colors = "#704640#8f89ae"
	flags_1 = NONE //No recoloring presets

/obj/item/clothing/head/cowboy/skyrat/flat/deputy
	name = "deputy hat"
	desc = "A light brown hat with a smell of iron. There's a small set of antlers embroidered on the inside."
	greyscale_colors = "#c26934#8f89ae"
	flags_1 = NONE //No recoloring presets

/obj/item/clothing/head/cowboy/skyrat/cattleman/sec
	name = "security cattleman hat"
	desc = "A security cattleman hat, perfect for any true lawman."
	greyscale_colors = "#39393F#3F6E9E"
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 20, ACID = 50, WOUND = 4) // same armour as the sec beret
	flags_1 = NONE //No recoloring presets

/obj/item/clothing/head/cowboy/skyrat/cattleman/wide/sec
	name = "wide brimmed security cattleman hat"
	desc = "A bandit turned sheriff, his enforcement is brutal but effective - whether out of fear or respect is unclear, though not many bodies hang high. A peaceful land, a quiet people."
	greyscale_colors = "#39393F#3F6E9E"
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 20, ACID = 50, WOUND = 4) // same armour as the sec beret
	flags_1 = NONE //No recoloring presets

//NOT CHANGED YET
/obj/item/clothing/head/costume/cowboyhat/sheriff
	name = "winter cowboy hat"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	icon_state = "sheriff_hat"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	desc = "A dark hat from the cold wastes of the Frosthill mountains. So it was done, all according to the law. There's a small set of antlers embroidered on the inside."
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR | SHOWSPRITEEARS
