#define MAXIMUM_QUICKBIND_SLOTS 5

GLOBAL_LIST_INIT(clockwork_slabs, list())


/obj/item/clockwork
	icon = 'modular_skyrat/modules/clock_cult/icons/clockwork_objects.dmi'
	/// Extra info to give clock cultists, added via the /datum/element/clockwork_description element
	var/clockwork_desc = ""

/obj/item/clockwork/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clockwork_description, clockwork_desc)
	AddElement(/datum/element/clockwork_pickup)

/obj/item/clockwork/clockwork_slab
	name = "Clockwork Slab"
	desc = "A mechanical-looking device filled with intricate cogs that swirl to their own accord."
	clockwork_desc = "A beautiful work of art, harnessing mechanical energy for a variety of useful powers."
	item_flags = NOBLUDGEON
	icon_state = "clockwork_slab"
	lefthand_file = 'modular_skyrat/modules/clock_cult/icons/weapons/clockwork_lefthand.dmi'
	righthand_file = 'modular_skyrat/modules/clock_cult/icons/weapons/clockwork_righthand.dmi'

	/// The scripture currently being invoked
	var/datum/scripture/invoking_scripture
	/// For scriptures that power the slab
	var/datum/scripture/slab/active_scripture

	var/list/scriptures = list()

	var/charge_overlay

	var/calculated_cogs = 0
	var/cogs = 0
	var/list/purchased_scriptures = list(
		//datum/scripture/ark_activation
	)

	//Initialise an empty list for quickbinding
	var/list/quick_bound_scriptures = list(
		1 = null,
		2 = null,
		3 = null,
		4 = null,
		5 = null
	)

	//The default scriptures that get auto-assigned.
	var/list/default_scriptures = list(
		//datum/scripture/abscond,
		//datum/scripture/integration_cog,
		//datum/scripture/clockwork_armaments
	)

	//For trap linkage
	var/datum/component/clockwork_trap/buffer

/obj/item/clockwork/clockwork_slab/Initialize(mapload)
	. = ..()
	if(!length(GLOB.clock_scriptures))
		generate_clockcult_scriptures()
	var/pos = 1
	cogs = GLOB.clock_installed_cogs
	GLOB.clockwork_slabs += src
	for(var/script in default_scriptures)
		if(!script)
			continue
		purchased_scriptures += script
		var/datum/scripture/default_script = new script
		bind_spell(null, default_script, pos++)

/obj/item/clockwork/clockwork_slab/Destroy()
	GLOB.clockwork_slabs -= src
	invoking_scripture = null
	active_scripture = null
	buffer = null
	return ..()

/obj/item/clockwork/clockwork_slab/dropped(mob/user)
	..()
	//Clear quickbinds
	for(var/datum/action/innate/clockcult/quick_bind/script in quick_bound_scriptures)
		script.Remove(user)
	if(active_scripture)
		active_scripture.end_invocation()
	if(buffer)
		buffer = null

/obj/item/clockwork/clockwork_slab/pickup(mob/user)
	..()
	if(!(IS_CLOCK(user)))
		return
	//Grant quickbound spells
	for(var/datum/action/innate/clockcult/quick_bind/script in quick_bound_scriptures)
		script.Grant(user)
	user.update_action_buttons()

/obj/item/clockwork/clockwork_slab/update_overlays()
	. = ..()
	cut_overlays()
	if(charge_overlay)
		add_overlay(charge_overlay)

/// Calculate the differential of old cogs to new cogs
/obj/item/clockwork/clockwork_slab/proc/update_integration_cogs()
	//Calculate cogs
	if(calculated_cogs != GLOB.clock_installed_cogs)
		var/difference = GLOB.clock_installed_cogs - calculated_cogs
		calculated_cogs += difference
		cogs += difference

/// Handle binding a spell to a quickbind slot
/obj/item/clockwork/clockwork_slab/proc/bind_spell(mob/living/binder, datum/scripture/spell, position = 1)
	if(position > length(quick_bound_scriptures) || position <= 0)
		return
	if(quick_bound_scriptures[position])
		//Unbind the scripture that is quickbound
		qdel(quick_bound_scriptures[position])
	//Put the quickbound action onto the slab, the slab should grant when picked up
	var/datum/action/innate/clockcult/quick_bind/quickbound = new
	quickbound.scripture = spell
	quickbound.activation_slab = src
	quick_bound_scriptures[position] = quickbound
	if(binder)
		quickbound.Grant(binder)

// UI things below

/obj/item/clockwork/clockwork_slab/attack_self(mob/living/user)
	if(IS_CULTIST(user))
		to_chat(user, span_bigbrass("You shouldn't be playing with my toys..."))
		user.Stun(60)
		user.adjust_blindness(150)
		user.electrocute_act(10, "[name]")
		return
	if(!(IS_CLOCK(user)))
		to_chat(user, span_warning("You cannot figure out what the device is used for!"))
		return
	if(active_scripture)
		active_scripture.end_invocation()
		return
	if(buffer)
		buffer = null
		to_chat(user, span_brass("You clear the [src]'s buffer."))
		return
	ui_interact(user)

/obj/item/clockwork/clockwork_slab/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ClockworkSlab")
		ui.open()

/obj/item/clockwork/clockwork_slab/ui_data(mob/user)
	var/list/data = list()
	data["cogs"] = cogs
	data["vitality"] = GLOB.clock_vitality
	data["max_vitality"] = GLOB.max_clock_vitality
	data["power"] = GLOB.clock_power
	data["max_power"] = GLOB.max_clock_power
	data["scriptures"] = list()
	//2 scriptures accessable at the same time will cause issues
	for(var/scripture_name in GLOB.clock_scriptures)
		var/datum/scripture/scripture = GLOB.clock_scriptures[scripture_name]
		var/list/scripture_data = list(
			"name" = scripture.name,
			"desc" = scripture.desc,
			"type" = scripture.category,
			"tip" = scripture.tip,
			"cost" = scripture.power_cost,
			"purchased" = (scripture.type in purchased_scriptures),
			"cog_cost" = scripture.cogs_required
		)
		//Add it to the correct list
		data["scriptures"] += list(scripture_data)
	return data

/obj/item/clockwork/clockwork_slab/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/living/living_user = usr
	if(!istype(living_user))
		return FALSE
	switch(action)
		if("invoke")
			var/datum/scripture/scripture = GLOB.clock_scriptures[params["scriptureName"]]
			if(!scripture)
				return FALSE
			if(scripture.type in purchased_scriptures)
				if(invoking_scripture)
					living_user.balloon_alert(living_user, "failed to invoke!")
					return FALSE
				if(scripture.power_cost > GLOB.clock_power)
					living_user.balloon_alert(living_user, "[scripture.power_cost] required!")
					return FALSE
				if(scripture.vitality_cost > GLOB.clock_vitality)
					living_user.balloon_alert(living_user, "[scripture.vitality_cost] required!")
					return FALSE
				var/datum/scripture/new_scripture = new scripture.type()
				//Create a new scripture temporarilly to process, when it's done it will be qdeleted.
				new_scripture.qdel_on_completion = TRUE
				new_scripture.begin_invoke(living_user, src)
			else
				if(cogs >= scripture.cogs_required)
					cogs -= scripture.cogs_required
					living_user.balloon_alert(living_user, "[scripture.name] purchased")
					log_game("[scripture.name] purchased by [living_user.ckey]/[living_user.name] the [living_user.job] for [scripture.cogs_required] cogs, [cogs] cogs remaining.")
					purchased_scriptures += scripture.type
				else
					living_user.balloon_alert(living_user, "need at least [scripture.cogs_required]!")
			return TRUE
		if("quickbind")
			var/datum/scripture/scripture = GLOB.clock_scriptures[params["scriptureName"]]
			if(!scripture)
				return FALSE
			var/list/positions = list()
			for(var/i in 1 to MAXIMUM_QUICKBIND_SLOTS)
				var/datum/scripture/quick_bound = quick_bound_scriptures[i]
				if(!quick_bound)
					positions += "([i])"
				else
					positions += "([i]) - [quick_bound.name]"
			var/position = tgui_input_list(living_user, "Where to quickbind to?", "Quickbind Slot", positions)
			if(!position)
				return FALSE
			//Create and assign the quickbind
			var/datum/scripture/new_scripture = new scripture.type()
			bind_spell(living_user, new_scripture, positions.Find(position))

#undef MAXIMUM_QUICKBIND_SLOTS
