/obj/machinery/plumbing/grinder_chemical
	name = "chemical grinder"
	desc = "chemical grinder."
	icon_state = "grinder_chemical"
	layer = ABOVE_ALL_MOB_LAYER

	reagent_flags = TRANSPARENT | DRAINABLE
	buffer = 400

	var/eat_dir = SOUTH

/obj/machinery/plumbing/grinder_chemical/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply, bolt, layer)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, src, loc_connections)

/obj/machinery/plumbing/grinder_chemical/can_be_rotated(mob/user, rotation_type)
	if(anchored)
		to_chat(user, "<span class='warning'>It is fastened to the floor!</span>")
		return FALSE
	return TRUE

/obj/machinery/plumbing/grinder_chemical/setDir(newdir)
	. = ..()
	eat_dir = newdir

/obj/machinery/plumbing/grinder_chemical/CanAllowThrough(atom/movable/AM)
	. = ..()
	if(!anchored)
		return
	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		return TRUE

/obj/machinery/plumbing/grinder_chemical/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	grind(AM)

/obj/machinery/plumbing/grinder_chemical/proc/grind(atom/AM)
	if(machine_stat & NOPOWER)
		return
	if(reagents.holder_full())
		return
	if(!isitem(AM))
		return
	var/obj/item/I = AM
	if(I.juice_results || I.grind_results)
		if(I.juice_results)
			I.on_juice()
			reagents.add_reagent_list(I.juice_results)
			if(I.reagents)
				I.reagents.trans_to(src, I.reagents.total_volume, transfered_by = src)
			qdel(I)
			return
		I.on_grind()
		reagents.add_reagent_list(I.grind_results)
		if(I.reagents)
			I.reagents.trans_to(src, I.reagents.total_volume, transfered_by = src)
		qdel(I)

