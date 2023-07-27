/obj/item/mod/control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MODsuit", name)
		ui.open()

/obj/item/mod/control/ui_data(mob/user)
	var/data = list()
<<<<<<< HEAD
	data["interface_break"] = interface_break
	data["malfunctioning"] = malfunctioning
	data["open"] = open
	data["active"] = active
	data["locked"] = locked
	data["complexity"] = complexity
	data["selected_module"] = selected_module?.name
	data["wearer_name"] = wearer ? (wearer.get_authentification_name("Unknown") || "Unknown") : "No Occupant"
	data["wearer_job"] = wearer ? wearer.get_assignment("Unknown", "Unknown", FALSE) : "No Job"
	// SKYRAT EDIT START - pAIs in MODsuits
	data["pAI"] = mod_pai?.name
	data["ispAI"] = mod_pai ? mod_pai == user : FALSE
	// SKYRAT EDIT END
	data["core"] = core?.name
	data["charge"] = get_charge_percent()
	data["modules"] = list()
=======
	// Suit information
	var/suit_status = list(
		"core_name" = core?.name,
		"cell_charge_current" = get_charge(),
		"cell_charge_max" = get_max_charge(),
		"active" = active,
		"ai_name" = ai?.name,
		// Wires
		"open" = open,
		"seconds_electrified" = seconds_electrified,
		"malfunctioning" = malfunctioning,
		"locked" = locked,
		"interface_break" = interface_break,
		// Modules
		"complexity" = complexity,
	)
	data["suit_status"] = suit_status
	// User information
	var/user_status = list(
		"user_name" = wearer ? (wearer.get_authentification_name("Unknown") || "Unknown") : "",
		"user_assignment" = wearer ? wearer.get_assignment("Unknown", "Unknown", FALSE) : "",
	)
	data["user_status"] = user_status
	// Module information
	var/module_custom_status = list()
	var/module_info = list()
>>>>>>> f83e03252f3 (New MOD Suit UI (#77022))
	for(var/obj/item/mod/module/module as anything in modules)
		module_custom_status += module.add_ui_data()
		module_info += list(list(
			"module_name" = module.name,
			"description" = module.desc,
			"module_type" = module.module_type,
			"module_active" = module.active,
			"pinned" = module.pinned_to[REF(user)],
			"idle_power" = module.idle_power_cost,
			"active_power" = module.active_power_cost,
			"use_power" = module.use_power_cost,
			"module_complexity" = module.complexity,
			"cooldown_time" = module.cooldown_time,
			"cooldown" = round(COOLDOWN_TIMELEFT(module, cooldown_timer), 1 SECONDS),
			"id" = module.tgui_id,
			"ref" = REF(module),
			"configuration_data" = module.get_configuration()
		))
	data["module_custom_status"] = module_custom_status
	data["module_info"] = module_info
	return data

/obj/item/mod/control/ui_static_data(mob/user)
	var/data = list()
	data["ui_theme"] = ui_theme
	data["control"] = name
	data["complexity_max"] = complexity_max
	data["helmet"] = helmet?.name
	data["chestplate"] = chestplate?.name
	data["gauntlets"] = gauntlets?.name
	data["boots"] = boots?.name
	return data

/obj/item/mod/control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	// allowed() doesn't allow for pAIs
	if((!allowed(usr) || !ispAI(usr)) && locked) // SKYRAT EDIT - pAIs in MODsuits
		balloon_alert(usr, "insufficient access!")
		playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		return
	if(malfunctioning && prob(75))
		balloon_alert(usr, "button malfunctions!")
		return
	switch(action)
		if("lock")
			locked = !locked
			balloon_alert(usr, "[locked ? "locked" : "unlocked"]!")
		if("activate")
			toggle_activate(usr)
		if("select")
			var/obj/item/mod/module/module = locate(params["ref"]) in modules
			if(!module)
				return
			module.on_select()
		if("configure")
			var/obj/item/mod/module/module = locate(params["ref"]) in modules
			if(!module)
				return
			module.configure_edit(params["key"], params["value"])
		if("pin")
			var/obj/item/mod/module/module = locate(params["ref"]) in modules
			if(!module)
				return
			module.pin(usr)
		// SKYRAT EDIT START - pAIs in MODsuits
		if("remove_pai")
			if(ishuman(usr)) // Only the MODsuit's wearer should be removing the pAI.
				var/mob/user = usr
				extract_pai(user)
		// SKYRAT EDIT END
	return TRUE
