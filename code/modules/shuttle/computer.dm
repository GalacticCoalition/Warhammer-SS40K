/obj/machinery/computer/shuttle
	name = "shuttle console"
	desc = "A shuttle control computer."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	req_access = list( )
	/// ID of the attached shuttle
	var/shuttleId
	/// Possible destinations of the attached shuttle
	var/possible_destinations = ""
	/// Variable dictating if the attached shuttle requires authorization from the admin staff to move
	var/admin_controlled = FALSE
	/// Variable dictating if the attached shuttle is forbidden to change destinations mid-flight
	var/no_destination_swap = FALSE
	/// ID of the currently selected destination of the attached shuttle
	var/destination
	/// If the console controls are locked
	var/locked = FALSE
	/// Authorization request cooldown to prevent request spam to admin staff
	COOLDOWN_DECLARE(request_cooldown)

	var/uses_overmap = TRUE //SKYRAT EDIT ADDITION

/obj/machinery/computer/shuttle/Initialize(mapload)
	. = ..()
	if(!mapload)
		connect_to_shuttle(SSshuttle.get_containing_shuttle(src))

//SKYRAT EDIT ADDITION
/obj/machinery/computer/shuttle/attacked_by(obj/item/smacking_object, mob/living/user)
	if(istype(smacking_object, /obj/item/navigation_datacard))
		var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
		if(M.gateway_stranded)
			to_chat(user, span_notice("You insert [smacking_object] into [src], loading the navigational data!"))
			say("Navigational data loaded.")
			playsound(loc, 'sound/machines/terminal_insert_disc.ogg', 35, 1)
			M.gateway_stranded = FALSE
			qdel(smacking_object)
		else
			to_chat(user, span_notice("[src] does not have a corrupted navigations system!"))
			say("Error loading navigational disk.")
//SKYRAT EDIT END

/obj/machinery/computer/shuttle/ui_interact(mob/user, datum/tgui/ui)
	//SKYRAT EDIT ADDITION/CHANGE
	if(uses_overmap)
		var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
		if(!M)
			return
		var/list/dat = list("<center>")
		var/status_info
		if(admin_controlled)
			status_info = "Unauthorized Access"
		else if(locked)
			status_info = "Locked"
		else if(M.gateway_stranded)
			status_info = "NAVIGATIONAL SYSTEM ERROR, RECALIBRATION REQUIRED!"
		else
			switch(M.mode)
				if(SHUTTLE_IGNITING)
					status_info = "Igniting"
				if(SHUTTLE_IDLE)
					status_info = "Idle"
				if(SHUTTLE_RECHARGING)
					status_info = "Recharging"
				else
					status_info = "In Transit"
		dat += "STATUS: <b>[status_info]</b>"
		var/link
		if(M.mode == SHUTTLE_IDLE)
			link = "href='?src=[REF(src)];task=overmap_launch'"
		else
			link = "class='linkOff'"
		dat += "<BR><BR><a [link]>Depart to Overmap</a><BR>"

		dat += "<a href='?src=[REF(src)];task=engines_on']>Engines On</a> <a href='?src=[REF(src)];task=engines_off']>Engines Off</a>"

		dat += "<BR><BR><a [M.my_overmap_object ? "href='?src=[REF(src)];task=overmap_view'" : "class='linkOff'"]>Overmap View</a>"
		dat += "<BR><a [M.my_overmap_object ? "href='?src=[REF(src)];task=overmap_ship_controls'" : "class='linkOff'"]>Ship Controls</a></center>"
		var/datum/browser/popup = new(user, "shuttle_computer", name, 300, 200)
		popup.set_content(dat.Join())
		popup.open()
	else
		ui = SStgui.try_update_ui(user, src, ui)
		if(!ui)
			ui = new(user, src, "ShuttleConsole", name)
			ui.open()

/obj/machinery/computer/shuttle/Topic(href, href_list)
	var/mob/user = usr
	if(!isliving(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	if(M.gateway_stranded)
		to_chat(usr, span_warning("Shuttle navigation systems are inoperable. Contact your IT supervisor immediately."))
		say("Navigational systems error.")
		playsound(src, 'modular_skyrat/modules/overmap/sound/shuttle_voice/error_navigation.ogg', OVERMAP_SHUTTLE_ALERT_VOLUME)
		return
	switch(href_list["task"])
		if("engines_off")
			M.TurnEnginesOff()
			say("Engines offline.")
			playsound(src, 'modular_skyrat/modules/overmap/sound/shuttle_voice/engines_off.ogg', OVERMAP_SHUTTLE_ALERT_VOLUME)
		if("engines_on")
			M.TurnEnginesOn()
			say("Engines online.")
			playsound(src, 'modular_skyrat/modules/overmap/sound/shuttle_voice/engines_on.ogg', OVERMAP_SHUTTLE_ALERT_VOLUME)
		if("overmap_view")
			if(M.my_overmap_object)
				M.my_overmap_object.GrantOvermapView(usr, get_turf(src))
				return
		if("overmap_ship_controls")
			if(M.my_overmap_object)
				M.my_overmap_object.DisplayUI(usr, get_turf(src))
				return
		if("overmap_launch")
			if(!uses_overmap)
				return
			if(!launch_check(usr))
				return
			if(M.launch_status == ENDGAME_LAUNCHED)
				to_chat(usr, "<span class='warning'>You've already escaped. Never going back to that place again!</span>")
				return
			if(no_destination_swap)
				if(M.mode == SHUTTLE_RECHARGING)
					to_chat(usr, "<span class='warning'>Shuttle engines are not ready for use.</span>")
					return
				if(M.mode != SHUTTLE_IDLE)
					to_chat(usr, "<span class='warning'>Shuttle already in transit.</span>")
					return
			if(uses_overmap)
				if(M.DrawDockingThrust())
					M.possible_destinations = possible_destinations
					M.destination = "overmap"
					M.mode = SHUTTLE_IGNITING
					M.play_engine_sound(src, TRUE)
					M.setTimer(5 SECONDS)
					say("Shuttle departing. Please stand away from the doors.")
					playsound(src, 'modular_skyrat/modules/overmap/sound/shuttle_voice/launch.ogg', OVERMAP_SHUTTLE_ALERT_VOLUME)
					log_shuttle("[key_name(usr)] has sent shuttle \"[M]\" into the overmap.")
					ui_interact(usr)
					return
				else
					say("Engine power insufficient to take off.")
					playsound(src, 'modular_skyrat/modules/overmap/sound/shuttle_voice/error_engines.ogg', OVERMAP_SHUTTLE_ALERT_VOLUME)
	ui_interact(usr)
//SKYRAT EDIT END
/obj/machinery/computer/shuttle/ui_data(mob/user)
	var/list/data = list()
	var/list/options = params2list(possible_destinations)
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	data["docked_location"] = M ? M.get_status_text_tgui() : "Unknown"
	data["locations"] = list()
	data["locked"] = locked
	data["authorization_required"] = admin_controlled
	data["timer_str"] = M ? M.getTimerStr() : "00:00"
	data["destination"] = destination
	if(!M)
		data["status"] = "Missing"
		return data
	if(admin_controlled)
		data["status"] = "Unauthorized Access"
	else if(locked)
		data["status"] = "Locked"
	else
		switch(M.mode)
			if(SHUTTLE_IGNITING)
				data["status"] = "Igniting"
			if(SHUTTLE_IDLE)
				data["status"] = "Idle"
			if(SHUTTLE_RECHARGING)
				data["status"] = "Recharging"
			else
				data["status"] = "In Transit"
	for(var/obj/docking_port/stationary/S in SSshuttle.stationary_docking_ports)
		if(!options.Find(S.port_destinations))
			continue
		if(!M.check_dock(S, silent = TRUE))
			continue
		var/list/location_data = list(
			id = S.id,
			name = S.name
		)
		data["locations"] += list(location_data)
	if(length(data["locations"]) == 1)
		for(var/location in data["locations"])
			destination = location["id"]
			data["destination"] = destination
	if(!length(data["locations"]))
		data["locked"] = TRUE
		data["status"] = "Locked"
	return data

/**
 * Checks if we are allowed to launch the shuttle, for special cases
 *
 * Arguments:
 * * user - The mob trying to initiate the launch
 */
/obj/machinery/computer/shuttle/proc/launch_check(mob/user)
	return TRUE

/obj/machinery/computer/shuttle/ui_act(action, params)
	. = ..()
	//SKYRAT EDIT ADDITION
	if(uses_overmap)
		return
	//SKYRAT EDIT END
	if(.)
		return
	if(!allowed(usr))
		to_chat(usr, span_danger("Access denied."))
		return

	switch(action)
		if("move")
			if(!launch_check(usr))
				return
			var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
			if(M.launch_status == ENDGAME_LAUNCHED)
				to_chat(usr, span_warning("You've already escaped. Never going back to that place again!"))
				return
			if(no_destination_swap)
				if(M.mode == SHUTTLE_RECHARGING)
					to_chat(usr, span_warning("Shuttle engines are not ready for use."))
					return
				if(M.mode != SHUTTLE_IDLE)
					to_chat(usr, span_warning("Shuttle already in transit."))
					return
			var/list/options = params2list(possible_destinations)
			var/obj/docking_port/stationary/S = SSshuttle.getDock(params["shuttle_id"])
			if(!(S.port_destinations in options))
				log_admin("[usr] attempted to href dock exploit on [src] with target location \"[params["shuttle_id"]]\"")
				message_admins("[usr] just attempted to href dock exploit on [src] with target location \"[params["shuttle_id"]]\"")
				return
			switch(SSshuttle.moveShuttle(shuttleId, params["shuttle_id"], 1))
				if(0)
					say("Shuttle departing. Please stand away from the doors.")
					log_shuttle("[key_name(usr)] has sent shuttle \"[M]\" towards \"[params["shuttle_id"]]\", using [src].")
					return TRUE
				if(1)
					to_chat(usr, span_warning("Invalid shuttle requested."))
				else
					to_chat(usr, span_warning("Unable to comply."))
		if("set_destination")
			var/target_destination = params["destination"]
			if(target_destination)
				destination = target_destination
				return TRUE
		if("request")
			if(!COOLDOWN_FINISHED(src, request_cooldown))
				to_chat(usr, span_warning("CentCom is still processing last authorization request!"))
				return
			COOLDOWN_START(src, request_cooldown, 1 MINUTES)
			to_chat(usr, span_notice("Your request has been received by CentCom."))
			to_chat(GLOB.admins, "<b>SHUTTLE: <font color='#3d5bc3'>[ADMIN_LOOKUPFLW(usr)] (<A HREF='?_src_=holder;[HrefToken()];move_shuttle=[shuttleId]'>Move Shuttle</a>)(<A HREF='?_src_=holder;[HrefToken()];unlock_shuttle=[REF(src)]'>Lock/Unlock Shuttle</a>)</b> is requesting to move or unlock the shuttle.</font>")
			return TRUE

/obj/machinery/computer/shuttle/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	req_access = list()
	obj_flags |= EMAGGED
	to_chat(user, span_notice("You fried the consoles ID checking system."))

/obj/machinery/computer/shuttle/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	if(port)
		//Remove old custom port id and ";;"
		var/find_old = findtextEx(possible_destinations, "[shuttleId]_custom")
		if(find_old)
			possible_destinations = replacetext(replacetextEx(possible_destinations, "[shuttleId]_custom", ""), ";;", ";")
		shuttleId = port.id
		possible_destinations += ";[port.id]_custom"
