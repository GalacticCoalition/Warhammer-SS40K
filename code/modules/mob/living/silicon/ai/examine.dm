/mob/living/silicon/ai/examine(mob/user)
<<<<<<< HEAD
	. = list("<span class='info'>This is [icon2html(src, user)] <EM>[src]</EM>!", EXAMINE_SECTION_BREAK) //SKYRAT EDIT CHANGE
=======
	. = list("<span class='info'>This is [icon2html(src, user)] <EM>[src]</EM>!")
>>>>>>> b864589522f (Examine Blocks (#67937))
	if (stat == DEAD)
		. += span_deadsay("It appears to be powered-down.")
	else
		if (getBruteLoss())
			if (getBruteLoss() < 30)
				. += span_warning("It looks slightly dented.")
			else
				. += span_warning("<B>It looks severely dented!</B>")
		if (getFireLoss())
			if (getFireLoss() < 30)
				. += span_warning("It looks slightly charred.")
			else
				. += span_warning("<B>Its casing is melted and heat-warped!</B>")
		if(deployed_shell)
			. += "The wireless networking light is blinking."
		else if (!shunted && !client)
<<<<<<< HEAD
			. += "[src]Core.exe has stopped responding! NTOS is searching for a solution to the problem...\n"
	//. += "*---------*</span>" SKYRAT EDIT REMOVAL
=======
			. += "[src]Core.exe has stopped responding! NTOS is searching for a solution to the problem..."
	. += "</span>"
>>>>>>> b864589522f (Examine Blocks (#67937))

	. += ..()

/mob/living/silicon/ai/get_examine_string(mob/user, thats = FALSE)
	return null
