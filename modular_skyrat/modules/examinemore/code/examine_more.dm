/*
EXTRA EXAMINE MODULE

This is the module for handling items with special examine stats,
like syndicate items having information in their description that
would only be recognisable with someone that had the syndicate trait.
*/

/obj/item
	//The special description that is triggered when special_desc_requirements are met. Make sure you set the correct EXAMINE_CHECK!
	var/special_desc = ""

	//The requirement setting for special descriptions. See examine_defines.dm for more info.
	var/special_desc_requirement = EXAMINE_CHECK_NONE

	//The ROLE requirement setting if EXAMINE_CHECK_ROLE is set. E.g. ROLE_SYNDICATE. As you can see, it's a list. So when setting it, ensure you do = list(shit1, shit2)
	var/special_desc_roles = list()

	//The JOB requirement setting if EXAMINE_CHECK_JOB is set. E.g. "Security Officer". As you can see, it's a list. So when setting it, ensure you do = list(shit1, shit2)
	var/special_desc_jobs = list()

	//The FACTION requirement setting if EXAMINE_CHECK_FACTION is set. E.g. "Syndicate". As you can see, it's a list. So when setting it, ensure you do = list(shit1, shit2)
	var/special_desc_factions = list()


/obj/item/examine_more(mob/user)
	. = list()
	if(special_desc)
		var/composed_message
		switch(special_desc_requirement)
			if(EXAMINE_CHECK_NONE)
				composed_message = "You note the following: <br>"
				composed_message += special_desc
				. += composed_message
			if(EXAMINE_CHECK_MINDSHIELD)
				if(ishuman(user))
					if(HAS_TRAIT(user, TRAIT_MINDSHIELD))
						composed_message = "You note the following because of your <span class='blue'><b>mindshield</b></span>: <br>"
						composed_message += special_desc
						. += composed_message
			if(EXAMINE_CHECK_SYNDICATE)
				if(user.mind)
					var/datum/mind/M = user.mind
					if(M.special_role == ROLE_TRAITOR || ROLE_SYNDICATE in user.faction)
						composed_message = "You note the following because of your <span class='red'><b>Syndicate affiliation</b></span>: <br>"
						composed_message += special_desc
						. += composed_message
					else if(ishuman(user))
						var/mob/living/carbon/human/H = user
						if(H.job == "Detective")  //Useful detective!
							composed_message = "You note the following because of your brilliant <span class='blue'><b>Detective skills</b></span>: <br>"
							composed_message += special_desc
							. += composed_message
			if(EXAMINE_CHECK_SYNDICATE_TOY)
				if(user.mind)
					var/datum/mind/M = user.mind
					if(M.special_role == ROLE_TRAITOR || ROLE_SYNDICATE in user.faction)
						composed_message = "You note the following because of your <span class='red'><b>Syndicate affiliation</b></span>: <br>"
						composed_message += special_desc
						. += composed_message
					else if(ishuman(user))
						var/mob/living/carbon/human/H = user
						if(H.job == "Detective") //Useful detective!
							composed_message = "You note the following because of your brilliant <span class='blue'><b>Detective skills</b></span>: <br>"
							composed_message += special_desc
							. += composed_message
					else
						composed_message = "The popular toy resembling a [src.name] from your local arcade, suitable for children and adults alike."
						. += composed_message
			if(EXAMINE_CHECK_ROLE)
				if(user.mind)
					var/datum/mind/M = user.mind
					for(var/role_i in special_desc_roles)
						if(M.special_role == role_i)
							composed_message = "You note the following because of your <b>[role_i]</b> role: <br>"
							composed_message += special_desc
							. += composed_message
			if(EXAMINE_CHECK_JOB)
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					for(var/job_i in special_desc_jobs)
						if(H.job == job_i)
							composed_message = "You note the following because of your job as a <b>[job_i]</b>: <br>"
							composed_message += special_desc
							. += composed_message
			if(EXAMINE_CHECK_FACTION)
				for(var/faction_i in special_desc_factions)
					if(faction_i in user.faction)
						composed_message = "You note the following because of your loyalty to <b>[faction_i]</b>: <br>"
						composed_message += special_desc
						. += composed_message

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE_MORE, user, .)
	if(!LAZYLEN(.)) // lol ..length
		return list("<span class='notice'><i>You examine [src] closer, but find nothing of interest...</i></span>")

//////////
//Examples:
//////////

/obj/item/storage/backpack/duffelbag/syndie
	name = "duffel bag"
	desc = "A large duffel bag for holding extra supplies."
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE
	special_desc = "This bag is used to store tactical equipment and is manufactured by the syndicate."
