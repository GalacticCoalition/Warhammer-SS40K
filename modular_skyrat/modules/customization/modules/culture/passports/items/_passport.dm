#define PASSPORT_CLOSED "closed"
#define PASSPORT_OPENED "opened"
#define PASSPORT_CLOSING "closing"
#define PASSPORT_OPENING "opening"

/obj/item/proc/get_passport()
	return

// This type should only ever be given to very poor backgrounds that aren't backed by an empire.
/obj/item/passport
	name = "passport papers"
	icon = 'modular_skyrat/master_files/icons/obj/passports.dmi'
	desc = "A bundle of papers indicating where you originated from, as well as who you are. Made from a non-flammable paper-like material."
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID

	var/icon_state_base = "generic"
	var/icon_state_ext = PASSPORT_CLOSED
	var/has_closed_state = FALSE
	var/has_animation = FALSE
	var/tgui_style = "paper"

	var/holder_faction
	var/holder_locale
	var/holder_age
	var/holder_name

	var/list/cached_data
	var/imprinted = FALSE

/obj/item/passport/Initialize(mapload)
	. = ..()
	switch(has_closed_state)
		if(TRUE)
			icon_state = "[icon_state_base]_[icon_state_ext]"
		else
			icon_state = icon_state_base

// This will not exist in the end code. This is to make testing easier.
// Imprinting will be done by the HoP, and via a traitor item.
/obj/item/passport/CtrlClick(mob/living/carbon/human/user)
	. = ..()
	if (imprinted == FALSE)
		balloon_alert(user, "imprinting...")
		imprint_owner(user)
		return
	balloon_alert(user, "already imprinted!")
	return

/obj/item/passport/get_passport()
	return src

/obj/item/passport/proc/imprint_owner(mob/living/carbon/human/user)
	if(!istype(user) || !user.client?.prefs)
		return

	holder_faction = user.client?.prefs?.culture_faction
	holder_locale = user.client?.prefs?.culture_location
	holder_age = user.age
	cached_data = null
	get_data() // This may have a performance hit at round start, but this will ensure things don't get stored inconsistently.
	imprinted = TRUE

/obj/item/passport/AltClick(mob/user)
	if(!has_closed_state)
		return

	switch(icon_state_ext)
		if(PASSPORT_CLOSED)
			icon_state_ext = PASSPORT_OPENED
			if(has_animation)
				flick(icon(icon, "[icon_state_base]_[PASSPORT_OPENING]"), src)
		if(PASSPORT_OPENED)
			icon_state_ext = PASSPORT_CLOSED
			if(has_animation)
				flick(icon(icon, "[icon_state_base]_[PASSPORT_CLOSING]"), src)

	icon_state = "[icon_state_base]_[icon_state_ext]"
	balloon_alert(user, "[icon_state_ext] [src.name]")

/obj/item/passport/ShiftClick(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/passport/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Passport", name, 400, 350)
		ui.open()

/obj/item/passport/ui_data(mob/user)
	return get_data()

/obj/item/passport/proc/get_headshot_from_datacore(name)
	var/list/datacore_entry = GLOB.name_to_datacore_entry[name]
	if(datacore_entry)
		var/datum/data/record/general_record = datacore_entry["general"]
		var/obj/item/photo/photo = general_record.get_front_photo()
		var/icon/headshot_crop = icon(photo.picture.picture_image)
		headshot_crop.Crop(9, 32, 24, 17)
		return headshot_crop

/obj/item/passport/proc/get_data()
	RETURN_TYPE(/list)
	if(!cached_data)
		var/datum/background_info/social_background/social_background = GLOB.social_backgrounds[holder_faction]
		var/datum/background_info/employment/employment = GLOB.employment[holder_faction]
		var/datum/background_info/origin/origin = GLOB.origins[holder_faction]
		cached_data = list(
			"name" = holder_name,
			"tgui_style" = tgui_style,
			"headshot_data" = icon2base64(get_headshot_from_datacore(holder_name)),
			"empire" = social_background.name,
			"employment" = employment.name,
			"age" = holder_age,
			"space_faring" = social_background.space_faring,
		)
	return cached_data

#undef PASSPORT_CLOSED
#undef PASSPORT_OPENED
