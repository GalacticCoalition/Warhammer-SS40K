/mob/living/silicon/robot/proc/latejoin_find_parent_ai(target_z_level = 3)
	if(connected_ai)
		return
	for(var/mob/living/silicon/ai/AI in GLOB.silicon_mobs)
		to_chat(world, "Current AI [AI]")
		to_chat(world, "AI z = [AI.z], target Z = [target_z_level]")
		if(AI.z == target_z_level)
			to_chat(world, "setting [AI]")
			set_connected_ai(AI)
			break
	to_chat(world, "Loop over")
	lawsync()
	show_laws()
