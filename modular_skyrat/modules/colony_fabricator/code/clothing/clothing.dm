// Jumpsuit

/obj/item/clothing/under/frontier_colonist
	name = "frontier jumpsuit"
	desc = "A heavy grey jumpsuit with extra padding around the joints. Two massive pockets included. \
		No matter what you do to adjust it, its always just slightly too large."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "jumpsuit"
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_digi = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_digi.dmi'
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "jumpsuit"
	inhand_icon_state = null
	has_sensor = SENSOR_COORDS
	random_sensor = FALSE

// Boots

/obj/item/clothing/shoes/jackboots/frontier_colonist
	name = "heavy frontier boots"
	desc = "A well built pair of tall boots usually seen on the feet of explorers, first wave colonists, \
		and larpers across the galaxy."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "boots"
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_digi = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_digi.dmi'
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "boots"
	inhand_icon_state = null
	armor_type = /datum/armor/colonist_clothing
	resistance_flags = NONE

// Jackets

/obj/item/clothing/suit/jacket/frontier_colonist
	name = "frontier trenchcoat"
	desc = "A knee length coat with a water-resistant exterior and relatively comfortable interior. \
		In between? Just enough protective material to stop the odd sharp thing getting through, \
		though don't expect miracles."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "jacket"
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "jacket"
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	inhand_icon_state = null
	armor_type = /datum/armor/colonist_clothing
	resistance_flags = NONE
	allowed = null

/obj/item/clothing/suit/jacket/frontier_colonist/Initialize(mapload)
	. = ..()
	allowed += GLOB.colonist_suit_allowed
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

/obj/item/clothing/suit/jacket/frontier_colonist/short
	name = "frontier jacket"
	desc = "A short coat with a water-resistant exterior and relatively comfortable interior. \
		In between? Just enough protective material to stop the odd sharp thing getting through, \
		though don't expect miracles."
	icon_state = "jacket_short"
	worn_icon_state = "jacket_short"

/obj/item/clothing/suit/jacket/frontier_colonist/medical
	name = "frontier medical jacket"
	desc = "A short coat with a water-resistant exterior and relatively comfortable interior. \
		In between? Just enough protective material to stop the odd sharp thing getting through, \
		though don't expect miracles. This one is colored a bright red and covered in white \
		stripes to denote that someone wearing it might be able to provide medical assistance."
	icon_state = "jacket_med"
	worn_icon_state = "jacket_med"

// Flak Jacket

/obj/item/clothing/suit/frontier_colonist_flak
	name = "frontier flak jacket"
	desc = "A simple flak jacket with an exterior of water-resistant material. \
		Jackets like these are often found on first wave colonists that want some armor \
		due to the fact they can be made easily within a colony core type machine."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "flak"
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "flak"
	inhand_icon_state = null
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	armor_type = /datum/armor/colonist_armor
	resistance_flags = NONE
	allowed = null

/obj/item/clothing/suit/frontier_colonist_flak/Initialize(mapload)
	. = ..()
	allowed += GLOB.colonist_suit_allowed
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

// Various softcaps

/obj/item/clothing/head/soft/frontier_colonist
	name = "frontier cap"
	desc = "It's a robust baseball hat in a rugged green color."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "cap"
	soft_type = "cap"
	soft_suffix = null
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "cap"
	inhand_icon_state = null

/obj/item/clothing/head/soft/frontier_colonist/medic
	name = "frontier medical cap"
	desc = "It's a robust baseball hat in a stylish red color. Has a white diamond to denote its wearer might be able to provide medical assistance."
	icon_state = "cap_medical"
	soft_type = "cap_medical"
	worn_icon_state = "cap_medical"

// Helmet (Is it a helmet? Questionable? I'm not sure what to call this thing)

/obj/item/clothing/head/frontier_colonist_helmet
	name = "frontier soft helmet"
	desc = "A unusual piece of headwear somewhere between a proper helmet and a normal cap."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "tanker"
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "tanker"
	inhand_icon_state = null
	armor_type = /datum/armor/colonist_armor
	resistance_flags = NONE
	flags_inv = 0
	clothing_flags = SNUG_FIT | STACKABLE_HELMET_EXEMPT

// Headset

/obj/item/radio/headset/headset_frontier_colonist
	name = "frontier radio headset"
	desc = "A bulky headset that should hopefully survive exposure to the elements better than station headsets might. \
		Has a built-in antenna allowing the headset to work independently of a communications network."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "radio"
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "radio"
	inhand_icon_state = null
	alternate_worn_layer = FACEMASK_LAYER + 0.5
	subspace_transmission = FALSE

/obj/item/radio/headset/headset_frontier_colonist/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

// Gloves

/obj/item/clothing/gloves/frontier_colonist
	name = "frontier gloves"
	desc = "A sturdy pair of black gloves that'll keep your precious fingers protected from the outside world. \
		They go a bit higher up the arm than most gloves should, and you aren't quite sure why."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "gloves"
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "gloves"
	greyscale_colors = "#3a373e"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

// Special mask

/obj/item/clothing/mask/gas/atmos/frontier_colonist
	name = "frontier gas mask"
	desc = "An improved gas mask commonly seen in places where the atmosphere is less than breathable, \
		but otherwise more or less habitable. Its certified to protect against most biological hazards \
		to boot."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "mask"
	worn_icon = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_digi = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_digi.dmi'
	worn_icon_teshari = 'modular_skyrat/modules/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	worn_icon_state = "mask"
	inhand_icon_state = null
	flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	armor_type = /datum/armor/colonist_hazard
