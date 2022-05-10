//--- BOWIE'S KNIFE (bowie knife)---\\\


/obj/item/melee/knife/bowie
	name = "Bowie knife"
	desc = "A frontiersman's classic, closer to a shortsword than a knife. It boasts a full-tanged build, a brass handguard and pommel, a wicked sharp point, and a large, heavy blade, It's almost everything you could want in a knife, besides portability."
	icon = 'modular_skyrat/modules/knives/icons/bowie.dmi'
  	iconstate = 'bowie'
	lefthand_file = 'modular_skyrat/modules/knives/icons/bowie_lefthand.dmi'
	righthand_file = 'modular_skyrat/modules/knives/icons/bowie_righthand.dmi'
  worn_icon_state = "knife"
	force = 20 // Zoowee Momma!
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 15
	wound_bonus = -15
	bare_wound_bonus = 20

  
  /obj/item/storage/bag/bowiesheath
	name = "Bowie Knife sheathe"
	desc = "A dressed-up leather sheath featuring a brass tip. It has a large pocket clip right in the center, for ease of carrying an otherwise burdensome knife."
	icon = 'modular_skyrat/modules/knives/icons/bowie.dmi'
	icon_state = "bowiesheathe2"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FLAMMABLE
	
/obj/item/storage/bag/bowiesheath/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/melee/knife/bowie
		))

  /obj/item/storage/bag/bowiesheath/PopulateContents()
	new /obj/item/melee/knife/bowie(src)
	update_appearance()

