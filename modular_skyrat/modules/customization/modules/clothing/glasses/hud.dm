/obj/item/clothing/glasses/hud/sec/eyepatchsr
	name = "Security Eyepatch Hud"
	desc = "Lost your eye beating an innocent clown? Thankfully your corporate overlords have made something to make up for this. May not do well against flashes."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/eyes.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/eyes.dmi'
	icon_state = "hudpatch"
	inhand_icon_state = "eyepatch"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	hud_trait = TRAIT_SECURITY_HUD
	glass_colour_type = /datum/client_colour/glass_colour/blue

/obj/item/clothing/glasses/hud/med/eyepatchsr
	name = "Medical Eyepatch Hud"
	desc = "Do no harm, maybe harm has befell to you, or your poor eyeball, thankfully there's a way to continue your oath, thankfully it didn't mention sleepdarts or monkey men."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/eyes.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/eyes.dmi'
	icon_state = "medpatch"
	inhand_icon_state = "eyepatch"
	hud_type = DATA_HUD_MEDICAL_ADVANCED
	hud_trait = TRAIT_MEDICAL_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightblue


/obj/item/clothing/glasses/hud/diagnostic/eyepatchsr
	name = "Diagnostic Eyepatch Hud"
	desc = "Lost your eyeball to a rogue borg? Dare to tell a Dogborg to do it's job? Got bored? Whatever the reason, this bit of tech will help you still repair borgs, they'll never need it since they usually do it themselves, but its the thought that counts."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/eyes.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/eyes.dmi'
	icon_state = "robopatch"
	inhand_icon_state = "eyepatch"
	hud_type = DATA_HUD_DIAGNOSTIC_BASIC
	hud_trait = TRAIT_DIAGNOSTIC_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

/obj/item/clothing/glasses/hud/sci/eyepatchsr
	name = "Science Eyepatch Hud"
	desc = "Every few years, the aspiring mad scientist says to themselves 'I've got the castle, the evil laugh and equipment, but what I need is a look', thankfully, Dr. Galox has already covered that for you dear friend, while it doesn't do much beyond scan chemicals, what it lacks in use it makes up for in style."
	icon = 'modular_skyrat/modules/customization/icons/obj/clothing/eyes.dmi'
	worn_icon = 'modular_skyrat/modules/customization/icons/mob/clothing/eyes.dmi'
	icon_state = "scipatch"
	inhand_icon_state = "eyepatch"
	clothing_flags = SCAN_REAGENTS
