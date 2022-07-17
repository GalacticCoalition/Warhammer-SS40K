///The base NIF program
/datum/nifsoft
	///What is the name of the program?
	var/name = "Generic NIFsoft"
	///A description of what the program does. This is used when looking at programs in the NIF, along with installing them from the store.
	var/program_desc = "This program does stuff!"
	///How much does the program cost to buy?
	var/cost = 100
	//What NIF does this program belong to?
	var/datum/weakref/parent_nif

	///Does the program have an active mode?
	var/active_mode = FALSE
	///Is the program active?
	var/active = FALSE
	///Does the what power cost does the program have while active?
	var/active_cost = 0
	///What is the power cost to activate the program?
	var/activation_cost = 0
	///Does the NIFSoft persist inbetween rounds?
	var/persistence = FALSE
	///What NIF models can this software be installed on?
	var/static/list/compatible_nifs = list(/obj/item/organ/internal/cyberimp/brain/nif)

/datum/nifsoft/New(obj/item/organ/internal/cyberimp/brain/nif/recepient_nif)
	. = ..()

	if(!recepient_nif.install_nifsoft(src))
		qdel(src)

/datum/nifsoft/Destroy()
	if(active)
		activate()

	if(!parent_nif)
		return ..()

	var/obj/item/organ/internal/cyberimp/brain/nif/installed_nif = parent_nif
	installed_nif.loaded_nifsofts.Remove(src)
	parent_nif = null

	..()

/datum/nifsoft/proc/life(mob/living/carbon/human/attached_human)
	return TRUE

/datum/nifsoft/proc/activate()
	var/obj/item/organ/internal/cyberimp/brain/nif/installed_nif = parent_nif

	if(active)
		active = FALSE
		to_chat(installed_nif.linked_mob, span_notice("The [src.name] is no longer running"))
		installed_nif.power_usage -= active_cost
		return TRUE

	if(!installed_nif.use_power(activation_cost))
		return FALSE

	if(active_mode)
		to_chat(installed_nif.linked_mob, span_notice("The [src.name] is now running"))
		installed_nif.power_usage += active_cost
		active = TRUE

	///Delete this later
	to_chat(installed_nif.linked_mob, span_notice("bababoeey"))
	return TRUE

/obj/item/disk/nifsoft_uploader
	name = "Generic NIFSoft datadisk"
	desc = "A datadisk that can be used to upload a loaded NIFSoft to the user's NIF"
	///What NIFSoft is currently loaded in?
	var/datum/nifsoft/loaded_nifsoft = /datum/nifsoft
	///Is the datadisk reusable?
	var/reusable = TRUE

/obj/item/disk/nifsoft_uploader/proc/attempt_software_install(mob/living/carbon/human/target)
	if(!ishuman(target) || !target.installed_nif)
		return FALSE

	var/obj/item/organ/internal/cyberimp/brain/nif/installed_nif = target.installed_nif
	new loaded_nifsoft(installed_nif)

/obj/item/disk/nifsoft_uploader/attack_self(mob/user, modifiers)
	. = ..()
	attempt_software_install(user)

/obj/item/disk/nifsoft_uploader/attack(mob/living/mob, mob/living/user, params)
	. = ..()
	attempt_software_install(mob)
