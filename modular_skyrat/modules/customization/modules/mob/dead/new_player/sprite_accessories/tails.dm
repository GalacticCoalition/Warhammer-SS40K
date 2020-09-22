/datum/sprite_accessory/tails
	key = "tail"
	generic = "Tail"
	organ_type = /obj/item/organ/tail
	icon = 'modular_skyrat/modules/customization/icons/mob/mutant_bodyparts.dmi'
	special_render_case = TRUE
	relevent_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/tails/get_special_render_state(mob/living/carbon/human/H, icon_state)
	var/obj/item/organ/tail/T = H.getorganslot(ORGAN_SLOT_TAIL)
	if(T && T.wagging)
		icon_state += "_wagging"
	return icon_state

/datum/sprite_accessory/tails/lizard
	recommended_species = list("lizard", "ashwalker", "mammal")
	organ_type = /obj/item/organ/tail/lizard

/datum/sprite_accessory/tails/human
	recommended_species = list("human", "felinid", "mammal")
	organ_type = /obj/item/organ/tail/cat

/datum/sprite_accessory/tails/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
		return TRUE
	return FALSE

/datum/sprite_accessory/tails/none
	name = "None"
	icon_state = "none"
	recommended_species = list("mammal", "human")
	color_src = null
	factual = FALSE

/datum/sprite_accessory/tails/mammal
	icon_state = "none"
	recommended_species = list("mammal", "human")
	icon = 'modular_skyrat/modules/customization/icons/mob/sprite_accessory/tails.dmi'
	organ_type = /obj/item/organ/tail/fluffy/no_wag
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/tails/mammal/wagging
	organ_type = /obj/item/organ/tail/fluffy

/datum/sprite_accessory/tails/mammal/wagging/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/tails/mammal/wagging/batl
	name = "Bat (Long)"
	icon_state = "batl"

/datum/sprite_accessory/tails/mammal/wagging/bats
	name = "Bat (Short)"
	icon_state = "bats"

/datum/sprite_accessory/tails/mammal/wagging/bee
	name = "Bee"
	icon_state = "bee"

/datum/sprite_accessory/tails/mammal/wagging/catbig
	name = "Cat, Big"
	icon_state = "catbig"

/datum/sprite_accessory/tails/mammal/wagging/twocat
	name = "Cat, Double"
	icon_state = "twocat"

/datum/sprite_accessory/tails/mammal/wagging/corvid
	name = "Corvid"
	icon_state = "crow"

/datum/sprite_accessory/tails/mammal/wagging/cow
	name = "Cow"
	icon_state = "cow"

/*/datum/sprite_accessory/tails/mammal/wagging/dtiger //icon = 'icons/mob/mutant_bodyparts.dmi'
	name = "Dark Tiger"
	icon_state = "dtiger"
	color_src = USE_ONE_COLOR
	default_color = DEFAULT_PRIMARY*/

/datum/sprite_accessory/tails/mammal/wagging/eevee
	name = "Eevee"
	icon_state = "eevee"

/datum/sprite_accessory/tails/mammal/wagging/fennec
	name = "Fennec"
	icon_state = "fennec"

/datum/sprite_accessory/tails/mammal/wagging/fish
	name = "Fish"
	icon_state = "fish"

/datum/sprite_accessory/tails/mammal/wagging/fox
	name = "Fox"
	icon_state = "fox"

/datum/sprite_accessory/tails/mammal/wagging/hawk
	name = "Hawk"
	icon_state = "hawk"

/datum/sprite_accessory/tails/mammal/wagging/horse
	name = "Horse"
	icon_state = "horse"
	color_src = USE_ONE_COLOR
	default_color = HAIR

/datum/sprite_accessory/tails/mammal/wagging/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/tails/mammal/wagging/insect
	name = "Insect"
	icon_state = "insect"

/datum/sprite_accessory/tails/mammal/wagging/kangaroo
	name = "kangaroo"
	icon_state = "kangaroo"

/datum/sprite_accessory/tails/mammal/wagging/kitsune
	name = "Kitsune"
	icon_state = "kitsune"

/datum/sprite_accessory/tails/mammal/wagging/lab
	name = "Lab"
	icon_state = "lab"

/*/datum/sprite_accessory/tails/mammal/wagging/ltiger //icon = 'icons/mob/mutant_bodyparts.dmi'
	name = "Light Tiger"
	icon_state = "ltiger"
	color_src = USE_ONE_COLOR
	default_color = DEFAULT_PRIMARY*/

/datum/sprite_accessory/tails/mammal/wagging/murid
	name = "Murid"
	icon_state = "murid"

/datum/sprite_accessory/tails/mammal/wagging/orca
	name = "Orca"
	icon_state = "orca"

/datum/sprite_accessory/tails/mammal/wagging/otie
	name = "Otusian"
	icon_state = "otie"

/datum/sprite_accessory/tails/mammal/wagging/rabbit
	name = "Rabbit"
	icon_state = "rabbit"

/datum/sprite_accessory/tails/mammal/wagging/ailurus
	name = "Red Panda"
	icon_state = "wah"
	extra = TRUE

/datum/sprite_accessory/tails/mammal/wagging/pede
	name = "Scolipede"
	icon_state = "pede"

/datum/sprite_accessory/tails/mammal/wagging/sergal
	name = "Sergal"
	icon_state = "sergal"

/datum/sprite_accessory/tails/mammal/wagging/shark
	name = "Shark"
	icon_state = "shark"

/datum/sprite_accessory/tails/mammal/wagging/shepherd
	name = "Shepherd"
	icon_state = "shepherd"

/datum/sprite_accessory/tails/mammal/wagging/skunk
	name = "Skunk"
	icon_state = "skunk"

/datum/sprite_accessory/tails/mammal/wagging/straighttail
	name = "Straight Tail"
	icon_state = "straighttail"

/datum/sprite_accessory/tails/mammal/wagging/squirrel
	name = "Squirrel"
	icon_state = "squirrel"

/datum/sprite_accessory/tails/mammal/wagging/tamamo_kitsune
	name = "Tamamo Kitsune Tails"
	icon_state = "9sune"

/datum/sprite_accessory/tails/mammal/wagging/tentacle
	name = "Tentacle"
	icon_state = "tentacle"

/datum/sprite_accessory/tails/mammal/wagging/tiger
	name = "Tiger"
	icon_state = "tiger"

/datum/sprite_accessory/tails/mammal/wagging/wolf
	name = "Wolf"
	icon_state = "wolf"

/datum/sprite_accessory/tails/mammal/wagging/guilmon
	name = "Guilmon"
	icon_state = "guilmon"

/datum/sprite_accessory/tails/mammal/wagging/sharknofin
	name = "Shark no fin"
	icon_state = "sharknofin"

/datum/sprite_accessory/tails/mammal/raptor
    name = "Raptor"
    icon_state = "raptor"
