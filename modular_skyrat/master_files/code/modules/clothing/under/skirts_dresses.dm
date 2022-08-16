/obj/item/clothing/under/dress
	body_parts_covered = CHEST|GROIN	//For reference
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY //For reference - We dont want to cut a random hole in dresses
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON	//For reference - keep in mind some dresses will need adjusted for digi thighs - hence the link below
	worn_icon_digi = 'modular_skyrat/master_files/icons/mob/clothing/under/skirts_dresses_digi.dmi'
	//God bless the skirt being a subtype of the dress, only need one worn_digi_icon definition

/obj/item/clothing/under/dress/skyrat
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/skirts_dresses.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/under/skirts_dresses.dmi'

/obj/item/clothing/under/dress/skirt/skyrat	//Just so they can stay under TG's skirts in case code needs subtypes of them (also SDMM dropdown looks nicer like this)
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/skirts_dresses.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/under/skirts_dresses.dmi'

//TG's icons only have a dress.dmi, but that means its not ABC-sorted to be beside shorts_pants_shirts.dmi. So its skirts_dresses for us.

/*
*	TG DIGI VERSION DRESSES
*/
/obj/item/clothing/under/dress/striped
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/dress/skirt/plaid
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/*
*	Skirts
*/

//Topless
/obj/item/clothing/under/dress/skirt/skyrat/swept
	name = "swept skirt"
	desc = "Formal skirt."
	icon_state = "skirt_swept"
	body_parts_covered = GROIN

/obj/item/clothing/under/dress/skirt/skyrat/loneskirt
	name = "skirt"
	desc = "Just a skirt! Hope you have a tanktop to wear with this."
	icon_state = "lone_skirt"
	body_parts_covered = GROIN
	greyscale_config = /datum/greyscale_config/loneskirt
	greyscale_config_worn = /datum/greyscale_config/loneskirt/worn
	greyscale_colors = "#5f534a"
	flags_1 = IS_PLAYER_COLORABLE_1
//End Topless
/obj/item/clothing/under/dress/skirt/skyrat/turtleskirt_knit //Essentially the same as the Turtleneck Skirt but with a different texture
	name = "cableknit skirt"
	desc = "A casual turtleneck skirt, with a cableknit pattern."
	icon_state = "turtleskirt_knit"
	custom_price = PAYCHECK_CREW
	greyscale_config = /datum/greyscale_config/turtleskirt_knit
	greyscale_config_worn = /datum/greyscale_config/turtleskirt_knit/worn
	greyscale_colors = "#cc0000#5f5f5f"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/dress/skirt/skyrat/jean
	name = "jean skirt"
	desc = "Technically, is there much difference between these and jorts? It's just one big hole instead of two. Does that make this a jirt?"
	icon_state = "jeanskirt"
	female_sprite_flags = NO_FEMALE_UNIFORM
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	greyscale_config = /datum/greyscale_config/jeanskirt
	greyscale_config_worn = /datum/greyscale_config/jeanskirt/worn
	greyscale_config_worn_digi = /datum/greyscale_config/jeanskirt/worn/digi
	greyscale_colors = "#787878#723E0E#4D7EAC"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/dress/skyrat/shortdress
	name = "short dress"
	desc = "An extremely short dress with a lovely sash and flower - only for those with good self-confidence."
	icon_state = "shortdress"
	greyscale_config = /datum/greyscale_config/shortdress
	greyscale_config_worn = /datum/greyscale_config/shortdress/worn
	greyscale_colors = "#ff3636#363030"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/dress/skyrat/pinktutu
	name = "pink tutu"
	desc = "A fluffy pink tutu."
	icon_state = "pinktutu_s"

/*
*	Dresses
*/

/obj/item/clothing/under/dress/skyrat/flower
	name = "flower dress"
	desc = "Lovely dress. Colored like the autumn leaves."
	icon_state = "flower_dress"
	body_parts_covered = CHEST|GROIN|LEGS

/obj/item/clothing/under/dress/skyrat/redformal
	name = "formal red dress"
	desc = "Not too wide flowing, but big enough to make an impression."
	icon_state = "formalred"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/skyrat/strapless
	name = "strapless dress"
	desc = "Typical formal wear with no straps, instead opting to be tied at the waist. Most likely will need constant adjustments."
	icon_state = "dress_strapless"
	body_parts_covered = CHEST|GROIN|LEGS
	greyscale_config = /datum/greyscale_config/strapless_dress
	greyscale_config_worn = /datum/greyscale_config/strapless_dress/worn
	greyscale_colors = "#cc0000#5f5f5f"
	flags_1 = IS_PLAYER_COLORABLE_1
