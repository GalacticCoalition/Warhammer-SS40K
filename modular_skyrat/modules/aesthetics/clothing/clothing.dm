//Moves all clothing icons to our own files.
//KEEP THEM UP TO DATE, ITS EASY TO JUST PASTE TG'S UPDATES WHERE NEEDED AND LEAVE OUR UNIQUE ONES PAST THE MARKER-STATE

//These are broken up in case some need re-pathing past the base type (under vs under/rank/x)

///////////////////////////////////////////////////////////////////////SHOES
/obj/item/clothing/shoes
	icon = 'icons/obj/clothing/shoes.dmi'

///////////////////////////////////////////////////////////////////////UNIFORMS



/obj/item/clothing/under/rank/civilian
	icon = 'icons/obj/clothing/under/civilian.dmi'
	worn_icon = 'icons/mob/clothing/under/civilian.dmi'

/obj/item/clothing/under/rank/civilian/chef/skirt
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'

/obj/item/clothing/under/rank/civilian/bartender/skirt
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'

/obj/item/clothing/under/rank/civilian/chef
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'

/obj/item/clothing/under/rank/civilian/bartender
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'

/obj/item/clothing/under/rank/civilian/lawyer/bluesuit
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'

/obj/item/clothing/under/rank/medical
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'

/obj/item/clothing/under/rank/rnd
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'
///////////////////////////////////////////////////////////////////////SUITS

/obj/item/clothing/suit/bio_suit/general
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/suit.dmi'

/obj/item/clothing/suit/bio_suit/security
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/suit.dmi'

/obj/item/clothing/suit/bio_suit/cmo
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/suit.dmi'

/obj/item/clothing/suit/bio_suit/scientist
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/suit.dmi'

/obj/item/clothing/suit/bio_suit/janitor
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/suit.dmi'

/obj/item/clothing/suit/bio_suit/virology
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/suit.dmi'

/obj/item/clothing/suit/toggle/labcoat
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/cmo
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/paramedic
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	icon_state = "labcoat_emt"

/obj/item/clothing/suit/toggle/labcoat/mad
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/genetics
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/chemist
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/virologist
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/science
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/rd
	name = "research directors labcoat"
	desc = "A Nanotrasen standard labcoat for Research Directors. It has extra layers for more protection."
	icon = 'modular_skyrat/modules/aesthetics/clothing/items.dmi'
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/suit.dmi'
	icon_state = "labcoat_rd"
	body_parts_covered = CHEST|ARMS|LEGS
	armor = list(MELEE = 5, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 80, FIRE = 80, ACID = 70)
	mutant_variants = NONE

///////////////////////////////////////////////////////////////////////HEAD
/obj/item/clothing/head/bio_hood
	dynamic_hair_suffix = ""

/obj/item/clothing/head/bio_hood/general
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/head.dmi'

/obj/item/clothing/head/bio_hood/security
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/head.dmi'

/obj/item/clothing/head/bio_hood/cmo
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/head.dmi'

/obj/item/clothing/head/bio_hood/scientist
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/head.dmi'

/obj/item/clothing/head/bio_hood/janitor
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/head.dmi'

/obj/item/clothing/head/bio_hood/virology
	worn_icon = 'modular_skyrat/modules/aesthetics/clothing/head.dmi'

/obj/item/clothing/head/weddingveil
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'

///////////////////////////////////////////////////////////////////////TURTLENECKS
/obj/item/clothing/under/syndicate
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'

/obj/item/clothing/under/syndicate/sniper
	icon = 'icons/obj/clothing/under/syndicate.dmi'
	worn_icon = 'icons/mob/clothing/under/syndicate.dmi'
