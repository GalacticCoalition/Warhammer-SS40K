/mob/living/silicon/robot/examine(mob/user)
	. = list("<span class='info'>This is [icon2html(src, user)] \a <EM>[src]</EM>!") //SKYRAT EDIT CHANGE
	if(desc)
		. += "[desc]"

	var/obj/act_module = get_active_held_item()
	if(act_module)
		. += "It is holding [icon2html(act_module, user)] \a [act_module]."
	. += status_effect_examines()
	if (getBruteLoss())
		if (getBruteLoss() < maxHealth*0.5)
			. += span_warning("It looks slightly dented.")
		else
			. += span_warning("<B>It looks severely dented!</B>")
	if (getFireLoss() || getToxLoss())
		var/overall_fireloss = getFireLoss() + getToxLoss()
		if (overall_fireloss < maxHealth * 0.5)
			. += span_warning("It looks slightly charred.")
		else
			. += span_warning("<B>It looks severely burnt and heat-warped!</B>")
	if (health < -maxHealth*0.5)
		. += span_warning("It looks barely operational.")
	if (fire_stacks < 0)
		. += span_warning("It's covered in water.")
	else if (fire_stacks > 0)
		. += span_warning("It's coated in something flammable.")

	if(opened)
		. += span_warning("Its cover is open and the power cell is [cell ? "installed" : "missing"].")
	else
		. += "Its cover is closed[locked ? "" : ", and looks unlocked"]."

	if(cell && cell.charge <= 0)
		. += span_warning("Its battery indicator is blinking red!")

	switch(stat)
		if(CONSCIOUS)
			if(shell)
				. += "It appears to be an [deployed ? "active" : "empty"] AI shell."
			else if(!client)
				. += "It appears to be in stand-by mode." //afk
		if(SOFT_CRIT, UNCONSCIOUS, HARD_CRIT)
			. += span_warning("It doesn't seem to be responding.")
		if(DEAD)
			. += "<span class='deadsay'>It looks like its system is corrupted and requires a reset.</span>"
	//SKYRAT EDIT ADDITION BEGIN - CUSTOMIZATION
	var/flavor_text_link
	var/silicon_preview_text = client.prefs.read_preference(/datum/preference/text/silicon_flavor_preview)
	if (!silicon_preview_text && silicon_preview_text != "") //sanity check, not sure if silicon_preview_text being "" counts as null but want to make sure it doesnt trip up
		flavor_text_link = span_notice("<a href='?src=[REF(src)];lookup_info=open_examine_panel'>Examine closely...</a>")
		. += flavor_text_link //no need for an if statement if we KNOW we just defined it as something
	else if ((length_char(silicon_preview_text) > FLAVOR_PREVIEW_LENGTH || length_char(silicon_preview_text) < 2) || (silicon_preview_text == FLAVOR_PREVIEW_DEFAULT_VALUE))
		//if the user has gone over the limit, only has 1 char (to prevent most accidental single spaces), or hasnt modified the default value, show the default
		flavor_text_link = span_notice("<a href='?src=[REF(src)];lookup_info=open_examine_panel'>Examine closely...</a>")
	else
		flavor_text_link = span_notice("[silicon_preview_text]...<a href='?src=[REF(src)];lookup_info=open_examine_panel'> Look closer?</a>")
	if (flavor_text_link) //i believe this is a sanity check
		. += flavor_text_link
	if(client)
		var/erp_status_pref = client.prefs.read_preference(/datum/preference/choiced/erp_status)
		if(erp_status_pref && erp_status_pref != "disabled")
			. += span_notice("ERP STATUS: [erp_status_pref]")
	if(temporary_flavor_text)
		if(length_char(temporary_flavor_text) <= 40)
			. += span_notice("<b> They look different than usual:</b> [temporary_flavor_text]")
		else
			. += span_notice("<b> They look different than usual:</b> [copytext_char(temporary_flavor_text, 1, 37)]... <a href='?src=[REF(src)];temporary_flavor=1'>More...</a>")
	//SKYRAT EDIT ADDITION END
	//. += "*---------*</span>"

	. += ..()
