#define FIRE_SPEED_REGULAR 3 SECONDS
#define FIRE_SPEED_SYNDIE 1.5 SECONDS

/obj/item/clothing/head/hair_tie
	name = "hair tie"
	desc = "An elastic hair tie, made to hold your hair up!"
	icon = 'modular_skyrat/modules/salon/icons/items.dmi'
	icon_state = "hairtie"
	worn_icon = 'modular_skyrat/modules/salon/icons/items.dmi'
	worn_icon_state = "none"
	lefthand_file = 'modular_skyrat/modules/salon/icons/items.dmi'
	righthand_file = 'modular_skyrat/modules/salon/icons/items.dmi'
	inhand_icon_state = "none"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_CREW * 0.2
	//string which set_hairstyle() will read
	var/picked_hairstyle
	//storage for the original hairstyle string
	var/actual_hairstyle

/obj/item/clothing/head/hair_tie/scrunchie
	name = "scrunchie"
	desc = "An elastic hair tie, its fabric is velvet soft."
	icon_state = "hairtie_scrunchie"

/obj/item/clothing/head/hair_tie/plastic_beads
	name = "colorful hair tie"
	desc = "An elastic hair tie, adornished with colorful plastic beads."
	icon_state = "hairtie_beads"
	custom_materials = (list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT*5))

/obj/item/clothing/head/hair_tie/syndicate
	name = "\improper Syndicate hair tie"
	desc = "An elastic hair tie with a metal clip, brandishing the logo of the Syndicate."
	icon_state = "hairtie_syndie"

/obj/item/clothing/head/hair_tie/examine(mob/user)
	. = ..()
	if(picked_hairstyle)
		. += span_notice("Wearing it will change your hairstyle to '[picked_hairstyle]'.")
	. += span_notice("Click [src] to pick a new hairstyle.")
	. += span_notice("Alt-click [src] to fling it.")

/obj/item/clothing/head/hair_tie/mob_can_equip(mob/living/carbon/human/user, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(user.hairstyle == "Bald") //could create a list of the bald hairstyles to check
		return FALSE
	return ..()

/obj/item/clothing/head/hair_tie/attack_self(mob/user)
	var/hair_id = tgui_input_list(user, "How does your hair look when its up?", "Pick!", GLOB.hairstyles_list)
	if(!hair_id || hair_id == "Bald")
		balloon_alert(user, "error!")
		return
	balloon_alert(user, "[hair_id]")
	picked_hairstyle = hair_id

/obj/item/clothing/head/hair_tie/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!ishuman(user) || !(slot_flags & slot))
		return
	if(!picked_hairstyle)
		return
	user.visible_message(
			span_notice("[user.name] ties up [user.p_their()] hair."),
			span_notice("You tie up your hair!"),
		)
	actual_hairstyle = user.hairstyle
	user.set_hairstyle(picked_hairstyle, update = TRUE)

/obj/item/clothing/head/hair_tie/dropped(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return
	if(!picked_hairstyle || !actual_hairstyle)
		return
	user.visible_message(
			span_notice("[user.name] takes [src] out of [user.p_their()] hair."),
			span_notice("You let down your hair!"),
		)
	user.set_hairstyle(actual_hairstyle, update = TRUE)
	actual_hairstyle = null

/obj/item/clothing/head/hair_tie/AltClick(mob/living/user)
	. = ..()
	if(!(user.get_slot_by_item(src) == ITEM_SLOT_HANDS))
		return
	user.visible_message(
	span_danger("[user.name] puts [src] around [user.p_their()] fingers, beginning to flick it!"),
	span_notice("You try to flick [src]!"),
	)
	flick_hair_tie(user)

/obj/item/clothing/head/hair_tie/proc/flick_hair_tie(mob/living/user)
	//find out if this is the syndie hair tie
	var/syndie = istype(src, /obj/item/clothing/head/hair_tie/syndicate)
	if(!do_after(user, syndie ? FIRE_SPEED_SYNDIE : FIRE_SPEED_REGULAR, src))
		return
	//pick and build the right projectile
	var/obj/projectile/proj_to_fire = syndie ? /obj/projectile/bullet/hair_tie/syndicate : /obj/projectile/bullet/hair_tie
	var/obj/projectile/bullet/hair_tie/proj = new proj_to_fire (drop_location())
	//clone some vars
	proj.name = name
	proj.icon_state = icon_state
	//add projectile_drop
	proj.AddElement(/datum/element/projectile_drop, type)
	//fire the projectile
	proj.firer = user
	proj.fired_from = user
	proj.fire(dir2angle(user.dir) + (syndie ? 0 : rand(-30, 30)))
	playsound(src, 'sound/weapons/effects/batreflect.ogg', 25, TRUE)
	//get rid of what we just launched to let projectile_drop spawn a new one
	qdel(src)

/obj/projectile/bullet/hair_tie
	icon = 'modular_skyrat/modules/salon/icons/items.dmi'
	hitsound = 'sound/weapons/genhit.ogg'
	damage = 0 //its just about the knockdown
	sharpness = NONE
	shrapnel_type = NONE //no embedding pls
	impact_effect_type = null
	ricochet_chance = 0
	range = 7
	knockdown = 1 SECONDS

/obj/projectile/bullet/hair_tie/syndicate
	damage = 10 //getting hit with this one fucking sucks
	stamina = 30
	eyeblur = 2 SECONDS
	jitter = 8 SECONDS

/datum/design/plastic_hair_tie
	name = "Plastic Hair Tie"
	id = "plastic_hair_tie"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE | COLONY_FABRICATOR
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/head/hair_tie/plastic_beads
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

#undef FIRE_SPEED_REGULAR
#undef FIRE_SPEED_SYNDIE
