/datum/augment_item/organ
	category = AUGMENT_CATEGORY_ORGANS

/datum/augment_item/organ/apply(mob/living/carbon/human/H, character_setup = FALSE, datum/preferences/prefs)
	if(character_setup)
		return
	var/obj/item/organ/new_organ = new path()
	new_organ.Insert(H,FALSE,FALSE)

//HEARTS
/datum/augment_item/organ/heart
	slot = AUGMENT_SLOT_HEART

/datum/augment_item/organ/heart/cybernetic
	name = "Cybernetic heart"
	path = /obj/item/organ/heart/cybernetic

/datum/augment_item/organ/heart/ethereal
	name = "Eletrical Core"
	path = /obj/item/organ/heart/ethereal

//LUNGS
/datum/augment_item/organ/lungs
	slot = AUGMENT_SLOT_LUNGS

/datum/augment_item/organ/lungs/hot
	name = "Lungs Adapted to Heat"
	slot = AUGMENT_SLOT_LUNGS
	path = /obj/item/organ/lungs/hot
	cost = 2

/datum/augment_item/organ/lungs/cold
	name = "Cold-Adapted Lungs"
	slot = AUGMENT_SLOT_LUNGS
	path = /obj/item/organ/lungs/cold
	cost = 2

/datum/augment_item/organ/lungs/toxin
	name = "Lungs Adapted to Toxins"
	slot = AUGMENT_SLOT_LUNGS
	path = /obj/item/organ/lungs/toxin
	cost = 2

/datum/augment_item/organ/lungs/oxy
	name = "Low-Pressure Adapted Lungs"
	slot = AUGMENT_SLOT_LUNGS
	path = /obj/item/organ/lungs/oxy
	cost = 2

/datum/augment_item/organ/lungs/ethereal
	name = "Aeration reticulum"
	path = /obj/item/organ/lungs/ethereal

/datum/augment_item/organ/lungs/cybernetic
	name = "Cybernetic lungs"
	path = /obj/item/organ/lungs/cybernetic

//LIVERS
/datum/augment_item/organ/liver
	slot = AUGMENT_SLOT_LIVER

/datum/augment_item/organ/liver/cybernetic
	name = "Cybernetic liver"
	path = /obj/item/organ/liver/cybernetic

/datum/augment_item/organ/liver/toxin
	name = "toxin adapted liver"
	path = /obj/item/organ/liver/alien/roundstart
	cost = 6


//STOMACHES
/datum/augment_item/organ/stomach
	slot = AUGMENT_SLOT_STOMACH

/datum/augment_item/organ/stomach/cybernetic
	name = "Cybernetic stomach"
	path = /obj/item/organ/stomach/cybernetic

/datum/augment_item/organ/stomach/battery
	name = "Biological Battery"
	path = /obj/item/organ/stomach/ethereal

//EYES
/datum/augment_item/organ/eyes
	slot = AUGMENT_SLOT_EYES

/datum/augment_item/organ/eyes/cybernetic
	name = "Cybernetic eyes"
	path = /obj/item/organ/eyes/robotic

/datum/augment_item/organ/eyes/highlumi
	name = "High-luminosity eyes"
	path = /obj/item/organ/eyes/robotic/glow
	allowed_biotypes = MOB_ORGANIC|MOB_ROBOTIC
	cost = 1

//TONGUES
/datum/augment_item/organ/tongue
	slot = AUGMENT_SLOT_TONGUE

/datum/augment_item/organ/tongue/normal
	name = "Organic tongue"
	path = /obj/item/organ/tongue

/datum/augment_item/organ/tongue/robo
	name = "Robotic voicebox"
	path = /obj/item/organ/tongue/robot

/datum/augment_item/organ/tongue/forked
	name = "Forked tongue"
	path = /obj/item/organ/tongue/lizard

/datum/augment_item/organ/tongue/ethereal
	name = "Eletrical tongue"
	path = /obj/item/organ/tongue/ethereal

/datum/augment_item/organ/tongue/fly
	name = "fly tongue"
	path = /obj/item/organ/tongue/fly
