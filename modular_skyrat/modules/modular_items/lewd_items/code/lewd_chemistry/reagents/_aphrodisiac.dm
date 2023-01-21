// The base ERP chem. It handles pref and human type checks for you, so ALL chems relating to ERP should be subtypes of this.
/datum/reagent/drug/aphrodisiac
	name = "liquid ERP"
	description = "ERP in its liquified form. Complain to a coder."

	/// What preference you need enabled for effects on life
	var/life_pref_datum = /datum/preference/toggle/erp
	/// What preference you need enabled for effects on overdose
	var/overdose_pref_datum = /datum/preference/toggle/erp

	/// The amount to adjust the mob's arousal by
	var/arousal_adjust_amount = 1
	/// The amount to adjust the mob's pleasure by
	var/pleasure_adjust_amount = 0
	/// The amount to adjust the mob's pain by
	var/pain_adjust_amount = 0

	// Vars for enlargement chems from here on
	/// Counts up to a threshold before triggering enlargement effects
	var/enlargement_amount = 0
	/// How much to increase the count by each process
	var/enlarger_increase_step = 5
	/// Count to reach before effects
	var/enlargement_threshold = 100

	/// % chance for damage to be applied when the organ is too large and the mob is clothed
	var/damage_chance = 20
	
	/// % chance for testicle growth to occur
	var/balls_increase_chance = 20

	/// Largest length the chem can make a mob's penis
	var/penis_max_length = PENIS_MAX_LENGTH
	/// Smallest size the chem can make a mob's penis
	var/penis_min_length = PENIS_MIN_LENGTH
	/// How much the penis is increased in size each time it's run
	var/penis_length_increase_step = 1
	/// How much the penis is increased in girth each time it's run
	var/penis_girth_increase_step = 1
	/// Largest girth the chem can make a mob's penis
	var/penis_max_girth = PENIS_MAX_GIRTH
	/// Smallest girth the chem can make a mob's penis
	var/penis_minimum_girth = 2
	/// How much to reduce the size of the penis each time it's run
	var/penis_size_reduction_step = 1
	/// How much to reduce the girth of the penis each time it's run
	var/penis_girth_reduction_step = 1
	/// How much to reduce the size of the balls each time it's run
	var/testicles_reduction_step = 1
	
	/// Largest size the chem can make a mob's balls
	var/balls_max_size = TESTICLES_MAX_SIZE
	/// Smallest size the chem can make a mob's balls
	var/balls_min_size = TESTICLES_MIN_SIZE
	/// Make the balls enormous only when the penis reaches a certain size
	var/balls_enormous_size_threshold = PENIS_MAX_LENGTH - 4

	/// Largest size the chem can make a mob's breasts
	var/max_breast_size = 16
	/// How much breasts are increased in size each time it's run
	var/breast_size_increase_step = 1
	/// Smallest size the chem can make a mob's breasts
	var/breast_minimum_size = 2
	/// How much to reduce the size of the breasts each time it's run
	var/breast_size_reduction_step = 1

/// Runs on life after preference checks. Use this instead of on_mob_life
/datum/reagent/drug/aphrodisiac/proc/life_effects(mob/living/carbon/human/exposed_mob)

/// Runs on OD process after preference checks. Use this instead of overdose_process
/datum/reagent/drug/aphrodisiac/proc/overdose_effects(mob/living/carbon/human/exposed_mob)
	return

/datum/reagent/drug/aphrodisiac/on_mob_life(mob/living/carbon/human/exposed_mob)
	. = ..()
	if(life_pref_datum && exposed_mob.client?.prefs.read_preference(life_pref_datum) && ishuman(exposed_mob))
		life_effects(exposed_mob)

/datum/reagent/drug/aphrodisiac/overdose_process(mob/living/carbon/human/exposed_mob)
	. = ..()
	if(overdose_pref_datum && exposed_mob.client?.prefs.read_preference(overdose_pref_datum) && ishuman(exposed_mob))
		overdose_effects(exposed_mob)		

/// Handle changing of gender
/datum/reagent/drug/aphrodisiac/proc/change_gender(mob/living/carbon/human/exposed_mob, datum/reagent/drug/aphrodisiac/aphrodisiac) 

/// Handle creation of new genitals
/datum/reagent/drug/aphrodisiac/proc/create_genitals(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE)
/datum/reagent/drug/aphrodisiac/proc/create_breasts(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/datum/reagent/drug/aphrodisiac/proc/create_penis(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/datum/reagent/drug/aphrodisiac/proc/create_testicles(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/datum/reagent/drug/aphrodisiac/proc/create_vagina(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/datum/reagent/drug/aphrodisiac/proc/create_womb(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 

/// Handle removal of old genitals
/datum/reagent/drug/aphrodisiac/proc/remove_genitals(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/datum/reagent/drug/aphrodisiac/proc/remove_penis(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/datum/reagent/drug/aphrodisiac/proc/remove_testicles(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/datum/reagent/drug/aphrodisiac/proc/remove_vagina(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/datum/reagent/drug/aphrodisiac/proc/remove_womb(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 

/// Handle penis growth
/datum/reagent/drug/aphrodisiac/proc/grow_penis(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/// Handle ball growth
/datum/reagent/drug/aphrodisiac/proc/grow_balls(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 
/// Handle breast growth
/datum/reagent/drug/aphrodisiac/proc/grow_breasts(mob/living/carbon/human/exposed_mob, suppress_chat = FALSE) 

/// Handle genital shrinkage
/datum/reagent/drug/aphrodisiac/proc/shrink_genitals(mob/living/carbon/human/exposed_mob) 
/datum/reagent/drug/aphrodisiac/proc/shrink_penis(mob/living/carbon/human/exposed_mob) 
/datum/reagent/drug/aphrodisiac/proc/shrink_testicles(mob/living/carbon/human/exposed_mob) 
/datum/reagent/drug/aphrodisiac/proc/shrink_breasts(mob/living/carbon/human/exposed_mob) 

/// Used to display the messages that appear in chat while the growth is occurring
/datum/reagent/drug/aphrodisiac/proc/growth_to_chat(mob/living/carbon/human/exposed_mob, obj/item/organ/external/genital/genital) 

/// Called after growth that alters appearance
/datum/reagent/drug/aphrodisiac/proc/update_appearance(mob/living/carbon/human/exposed_mob, obj/item/organ/external/genital/genital, mutations_overlay = FALSE)
	if(genital)
		genital.update_sprite_suffix()
	if(exposed_mob) 
		exposed_mob.update_body()
		if(mutations_overlay)
			exposed_mob.update_mutations_overlay()
