/mob/living/simple_animal/pet/fox/syndifox
	name = "Syndi-Fox"
	real_name = "Syndi-Fox" // Intended to hold the name without altering it.
	gender = NEUTER
	desc = "It's a Cybersun MiniVixen robotic model wearing a microsized syndicate MODsuit and a cute little cap. Quite pretty."
	icon = 'modular_skyrat/master_files/icons/mob/pets.dmi'
	icon_state = "syndifox"
	icon_living = "syndifox"
	icon_dead = "syndifox_dead"
	speak = list("Ack-Ack","Stay winning!","Geckers","For Sothra!","Tchoff")
	speak_emote = list("geckers", "barks")
	emote_hear = list("howls.","barks.")
	emote_see = list("shakes their head.", "shivers.")
	speak_chance = 1
	can_be_held = FALSE
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	footstep_type = FOOTSTEP_MOB_CLAW
	maxHealth = 150
	health = 150
	turns_per_move = 10
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	stop_automated_movement = 0
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	loot = list(/obj/effect/decal/cleanable/oil/slippery)
	death_message = "beeps, its mechanical parts hissing before the chassis collapses in a loud thud."
	animal_species = /mob/living/simple_animal/pet/fox
	gold_core_spawnable = FRIENDLY_SPAWN

