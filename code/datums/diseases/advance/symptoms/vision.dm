/*Hyphema (Eye bleeding)
 * Slightly reduces stealth
 * Tremendously reduces resistance
 * Tremendously reduces stage speed
 * Greatly reduces transmissibility
 * Critical level
 * Bonus: Causes blindness.
*/
/datum/symptom/visionloss
	name = "Hyphema"
	desc = "The virus causes inflammation of the retina, leading to eye damage and eventually blindness."
	stealth = -1
	resistance = -4
	stage_speed = -4
	transmittable = -3
	level = 5
	severity = 5
	base_message_chance = 50
	symptom_delay_min = 25
	symptom_delay_max = 80
	var/remove_eyes = FALSE
	threshold_descs = list(
		"Resistance 12" = "Weakens extraocular muscles, eventually leading to complete detachment of the eyes.",
		"Stealth 4" = "The symptom remains hidden until active.",
	)

/datum/symptom/visionloss/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalStealth() >= 4)
		suppress_warning = TRUE
	if(A.totalResistance() >= 12) //goodbye eyes
		remove_eyes = TRUE

/datum/symptom/visionloss/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/M = A.affected_mob
	var/obj/item/organ/internal/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		switch(A.stage)
			if(1, 2)
				if(prob(base_message_chance) && !suppress_warning)
					to_chat(M, span_warning("Your eyes itch."))
			if(3, 4)
				to_chat(M, span_boldwarning("Your eyes burn!"))
				M.set_eye_blur_if_lower(20 SECONDS)
				eyes.applyOrganDamage(1)
			else
				M.set_eye_blur_if_lower(40 SECONDS)
				eyes.applyOrganDamage(5)
				if(eyes.damage >= 10)
					M.become_nearsighted(EYE_DAMAGE)
				if(prob(eyes.damage - 10 + 1))
					if(!remove_eyes)
						if(!M.is_blind())
							to_chat(M, span_userdanger("You go blind!"))
							eyes.applyOrganDamage(eyes.maxHealth)
					else
						M.visible_message(span_warning("[M]'s eyes fall out of their sockets!"), span_userdanger("Your eyes fall out of their sockets!"))
						eyes.Remove(M)
						eyes.forceMove(get_turf(M))
				else
					to_chat(M, span_userdanger("Your eyes burn horrifically!"))
