/*
* BREAST ENLARGEMENT
* Normal function increases the player's breast size.
* If the player's breasts are near or at the maximum size and they're wearing clothing, they press against the player's clothes and causes brute and oxygen damage.
* If gender change preference is enabled: Overdosing makes you female if male, makes the player grow breasts, sets the player's testicles to the minimum size, and shrinks the player's penis to a minimum size.
* If the gender change preference is not enabled: Overdosing will just make you grow breasts if you don't have any.
* Credit to Citadel for the original code before modification
*/

/datum/reagent/drug/aphrodisiac/succubus_milk
	name = "succubus milk"
	description = "A volatile collodial mixture derived from milk that encourages mammary production via a potent estrogen mix."
	color = "#E60584"
	taste_description = "a milky ice cream like flavour"
	overdose_threshold = 20
	metabolization_rate = 0.25
	life_pref_datum = /datum/preference/toggle/erp/breast_enlargement
	overdose_pref_datum = /datum/preference/toggle/erp

	/// Words for the breasts when huge.
	var/static/list/words_for_bigger = list(
		"huge",
		"massive",
		"squishy",
		"gigantic",
		"rather large",
		"jiggly",
		"hefty",
	)
	/// Synonyms for breasts.
	var/static/list/boob_text_list = list(
		"boobs",
		"tits",
		"breasts",
	)
	/// Synonyms for the chest.
	var/static/list/covered_boobs_list = list(
		"bust",
		"chest",
		"bosom",
	)
	/// Synonyms for bigger breasts.
	var/static/list/bigger_boob_text_list = list(
		"jigglies",
		"melons",
		"jugs",
		"boobies",
		"milkers",
		"boobs",
		"tits",
		"breasts",
	)
	/// Wording chosen to expand the breasts,shown only to the mob.
	var/static/list/action_text_list = list(
		"expand outward to ",
		"grow out to ",
		"begin to enlarge, growing to ",
		"suddenly expand to ",
		"swell out to ",
	)
	/// Wording chosen to be seen by other mobs, regardless of whether mob is clothed/unclothed.
	var/static/list/public_bigger_action_text_list = list(
		"expand and jiggle outward.",
		"grow a bit larger, bouncing about.",
		"seem a bit bigger than they were before.",
		"bounce and jiggle as they suddenly expand.",
	)
	/// Wording chosen to be seen by other mobs, while mob is unclothed.
	var/static/list/public_action_text_list = list(
		"expand outward.",
		"seem to grow a bit larger.",
		"appear a bit bigger than they were before.",
		"bounce and jiggle as they suddenly expand.",
	)
	/// Wording chosen to be seen by other mobs, while mob is clothed.
	var/static/list/notice_boobs = list(
		"seems to be a bit tighter.",
		"appears to be a bit bigger.",
		"seems to swell outward a bit.",
	)

/datum/reagent/drug/aphrodisiac/succubus_milk/life_effects(mob/living/carbon/human/exposed_mob) //Increases breast size
	var/obj/item/organ/external/genital/breasts/mob_breasts = exposed_mob.getorganslot(ORGAN_SLOT_BREASTS)
	enlargement_amount += enlarger_increase_step
	// Adds a check for breasts in the first place.
	if(!mob_breasts)
		return
	if(enlargement_amount >= enlargement_threshold)
		if(mob_breasts?.genital_size >= max_breast_size)
			return
		mob_breasts.genital_size += breast_size_increase_step
		mob_breasts.update_sprite_suffix()
		exposed_mob.update_body()
		enlargement_amount = 0

		// Checks for cup size.
		var/translation = mob_breasts.breasts_size_to_cup(mob_breasts.genital_size)

		if(mob_breasts.visibility_preference == GENITAL_ALWAYS_SHOW || exposed_mob.is_topless())
			switch(translation)
				if(BREAST_SIZE_FLATCHESTED)
				if(BREAST_SIZE_BEYOND_MEASUREMENT)
					exposed_mob.visible_message(span_notice("[exposed_mob]'s [pick(words_for_bigger)] [pick(bigger_boob_text_list)] [pick(public_bigger_action_text_list)]"))
					to_chat(exposed_mob, span_purple("Your [pick(words_for_bigger)] [pick(bigger_boob_text_list)] [pick(action_text_list)]about [mob_breasts.genital_size] inches in diameter."))
				else
					if(mob_breasts?.genital_size >= (max_breast_size - 2))
						exposed_mob.visible_message(span_notice("[exposed_mob]'s [pick(words_for_bigger)] [pick(bigger_boob_text_list)] [pick(public_bigger_action_text_list)]"))
						to_chat(exposed_mob, span_purple("Your [pick(words_for_bigger)] [pick(bigger_boob_text_list)] [pick(action_text_list)]about [translation]-cups."))
					else
						exposed_mob.visible_message(span_notice("[exposed_mob]'s [pick(boob_text_list)] [pick(public_action_text_list)]"))
						to_chat(exposed_mob, span_purple("Your [pick(boob_text_list)] [pick(action_text_list)]about [translation]-cups."))
		else
			switch(translation)
				if(BREAST_SIZE_FLATCHESTED)
				if(BREAST_SIZE_BEYOND_MEASUREMENT)
					exposed_mob.visible_message(span_notice("[exposed_mob]'s [pick(boob_text_list)] [pick(public_bigger_action_text_list)]"))
					to_chat(exposed_mob, span_purple("Your [pick(words_for_bigger)] [pick(bigger_boob_text_list)] [pick(action_text_list)]about [mob_breasts.genital_size] inches in diameter."))
				else
					if(mob_breasts?.genital_size >= (max_breast_size - 2))
						exposed_mob.visible_message(span_notice("[exposed_mob]'s [pick(boob_text_list)] [pick(public_bigger_action_text_list)]"))
						to_chat(exposed_mob, span_purple("Your [pick(words_for_bigger)] [pick(bigger_boob_text_list)] [pick(action_text_list)]about [translation]-cups."))
					else
						exposed_mob.visible_message(span_notice("The area around [exposed_mob]'s [pick(covered_boobs_list)] [pick(notice_boobs)]"))
						to_chat(exposed_mob, span_purple("Your [pick(boob_text_list)] [pick(action_text_list)]about [translation]-cups."))

		if((mob_breasts?.genital_size >= (max_breast_size - 2)) && (exposed_mob.w_uniform || exposed_mob.wear_suit))
			if(prob(damage_chance))
				to_chat(exposed_mob, span_danger("Your breasts begin to strain against your clothes!"))
				exposed_mob.adjustOxyLoss(5)
				exposed_mob.apply_damage(1, BRUTE, exposed_mob.get_bodypart(BODY_ZONE_CHEST))

// Turns you into a female if character is male. Also adds breasts.
/datum/reagent/drug/aphrodisiac/succubus_milk/overdose_effects(mob/living/carbon/human/exposed_mob)
	var/double_dosing = FALSE //overdosing on succubus milk and incubus draft simultaneously
		for(var/r in exposed_mob.reagents.reagent_list)
			var/datum/reagent/reagent = r
			if(reagent.name == "incubus draft" && reagent.overdosed)
				double_dosing = TRUE
	if(exposed_mob.client?.prefs.read_preference(/datum/preference/toggle/erp/breast_enlargement))
		if(!exposed_mob.getorganslot(ORGAN_SLOT_BREASTS) && exposed_mob.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			var/obj/item/organ/path = /obj/item/organ/external/genital/breasts
			exposed_mob.dna.mutant_bodyparts[ORGAN_SLOT_BREASTS][MUTANT_INDEX_NAME] = "Pair"
			path = new /obj/item/organ/external/genital/breasts
			path.build_from_dna(exposed_mob.dna, ORGAN_SLOT_BREASTS)
			path.Insert(exposed_mob, FALSE, FALSE)
			var/obj/item/organ/external/genital/new_breasts = exposed_mob.getorganslot(ORGAN_SLOT_BREASTS)
			new_breasts.genital_size = 2
			new_breasts.update_sprite_suffix()
			exposed_mob.update_body()
			enlargement_amount = 0
			if(new_breasts.visibility_preference == GENITAL_ALWAYS_SHOW || exposed_mob.is_topless())
				if(!double_dosing)
					exposed_mob.visible_message(span_notice("[exposed_mob]'s bust suddenly expands!"))
					to_chat(exposed_mob, span_purple("Your chest feels warm, tingling with sensitivity as it expands outward."))
			else
				if(!double_dosing)
					exposed_mob.visible_message(span_notice("The area around [exposed_mob]'s chest suddenly bounces a bit."))
					to_chat(exposed_mob, span_purple("Your chest feels warm, tingling with sensitivity as it strains against your clothes."))
	
	// Separates gender change stuff from breast growth.
	if(exposed_mob.client?.prefs.read_preference(/datum/preference/toggle/erp/gender_change))
		var/obj/item/organ/external/genital/penis/mob_penis = exposed_mob.getorganslot(ORGAN_SLOT_PENIS)
		var/obj/item/organ/external/genital/testicles/mob_testicles = exposed_mob.getorganslot(ORGAN_SLOT_TESTICLES)
		if (double_dosing)
			if(exposed_mob.gender != PLURAL)
				exposed_mob.set_gender(PLURAL)
				exposed_mob.physique = exposed_mob.gender
				exposed_mob.update_body()
				exposed_mob.update_mutations_overlay()
		else if(exposed_mob.gender != FEMALE)
			exposed_mob.set_gender(FEMALE)
			exposed_mob.physique = exposed_mob.gender
			exposed_mob.update_body()
			exposed_mob.update_mutations_overlay()
		
		//add new vagina and womb if prefs allow
		if(exposed_mob.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			if(!exposed_mob.getorganslot(ORGAN_SLOT_VAGINA))
				var/obj/item/organ/external/genital/vagina/new_vagina = new /obj/item/organ/external/genital/vagina
				if (exposed_mob.dna.mutant_bodyparts[ORGAN_SLOT_VAGINA][MUTANT_INDEX_NAME] == "None")
					exposed_mob.dna.mutant_bodyparts[ORGAN_SLOT_VAGINA][MUTANT_INDEX_NAME] = "Human"
				new_vagina.build_from_dna(exposed_mob.dna, ORGAN_SLOT_VAGINA)
				new_vagina.Insert(exposed_mob, 0, FALSE)
				exposed_mob.update_body()
			if(!exposed_mob.getorganslot(ORGAN_SLOT_WOMB))
				var/obj/item/organ/external/genital/womb/new_womb = new /obj/item/organ/external/genital/womb
				new_womb.build_from_dna(exposed_mob.dna, ORGAN_SLOT_WOMB)
				new_womb.Insert(exposed_mob, 0, FALSE)
				exposed_mob.update_body()
		
		//Cock shrinkage portion
		if(!mob_penis && !mob_testicles)
			return
		if(exposed_mob.client?.prefs.read_preference(/datum/preference/toggle/erp/penis_shrinkage)) // To do cock shrinkage, check if prefs allow for this.
			// Penis shrinkage
			if(mob_penis)
				if(mob_penis.genital_size == penis_min_length)
					mob_penis.Remove(exposed_mob)
					exposed_mob.update_body()
				else 
					if(mob_penis.genital_size > penis_min_length)
						mob_penis.genital_size -= penis_size_reduction_step
						mob_penis.update_sprite_suffix()
						exposed_mob.update_body()
					if(mob_penis.girth > penis_minimum_girth)
						mob_penis.girth -= penis_girth_reduction_step
						mob_penis.update_sprite_suffix()
						exposed_mob.update_body()
			
			// Testicles shrinkage
			if(mob_testicles)
				if(mob_testicles.genital_size > 0)
					mob_testicles.genital_size -= 1
					mob_testicles.update_sprite_suffix()
					exposed_mob.update_body()
				else if(mob_testicles.genital_size == 0)
					mob_testicles.Remove(exposed_mob)
					mob_testicles.update_sprite_suffix()
					exposed_mob.update_body()

// Notify the user that they're overdosing. Doesn't affect their mood.
/datum/reagent/drug/aphrodisiac/succubus_milk/overdose_start(mob/living/carbon/human/exposed_mob)
	to_chat(exposed_mob, span_userdanger("You feel like you took too much [name]!"))
	exposed_mob.add_mood_event("[type]_overdose", /datum/mood_event/minor_overdose, name)

/datum/chemical_reaction/succubus_milk
	results = list(/datum/reagent/drug/aphrodisiac/succubus_milk = 8)
	required_reagents = list(/datum/reagent/medicine/salglu_solution = 1, /datum/reagent/consumable/milk = 1, /datum/reagent/medicine/c2/synthflesh = 2, /datum/reagent/silicon = 3, /datum/reagent/drug/aphrodisiac/crocin = 3)
	mix_message = "the reaction gives off a mist of milk."
	erp_reaction = TRUE
