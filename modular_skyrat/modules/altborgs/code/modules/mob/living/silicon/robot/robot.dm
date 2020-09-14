/mob/living/silicon/robot
	var/robot_resting = FALSE
	var/dogborg = FALSE

/mob/living/silicon/robot/doMove(atom/destination) //Could potentially be a signal instead
	. = ..()
	if(robot_resting)
		robot_resting = FALSE
		update_icons()

/mob/living/silicon/robot/proc/rest_style()
	set name = "Switch Rest Style"
	set category = "IC"
	set desc = "Select your resting pose."
	if(!dogborg)
		to_chat(src, "<span class='warning'>You can't do that!</span>")
	var/choice = alert(src, "Select resting pose", "", "Resting", "Sitting", "Belly up")
	switch(choice)
		if("Resting")
			robot_resting = ROBOT_REST_NORMAL
		if("Sitting")
			robot_resting = ROBOT_REST_SITTING
		if("Belly up")
			robot_resting = ROBOT_REST_BELLY_UP
	update_icons()

/mob/living/silicon/robot/proc/robot_lay_down()
	set name = "Lay down"
	set category = "IC"
	if(!dogborg)
		to_chat(src, "<span class='warning'>You can't do that!</span>")
	if(stat != CONSCIOUS) //Make sure we don't enable movement when not concious
		return
	if(robot_resting)
		to_chat(src, "<span class='notice'>You are now getting up.</span>")
		robot_resting = FALSE
		mobility_flags = MOBILITY_FLAGS_DEFAULT
	else
		to_chat(src, "<span class='notice'>You are now laying down.</span>")
		robot_resting = ROBOT_REST_NORMAL
	update_icons()

/mob/living/silicon/robot/update_mobility()
	..()
	if(dogborg)
		robot_resting = FALSE
		update_icons()

/mob/living/silicon/robot/update_module_innate()
	..()
	if(hands)
		hands.icon = (module.moduleselect_alternate_icon ? module.moduleselect_alternate_icon : initial(hands.icon))

/mob/living/silicon/robot/modules/miner/skyrat
	set_module = /obj/item/robot_module/miner/skyrat

/mob/living/silicon/robot/modules/butler/skyrat
	set_module = /obj/item/robot_module/butler/skyrat

/mob/living/silicon/robot/pick_module()
	if(module.type != /obj/item/robot_module)
		return

	if(wires.is_cut(WIRE_RESET_MODULE))
		to_chat(src,"<span class='userdanger'>ERROR: Module installer reply timeout. Please check internal connections.</span>")
		return

	var/list/skyratmodule = list(
	"Skyrat Service(alt skins)" = /obj/item/robot_module/butler/skyrat,
	"Skyrat Miner(alt skins)" = /obj/item/robot_module/miner/skyrat,
	"Next page" = "next"
	)
	var/input_module_sk = input("Please select a skyrat module if you want one, otherwise select next page.", "Robot", null, null) as null|anything in sortList(skyratmodule)
	if(input_module_sk == "Next page" || !input_module_sk || module.type != /obj/item/robot_module)
		return ..()
	else
		module.transform_to(skyratmodule[input_module_sk])
		return
