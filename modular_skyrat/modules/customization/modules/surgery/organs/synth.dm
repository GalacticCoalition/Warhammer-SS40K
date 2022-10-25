#define SYNTH_EMP_BRAIN_DAMAGE_HEAVY 36
#define SYNTH_EMP_BRAIN_DAMAGE_LIGHT 12
#define SYNTH_EMP_BRAIN_DAMAGE_MAXIMUM 75

/obj/item/organ/internal/brain/synth
	name = "positronic brain carcass"
	slot = ORGAN_SLOT_BRAIN
	zone = BODY_ZONE_CHEST
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves. It has an IPC serial number engraved on the top. It is usually slotted into the chest of synthetic crewmembers."
	icon = 'modular_skyrat/master_files/icons/obj/surgery.dmi'
	icon_state = "posibrain-ipc"

/obj/item/organ/internal/brain/synth/Insert(mob/living/carbon/user, special = 0, drop_if_replaced = TRUE)
	..()
	if(user.stat == DEAD && ishuman(user))
		var/mob/living/carbon/human/user_human = user
		if(user_human?.dna?.species && (REVIVES_BY_HEALING in user_human.dna.species.species_traits))
			if(user_human.health > 50)
				user_human.revive(FALSE)

/obj/item/organ/internal/brain/synth/emp_act(severity)
	switch(severity)
		if(1)
			owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, SYNTH_EMP_BRAIN_DAMAGE_HEAVY, SYNTH_EMP_BRAIN_DAMAGE_MAXIMUM)
			to_chat(owner, span_warning("Alert: Rampant system corruption in central processing unit."))
		if(2)
			owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, SYNTH_EMP_BRAIN_DAMAGE_LIGHT, SYNTH_EMP_BRAIN_DAMAGE_MAXIMUM)
			to_chat(owner, span_warning("Alert: System corruption in central processing unit."))

/obj/item/organ/internal/stomach/synth
	name = "synth power cell"
	icon = 'modular_skyrat/master_files/icons/obj/surgery.dmi'
	icon_state = "stomach-ipc"
	w_class = WEIGHT_CLASS_NORMAL
	zone = "chest"
	slot = "stomach"
	desc = "A specialised cell, for synthetic use only. Has a low-power mode. Without this, synthetics are unable to stay powered."
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/internal/stomach/synth/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			owner.nutrition = 50
			to_chat(owner, span_warning("Alert: Detected severe battery discharge!"))
		if(2)
			owner.nutrition = 250
			to_chat(owner, span_warning("Alert: Minor battery discharge!"))

/obj/item/organ/internal/ears/synth
	name = "auditory sensors"
	icon = 'modular_skyrat/master_files/icons/obj/surgery.dmi'
	icon_state = "ears-ipc"
	desc = "A pair of microphones intended to be installed in an IPC head, that grant the ability to hear."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EARS
	gender = PLURAL
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/internal/ears/synth/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			owner.set_jitter_if_lower(60 SECONDS)
			owner.set_dizzy_if_lower(60 SECONDS)
			owner.Knockdown(80)
			deaf = 30
			to_chat(owner, span_warning("Your system reports a complete lack of input from your auditory sensors."))
		if(2)
			owner.set_jitter_if_lower(30 SECONDS)
			owner.set_dizzy_if_lower(30 SECONDS)
			owner.Knockdown(40)
			to_chat(owner, span_warning("Your system reports anomalous feedback from your auditory sensors."))

/obj/item/organ/internal/tongue/synth
	name = "synthetic voicebox"
	desc = "A voice synthesizer that allows synths to communicate with lifeforms. Tuned to sound less agressive than robotic voiceboxes."
	status = ORGAN_ROBOTIC
	icon = 'modular_skyrat/master_files/icons/obj/surgery.dmi'
	icon_state = "tongue-ipc"
	say_mod = "beeps"
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue
	maxHealth = 100 //RoboTongue!
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/internal/tongue/synth/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/internal/eyes/synth
	name = "optical sensors"
	icon_state = "cybernetic_eyeballs"
	desc = "A very basic set of optical sensors with no extra vision modes or functions."
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/internal/eyes/synth/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	to_chat(owner, span_warning("Electromagnetic interference clouds your optics with static."))
	owner.flash_act(visual = 1)
	if(severity == EMP_HEAVY)
		owner.adjustOrganLoss(ORGAN_SLOT_EYES, 20)

/obj/item/organ/internal/lungs/synth
	name = "heat sink"
	desc = "A device that transfers generated heat to a fluid medium to cool it down. Required to keep your synthetics cool-headed. It's shape resembles lungs." //Purposefully left the 'fluid medium' ambigious for interpretation of the character, whether it be air or fluid cooling
	icon = 'modular_skyrat/master_files/icons/obj/surgery.dmi'
	icon_state = "lungs-ipc"
	safe_nitro_min = 0
	safe_nitro_max = 0
	safe_co2_min = 0
	safe_co2_max = 0
	safe_plasma_min = 0
	safe_plasma_max = 0
	safe_oxygen_min = 0	//What are you doing man, dont breathe with those!
	safe_oxygen_max = 0
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/internal/lungs/synth/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			to_chat(owner, span_warning("Alert: Critical cooling system failure!"))
			owner.adjust_bodytemperature(100*TEMPERATURE_DAMAGE_COEFFICIENT)
		if(2)
			owner.adjust_bodytemperature(30*TEMPERATURE_DAMAGE_COEFFICIENT)

/obj/item/organ/internal/heart/synth
	name = "hydraulic pump engine"
	desc = "An electronic device that handles the hydraulic pumps, powering one's robotic limbs. Without this, synthetics are unable to move."
	organ_flags = ORGAN_SYNTHETIC
	status = ORGAN_ROBOTIC
	icon = 'modular_skyrat/master_files/icons/obj/surgery.dmi'
	icon_state = "heart-ipc"

/obj/item/organ/internal/liver/synth
	name = "reagent processing unit"
	desc = "An electronic device that processes the beneficial chemicals for the synthetic user."
	organ_flags = ORGAN_SYNTHETIC
	status = ORGAN_ROBOTIC
	icon = 'modular_skyrat/master_files/icons/obj/surgery.dmi'
	icon_state = "liver-c"
	filterToxins = FALSE //We dont filter them, we're immune to them

/obj/item/organ/internal/cyberimp/arm/power_cord
	name = "power cord implant"
	desc = "An internal power cord. Useful if you run on elecricity. Not so much otherwise."
	contents = newlist(/obj/item/apc_powercord)
	zone = "l_arm"

/obj/item/apc_powercord
	name = "power cord"
	desc = "An internal power cord. Useful if you run on electricity. Not so much otherwise."
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

/obj/item/apc_powercord/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!istype(target, /obj/machinery/power/apc) || !ishuman(user) || !proximity_flag)
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)
	var/obj/machinery/power/apc/target_apc = target
	var/mob/living/carbon/human/ipc = user
	var/obj/item/organ/internal/stomach/synth/cell = locate(/obj/item/organ/internal/stomach/synth) in ipc.internal_organs
	if(!cell)
		to_chat(ipc, span_warning("You try to siphon energy from the [target_apc], but your power cell is gone! How are you still standing?"))
		return

	if(target_apc.cell && target_apc.cell.charge > 0)
		if(ipc.nutrition >= NUTRITION_LEVEL_WELL_FED)
			to_chat(user, span_warning("You are already fully charged!"))
			return
		else
			powerdraw_loop(target_apc, ipc)
			return

	to_chat(user, span_warning("There is no charge to draw from that APC."))

#define SYNTH_CHARGE_MAX 150
#define SYNTH_CHARGE_MIN 50
#define SYNTH_CHARGE_PER_NUTRITION 10
#define SYNTH_CHARGE_DELAY_PER_100 10

/obj/item/apc_powercord/proc/powerdraw_loop(obj/machinery/power/apc/target_apc, mob/living/carbon/human/user)
	user.visible_message(span_notice("[user] inserts a power connector into the [target_apc]."), span_notice("You begin to draw power from the [target_apc]."))

	while(TRUE)
		var/power_needed = NUTRITION_LEVEL_WELL_FED - user.nutrition // How much charge do we need in total?
		// Do we even need anything?
		if(power_needed <= 0)
			to_chat(user, span_notice("You are fully charged."))
			break

		// Is the APC almost empty?
		if(target_apc.cell.percent() < 10)
			to_chat(user, span_warning("[target_apc]'s emergency power is active."))
			break

		// Calculate how much to draw this cycle
		var/power_use = clamp(power_needed, SYNTH_CHARGE_MIN, SYNTH_CHARGE_MAX)
		power_use = clamp(power_use, 0, target_apc.cell.charge)
		// Are we able to draw anything?
		if(power_use == 0)
			to_chat(user, span_warning("[target_apc] lacks the power to charge you."))
			break

		// Calculate the delay.
		var/power_delay = (power_use / 100) * SYNTH_CHARGE_DELAY_PER_100
		// Attempt to run a charging cycle.
		if(!do_after(user, power_delay, target = target_apc))
			break

		// Use the power and increase nutrition.
		target_apc.cell.use(power_use)
		user.nutrition += power_use / SYNTH_CHARGE_PER_NUTRITION
		do_sparks(1, FALSE, target_apc)

	user.visible_message(span_notice("[user] unplugs from the [target_apc]."), span_notice("You unplug from the [target_apc]."))

#undef SYNTH_CHARGE_MAX
#undef SYNTH_CHARGE_MIN
#undef SYNTH_CHARGE_PER_NUTRITION
#undef SYNTH_CHARGE_DELAY_PER_100

#undef SYNTH_EMP_BRAIN_DAMAGE_HEAVY
#undef SYNTH_EMP_BRAIN_DAMAGE_LIGHT
#undef SYNTH_EMP_BRAIN_DAMAGE_MAXIMUM
