//Define worn_icon_muzzled below here for suits so we don't have to make whole new .dm files for each

// For making sure that snouts with the (Top) suffix have their gear layered correctly
/obj/item/clothing/head/visual_equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot & ITEM_SLOT_HEAD)
		if(!(user.dna.species.bodytype & BODYTYPE_ALT_FACEWEAR_LAYER))
			return
		if(!isnull(alternate_worn_layer) && alternate_worn_layer < BODY_FRONT_LAYER) // if the alternate worn layer was already lower than snouts then leave it be
			return

		alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
		user.update_worn_head()
			
/obj/item/clothing/head/dropped(mob/living/carbon/human/user)
	. = ..()
	alternate_worn_layer = initial(alternate_worn_layer)

/obj/item/clothing/head/bio_hood
	worn_icon_muzzled = 'modular_skyrat/master_files/icons/mob/clothing/head/bio_muzzled.dmi'

/obj/item/clothing/head/helmet/space
	worn_icon_muzzled = 'modular_skyrat/master_files/icons/mob/clothing/head/spacehelm_muzzled.dmi'
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR //Removes HIDESNOUT so that transparent helmets still show the snout

/obj/item/clothing/head/helmet/chaplain
	worn_icon_muzzled = 'modular_skyrat/master_files/icons/mob/clothing/head/chaplain_muzzled.dmi'

/obj/item/clothing/head/collectable/welding
	worn_icon_muzzled = 'modular_skyrat/master_files/icons/mob/clothing/head_muzzled.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION

//Re-adds HIDESNOUT to whatever needs it, and marks them CLOTHING_NO_VARIATION so they don't look for muzzled sprites
//ORION TODO - this needs a better method, can we do this as a SQUISH thing like digitigrade?
/obj/item/clothing/head/helmet/space/changeling
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	supports_variations_flags = CLOTHING_NO_VARIATION
/obj/item/clothing/head/helmet/space/freedom
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/head/helmet/space/santahat
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	supports_variations_flags = CLOTHING_NO_VARIATION
