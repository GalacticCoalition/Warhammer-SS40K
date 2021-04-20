/obj/item/clothing/under/misc/stripper
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	name = "pink stripper outfit"
	icon_state = "stripper_p"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	mutant_variants = NONE

/obj/item/clothing/under/misc/stripper/green
	name = "green stripper outfit"
	icon_state = "stripper_g"

/obj/item/clothing/under/misc/stripper/mankini
	name = "pink mankini"
	icon_state = "mankini"

/obj/item/clothing/under/croptop
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	name = "crop top"
	desc = "We've saved money by giving you half a shirt!"
	icon_state = "croptop"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/misc/gear_harness
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	name = "gear harness"
	desc = "A simple, inconspicuous harness replacement for a jumpsuit."
	icon_state = "gear_harness"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE

/obj/item/clothing/under/misc/poly_kilt
	name = "polychromic kilt"
	desc = "It's not a skirt!"
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "polykilt"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	mutant_variants = NONE

/obj/item/clothing/under/misc/poly_kilt/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("FFF", "F88", "FFF"))

/obj/item/clothing/under/misc/royalkilt
	name = "royal kilt"
	desc = "A far more modern kilt, the tunic's been tossed for a combat sweater, the Hunting tartan swapped for Royal Stuart, the itchy green socks are now not itchy or green!"
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "royalkilt"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/under/misc/tactical1
	name = "irish tactical uniform"
	desc = "The SAM missiles are in the sky! Faint whiffs of cheap booze and Libyan semtex come off this getup, someone was so kind as to leave a book in one of the pockets, too bad it's all in Gaelic!"
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "tactical1"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/under/rank/security/blackwatch
	name = "security kilt"
	desc = "Youve heard about the B-men, the cruel RUC. Well theres another regiment the devil calls his own. Theyre known as the Black Watch commissioned by the Crown"
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "blackwatch"
	inhand_icon_state = "kilt"
	armor = list(MELEE = 30, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 10, ACID = 20, WOUND = 10)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/under/misc/discounder
	name = "superstar cop uniform"
	desc = "Flare cut trousers and a dirty shirt that might have been classy before someone took a piss in the armpits, it's the dress of a superstar."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "jamrock_suit"

/obj/item/clothing/under/misc/kimunder
	name = "aerostatic suit"
	desc = "A crisp and well-pressed suit; professional, comfortable and curiously authoritative."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "aerostatic_suit"

/obj/item/clothing/under/misc/countess
	name = "countess dress"
	desc = "A wide flowing dress fitting for a countess, maybe not for anyone who enjoys a dress that doesn't catch on things."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "countess_s"

/obj/item/clothing/under/misc/formaldressred
	name = "formal red dress"
	desc = "Not too wide flowing, but big enough to make an impression."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "formalred_s"

/obj/item/clothing/under/misc/peakyblinder
	name = "birmingham bling"
	desc = "A grey suit with a white vest, maybe you run a whiskey plant, maybe you have a frenemy relationship with that guy out of that one film, whatever it is, it's still a nice looking suit."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "peakyblinder"

/obj/item/clothing/under/misc/taccas
	name = "tacticasual uniform"
	desc = "A white wifebeater on top of some cargo pants. For when you need to carry various beers."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "tac_s"

/obj/item/clothing/under/misc/bluetracksuit
	name = "blue tracksuit"
	desc = "Found on a dead homeless man squatting in an alleyway, the classic design has been mass produced to bring terror to the galaxy."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "tracksuit_blue"

/obj/item/clothing/under/misc/hlscience
	name = "ridiculous scientist outfit"
	desc = "The tie is mandatory."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "hl_scientist"

/obj/item/clothing/under/enclaveo
	name = "neo american officer uniform"
	desc = "Throughout the stars, rumors of mad scientists and angry drill sergeant run rampent, of creatures in armor black as night being led by men or women wearing this uniform, they share one thing, a deep, natonalistic zeal of the dream of America."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "enclaveo"
	armor = list(MELEE = 0, BULLET = 10, LASER = 20,ENERGY = 20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/under/enclave
	name = "neo american sergeant uniform"
	desc = "Not as high ranking as the officers often standing in front of them, this outfit is less armored than it's sister."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/uniform.dmi'
	icon_state = "enclave"
	armor = list(MELEE = 0, BULLET = 10, LASER = 10,ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
