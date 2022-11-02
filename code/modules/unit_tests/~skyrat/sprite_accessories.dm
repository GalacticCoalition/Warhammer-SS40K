// Yea, I'm doing this. This shit annoys me too much.
// Set your layers properly, or be yelled at angrily. - Rimi
/datum/unit_test/sprite_accessories
	var/static/list/genitals_to_add = list(
		/obj/item/organ/external/genital/breasts,
		/obj/item/organ/external/genital/vagina,
		/obj/item/organ/external/genital/penis,
		/obj/item/organ/external/genital/testicles,
		/obj/item/organ/external/genital/anus,
	)

/datum/unit_test/sprite_accessories/Run()
	var/genitals_enabled = CONFIG_GET(flag/disable_erp_preferences)
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)

	if(!genitals_enabled)
		for(var/obj/item/organ/external/genital/genital in genitals_to_add)
			genital = new genital
			genital.Insert(human)

	var/datum/species/human/human_species = human.dna.species

	for(var/looping_accessory_key as anything in GLOB.sprite_accessories)
		for(var/datum/sprite_accessory/sprite_accessory as anything in GLOB.sprite_accessories[looping_accessory_key])
			sprite_accessory = GLOB.sprite_accessories[looping_accessory_key]?[sprite_accessory]
			var/accessory_name = sprite_accessory.name
			var/accessory_icon_state = sprite_accessory.icon_state
			var/icon/accessory_icon = sprite_accessory.icon
			var/accessory_key = sprite_accessory.key

			// This shouldn't be possible, I'm checking anyway, cause if this does happen, it means you fucked up big time.
			if(!sprite_accessory)
				TEST_FAIL("Null accessory entry in key [looping_accessory_key]!")

			// People will do custom stuff with non-factual sprites. Not touching those.
			// Also skips sprites with "none" or null as their icon state, and genitals, should those be disabled.
			// Lets hair through regardless of what's set. Every single subtype under hair or facial_hair should be usable. No, I am not editing the code to support non-factual stuff.
			if((!istype(sprite_accessory, /datum/sprite_accessory/hair) && !istype(sprite_accessory, /datum/sprite_accessory/facial_hair)) && (!sprite_accessory.factual || !accessory_icon_state || accessory_icon_state == "none" || (!genitals_enabled && istype(sprite_accessory, /datum/sprite_accessory/genital))))
				continue

			if(!accessory_icon)
				TEST_FAIL("Null icon on factual accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")
				continue
			if(!accessory_icon_state)
				TEST_FAIL("Null icon_state on factual accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")
				continue
			if(!accessory_name)
				TEST_FAIL("Null name on factual accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")

			if(!sprite_accessory.relevent_layers || !sprite_accessory.relevent_layers.len)
				TEST_FAIL("Null relevent_layers on factual accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")
				continue

			for(var/gender_prefix in (sprite_accessory.gender_specific ? list("m", "f") : list("m")))
				var/render_state

				if(sprite_accessory.special_render_case)
					render_state = sprite_accessory.get_special_render_state(human)
				else
					render_state = accessory_icon_state

				for(var/layer in sprite_accessory.relevent_layers)
					var/use_main = TRUE
					var/use_inner = sprite_accessory.hasinner
					var/use_extra = sprite_accessory.extra
					var/use_extra2 = sprite_accessory.extra2
					if(sprite_accessory.relevent_layers_filter && sprite_accessory.relevent_layers_filter[layer])
						var/list/filter = sprite_accessory.relevent_layers_filter[layer]
						// Layer filtering for edge cases like cat ears that don't have inner for certain layers.
						use_main = (SPRITE_ACCESSORY_MAIN in filter)
						use_inner = (SPRITE_ACCESSORY_INNER in filter) && use_inner
						use_extra = (SPRITE_ACCESSORY_EXTRA in filter) && use_extra
						use_extra2 = (SPRITE_ACCESSORY_EXTRA2 in filter) && use_extra2

					var/layertext = human_species.mutant_bodyparts_layertext(layer)

					var/final_icon_state

					if(use_main)
						final_icon_state = "[gender_prefix]_[sprite_accessory.get_special_render_key(human)]_[render_state]_[layertext]"
						if(sprite_accessory.color_src == USE_MATRIXED_COLORS)
							final_icon_state += "_primary"
							var/list/color_layer_list
							if(sprite_accessory.special_render_case)
								color_layer_list = list("1" = "primary", "2" = "secondary", "3" = "tertiary")
							else
								color_layer_list = sprite_accessory.color_layer_names
							for(var/entry_number in color_layer_list)
								var/color_entry = color_layer_list[entry_number]
								if(sprite_accessory.relevent_layers_filter)
									var/list/filter = sprite_accessory.relevent_layers_filter[layer]
									if(filter && (color_entry in filter))
										continue

								final_icon_state = "[final_icon_state]_[layertext]_[color_layer_list[entry_number]]"

								if(!icon_exists(accessory_icon, final_icon_state))
									TEST_FAIL("Missing MAIN MATRIXED icon for [final_icon_state] in [accessory_icon_state] for factual sprite accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")

						else if(!icon_exists(accessory_icon, final_icon_state))
							TEST_FAIL("Missing MAIN icon for [final_icon_state] in [accessory_icon_state] for factual sprite accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")

					if(use_inner)
						final_icon_state = "[gender_prefix]_[accessory_key]inner_[accessory_icon_state]_[layertext]"

						if(!icon_exists(accessory_icon, final_icon_state))
							TEST_FAIL("Missing INNER icon for [final_icon_state] in [accessory_icon_state] for factual sprite accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")

					if(use_extra)
						final_icon_state = "[gender_prefix]_[accessory_key]_extra_[accessory_icon_state]_[layertext]"
						if(!icon_exists(accessory_icon, final_icon_state))
							TEST_FAIL("Missing EXTRA icon for [final_icon_state] in [accessory_icon_state] for factual sprite accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")

					if(use_extra2)
						final_icon_state = "[gender_prefix]_[accessory_key]_extra2_[accessory_icon_state]_[layertext]"
						if(!icon_exists(accessory_icon, final_icon_state))
							TEST_FAIL("Missing EXTRA2 icon for [final_icon_state] in [accessory_icon_state] for factual sprite accessory [accessory_name] ([sprite_accessory.type]) in key [accessory_key]!")

