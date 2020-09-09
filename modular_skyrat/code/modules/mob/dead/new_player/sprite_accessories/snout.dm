/datum/sprite_accessory/snouts
	key = "snout"
	generic = "Snout"
	var/use_muzzled_sprites = TRUE

/datum/sprite_accessory/snouts/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)) || !HD || HD.status == BODYPART_ROBOTIC)
		return TRUE
	return FALSE

/datum/sprite_accessory/snouts/none
	name = "None"
	icon_state = "none"
	use_muzzled_sprites = FALSE
	factual = FALSE

/datum/sprite_accessory/snouts/mammal
	icon = 'modular_skyrat/icons/mob/sprite_accessory/snouts.dmi'
	color_src = USE_MATRIXED_COLORS
	recommended_species = list("mammal")

/datum/sprite_accessory/snouts/mammal/bird
	name = "Beak"
	icon_state = "bird"

/datum/sprite_accessory/snouts/mammal/bigbeak
	name = "Big Beak"
	icon_state = "bigbeak"

/datum/sprite_accessory/snouts/mammal/bug
	name = "Bug"
	icon_state = "bug"
	color_src = USE_ONE_COLOR
	extra2 = TRUE
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/mammal/elephant
	name = "Elephant"
	icon_state = "elephant"
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/mammal/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/snouts/mammal/rhino
	name = "Horn"
	icon_state = "rhino"
	extra = TRUE
	extra = MUTCOLORS3

/datum/sprite_accessory/snouts/mammal/rodent
	name = "Rodent"
	icon_state = "rodent"

/datum/sprite_accessory/snouts/mammal/lcanid
	name = "Mammal, Long"
	icon_state = "lcanid"

/datum/sprite_accessory/snouts/mammal/lcanidalt
	name = "Mammal, Long ALT"
	icon_state = "lcanidalt"

/datum/sprite_accessory/snouts/mammal/scanid
	name = "Mammal, Short"
	icon_state = "scanid"

/datum/sprite_accessory/snouts/mammal/scanidalt
	name = "Mammal, Short ALT"
	icon_state = "scanidalt"

/datum/sprite_accessory/snouts/mammal/scanidalt2
	name = "Mammal, Short ALT 2"
	icon_state = "scanidalt2"

/datum/sprite_accessory/snouts/mammal/wolf
	name = "Mammal, Thick"
	icon_state = "wolf"

/datum/sprite_accessory/snouts/mammal/wolfalt
	name = "Mammal, Thick ALT"
	icon_state = "wolfalt"

/datum/sprite_accessory/snouts/mammal/otie
	name = "Otie"
	icon_state = "otie"

/*/datum/sprite_accessory/snouts/mammal/round
	name = "Mammal Round"
	icon_state = "round"
	color_src = USE_ONE_COLOR

/datum/sprite_accessory/snouts/mammal/roundlight
	name = "Mammal Round + Light"
	icon_state = "roundlight"
	color_src = USE_ONE_COLOR*/

/datum/sprite_accessory/snouts/mammal/pede
	name = "Scolipede"
	icon_state = "pede"

/datum/sprite_accessory/snouts/mammal/sergal
	name = "Sergal"
	icon_state = "sergal"

/datum/sprite_accessory/snouts/mammal/shark
	name = "Shark"
	icon_state = "shark"

/datum/sprite_accessory/snouts/mammal/hshark
	name = "hShark"
	icon_state = "hshark"

/*/datum/sprite_accessory/snouts/mammal/sharp
	name = "Mammal Sharp"
	icon_state = "sharp"
	color_src = USE_ONE_COLOR

/datum/sprite_accessory/snouts/mammal/sharplight
	name = "Mammal Sharp + Light"
	icon_state = "sharplight"
	color_src = USE_ONE_COLOR*/

/datum/sprite_accessory/snouts/mammal/skulldog
	name = "Skulldog"
	icon_state = "skulldog"
	extra = TRUE
	//extra_color_src = MATRIXED

/datum/sprite_accessory/snouts/mammal/toucan
	name = "Toucan"
	icon_state = "toucan"

/datum/sprite_accessory/snouts/mammal/redpanda
	name = "WahCoon"
	icon_state = "wah"

/datum/sprite_accessory/snouts/mammal/redpandaalt
	name = "WahCoon ALT"
	icon_state = "wahalt"

/******************************************
**************** Snouts *******************
*************but higher up*****************/

/datum/sprite_accessory/snouts/mammal/fbird
	name = "Beak (Top)"
	icon_state = "fbird"

/datum/sprite_accessory/snouts/mammal/fbigbeak
	name = "Big Beak (Top)"
	icon_state = "fbigbeak"

/datum/sprite_accessory/snouts/mammal/fbug
	name = "Bug (Top)"
	icon_state = "fbug"
	color_src = USE_ONE_COLOR
	extra2 = TRUE
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/mammal/felephant
	name = "Elephant (Top)"
	icon_state = "felephant"
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/mammal/frhino
	name = "Horn (Top)"
	icon_state = "frhino"
	extra = TRUE
	extra = MUTCOLORS3

/datum/sprite_accessory/snouts/mammal/fhusky
	name = "Husky (Top)"
	icon_state = "fhusky"

/datum/sprite_accessory/snouts/mammal/flcanid
	name = "Mammal, Long (Top)"
	icon_state = "flcanid"

/datum/sprite_accessory/snouts/mammal/flcanidalt
	name = "Mammal, Long ALT (Top)"
	icon_state = "flcanidalt"

/datum/sprite_accessory/snouts/mammal/fscanid
	name = "Mammal, Short (Top)"
	icon_state = "fscanid"

/datum/sprite_accessory/snouts/mammal/fscanidalt
	name = "Mammal, Short ALT (Top)"
	icon_state = "fscanidalt"

/datum/sprite_accessory/snouts/mammal/fscanidalt2
	name = "Mammal, Short ALT 2 (Top)"
	icon_state = "fscanidalt2"

/datum/sprite_accessory/snouts/mammal/fwolf
	name = "Mammal, Thick (Top)"
	icon_state = "fwolf"

/datum/sprite_accessory/snouts/mammal/fwolfalt
	name = "Mammal, Thick ALT (Top)"
	icon_state = "fwolfalt"

/datum/sprite_accessory/snouts/mammal/fotie
	name = "Otie (Top)"
	icon_state = "fotie"

/datum/sprite_accessory/snouts/mammal/frodent
	name = "Rodent (Top)"
	icon_state = "frodent"

/*/datum/sprite_accessory/snouts/mammal/fround
	name = "Mammal Round (Top)"
	icon_state = "fround"
	color_src = USE_ONE_COLOR

/datum/sprite_accessory/snouts/mammal/froundlight
	name = "Mammal Round + Light (Top)"
	icon_state = "froundlight"
	color_src = USE_ONE_COLOR*/

/datum/sprite_accessory/snouts/mammal/fpede
	name = "Scolipede (Top)"
	icon_state = "fpede"

/datum/sprite_accessory/snouts/mammal/fsergal
	name = "Sergal (Top)"
	icon_state = "fsergal"

/datum/sprite_accessory/snouts/mammal/fshark
	name = "Shark (Top)"
	icon_state = "fshark"

/*/datum/sprite_accessory/snouts/mammal/fsharp
	name = "Mammal Sharp (Top)"
	icon_state = "fsharp"
	color_src = USE_ONE_COLOR

/datum/sprite_accessory/snouts/mammal/fsharplight
	name = "Mammal Sharp + Light (Top)"
	icon_state = "fsharplight"
	color_src = USE_ONE_COLOR*/

/datum/sprite_accessory/snouts/mammal/ftoucan
	name = "Toucan (Top)"
	icon_state = "ftoucan"

/datum/sprite_accessory/snouts/mammal/fredpanda
	name = "WahCoon (Top)"
	icon_state = "fwah"
