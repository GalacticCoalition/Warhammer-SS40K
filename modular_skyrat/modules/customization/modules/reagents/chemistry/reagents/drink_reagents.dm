// Modular DRINK REAGENTS, see the following file for the mixes: modular_skyrat\modules\customization\modules\food_and_drinks\recipes\drinks_recipes.dm

/datum/reagent/consumable/pinkmilk
	name = "Strawberry Milk"
	description = "A drink of a bygone era of milk and artificial sweetener back on a rock."
	color = "#f76aeb"//rgb(247, 106, 235)
	glass_icon = 'modular_skyrat/master_files/icons/obj/drinks.dmi'
	glass_icon_state = "pinkmilk"
	quality = DRINK_VERYGOOD
	taste_description = "sweet strawberry and milk cream"
	glass_name = "tall glass of strawberry milk"
	glass_desc = "Delicious flavored strawberry syrup mixed with milk."

/datum/reagent/consumable/tea/pinkmilk/on_mob_life(mob/living/carbon/M)
	if(prob(15))
		to_chat(M, "<span class = 'notice'>[pick("You cant help to smile.","You feel nostalgia all of sudden.","You remember to relax.")]</span>")
	..()
	. = 1

/datum/reagent/consumable/pinktea //Tiny Tim song
	name = "Strawberry Tea"
	description = "A timeless classic!"
	color = "#f76aeb"//rgb(247, 106, 235)
	glass_icon_state = "pinktea"
	quality = DRINK_VERYGOOD
	taste_description = "sweet tea with a hint of strawberry"
	glass_icon = 'modular_skyrat/master_files/icons/obj/drinks.dmi'
	glass_name = "mug of strawberry tea"
	glass_desc = "Delicious traditional tea flavored with strawberries."

/datum/reagent/consumable/tea/pinktea/on_mob_life(mob/living/carbon/M)
	if(prob(10))
		to_chat(M, "<span class = 'notice'>[pick("Diamond skies where white deer fly.","Sipping strawberry tea.","Silver raindrops drift through timeless, Neverending June.","Crystal ... pearls free, with love!","Beaming love into me.")]</span>")
	..()
	. = 1
