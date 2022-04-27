
// Checks plants for broken tray icons. Use Advanced Proc Call to activate.
// Maybe some day it would be used as unit test.
// -------- IT IS NOW!
/datum/unit_test/plantgrowth/Run()
	var/list/states = icon_states('icons/obj/hydroponics/growing.dmi')
	states |= icon_states('icons/obj/hydroponics/growing_fruits.dmi')
	states |= icon_states('icons/obj/hydroponics/growing_flowers.dmi')
	states |= icon_states('icons/obj/hydroponics/growing_mushrooms.dmi')
	states |= icon_states('icons/obj/hydroponics/growing_vegetables.dmi')
<<<<<<< HEAD
	states |= icon_states('goon/icons/obj/hydroponics.dmi')
	states |= icon_states('modular_skyrat/master_files/icons/obj/hydroponics/growing.dmi') // SKYRAT ADDITION
	states |= icon_states('modular_skyrat/modules/xenoarch/icons/growing.dmi') // SKYRAT ADDITION
=======
>>>>>>> 3f15c6359c0 (Replaces the weed sprites, and removes the /goon folder. (#66136))
	var/list/paths = subtypesof(/obj/item/seeds) - /obj/item/seeds - typesof(/obj/item/seeds/sample) - /obj/item/seeds/lavaland

	for(var/seedpath in paths)
		var/obj/item/seeds/seed = new seedpath

		for(var/i in 1 to seed.growthstages)
			if("[seed.icon_grow][i]" in states)
				continue
			Fail("[seed.name] ([seed.type]) lacks the [seed.icon_grow][i] icon!")

		if(!(seed.icon_dead in states))
			Fail("[seed.name] ([seed.type]) lacks the [seed.icon_dead] icon!")

		if(seed.icon_harvest) // mushrooms have no grown sprites, same for items with no product
			if(!(seed.icon_harvest in states))
				Fail("[seed.name] ([seed.type]) lacks the [seed.icon_harvest] icon!")
