/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'> Speech is currently admin-disabled.</span>")
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!(prefs.skyrat_toggles & CHAT_LOOC))
		to_chat(src, "<span class='danger'> You have LOOC muted.</span>")
		return
	if(is_banned_from(mob, "OOC"))
		to_chat(src, "<span class='danger'>You have been banned from OOC.</span>")
		return

	if(!holder)
		if(!GLOB.looc_allowed)
			to_chat(src, "<span class='danger'> LOOC is globally muted</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'> You cannot use OOC (muted).</span>")
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(mob.stat)
			to_chat(src, "<span class='danger'>You cannot use LOOC while unconscious or dead.</span>")  //Skyrat change
			return
		if(istype(mob, /mob/dead))
			to_chat(src, "<span class='danger'>You cannot use LOOC while ghosting.</span>")
			return

	msg = emoji_parse(msg)

	mob.log_talk(msg,LOG_OOC, tag="(LOOC)")

	var/list/heard = get_hearers_in_view(7, get_top_level_mob(src.mob))
	for(var/mob/M in heard)
		if(!M.client)
			continue
		var/client/C = M.client
		if (C in GLOB.admins)
			continue //they are handled after that

		if (isobserver(M))
			continue //Also handled later.

		if(C.prefs.skyrat_toggles & CHAT_LOOC)
			to_chat(C, "<span class='looc'><span class='prefix'>LOOC:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]</span></span>")

	for(var/client/C in GLOB.admins)
		if(C.prefs.skyrat_toggles & CHAT_LOOC)
			if (C.mob in heard)
				to_chat(C, "<span class='looc'>[ADMIN_FLW(usr)] <span class='prefix'>LOOC:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span></span>")
			else if (!(C.prefs.skyrat_toggles & CHAT_LOOC_ADMIN))
				to_chat(C, "<span class='looc'>[ADMIN_FLW(usr)] <span class='prefix'>(R)LOOC:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span></span>")
