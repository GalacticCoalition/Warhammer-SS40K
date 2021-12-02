/*
MICROFUSION CELL SYSTEM

Microfusion cells are small battery units that house controlled nuclear fusion within, and that fusion is converted into useable energy.

They cannot be charged as standard, and require upgrades to do so.

These are basically advanced cells.
*/

/obj/item/stock_parts/cell/microfusion //Just a standard cell.
	name = "microfusion cell"
	desc = "A standard-issue microfusion cell, produced by Micron Control Systems. Smaller than a can of soda, these fulfill the need for a power source where plugging into a recharger is inconvenient or unavailable; although they will eventually run dry due to being shipped without a fuel source."
	icon = 'modular_skyrat/modules/microfusion/icons/microfusion_cells.dmi'
	charge_overlay_icon = 'modular_skyrat/modules/microfusion/icons/microfusion_cells.dmi'
	icon_state = "microfusion"
	w_class = WEIGHT_CLASS_NORMAL
	maxcharge = 1200 //12 shots
	chargerate = 0 //Standard microfusion cells can't be recharged, they're single use.
	microfusion_readout = TRUE

	/// A hard referenced list of upgrades currently attached to the weapon.
	var/list/attachments = list()
	/// Are we melting down? For icon stuffs.
	var/meltdown = FALSE
	/// How many upgrades can you have on this cell?
	var/max_attachments = 1
	/// Hard ref to the parent gun.
	var/obj/item/gun/microfusion/parent_gun
	/// Do we play an alarm when empty?
	var/empty_alarm = TRUE
	/// What sound do we play when empty?
	var/empty_alarm_sound = 'sound/weapons/gun/general/empty_alarm.ogg'
	/// Do we have the self charging upgrade?
	var/self_charging = FALSE

/obj/item/stock_parts/cell
	/// Is this cell stabilised? (used in microfusion guns)
	var/stabilised = FALSE
	/// Do we show the microfusion readout instead of KJ?
	var/microfusion_readout = FALSE

/obj/item/stock_parts/cell/microfusion/Destroy()
	if(attachments.len)
		for(var/obj/item/iterating_item as anything in attachments)
			iterating_item.forceMove(get_turf(src))
		attachments = null
	parent_gun = null
	return ..()

/obj/item/stock_parts/cell/microfusion/attackby(obj/item/attacking_item, mob/living/user, params)
	if(istype(attacking_item, /obj/item/microfusion_cell_attachment))
		add_attachment(attacking_item, user)
		return
	return ..()

/obj/item/stock_parts/cell/microfusion/emp_act(severity)
	var/prob_percent = charge / 100 * severity
	if(prob(prob_percent) && !meltdown && !stabilised && parent_gun)
		process_instability()

/obj/item/stock_parts/cell/microfusion/use(amount)
	if(charge >= amount)
		var/check_if_empty = charge - amount
		if(check_if_empty < amount && empty_alarm && !self_charging)
			playsound(src, empty_alarm_sound, 50)
	return ..()

/obj/item/stock_parts/cell/microfusion/proc/process_instability()
	var/seconds_to_explode = rand(MICROFUSION_CELL_FAILURE_LOWER, MICROFUSION_CELL_FAILURE_UPPER)
	meltdown = TRUE
	say("Malfunction in [seconds_to_explode] seconds!")
	playsound(src, 'sound/machines/warning-buzzer.ogg', 30, FALSE, FALSE)
	add_filter("rad_glow", 2, list("type" = "outline", "color" = "#ff5e0049", "size" = 2))
	addtimer(CALLBACK(src, .proc/process_failure), seconds_to_explode)

/obj/item/stock_parts/cell/microfusion/proc/process_failure()
	var/fuckup_type = rand(1, 4)
	remove_filter("rad_glow")
	playsound(src, 'sound/effects/spray.ogg', 70)
	switch(fuckup_type)
		if(MICROFUSION_CELL_FAILURE_TYPE_CHARGE_DRAIN)
			charge = clamp(charge - MICROFUSION_CELL_DRAIN_FAILURE, 0, maxcharge)
		if(MICROFUSION_CELL_FAILURE_TYPE_EXPLOSION)
			explode()
		if(MICROFUSION_CELL_FAILURE_TYPE_EMP)
			empulse(get_turf(src), MICROFUSION_CELL_EMP_HEAVY_FAILURE, MICROFUSION_CELL_EMP_LIGHT_FAILURE, FALSE)
		if(MICROFUSION_CELL_FAILURE_TYPE_RADIATION)
			radiation_pulse(src, MICROFUSION_CELL_RADIATION_RANGE_FAILURE, RAD_MEDIUM_INSULATION)
	meltdown = FALSE

/obj/item/stock_parts/cell/microfusion/update_overlays()
	. = ..()
	for(var/obj/item/microfusion_cell_attachment/microfusion_cell_attachment as anything in attachments)
		. += microfusion_cell_attachment.attachment_overlay_icon_state

/obj/item/stock_parts/cell/microfusion/screwdriver_act(mob/living/user, obj/item/tool)
	if(!attachments.len)
		to_chat(user, span_danger("There are no attachments to remove!"))
		return
	remove_attachments()
	playsound(src, 'sound/items/screwdriver.ogg', 70, TRUE)
	to_chat(user, span_notice("You remove the upgrades from [src]."))

/obj/item/stock_parts/cell/microfusion/process(delta_time)
	for(var/obj/item/microfusion_cell_attachment/microfusion_cell_attachment as anything in attachments)
		microfusion_cell_attachment.process_attachment(src, delta_time)

/obj/item/stock_parts/cell/microfusion/examine(mob/user)
	. = ..()
	. += span_notice("It can hold [max_attachments] attachment(s).")
	if(attachments.len)
		for(var/obj/item/microfusion_cell_attachment/microfusion_cell_attachment as anything in attachments)
			. += span_notice("It has a [microfusion_cell_attachment.name] installed.")
		. += span_notice("Use a <b>screwdriver</b> to remove the upgrades.")

/obj/item/stock_parts/cell/microfusion/proc/add_attachment(obj/item/microfusion_cell_attachment/microfusion_cell_attachment, mob/living/user)
	if(attachments.len >= max_attachments)
		to_chat(user, span_warning("[src] cannot fit any more attachments!"))
		return FALSE
	if(is_type_in_list(microfusion_cell_attachment, attachments))
		to_chat(user, span_warning("[src] already has [microfusion_cell_attachment] installed!"))
		return FALSE
	attachments += microfusion_cell_attachment
	microfusion_cell_attachment.forceMove(src)
	microfusion_cell_attachment.add_attachment(src)
	to_chat(user, span_notice("You successfully install [microfusion_cell_attachment] onto [src]!"))
	playsound(src, 'sound/effects/structure_stress/pop2.ogg', 70, TRUE)
	update_appearance()
	return TRUE

/obj/item/stock_parts/cell/microfusion/proc/remove_attachments()
	for(var/obj/item/microfusion_cell_attachment/microfusion_cell_attachment in attachments)
		microfusion_cell_attachment.remove_attachment(src)
		microfusion_cell_attachment.forceMove(get_turf(src))
		attachments -= microfusion_cell_attachment
	update_appearance()

/datum/crafting_recipe/makeshift/microfusion_cell
	name = "Makeshift Microfusion Cell"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WELDER)
	result = /obj/item/stock_parts/cell/microfusion/makeshift
	reqs = list(/obj/item/trash/can = 1,
				/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/cable_coil = 1)
	time = 12 SECONDS
	category = CAT_MISC

//WHY WOULD YOU MAKE THIS?
/obj/item/stock_parts/cell/microfusion/makeshift
	name = "makeshift microfusion cell"
	desc = "An.. apparatus, comprised of an everyday aluminum can with several civilian-grade batteries tightly packed together and plugged in. This vaguely resembles a microfusion cell, if the user tilts their head to a precise fifty degree angle. While the effects on enemy combatants may be dubious, it will certainly do incredible damage to the gun's warranty. What the hell were you thinking when you came up with this?"
	icon_state = "microfusion_makeshift"
	maxcharge = 600
	max_attachments = 0
	/// The probability of the cell failing
	var/fail_prob = 10

/obj/item/stock_parts/cell/microfusion/makeshift/use(amount)
	if(prob(fail_prob))
		process_instability()
	return ..()

/obj/item/stock_parts/cell/microfusion/enhanced
	name = "enhanced microfusion cell"
	desc = "A second generation microfusion cell, weighing about the same as the standard-issue cell and having the same space for attachments; however, it has a higher capacity."
	icon_state = "microfusion_enhanced"
	maxcharge = 1500

/obj/item/stock_parts/cell/microfusion/advanced
	name = "advanced microfusion cell"
	desc = "A third generation microfusion cell, boasting a much higher shot count. Additionally, these come with support for up to three modifications to the cell itself."
	icon_state = "microfusion_advanced"
	maxcharge = 1700
	max_attachments = 3

/obj/item/stock_parts/cell/microfusion/bluespace
	name = "bluespace microfusion cell"
	desc = "A fourth generation microfusion cell, employing bluespace technology to store power in a medium that's bigger on the inside. This has the highest capacity of any man-portable cell, and has flexibility for four different attachments to the cell itself."
	icon_state = "microfusion_bluespace"
	maxcharge = 2000
	max_attachments = 4

/obj/item/stock_parts/cell/microfusion/nanocarbon
	name = "nanocarbon fusion cell"
	desc = "This cell combines both top-of-the-line nanotech and advanced microfusion power to brute force the most common issue of Nanotrasen Asset Protection operatives, ammunition, through sheer volume. Intended for use with Nanotrasen-brand capacitor arrays only. Warranty void if dropped in toilet."
	icon_state = "microfusion_bluespace"
	maxcharge = 30000
	max_attachments = 420
