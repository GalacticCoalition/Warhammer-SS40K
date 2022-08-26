/// SKYRAT MODULE SKYRAT_XENO_REDO

/mob/living/carbon/alien/humanoid/skyrat/warrior
	name = "alien warrior"
	caste = "warrior"
	maxHealth = 400
	health = 400
	icon_state = "alienwarrior"
	melee_damage_lower = 30
	melee_damage_upper = 35
	var/datum/action/cooldown/mob_cooldown/charge/basic_charge/defender/charge
	var/datum/action/cooldown/spell/aoe/repulse/xeno/hard_throwing/tail_sweep
	var/datum/action/cooldown/alien/skyrat/warrior_agility/agility

/mob/living/carbon/alien/humanoid/skyrat/warrior/Initialize(mapload)
	. = ..()
	tail_sweep = new /datum/action/cooldown/spell/aoe/repulse/xeno/hard_throwing()
	tail_sweep.Grant(src)

	charge = new /datum/action/cooldown/mob_cooldown/charge/basic_charge/defender()
	charge.Grant(src)

	agility = new /datum/action/cooldown/alien/skyrat/warrior_agility()
	agility.Grant(src)

	REMOVE_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

	add_movespeed_modifier(/datum/movespeed_modifier/alien_big)

/mob/living/carbon/alien/humanoid/skyrat/warrior/Destroy()
	QDEL_NULL(charge)
	QDEL_NULL(tail_sweep)
	QDEL_NULL(agility)
	return ..()

/mob/living/carbon/alien/humanoid/skyrat/warrior/create_internal_organs()
	internal_organs += new /obj/item/organ/internal/alien/plasmavessel
	..()

/datum/action/cooldown/alien/skyrat/warrior_agility
	name = "Agility Mode"
	desc = "Drop onto all fours, increasing your speed at the cost of being unable to use most abilities."
	button_icon_state = "the_speed_is_alot"
	cooldown_time = 1 SECONDS
	can_be_used_always = TRUE
	var/being_agile = FALSE

/datum/action/cooldown/alien/skyrat/warrior_agility/Activate()
	. = ..()
	var/mob/living/carbon/alien/humanoid/skyrat/agility_target = owner
	if(!being_agile)
		agility_target.balloon_alert(agility_target, "agility active")
		to_chat(agility_target, span_danger("We drop onto all fours, allowing us to move at much greater speed at expense of being able to use most abilities."))
		playsound(agility_target, 'modular_skyrat/modules/xenos_skyrat_redo/sound/alien_hiss.ogg', 100, TRUE, 8, 0.9)
		being_agile = TRUE
		agility_target.icon_state = "alien[agility_target.caste]_mobility"
		agility_target.add_movespeed_modifier(/datum/movespeed_modifier/warrior_agility)
		agility_target.unable_to_use_abilities = TRUE
		return TRUE
	if(being_agile)
		agility_target.balloon_alert(agility_target, "agility ended")
		playsound(agility_target, 'modular_skyrat/modules/xenos_skyrat_redo/sound/alien_roar2.ogg', 100, TRUE, 8, 0.9) //Warrior runs up on all fours, stands upright, screams at you
		being_agile = FALSE
		agility_target.icon_state = "alien[agility_target.caste]"
		agility_target.remove_movespeed_modifier(/datum/movespeed_modifier/warrior_agility)
		agility_target.unable_to_use_abilities = FALSE
		return TRUE

/datum/movespeed_modifier/warrior_agility
	multiplicative_slowdown = -2
