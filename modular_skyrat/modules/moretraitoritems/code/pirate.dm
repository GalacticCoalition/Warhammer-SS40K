//Heister kit
/obj/item/clothing/suit/jacket/det_suit/noir/heister
	name = "armored suit jacket"
	desc = "A professional suit jacket, it feels much heavier than a regular jacket. A label on the inside reads \"Nanite-based Self-repairing Kevlar weave\"."
	armor_type = /datum/armor/heister
	/// How many hits we can take before the armor breaks, PAYDAY style
	var/armor_stacks = 2

/datum/armor/heister
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/suit/jacket/det_suit/noir/heister/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/shielded/suit, max_charges = armor_stacks, recharge_start_delay = 8 SECONDS, charge_increment_delay = 1 SECONDS, \
	charge_recovery = armor_stacks, lose_multiple_charges = FALSE, starting_charges = armor_stacks, shield_icon_file = null, shield_icon = null)

/obj/item/clothing/suit/jacket/det_suit/noir/heister/equipped(mob/living/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_OCLOTHING))
		return
	RegisterSignal(user, COMSIG_HUMAN_CHECK_SHIELDS, PROC_REF(armor_reaction))

/obj/item/clothing/suit/jacket/det_suit/noir/heister/proc/armor_reaction(mob/living/carbon/human/owner, atom/movable/hitby, damage = 0, attack_text = "the attack", attack_type = MELEE_ATTACK, armour_penetration = 0)
	if(SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, owner, hitby, attack_text, 0, damage, attack_type) & COMPONENT_HIT_REACTION_BLOCK)
		return SHIELD_BLOCK
	return NONE

/obj/item/clothing/gloves/latex/nitrile/heister
	desc = "Pricy sterile gloves that are thicker than latex. Perfect for hiding fingerprints."
	clothing_traits = null
	siemens_coefficient = 0

//NRI commando
/obj/item/clothing/head/beret/sec/ocelot
	name = "ocelot beret"
	desc = "A red beret with the neo-russian insignia stamped on it. This bitch is wearing perfume."
	armor_type = /datum/armor/sec_ocelot

/datum/armor/sec_ocelot
	melee = 30
	bullet = 20
	laser = 20
	energy = 30
	bomb = 25
	fire = 20
	acid = 50
	wound = 4

/obj/item/clothing/suit/jacket/det_suit/noir/ocelot
	name = "ocelot trenchcoat"
	desc = "A black armoured trenchcoat worn by a certain gun spinning spy. Don't confuse me with those uniformed fools."
	armor_type = /datum/armor/noir_ocelot

/datum/armor/noir_ocelot
	melee = 25
	bullet = 20
	laser = 30
	energy = 30
	bomb = 30
	fire = 30
	acid = 30
	wound = 20

//Mafioso
/obj/item/clothing/suit/jacket/det_suit/noir/mafioso
	name = "mafioso trenchcoat"
	desc = "Someone wearing this means serious business."
	armor_type = /datum/armor/noir_mafioso

/datum/armor/noir_mafioso
	melee = 25
	bullet = 20
	laser = 30
	energy = 30
	bomb = 30
	fire = 30
	acid = 30
	wound = 20
