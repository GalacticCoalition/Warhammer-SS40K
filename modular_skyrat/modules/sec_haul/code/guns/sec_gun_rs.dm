//Security Crafting Recipe

/datum/crafting_recipe/sol_rifle_carbine_kit
	name = "Sol Carbine Conversion"
	result = /obj/item/gun/ballistic/automatic/rom_carbine
	reqs = list(
		/obj/item/gun/ballistic/automatic/sol_rifle = 1,
		/obj/item/weaponcrafting/gunkit/sol_rifle_carbine_kit = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED
