

/*
 * A large number of misc global procs.
 */

//Inverts the colour of an HTML string
/proc/invertHTML(HTMLstring)
	if(!istext(HTMLstring))
		CRASH("Given non-text argument!")
	else if(length(HTMLstring) != 7)
		CRASH("Given non-HTML argument!")
	else if(length_char(HTMLstring) != 7)
		CRASH("Given non-hex symbols in argument!")
	var/textr = copytext(HTMLstring, 2, 4)
	var/textg = copytext(HTMLstring, 4, 6)
	var/textb = copytext(HTMLstring, 6, 8)
	return rgb(255 - hex2num(textr), 255 - hex2num(textg), 255 - hex2num(textb))

/proc/Get_Angle(atom/movable/start,atom/movable/end)//For beams.
	if(!start || !end)
		return 0
	var/dy
	var/dx
	dy=(32*end.y+end.pixel_y)-(32*start.y+start.pixel_y)
	dx=(32*end.x+end.pixel_x)-(32*start.x+start.pixel_x)
	if(!dy)
		return (dx>=0)?90:270
	.=arctan(dx/dy)
	if(dy<0)
		.+=180
	else if(dx<0)
		.+=360

/proc/Get_Pixel_Angle(y, x)//for getting the angle when animating something's pixel_x and pixel_y
	if(!y)
		return (x>=0)?90:270
	.=arctan(x/y)
	if(y<0)
		.+=180
	else if(x<0)
		.+=360

//Returns location. Returns null if no location was found.
/proc/get_teleport_loc(turf/location,mob/target,distance = 1, density = FALSE, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)
/*
Location where the teleport begins, target that will teleport, distance to go, density checking 0/1(yes/no).
Random error in tile placement x, error in tile placement y, and block offset.
Block offset tells the proc how to place the box. Behind teleport location, relative to starting location, forward, etc.
Negative values for offset are accepted, think of it in relation to North, -x is west, -y is south. Error defaults to positive.
Turf and target are separate in case you want to teleport some distance from a turf the target is not standing on or something.
*/

	var/dirx = 0//Generic location finding variable.
	var/diry = 0

	var/xoffset = 0//Generic counter for offset location.
	var/yoffset = 0

	var/b1xerror = 0//Generic placing for point A in box. The lower left.
	var/b1yerror = 0
	var/b2xerror = 0//Generic placing for point B in box. The upper right.
	var/b2yerror = 0

	errorx = abs(errorx)//Error should never be negative.
	errory = abs(errory)

	switch(target.dir)//This can be done through equations but switch is the simpler method. And works fast to boot.
	//Directs on what values need modifying.
		if(1)//North
			diry+=distance
			yoffset+=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(2)//South
			diry-=distance
			yoffset-=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(4)//East
			dirx+=distance
			yoffset+=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx
		if(8)//West
			dirx-=distance
			yoffset-=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx

	var/turf/destination=locate(location.x+dirx,location.y+diry,location.z)

	if(destination)//If there is a destination.
		if(errorx||errory)//If errorx or y were specified.
			var/destination_list[] = list()//To add turfs to list.
			//destination_list = new()
			/*This will draw a block around the target turf, given what the error is.
			Specifying the values above will basically draw a different sort of block.
			If the values are the same, it will be a square. If they are different, it will be a rectengle.
			In either case, it will center based on offset. Offset is position from center.
			Offset always calculates in relation to direction faced. In other words, depending on the direction of the teleport,
			the offset should remain positioned in relation to destination.*/

			var/turf/center = locate((destination.x+xoffset),(destination.y+yoffset),location.z)//So now, find the new center.

			//Now to find a box from center location and make that our destination.
			for(var/turf/T in block(locate(center.x+b1xerror,center.y+b1yerror,location.z), locate(center.x+b2xerror,center.y+b2yerror,location.z) ))
				if(density&&T.density)
					continue//If density was specified.
				if(T.x>world.maxx || T.x<1)
					continue//Don't want them to teleport off the map.
				if(T.y>world.maxy || T.y<1)
					continue
				destination_list += T
			if(destination_list.len)
				destination = pick(destination_list)
			else
				return

		else//Same deal here.
			if(density&&destination.density)
				return
			if(destination.x>world.maxx || destination.x<1)
				return
			if(destination.y>world.maxy || destination.y<1)
				return
	else
		return

	return destination

/**
 * Get a list of turfs in a line from `M` to `N`.
 *
 * Uses the ultra-fast [Bresenham Line-Drawing Algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm).
 */
/proc/getline(atom/M,atom/N)
	var/px=M.x //starting x
	var/py=M.y
	var/line[] = list(locate(px,py,M.z))
	var/dx=N.x-px //x distance
	var/dy=N.y-py
	var/dxabs = abs(dx)//Absolute value of x distance
	var/dyabs = abs(dy)
	var/sdx = SIGN(dx) //Sign of x distance (+ or -)
	var/sdy = SIGN(dy)
	var/x=dxabs>>1 //Counters for steps taken, setting to distance/2
	var/y=dyabs>>1 //Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/j //Generic integer for counting
	if(dxabs>=dyabs) //x distance is greater than y
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to get there
			y+=dyabs
			if(y>=dxabs) //Every dyabs steps, step once in y direction
				y-=dxabs
				py+=sdy
			px+=sdx //Step on in x direction
			line+=locate(px,py,M.z)//Add the turf to the list
	else
		for(j=0;j<dyabs;j++)
			x+=dxabs
			if(x>=dyabs)
				x-=dyabs
				px+=sdx
			py+=sdy
			line+=locate(px,py,M.z)
	return line

//Returns whether or not a player is a guest using their ckey as an input
/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return FALSE

	var/i, ch, len = length(key)

	for (i = 7, i <= len, ++i) //we know the first 6 chars are Guest-
		ch = text2ascii(key, i)
		if (ch < 48 || ch > 57) //0-9
			return FALSE
	return TRUE

//Generalised helper proc for letting mobs rename themselves. Used to be clname() and ainame()
/mob/proc/apply_pref_name(role, client/C)
	if(!C)
		C = client
	var/oldname = real_name
	var/newname
	var/loop = 1
	var/safety = 0

	var/random = CONFIG_GET(flag/force_random_names) || (C ? is_banned_from(C.ckey, "Appearance") : FALSE)

	while(loop && safety < 5)
		if(!safety && !random && C?.prefs.custom_names[role])
			newname = C.prefs.custom_names[role]
		else
			switch(role)
				if(SPECIES_HUMAN)
					newname = random_unique_name(gender)
				if("clown")
					newname = pick(GLOB.clown_names)
				if("mime")
					newname = pick(GLOB.mime_names)
				if("ai")
					newname = pick(GLOB.ai_names)
				else
					return FALSE

		for(var/mob/living/M in GLOB.player_list)
			if(M == src)
				continue
			if(!newname || M.real_name == newname)
				newname = null
				loop++ // name is already taken so we roll again
				break
		loop--
		safety++

	if(newname)
		fully_replace_character_name(oldname,newname)
		return TRUE
	return FALSE


//Picks a string of symbols to display as the law number for hacked or ion laws
/proc/ionnum() //! is at the start to prevent us from changing say modes via get_message_mode()
	return "![pick("!","@","#","$","%","^","&")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")]"

/// Orders mobs by type then by name. Accepts optional arg to sort a custom list, otherwise copies GLOB.mob_list.
/proc/sortmobs()
	var/list/moblist = list()
	var/list/sortmob = sortNames(GLOB.mob_list)
	for(var/mob/living/silicon/ai/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/camera/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/silicon/pai/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/silicon/robot/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/carbon/human/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/brain/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/carbon/alien/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/dead/observer/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/dead/new_player/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/simple_animal/slime/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/simple_animal/mob_to_sort in sortmob)
		// We've already added slimes.
		if(isslime(mob_to_sort))
			continue
		moblist += mob_to_sort
	for(var/mob/living/basic/mob_to_sort in sortmob)
		moblist += mob_to_sort
	return moblist

// Format a power value in W, kW, MW, or GW.
/proc/DisplayPower(powerused)
	if(powerused < 1000) //Less than a kW
		return "[powerused] W"
	else if(powerused < 1000000) //Less than a MW
		return "[round((powerused * 0.001),0.01)] kW"
	else if(powerused < 1000000000) //Less than a GW
		return "[round((powerused * 0.000001),0.001)] MW"
	return "[round((powerused * 0.000000001),0.0001)] GW"

// Format an energy value in J, kJ, MJ, or GJ. 1W = 1J/s.
/proc/DisplayJoules(units)
	if (units < 1000) // Less than a kJ
		return "[round(units, 0.1)] J"
	else if (units < 1000000) // Less than a MJ
		return "[round(units * 0.001, 0.01)] kJ"
	else if (units < 1000000000) // Less than a GJ
		return "[round(units * 0.000001, 0.001)] MJ"
	return "[round(units * 0.000000001, 0.0001)] GJ"

// Format an energy value measured in Power Cell units.
/proc/DisplayEnergy(units)
	// APCs process every (SSmachines.wait * 0.1) seconds, and turn 1 W of
	// excess power into watts when charging cells.
	// With the current configuration of wait=20 and CELLRATE=0.002, this
	// means that one unit is 1 kJ.
	return DisplayJoules(units * SSmachines.wait * 0.1 WATTS)

/proc/get_mob_by_ckey(key)
	if(!key)
		return
	var/list/mobs = sortmobs()
	for(var/mob/M in mobs)
		if(M.ckey == key)
			return M

//Returns the atom sitting on the turf.
//For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
//Optional arg 'type' to stop once it reaches a specific type instead of a turf.
/proc/get_atom_on_turf(atom/movable/M, stop_type)
	var/atom/turf_to_check = M
	while(turf_to_check?.loc && !isturf(turf_to_check.loc))
		turf_to_check = turf_to_check.loc
		if(stop_type && istype(turf_to_check, stop_type))
			break
	return turf_to_check

//Returns a list of all locations (except the area) the movable is within.
/proc/get_nested_locs(atom/movable/AM, include_turf = FALSE)
	. = list()
	var/atom/location = AM.loc
	var/turf/turf = get_turf(AM)
	while(location && location != turf)
		. += location
		location = location.loc
	if(location && include_turf) //At this point, only the turf is left, provided it exists.
		. += location

// returns the turf located at the map edge in the specified direction relative to A
// used for mass driver
/proc/get_edge_target_turf(atom/A, direction)
	var/turf/target = locate(A.x, A.y, A.z)
	if(!A || !target)
		return 0
		//since NORTHEAST == NORTH|EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = world.maxy
	else if(direction & SOUTH) //you should not have both NORTH and SOUTH in the provided direction
		y = 1
	if(direction & EAST)
		x = world.maxx
	else if(direction & WEST)
		x = 1
	if(ISDIAGONALDIR(direction)) //let's make sure it's accurately-placed for diagonals
		var/lowest_distance_to_map_edge = min(abs(x - A.x), abs(y - A.y))
		return get_ranged_target_turf(A, direction, lowest_distance_to_map_edge)
	return locate(x,y,A.z)

// returns turf relative to A in given direction at set range
// result is bounded to map size
// note range is non-pythagorean
// used for disposal system
/proc/get_ranged_target_turf(atom/A, direction, range)

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	else if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	else if(direction & WEST) //if you have both EAST and WEST in the provided direction, then you're gonna have issues
		x = max(1, x - range)

	return locate(x,y,A.z)

/**
 * Get ranged target turf, but with direct targets as opposed to directions
 *
 * Starts at atom A and gets the exact angle between A and target
 * Moves from A with that angle, Range amount of times, until it stops, bound to map size
 * Arguments:
 * * A - Initial Firer / Position
 * * target - Target to aim towards
 * * range - Distance of returned target turf from A
 * * offset - Angle offset, 180 input would make the returned target turf be in the opposite direction
 */
/proc/get_ranged_target_turf_direct(atom/A, atom/target, range, offset)
	var/angle = ATAN2(target.x - A.x, target.y - A.y)
	if(offset)
		angle += offset
	var/turf/T = get_turf(A)
	for(var/i in 1 to range)
		var/turf/check = locate(A.x + cos(angle) * i, A.y + sin(angle) * i, A.z)
		if(!check)
			break
		T = check

	return T


// returns turf relative to A offset in dx and dy tiles
// bound to map limits
/proc/get_offset_target_turf(atom/A, dx, dy)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x,y,A.z)


///Returns the src and all recursive contents as a list.
/atom/proc/GetAllContents(ignore_flag_1)
	. = list(src)
	var/i = 0
	while(i < length(.))
		var/atom/A = .[++i]
		if (!(A.flags_1 & ignore_flag_1))
			. += A.contents

///identical to getallcontents but returns a list of atoms of the type passed in the argument.
/atom/proc/get_all_contents_type(type)
	var/list/processing_list = list(src)
	. = list()
	while(length(processing_list))
		var/atom/A = processing_list[1]
		processing_list.Cut(1, 2)
		processing_list += A.contents
		if(istype(A, type))
			. += A

/atom/proc/GetAllContentsIgnoring(list/ignore_typecache)
	if(!length(ignore_typecache))
		return GetAllContents()
	var/list/processing = list(src)
	. = list()
	var/i = 0
	while(i < length(processing))
		var/atom/A = processing[++i]
		if(!ignore_typecache[A.type])
			processing += A.contents
			. += A

//Step-towards method of determining whether one atom can see another. Similar to viewers()
/proc/can_see(atom/source, atom/target, length=5) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	if(get_dist(source, target) > length)
		return FALSE
	var/steps = 1
	if(current != target_turf)
		current = get_step_towards(current, target_turf)
		while(current != target_turf)
			if(steps > length)
				return FALSE
			if(IS_OPAQUE_TURF(current))
				return FALSE
			current = get_step_towards(current, target_turf)
			steps++
	return TRUE


//Repopulates sortedAreas list
/proc/repopulate_sorted_areas()
	GLOB.sortedAreas = list()

	for(var/area/A in world)
		GLOB.sortedAreas.Add(A)

	sortTim(GLOB.sortedAreas, /proc/cmp_name_asc)

/area/proc/addSorted()
	GLOB.sortedAreas.Add(src)
	sortTim(GLOB.sortedAreas, /proc/cmp_name_asc)

//Takes: Area type as a text string from a variable.
//Returns: Instance for the area in the world.
/proc/get_area_instance_from_text(areatext)
	if(istext(areatext))
		areatext = text2path(areatext)
	return GLOB.areas_by_type[areatext]

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all areas of that type in the world.
/proc/get_areas(areatype, subtypes=TRUE)
	if(istext(areatype))
		areatype = text2path(areatype)
	else if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type
	else if(!ispath(areatype))
		return null

	var/list/areas = list()
	if(subtypes)
		var/list/cache = typecacheof(areatype)
		for(var/area/area_to_check as anything in GLOB.sortedAreas)
			if(cache[area_to_check.type])
				areas += area_to_check
	else
		for(var/area/area_to_check as anything in GLOB.sortedAreas)
			if(area_to_check.type == areatype)
				areas += area_to_check
	return areas

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all turfs in areas of that type of that type in the world.
/proc/get_area_turfs(areatype, target_z = 0, subtypes=FALSE)
	if(istext(areatype))
		areatype = text2path(areatype)
	else if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type
	else if(!ispath(areatype))
		return null

	var/list/turfs = list()
	if(subtypes)
		var/list/cache = typecacheof(areatype)
		for(var/area/area_to_check as anything in GLOB.sortedAreas)
			if(!cache[area_to_check.type])
				continue
			for(var/turf/turf_in_area in area_to_check)
				if(target_z == 0 || target_z == turf_in_area.z)
					turfs += turf_in_area
	else
		for(var/area/area_to_check as anything in GLOB.sortedAreas)
			if(area_to_check.type != areatype)
				continue
			for(var/turf/turf_in_area in area_to_check)
				if(target_z == 0 || target_z == turf_in_area.z)
					turfs += turf_in_area
	return turfs

/proc/get_cardinal_dir(atom/A, atom/B)
	var/dx = abs(B.x - A.x)
	var/dy = abs(B.y - A.y)
	return get_dir(A, B) & (rand() * (dx+dy) < dy ? 3 : 12)

//chances are 1:value. anyprob(1) will always return true
/proc/anyprob(value)
	return (rand(1,value)==value)

/proc/parse_zone(zone)
	if(zone == BODY_ZONE_PRECISE_R_HAND)
		return "right hand"
	else if (zone == BODY_ZONE_PRECISE_L_HAND)
		return "left hand"
	else if (zone == BODY_ZONE_L_ARM)
		return "left arm"
	else if (zone == BODY_ZONE_R_ARM)
		return "right arm"
	else if (zone == BODY_ZONE_L_LEG)
		return "left leg"
	else if (zone == BODY_ZONE_R_LEG)
		return "right leg"
	else if (zone == BODY_ZONE_PRECISE_L_FOOT)
		return "left foot"
	else if (zone == BODY_ZONE_PRECISE_R_FOOT)
		return "right foot"
	else
		return zone

/*

Lets the turf this atom's *ICON* appears to inhabit
it takes into account:
* Pixel_x/y
* Matrix x/y

NOTE: if your atom has non-standard bounds then this proc
will handle it, but:
* if the bounds are even, then there are an even amount of "middle" turfs, the one to the EAST, NORTH, or BOTH is picked
this may seem bad, but you're atleast as close to the center of the atom as possible, better than byond's default loc being all the way off)
* if the bounds are odd, the true middle turf of the atom is returned

*/

/proc/get_turf_pixel(atom/AM)
	if(!istype(AM))
		return

	//Find AM's matrix so we can use it's X/Y pixel shifts
	var/matrix/M = matrix(AM.transform)

	var/pixel_x_offset = AM.pixel_x + M.get_x_shift()
	var/pixel_y_offset = AM.pixel_y + M.get_y_shift()

	//Irregular objects
	var/icon/AMicon = icon(AM.icon, AM.icon_state)
	var/AMiconheight = AMicon.Height()
	var/AMiconwidth = AMicon.Width()
	if(AMiconheight != world.icon_size || AMiconwidth != world.icon_size)
		pixel_x_offset += ((AMiconwidth/world.icon_size)-1)*(world.icon_size*0.5)
		pixel_y_offset += ((AMiconheight/world.icon_size)-1)*(world.icon_size*0.5)

	//DY and DX
	var/rough_x = round(round(pixel_x_offset,world.icon_size)/world.icon_size)
	var/rough_y = round(round(pixel_y_offset,world.icon_size)/world.icon_size)

	//Find coordinates
	var/turf/T = get_turf(AM) //use AM's turfs, as it's coords are the same as AM's AND AM's coords are lost if it is inside another atom
	if(!T)
		return null
	var/final_x = T.x + rough_x
	var/final_y = T.y + rough_y

	if(final_x || final_y)
		return locate(final_x, final_y, T.z)

//Finds the distance between two atoms, in pixels
//centered = FALSE counts from turf edge to edge
//centered = TRUE counts from turf center to turf center
//of course mathematically this is just adding world.icon_size on again
/proc/getPixelDistance(atom/A, atom/B, centered = TRUE)
	if(!istype(A)||!istype(B))
		return 0
	. = bounds_dist(A, B) + sqrt((((A.pixel_x+B.pixel_x)**2) + ((A.pixel_y+B.pixel_y)**2)))
	if(centered)
		. += world.icon_size

/proc/get(atom/loc, type)
	while(loc)
		if(istype(loc, type))
			return loc
		loc = loc.loc
	return null


/*
Checks if that loc and dir has an item on the wall
*/
GLOBAL_LIST_INIT(WALLITEMS, typecacheof(list(
	/obj/machinery/power/apc, /obj/machinery/airalarm, /obj/item/radio/intercom,
	/obj/structure/extinguisher_cabinet, /obj/structure/reagent_dispensers/peppertank,
	/obj/machinery/status_display, /obj/machinery/requests_console, /obj/machinery/light_switch, /obj/structure/sign,
	/obj/machinery/newscaster, /obj/machinery/firealarm, /obj/structure/noticeboard, /obj/machinery/button,
	/obj/machinery/computer/security/telescreen, /obj/machinery/embedded_controller/radio/simple_vent_controller,
	/obj/item/storage/secure/safe, /obj/machinery/door_timer, /obj/machinery/flasher, /obj/machinery/keycard_auth,
	/obj/structure/mirror, /obj/structure/fireaxecabinet, /obj/machinery/computer/security/telescreen/entertainment,
	/obj/structure/sign/picture_frame, /obj/machinery/bounty_board
	)))

GLOBAL_LIST_INIT(WALLITEMS_EXTERNAL, typecacheof(list(
	/obj/machinery/camera, /obj/structure/camera_assembly,
	/obj/structure/light_construct, /obj/machinery/light)))

GLOBAL_LIST_INIT(WALLITEMS_INVERSE, typecacheof(list(
	/obj/structure/light_construct, /obj/machinery/light)))


/proc/gotwallitem(loc, dir, check_external = 0)
	var/locdir = get_step(loc, dir)
	for(var/obj/O in loc)
		if(is_type_in_typecache(O, GLOB.WALLITEMS) && check_external != 2)
			//Direction works sometimes
			if(is_type_in_typecache(O, GLOB.WALLITEMS_INVERSE))
				if(O.dir == turn(dir, 180))
					return TRUE
			else if(O.dir == dir)
				return TRUE

			//Some stuff doesn't use dir properly, so we need to check pixel instead
			//That's exactly what get_turf_pixel() does
			if(get_turf_pixel(O) == locdir)
				return TRUE

		if(is_type_in_typecache(O, GLOB.WALLITEMS_EXTERNAL) && check_external)
			if(is_type_in_typecache(O, GLOB.WALLITEMS_INVERSE))
				if(O.dir == turn(dir, 180))
					return TRUE
			else if(O.dir == dir)
				return TRUE

	//Some stuff is placed directly on the wallturf (signs)
	for(var/obj/O in locdir)
		if(is_type_in_typecache(O, GLOB.WALLITEMS) && check_external != 2)
			if(O.pixel_x == 0 && O.pixel_y == 0)
				return TRUE
	return FALSE

/proc/format_text(text)
	return replacetext(replacetext(text,"\proper ",""),"\improper ","")

/proc/check_target_facings(mob/living/initator, mob/living/target)
	/*This can be used to add additional effects on interactions between mobs depending on how the mobs are facing each other, such as adding a crit damage to blows to the back of a guy's head.
	Given how click code currently works (Nov '13), the initiating mob will be facing the target mob most of the time
	That said, this proc should not be used if the change facing proc of the click code is overridden at the same time*/
	if(!isliving(target) || target.body_position == LYING_DOWN)
	//Make sure we are not doing this for things that can't have a logical direction to the players given that the target would be on their side
		return FALSE
	if(initator.dir == target.dir) //mobs are facing the same direction
		return FACING_SAME_DIR
	if(is_A_facing_B(initator,target) && is_A_facing_B(target,initator)) //mobs are facing each other
		return FACING_EACHOTHER
	if(initator.dir + 2 == target.dir || initator.dir - 2 == target.dir || initator.dir + 6 == target.dir || initator.dir - 6 == target.dir) //Initating mob is looking at the target, while the target mob is looking in a direction perpendicular to the 1st
		return FACING_INIT_FACING_TARGET_TARGET_FACING_PERPENDICULAR

/proc/random_step(atom/movable/AM, steps, chance)
	var/initial_chance = chance
	while(steps > 0)
		if(prob(chance))
			step(AM, pick(GLOB.alldirs))
		chance = max(chance - (initial_chance / steps), 0)
		steps--

/proc/living_player_count()
	var/living_player_count = 0
	for(var/mob in GLOB.player_list)
		if(mob in GLOB.alive_mob_list)
			living_player_count += 1
	return living_player_count

/proc/randomColor(mode = 0) //if 1 it doesn't pick white, black or gray
	switch(mode)
		if(0)
			return pick("white","black","gray","red","green","blue","brown","yellow","orange","darkred",
						"crimson","lime","darkgreen","cyan","navy","teal","purple","indigo")
		if(1)
			return pick("red","green","blue","brown","yellow","orange","darkred","crimson",
						"lime","darkgreen","cyan","navy","teal","purple","indigo")
		else
			return "white"

/proc/params2turf(scr_loc, turf/origin, client/C)
	if(!scr_loc)
		return null
	var/tX = splittext(scr_loc, ",")
	var/tY = splittext(tX[2], ":")
	var/tZ = origin.z
	tY = tY[1]
	tX = splittext(tX[1], ":")
	tX = tX[1]
	var/list/actual_view = getviewsize(C ? C.view : world.view)
	tX = clamp(origin.x + text2num(tX) - round(actual_view[1] / 2) - 1, 1, world.maxx)
	tY = clamp(origin.y + text2num(tY) - round(actual_view[2] / 2) - 1, 1, world.maxy)
	return locate(tX, tY, tZ)

/proc/screen_loc2turf(text, turf/origin, client/C)
	if(!text)
		return null
	var/tZ = splittext(text, ",")
	var/tX = splittext(tZ[1], "-")
	var/tY = text2num(tX[2])
	tX = splittext(tZ[2], "-")
	tX = text2num(tX[2])
	tZ = origin.z
	var/list/actual_view = getviewsize(C ? C.view : world.view)
	tX = clamp(origin.x + round(actual_view[1] / 2) - tX, 1, world.maxx)
	tY = clamp(origin.y + round(actual_view[2] / 2) - tY, 1, world.maxy)
	return locate(tX, tY, tZ)

/proc/IsValidSrc(datum/D)
	if(istype(D))
		return !QDELETED(D)
	return 0

//Compare A's dir, the clockwise dir of A and the anticlockwise dir of A
//To the opposite dir of the dir returned by get_dir(B,A)
//If one of them is a match, then A is facing B
/proc/is_A_facing_B(atom/A,atom/B)
	if(!istype(A) || !istype(B))
		return FALSE
	if(isliving(A))
		var/mob/living/LA = A
		if(LA.body_position == LYING_DOWN)
			return FALSE
	var/goal_dir = get_dir(A,B)
	var/clockwise_A_dir = turn(A.dir, -45)
	var/anticlockwise_A_dir = turn(A.dir, 45)

	if(A.dir == goal_dir || clockwise_A_dir == goal_dir || anticlockwise_A_dir == goal_dir)
		return TRUE
	return FALSE


/*
rough example of the "cone" made by the 3 dirs checked


* \
*  \
*   >
*     <
*      \
*       \
*B --><-- A
*       /
*      /
*     <
*    >
*   /
*  /


*/


//Center's an image.
//Requires:
//The Image
//The x dimension of the icon file used in the image
//The y dimension of the icon file used in the image
// eg: center_image(I, 32,32)
// eg2: center_image(I, 96,96)

/proc/center_image(image/I, x_dimension = 0, y_dimension = 0)
	if(!I)
		return

	if(!x_dimension || !y_dimension)
		return

	if((x_dimension == world.icon_size) && (y_dimension == world.icon_size))
		return I

	//Offset the image so that it's bottom left corner is shifted this many pixels
	//This makes it infinitely easier to draw larger inhands/images larger than world.iconsize
	//but still use them in game
	var/x_offset = -((x_dimension/world.icon_size)-1)*(world.icon_size*0.5)
	var/y_offset = -((y_dimension/world.icon_size)-1)*(world.icon_size*0.5)

	//Correct values under world.icon_size
	if(x_dimension < world.icon_size)
		x_offset *= -1
	if(y_dimension < world.icon_size)
		y_offset *= -1

	I.pixel_x = x_offset
	I.pixel_y = y_offset

	return I

//ultra range (no limitations on distance, faster than range for distances > 8); including areas drastically decreases performance
/proc/urange(dist=0, atom/center=usr, orange=0, areas=0)
	if(!dist)
		if(!orange)
			return list(center)
		else
			return list()

	var/list/turfs = RANGE_TURFS(dist, center)
	if(orange)
		turfs -= get_turf(center)
	. = list()
	for(var/V in turfs)
		var/turf/T = V
		. += T
		. += T.contents
		if(areas)
			. |= T.loc

//similar function to range(), but with no limitations on the distance; will search spiralling outwards from the center
/proc/spiral_range(dist=0, center=usr, orange=0)
	var/list/L = list()
	var/turf/t_center = get_turf(center)
	if(!t_center)
		return list()

	if(!orange)
		L += t_center
		L += t_center.contents

	if(!dist)
		return L


	var/turf/T
	var/y
	var/x
	var/c_dist = 1


	while( c_dist <= dist )
		y = t_center.y + c_dist
		x = t_center.x - c_dist + 1
		for(x in x to t_center.x+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
				L += T.contents

		y = t_center.y + c_dist - 1
		x = t_center.x + c_dist
		for(y in t_center.y-c_dist to y)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
				L += T.contents

		y = t_center.y - c_dist
		x = t_center.x + c_dist - 1
		for(x in t_center.x-c_dist to x)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
				L += T.contents

		y = t_center.y - c_dist + 1
		x = t_center.x - c_dist
		for(y in y to t_center.y+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
				L += T.contents
		c_dist++

	return L

//similar function to RANGE_TURFS(), but will search spiralling outwards from the center (like the above, but only turfs)
/proc/spiral_range_turfs(dist=0, center=usr, orange=0, list/outlist = list(), tick_checked)
	outlist.Cut()
	if(!dist)
		outlist += center
		return outlist

	var/turf/t_center = get_turf(center)
	if(!t_center)
		return outlist

	var/list/L = outlist
	var/turf/T
	var/y
	var/x
	var/c_dist = 1

	if(!orange)
		L += t_center

	while( c_dist <= dist )
		y = t_center.y + c_dist
		x = t_center.x - c_dist + 1
		for(x in x to t_center.x+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y + c_dist - 1
		x = t_center.x + c_dist
		for(y in t_center.y-c_dist to y)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y - c_dist
		x = t_center.x + c_dist - 1
		for(x in t_center.x-c_dist to x)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y - c_dist + 1
		x = t_center.x - c_dist
		for(y in y to t_center.y+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
		c_dist++
		if(tick_checked)
			CHECK_TICK

	return L

/atom/proc/contains(atom/A)
	if(!A)
		return FALSE
	for(var/atom/location = A.loc, location, location = location.loc)
		if(location == src)
			return TRUE

/proc/flick_overlay_static(O, atom/A, duration)
	set waitfor = FALSE
	if(!A || !O)
		return
	A.add_overlay(O)
	sleep(duration)
	A.cut_overlay(O)

/proc/get_random_station_turf()
	var/list/turfs = get_area_turfs(pick(GLOB.the_station_areas))
	if (length(turfs))
		return pick(turfs)

/proc/get_safe_random_station_turf(list/areas_to_pick_from = GLOB.the_station_areas) //excludes dense turfs (like walls) and areas that have valid_territory set to FALSE
	for (var/i in 1 to 5)
		var/list/L = get_area_turfs(pick(areas_to_pick_from))
		var/turf/target
		while (L.len && !target)
			var/I = rand(1, L.len)
			var/turf/T = L[I]
			var/area/X = get_area(T)
			if(!T.density && (X.area_flags & VALID_TERRITORY))
				var/clear = TRUE
				for(var/obj/O in T)
					if(O.density)
						clear = FALSE
						break
				if(clear)
					target = T
			if (!target)
				L.Cut(I,I+1)
		if (target)
			return target


/proc/get_closest_atom(type, list, source)
	var/closest_atom
	var/closest_distance
	for(var/A in list)
		if(!istype(A, type))
			continue
		var/distance = get_dist(source, A)
		if(!closest_atom)
			closest_distance = distance
			closest_atom = A
		else
			if(closest_distance > distance)
				closest_distance = distance
				closest_atom = A
	return closest_atom


/proc/pick_closest_path(value, list/matches = get_fancy_list_of_atom_types())
	if (value == FALSE) //nothing should be calling us with a number, so this is safe
		value = input("Enter type to find (blank for all, cancel to cancel)", "Search for type") as null|text
		if (isnull(value))
			return
	value = trim(value)

	var/random = FALSE
	if(findtext(value, "?"))
		value = replacetext(value, "?", "")
		random = TRUE

	if(!isnull(value) && value != "")
		matches = filter_fancy_list(matches, value)

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else if(random)
		chosen = pick(matches) || null
	else
		chosen = input("Select a type", "Pick Type", matches[1]) as null|anything in sortList(matches)
	if(!chosen)
		return
	chosen = matches[chosen]
	return chosen

//gives us the stack trace from CRASH() without ending the current proc.
/proc/stack_trace(msg)
	CRASH(msg)

/datum/proc/stack_trace(msg)
	CRASH(msg)

GLOBAL_REAL_VAR(list/stack_trace_storage)
/proc/gib_stack_trace()
	stack_trace_storage = list()
	stack_trace()
	stack_trace_storage.Cut(1, min(3,stack_trace_storage.len))
	. = stack_trace_storage
	stack_trace_storage = null

//Key thing that stops lag. Cornerstone of performance in ss13, Just sitting here, in unsorted.dm.

//Increases delay as the server gets more overloaded,
//as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful
#define DELTA_CALC max(((max(TICK_USAGE, world.cpu) / 100) * max(Master.sleep_delta-1,1)), 1)

//returns the number of ticks slept
/proc/stoplag(initial_delay)
	if (!Master || !(Master.current_runlevel & RUNLEVELS_DEFAULT))
		sleep(world.tick_lag)
		return 1
	if (!initial_delay)
		initial_delay = world.tick_lag
	. = 0
	var/i = DS2TICKS(initial_delay)
	do
		. += CEILING(i*DELTA_CALC, 1)
		sleep(i*world.tick_lag*DELTA_CALC)
		i *= 2
	while (TICK_USAGE > min(TICK_LIMIT_TO_RUN, Master.current_ticklimit))

#undef DELTA_CALC

/proc/flash_color(mob_or_client, flash_color="#960000", flash_time=20)
	var/client/C
	if(ismob(mob_or_client))
		var/mob/M = mob_or_client
		if(M.client)
			C = M.client
		else
			return
	else if(istype(mob_or_client, /client))
		C = mob_or_client

	if(!istype(C))
		return

	var/animate_color = C.color
	C.color = flash_color
	animate(C, color = animate_color, time = flash_time)

#define RANDOM_COLOUR (rgb(rand(0,255),rand(0,255),rand(0,255)))

/proc/random_nukecode()
	var/val = rand(0, 99999)
	var/str = "[val]"
	while(length(str) < 5)
		str = "0" + str
	. = str

/atom/proc/Shake(pixelshiftx = 15, pixelshifty = 15, duration = 250)
	var/initialpixelx = pixel_x
	var/initialpixely = pixel_y
	var/shiftx = rand(-pixelshiftx,pixelshiftx)
	var/shifty = rand(-pixelshifty,pixelshifty)
	animate(src, pixel_x = pixel_x + shiftx, pixel_y = pixel_y + shifty, time = 0.2, loop = duration)
	pixel_x = initialpixelx
	pixel_y = initialpixely

/proc/weightclass2text(w_class)
	switch(w_class)
		if(WEIGHT_CLASS_TINY)
			. = "tiny"
		if(WEIGHT_CLASS_SMALL)
			. = "small"
		if(WEIGHT_CLASS_NORMAL)
			. = "normal-sized"
		if(WEIGHT_CLASS_BULKY)
			. = "bulky"
		if(WEIGHT_CLASS_HUGE)
			. = "huge"
		if(WEIGHT_CLASS_GIGANTIC)
			. = "gigantic"
		else
			. = ""

GLOBAL_DATUM_INIT(dview_mob, /mob/dview, new)

//Version of view() which ignores darkness, because BYOND doesn't have it (I actually suggested it but it was tagged redundant, BUT HEARERS IS A T- /rant).
/proc/dview(range = world.view, center, invis_flags = 0)
	if(!center)
		return

	GLOB.dview_mob.loc = center

	GLOB.dview_mob.see_invisible = invis_flags

	. = view(range, GLOB.dview_mob)
	GLOB.dview_mob.loc = null

/mob/dview
	name = "INTERNAL DVIEW MOB"
	invisibility = 101
	density = FALSE
	see_in_dark = 1e6
	move_resist = INFINITY
	var/ready_to_die = FALSE

/mob/dview/Initialize() //Properly prevents this mob from gaining huds or joining any global lists
	SHOULD_CALL_PARENT(FALSE)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1
	return INITIALIZE_HINT_NORMAL

/mob/dview/Destroy(force = FALSE)
	if(!ready_to_die)
		stack_trace("ALRIGHT WHICH FUCKER TRIED TO DELETE *MY* DVIEW?")

		if (!force)
			return QDEL_HINT_LETMELIVE

		log_world("EVACUATE THE SHITCODE IS TRYING TO STEAL MUH JOBS")
		GLOB.dview_mob = new
	return ..()


#define FOR_DVIEW(type, range, center, invis_flags) \
	GLOB.dview_mob.loc = center;           \
	GLOB.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, GLOB.dview_mob))

#define FOR_DVIEW_END GLOB.dview_mob.loc = null

/**
 * Checks whether the target turf is in a valid state to accept a directional window
 * or other directional pseudo-dense object such as railings.
 *
 * Returns FALSE if the target turf cannot accept a directional window or railing.
 * Returns TRUE otherwise.
 *
 * Arguments:
 * * dest_turf - The destination turf to check for existing windows and railings
 * * test_dir - The prospective dir of some atom you'd like to put on this turf.
 * * is_fulltile - Whether the thing you're attempting to move to this turf takes up the entire tile or whether it supports multiple movable atoms on its tile.
 */
/proc/valid_window_location(turf/dest_turf, test_dir, is_fulltile = FALSE)
	if(!dest_turf)
		return FALSE
	for(var/obj/turf_content in dest_turf)
		if(istype(turf_content, /obj/machinery/door/window))
			if((turf_content.dir == test_dir) || is_fulltile)
				return FALSE
		if(istype(turf_content, /obj/structure/windoor_assembly))
			var/obj/structure/windoor_assembly/windoor_assembly = turf_content
			if(windoor_assembly.dir == test_dir || is_fulltile)
				return FALSE
		if(istype(turf_content, /obj/structure/window))
			var/obj/structure/window/window_structure = turf_content
			if(window_structure.dir == test_dir || window_structure.fulltile || is_fulltile)
				return FALSE
		if(istype(turf_content, /obj/structure/railing))
			var/obj/structure/railing/rail = turf_content
			if(rail.dir == test_dir || is_fulltile)
				return FALSE
	return TRUE

#define UNTIL(X) while(!(X)) stoplag()

/proc/pass(...)
	return

/proc/get_mob_or_brainmob(occupant)
	var/mob/living/mob_occupant

	if(isliving(occupant))
		mob_occupant = occupant

	else if(isbodypart(occupant))
		var/obj/item/bodypart/head/head = occupant

		mob_occupant = head.brainmob

	else if(isorgan(occupant))
		var/obj/item/organ/brain/brain = occupant
		mob_occupant = brain.brainmob

	return mob_occupant

//counts the number of bits in Byond's 16-bit width field
//in constant time and memory!
/proc/BitCount(bitfield)
	var/temp = bitfield - ((bitfield>>1)&46811) - ((bitfield>>2)&37449) //0133333 and 0111111 respectively
	temp = ((temp + (temp>>3))&29127) % 63 //070707
	return temp

//returns a GUID like identifier (using a mostly made up record format)
//guids are not on their own suitable for access or security tokens, as most of their bits are predictable.
// (But may make a nice salt to one)
/proc/GUID()
	var/const/GUID_VERSION = "b"
	var/const/GUID_VARIANT = "d"
	var/node_id = copytext_char(md5("[rand()*rand(1,9999999)][world.name][world.hub][world.hub_password][world.internet_address][world.address][world.contents.len][world.status][world.port][rand()*rand(1,9999999)]"), 1, 13)

	var/time_high = "[num2hex(text2num(time2text(world.realtime,"YYYY")), 2)][num2hex(world.realtime, 6)]"

	var/time_mid = num2hex(world.timeofday, 4)

	var/time_low = num2hex(world.time, 3)

	var/time_clock = num2hex(TICK_DELTA_TO_MS(world.tick_usage), 3)

	return "{[time_high]-[time_mid]-[GUID_VERSION][time_low]-[GUID_VARIANT][time_clock]-[node_id]}"

// \ref behaviour got changed in 512 so this is necesary to replicate old behaviour.
// If it ever becomes necesary to get a more performant REF(), this lies here in wait
// #define REF(thing) (thing && istype(thing, /datum) && (thing:datum_flags & DF_USE_TAG) && thing:tag ? "[thing:tag]" : "\ref[thing]")
/proc/REF(input)
	if(istype(input, /datum))
		var/datum/thing = input
		if(thing.datum_flags & DF_USE_TAG)
			if(!thing.tag)
				stack_trace("A ref was requested of an object with DF_USE_TAG set but no tag: [thing]")
				thing.datum_flags &= ~DF_USE_TAG
			else
				return "\[[url_encode(thing.tag)]\]"
	return "\ref[input]"

// Makes a call in the context of a different usr
// Use sparingly
/world/proc/PushUsr(mob/M, datum/callback/CB, ...)
	var/temp = usr
	usr = M
	if (length(args) > 2)
		. = CB.Invoke(arglist(args.Copy(3)))
	else
		. = CB.Invoke()
	usr = temp

//datum may be null, but it does need to be a typed var
#define NAMEOF(datum, X) (#X || ##datum.##X)

#define VARSET_LIST_CALLBACK(target, var_name, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##target, ##var_name, ##var_value)
//dupe code because dm can't handle 3 level deep macros
#define VARSET_CALLBACK(datum, var, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##datum, NAMEOF(##datum, ##var), ##var_value)

/proc/___callbackvarset(list_or_datum, var_name, var_value)
	if(length(list_or_datum))
		list_or_datum[var_name] = var_value
		return
	var/datum/D = list_or_datum
	if(IsAdminAdvancedProcCall())
		D.vv_edit_var(var_name, var_value) //same result generally, unless badmemes
	else
		D.vars[var_name] = var_value

#define TRAIT_CALLBACK_ADD(target, trait, source) CALLBACK(GLOBAL_PROC, /proc/___TraitAdd, ##target, ##trait, ##source)
#define TRAIT_CALLBACK_REMOVE(target, trait, source) CALLBACK(GLOBAL_PROC, /proc/___TraitRemove, ##target, ##trait, ##source)

///DO NOT USE ___TraitAdd OR ___TraitRemove as a replacement for ADD_TRAIT / REMOVE_TRAIT defines. To be used explicitly for callback.
/proc/___TraitAdd(target,trait,source)
	if(!target || !trait || !source)
		return
	if(islist(target))
		for(var/i in target)
			if(!isatom(i))
				continue
			var/atom/the_atom = i
			ADD_TRAIT(the_atom,trait,source)
	else if(isatom(target))
		var/atom/the_atom2 = target
		ADD_TRAIT(the_atom2,trait,source)

///DO NOT USE ___TraitAdd OR ___TraitRemove as a replacement for ADD_TRAIT / REMOVE_TRAIT defines. To be used explicitly for callback.
/proc/___TraitRemove(target,trait,source)
	if(!target || !trait || !source)
		return
	if(islist(target))
		for(var/i in target)
			if(!isatom(i))
				continue
			var/atom/the_atom = i
			REMOVE_TRAIT(the_atom,trait,source)
	else if(isatom(target))
		var/atom/the_atom2 = target
		REMOVE_TRAIT(the_atom2,trait,source)

/proc/get_random_food()
	var/list/blocked = list(/obj/item/food/bread,
		/obj/item/food/breadslice,
		/obj/item/food/cake,
		/obj/item/food/cakeslice,
		/obj/item/food/pie,
		/obj/item/food/pieslice,
		/obj/item/food/kebab,
		/obj/item/food/pizza,
		/obj/item/food/pizzaslice,
		/obj/item/food/salad,
		/obj/item/food/meat,
		/obj/item/food/meat/slab,
		/obj/item/food/soup,
		/obj/item/food/grown,
		/obj/item/food/grown/mushroom,
		/obj/item/food/deepfryholder,
		/obj/item/food/clothing,
		/obj/item/food/meat/slab/human/mutant,
		/obj/item/food/grown/ash_flora,
		/obj/item/food/grown/nettle,
		/obj/item/food/grown/shell
		)

	return pick(subtypesof(/obj/item/food) - blocked)

/proc/get_random_drink()
	var/list/blocked = list(/obj/item/reagent_containers/food/drinks/soda_cans,
		/obj/item/reagent_containers/food/drinks/bottle
		)
	return pick(subtypesof(/obj/item/reagent_containers/food/drinks) - blocked)

//For these two procs refs MUST be ref = TRUE format like typecaches!
/proc/weakref_filter_list(list/things, list/refs)
	if(!islist(things) || !islist(refs))
		return
	if(!refs.len)
		return things
	if(things.len > refs.len)
		var/list/f = list()
		for(var/i in refs)
			var/datum/weakref/r = i
			var/datum/d = r.resolve()
			if(d)
				f |= d
		return things & f

	else
		. = list()
		for(var/i in things)
			if(!refs[WEAKREF(i)])
				continue
			. |= i

/proc/weakref_filter_list_reverse(list/things, list/refs)
	if(!islist(things) || !islist(refs))
		return
	if(!refs.len)
		return things
	if(things.len > refs.len)
		var/list/f = list()
		for(var/i in refs)
			var/datum/weakref/r = i
			var/datum/d = r.resolve()
			if(d)
				f |= d

		return things - f
	else
		. = list()
		for(var/i in things)
			if(refs[WEAKREF(i)])
				continue
			. |= i

/proc/special_list_filter(list/L, datum/callback/condition)
	if(!islist(L) || !length(L) || !istype(condition))
		return list()
	. = list()
	for(var/i in L)
		if(condition.Invoke(i))
			. |= i
/proc/generate_items_inside(list/items_list,where_to)
	for(var/each_item in items_list)
		for(var/i in 1 to items_list[each_item])
			new each_item(where_to)

/proc/CallAsync(datum/source, proctype, list/arguments)
	set waitfor = FALSE
	return call(source, proctype)(arglist(arguments))

/// Returns the name of the mathematical tuple of same length as the number arg (rounded down).
/proc/make_tuple(number)
	var/static/list/units_prefix = list("", "un", "duo", "tre", "quattuor", "quin", "sex", "septen", "octo", "novem")
	var/static/list/tens_prefix = list("", "decem", "vigin", "trigin", "quadragin", "quinquagin", "sexagin", "septuagin", "octogin", "nongen")
	var/static/list/one_to_nine = list("monuple", "double", "triple", "quadruple", "quintuple", "sextuple", "septuple", "octuple", "nonuple")
	number = round(number)
	switch(number)
		if(0)
			return "empty tuple"
		if(1 to 9)
			return one_to_nine[number]
		if(10 to 19)
			return "[units_prefix[(number%10)+1]]decuple"
		if(20 to 99)
			return "[units_prefix[(number%10)+1]][tens_prefix[round((number % 100)/10)+1]]tuple"
		if(100)
			return "centuple"
		else //It gets too tedious to use latin prefixes from here.
			return "[number]-tuple"

#define TURF_FROM_COORDS_LIST(List) (locate(List[1], List[2], List[3]))


/**
 * One proc for easy spawning of pods in the code to drop off items before whizzling (please don't proc call this in game, it will destroy you)
 *
 * Arguments:
 * * specifications: special mods to the pod, see non var edit specifications for details on what you should fill this with
 * Non var edit specifications:
 * * target = where you want the pod to drop
 * * path = a special specific pod path if you want, this can save you a lot of var edits
 * * style = style of the pod, defaults to the normal pod
 * * spawn = spawned path or a list of the paths spawned, what you're sending basically
 * Returns the pod spawned, in case you want to spawn items yourself and modify them before putting them in.
 */
/proc/podspawn(specifications)
	//get non var edit specifications
	var/turf/landing_location = specifications["target"]
	var/spawn_type = specifications["path"]
	var/style = specifications["style"]
	var/list/paths_to_spawn = specifications["spawn"]

	//setup pod, add contents
	if(!isturf(landing_location))
		landing_location = get_turf(landing_location)
	if(!spawn_type)
		spawn_type = /obj/structure/closet/supplypod/podspawn
	var/obj/structure/closet/supplypod/podspawn/pod = new spawn_type(null, style)
	if(paths_to_spawn && !islist(paths_to_spawn))
		paths_to_spawn = list(paths_to_spawn)
	for(var/atom/path as anything in paths_to_spawn)
		path = new path(pod)

	//remove non var edits from specifications
	specifications -= "target"
	specifications -= "style"
	specifications -= "path"
	specifications -= "spawn" //list, we remove the key

	//rest of specificiations are edits on the pod
	for(var/variable_name in specifications)
		var/variable_value = specifications[variable_name]
		if(!pod.vv_edit_var(variable_name, variable_value))
			stack_trace("WARNING! podspawn vareditting \"[variable_name]\" to \"[variable_value]\" was rejected by the pod!")
	new /obj/effect/pod_landingzone(landing_location, pod)
	return pod

