/datum/loadout_item/glasses
	category = LOADOUT_CATEGORY_GLASSES

//MISC
/datum/loadout_item/glasses/blindfold
	name = "Blindfold"
	path = /obj/item/clothing/glasses/blindfold

/datum/loadout_item/glasses/fakeblindfold
	name = "Fake Blindfold"
	path = /obj/item/clothing/glasses/trickblindfold

/datum/loadout_item/glasses/cold
	name = "Cold goggles"
	path = /obj/item/clothing/glasses/cold

/datum/loadout_item/glasses/eyepatch
	name = "Eyepatch"
	path = /obj/item/clothing/glasses/eyepatch

/datum/loadout_item/glasses/eyepatch/white
	name = "White Eyepatch"
	path = /obj/item/clothing/glasses/eyepatch/white

/datum/loadout_item/glasses/heat
	name = "Heat goggles"
	path = /obj/item/clothing/glasses/heat

/datum/loadout_item/glasses/hipster
	name = "Hipster glasses"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/loadout_item/glasses/thin
	name = "Thin glasses"
	path = /obj/item/clothing/glasses/thin

/datum/loadout_item/glasses/better
	name = "Modern glasses"
	path = /obj/item/clothing/glasses/betterunshit

/datum/loadout_item/glasses/jamjar
	name = "Jamjar glasses"
	path = /obj/item/clothing/glasses/regular/jamjar

/datum/loadout_item/glasses/monocle
	name = "Monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/loadout_item/glasses/orange
	name = "Orange glasses"
	path = /obj/item/clothing/glasses/orange

/datum/loadout_item/glasses/red
	name = "Red Glasses"
	path = /obj/item/clothing/glasses/red

/datum/loadout_item/glasses/prescription
	name = "Prescription glasses"
	path = /obj/item/clothing/glasses/regular

/datum/loadout_item/glasses/medic
	name = "Medical Eyepatch"
	path = /obj/item/clothing/glasses/hud/med/eyepatchsr
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist", "Paramedic")
	restricted_desc = "Medical"

/datum/loadout_item/glasses/robo
	name = "Diagnostic Eyepatch"
	path = /obj/item/clothing/glasses/hud/diagnostic/eyepatchsr
	restricted_roles = list("Scientist", "Roboticist", "Geneticist", "Research Director")
	restricted_desc = "Science"

/datum/loadout_item/glasses/sci
	name = "Science Eyepatch"
	path = /obj/item/clothing/glasses/hud/sci/eyepatchsr
	restricted_roles = list("Scientist", "Roboticist", "Geneticist", "Research Director", "Chemist")
	restricted_desc = "Science"

/datum/loadout_item/glasses/sechud
	name = "Security Hud"
	path = /obj/item/clothing/glasses/hud/security
	restricted_roles = list("Security Officer", "Warden", "Head of Security")

/datum/loadout_item/glasses/sechud/eyepatch
	name = "Security Eyepatch Hud"
	path = /obj/item/clothing/glasses/hud/sec/eyepatchsr
	restricted_roles = list("Security Officer", "Warden", "Head of Security")
