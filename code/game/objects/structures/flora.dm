//These globs are to make sure that each flora instance doesn't have to make a new typepath if its type already made it; aka performance junk
GLOBAL_LIST_EMPTY(flora_required_tools_typepaths)
GLOBAL_LIST_EMPTY(flora_disallowed_tools_typepaths)
GLOBAL_LIST_EMPTY(flora_uprooting_tools_typepaths)

/obj/structure/flora
	name = "flora"
	desc = "Some sort of plant."
	resistance_flags = FLAMMABLE
	max_integrity = 150
	anchored = TRUE
	drag_slowdown = 1.3

	/// If set, the flora will have this as its name after being harvested. When the flora becomes harvestable again, it reverts to its initial(name)
	var/harvested_name
	/// If set, the flora will have this as its description after being harvested. When the flora becomes harvestable again, it regerts to its initial(desc)
	var/harvested_desc

	/// A lazylist of products that could be created when harvesting this flora, syntax is (type = weight)
	/// Because of how this works, it can spawn in anomalies if you want it to. Or wall girders
	var/product_types
	/// A lazylist typecache of items that can harvest this flora.
	/// Will be set automatically on Initialization depending on flora_flags.
	/// Paths in this list and their subtypes will be able to harvest the flora.
	var/required_tools
	/// A lazylist typecache of items that will be excluded from required_tools
	/// Paths in this list disallows items from harvesting this flora if that item is a type of this path
	var/disallowed_tools
	/// If the user is able to harvest this with their hands
	var/harvest_with_hands = FALSE
	/// The "verb" to use when the user harvests the flora
	var/harvest_verb = "harvest"
	/// What should be added to harvest_verb depending on the context ("user harvest(s) the tree" / "user chop(s down) the tree")
	var/harvest_verb_suffix = "s"
	/// If the user is allowed to uproot the flora
	var/can_uproot = TRUE
	/// What tools are allowed to be used to uproot the flora
	var/uprooting_tools = list(/obj/item/shovel)
	var/uprooted = FALSE
	var/previous_rotation = 0
	
	/// If false, the flora won't be able to be harvested at all. If it's true, go through checks normally to determine if the flora is able to be harvested
	var/harvestable = TRUE
	/// The low end of how many product_type items you get
	var/harvest_amount_low = 1
	/// The high end of how many product_type items you get
	var/harvest_amount_high = 3

	//Messages to show to the user depending on how many items they get when harvesting the flora
	var/harvest_message_low
	var/harvest_message_med
	var/harvest_message_high
	/// See proc/harvest() and where this is used for an explaination on how this works
	var/harvest_message_true_thresholds = FALSE

	/// How long it takes to harvest the flora with the correct tool
	var/harvest_time = 6 SECONDS
	var/delete_on_harvest = FALSE
	var/harvested = FALSE

	/// Variables for determining the low/high ends of how long it takes for the flora takes to grow.
	var/regrowth_time_low = 8 MINUTES
	/// Stops the flora from regrowing if this is set to 0
	var/regrowth_time_high = 16 MINUTES

	/// Flags for the flora to determine what kind of sound to play when it gets hit
	var/flora_flags = NONE

/obj/structure/flora/Initialize(mapload)
	. = ..()
	if(!required_tools)
		required_tools = list()
		if(flora_flags & FLORA_WOODEN)
			required_tools += FLORA_HARVEST_WOOD_TOOLS
		if(flora_flags & FLORA_STONE)
			required_tools += FLORA_HARVEST_STONE_TOOLS
	
	//ugly-looking performance optimization. what the glob bro
	if(!GLOB.flora_required_tools_typepaths[type])
		GLOB.flora_required_tools_typepaths[type] = typecacheof(required_tools)
	if(!GLOB.flora_disallowed_tools_typepaths[type])
		GLOB.flora_disallowed_tools_typepaths[type] = typecacheof(disallowed_tools)
	if(!GLOB.flora_uprooting_tools_typepaths[type])
		GLOB.flora_uprooting_tools_typepaths[type] = typecacheof(uprooting_tools)
	
	required_tools = GLOB.flora_required_tools_typepaths[type]
	disallowed_tools = GLOB.flora_disallowed_tools_typepaths[type]
	uprooting_tools = GLOB.flora_uprooting_tools_typepaths[type]

/obj/structure/flora/attackby(obj/item/W, mob/living/user, params)
	if(user.combat_mode)
		return ..()

	if(can_uproot && is_type_in_typecache(W, uprooting_tools))
		if(uprooted)
			user.visible_message(span_notice("[user] starts to replant [src]..."),
				span_notice("You start to replant [src]..."))
		else
			user.visible_message(span_notice("[user] starts to uproot [src]..."),
				span_notice("You start to uproot [src]..."))
		W.play_tool_sound(src, 50)
		if(!do_after(user, harvest_time, src))
			return
		if(uprooted)
			user.visible_message(span_notice("[user] replants [src]."),
				span_notice("You replant [src]."))
			replant(user)
		else
			user.visible_message(span_notice("[user] uproots [src]."),
				span_notice("You uproot [src]."))
			uproot(user)
		W.play_tool_sound(src, 50)
		return

	if(!can_harvest(user, W))
		return ..()
	
	user.visible_message(span_notice("[user] starts to [harvest_verb] [src]..."),
		span_notice("You start to [harvest_verb] [src] with [W]..."))
	play_attack_sound(W.force)
	if(!do_after(user, harvest_time, src))
		return
	visible_message(span_notice("[user] [harvest_verb][harvest_verb_suffix] [src]."),
		ignored_mobs = list(user))
	play_attack_sound(W.force)
	
	if(harvest(user))
		after_harvest(user)

/obj/structure/flora/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!can_harvest(user) || !harvest_with_hands)
		return

	user.visible_message(span_notice("[user] starts to [harvest_verb] [src]..."),
		span_notice("You start to [harvest_verb] [src]..."))
	play_attack_sound()
	if(!do_after(user, harvest_time, src))
		return
	visible_message(span_notice("[user] [harvest_verb][harvest_verb_suffix] [src]."),
		ignored_mobs = list(user))
	play_attack_sound()
	
	if(harvest(user))
		after_harvest(user)

/obj/structure/flora/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	var/use_default_sound = TRUE //Because I don't wanna do unnecessary bitflag checks in a single if statement, while also allowing for multiple sounds to be played
	if(flora_flags & FLORA_HERBAL)
		playsound(src, SFX_CRUNCHY_BUSH_WHACK, 50, vary = FALSE)
		use_default_sound = FALSE
	if(flora_flags & FLORA_WOODEN)
		playsound(src, SFX_TREE_CHOP, 50, vary = FALSE)
		use_default_sound = FALSE
	if(flora_flags & FLORA_STONE)
		playsound(src, SFX_ROCK_TAP, 50, vary = FALSE)
		use_default_sound = FALSE
	if(use_default_sound)
		return ..()

/* 
 * A helper proc for getting a random amount of products, associated with the flora's product list.
 * Returns: A list where each value is (product_type = amount_of_products)
 */
/obj/structure/flora/proc/get_products_list()
	if(!LAZYLEN(product_types))
		return list()
	var/list/product_list = list()

	var/harvest_amount = rand(harvest_amount_low, harvest_amount_high)
	for(var/iteration in 1 to harvest_amount)
		var/chosen_product = pick_weight(product_types)
		if(!product_list[chosen_product])
			product_list[chosen_product] = 0
		product_list[chosen_product]++
	return product_list

/*
 * A helper proc that determines if a user can currently harvest this flora with whatever tool they're trying to use.
 * Returns: TRUE if they can harvest, FALSE if not. Null if it's not harvestable at all.
 */
/obj/structure/flora/proc/can_harvest(mob/user, obj/item/harvesting_item)
	. = FALSE
	if(harvested || !harvestable)
		return null
	
	if(harvesting_item)
		if(!is_type_in_typecache(harvesting_item, required_tools))
			return
		if(is_type_in_typecache(harvesting_item, disallowed_tools))
			return
	return TRUE

/*
 * This gets called after a mob tries to harvest this flora with the correct tool.
 * It displays a flavor message to whoever's harvesting this flora, then creates new products depending on the flora's product list.
 * Also renames the flora if harvested_name or harvested_desc is set in the variables
 * Returns: FALSE if nothing was made, otherwise a list of created products
 */
/obj/structure/flora/proc/harvest(user)
	. = FALSE
	if(harvested && !LAZYLEN(product_types))
		return
	
	var/list/products_to_create = get_products_list()
	if(!products_to_create.len)
		return

	var/products_created = 0
	var/turf/turf_below = get_turf(src)

	//This loop creates new products on the turf of our flora, but checks if it's an item stack
	//If it *is* an item stack, we don't want to go through 50 different iterations of a new object where it just gets qdeleted after the first
	. = list()
	for(var/product in products_to_create)
		var/amount_to_create = products_to_create[product]
		products_created += amount_to_create
		if(ispath(product, /obj/item/stack))
			var/product_left = amount_to_create
			while(product_left > 0)
				var/obj/item/stack/new_stack = new product(turf_below)
				product_left -= new_stack.amount = min(product_left, new_stack.max_amount)
				. += new_stack
		else
			for(var/iteration in 1 to amount_to_create)
				. += new product(turf_below)

	//This bit of code determines what should be shown to the user when this is harvested
	var/message = harvest_message_med || harvest_message_high || harvest_message_low
	if(user && message)
		if(harvest_message_true_thresholds) //Old method of how the harvest messages worked. Useful depending on the context you want to implement
			if(products_created == harvest_amount_low && harvest_message_low)
				message = harvest_message_low
			if(products_created == harvest_amount_high && harvest_message_high)
				message = harvest_message_high
		else //New method of determining the message to display. Separates the messages into 3 different viable "regions"
			//[   ][   ][   ] the default message depends on whether or not something's nulled out
			var/comparison = products_created - harvest_amount_low //avoiding unnecessary math
			var/middle_value = round((harvest_amount_high - harvest_amount_low)/2) + harvest_amount_low //mathy shit, gets the middle between two values
			//[***][   ][   ]
			if(comparison < (middle_value - harvest_amount_low)/2 && harvest_message_low) //more mathy shit, gets the middle between middle_value and harvest_amount_low
				message = harvest_message_low
			//[   ][   ][***]
			if(comparison > (harvest_amount_high - middle_value)/2 && harvest_message_high) //the middle between middle_value and harvest_amount_high
				message = harvest_message_high
			//[   ][***][   ] use the default message if none of the above applies

		to_chat(user, span_notice(message))

	if(harvested_name)
		name = harvested_name
	if(harvested_desc)
		desc = harvested_desc
	harvested = TRUE
	if(!delete_on_harvest && regrowth_time_high > 0)
		addtimer(CALLBACK(src, .proc/regrow), rand(regrowth_time_low, regrowth_time_high))

/obj/structure/flora/proc/after_harvest(user)
	if(delete_on_harvest)
		qdel(src)

/obj/structure/flora/proc/regrow()
	name = initial(name)
	desc = initial(desc)
	harvested = FALSE

/*
 * Called after the user uproots the flora with a shovel.
 */
/obj/structure/flora/proc/uproot(mob/living/user)
	anchored = FALSE
	uprooted = TRUE
	var/matrix/M = matrix(transform)
	previous_rotation = pick(-90, 90)
	transform = M.Turn(previous_rotation)

/*
 * Called after the user plants the flora back into the ground after uprooted
 */
/obj/structure/flora/proc/replant(mob/living/user)
	anchored = initial(anchored)
	uprooted = FALSE
	var/matrix/M = matrix(transform)
	transform = M.Turn(-previous_rotation)

/*********
 * Trees *
 *********/
//Can *you* speak their language?

/obj/structure/flora/tree
	name = "tree"
	desc = "A large tree."
	density = TRUE
	pixel_x = -16
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE
	drag_slowdown = 1.5
	product_types = list(/obj/item/grown/log/tree = 1)
	harvest_amount_low = 6
	harvest_amount_high = 10
	harvest_message_low = "You manage to gather a few logs from the tree."
	harvest_message_med = "You manage to gather some logs from the tree."
	harvest_message_high = "You manage to get most of the wood from the tree."
	harvest_verb = "chop"
	harvest_verb_suffix = "s down"
	delete_on_harvest = TRUE
	flora_flags = FLORA_HERBAL | FLORA_WOODEN

/obj/structure/flora/tree/harvest(mob/living/user)
	. = ..()
	var/turf/my_turf = get_turf(src)
	playsound(my_turf, 'sound/effects/meteorimpact.ogg', 100 , FALSE, FALSE)
	var/obj/structure/flora/tree/stump/new_stump = new(my_turf)
	new_stump.name = "[name] stump"

/obj/structure/flora/tree/uproot(mob/living/user)
	..()
	playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 100 , FALSE, FALSE)

/obj/structure/flora/tree/stump
	name = "stump"
	desc = "This represents our promise to the crew, and the station itself, to cut down as many trees as possible." //running naked through the trees
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "tree_stump"
	density = FALSE
	delete_on_harvest = TRUE

/obj/structure/flora/tree/stump/harvest(mob/living/user)
	to_chat(user, span_notice("You manage to remove [src]."))
	qdel(src)

/obj/structure/flora/tree/stump/uproot(mob/living/user)
	..()
	to_chat(user, span_notice("You manage to remove [src]."))
	qdel(src)

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	desc = "A dead tree. How it died, you know not."
	icon_state = "tree_1"
	harvest_amount_low = 2
	harvest_amount_high = 6
	flora_flags = FLORA_WOODEN

/obj/structure/flora/tree/dead/style_2
	icon_state = "tree_2"
/obj/structure/flora/tree/dead/style_3
	icon_state = "tree_3"
/obj/structure/flora/tree/dead/style_4
	icon_state = "tree_4"
/obj/structure/flora/tree/dead/style_5
	icon_state = "tree_5"
/obj/structure/flora/tree/dead/style_6
	icon_state = "tree_6"
/obj/structure/flora/tree/dead/style_random/Initialize(mapload)
	. = ..()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree/jungle
	desc = "It's seriously hampering your view of the jungle."
	icon = 'icons/obj/flora/jungletrees.dmi'
	icon_state = "tree1"
	pixel_x = -48
	pixel_y = -20

/obj/structure/flora/tree/jungle/style_2
	icon_state = "tree2"
/obj/structure/flora/tree/jungle/style_3
	icon_state = "tree3"
/obj/structure/flora/tree/jungle/style_4
	icon_state = "tree4"
/obj/structure/flora/tree/jungle/style_5
	icon_state = "tree5"
/obj/structure/flora/tree/jungle/style_6
	icon_state = "tree6"
/obj/structure/flora/tree/jungle/style_random/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1, 6)]"

/obj/structure/flora/tree/jungle/small
	pixel_y = 0
	pixel_x = -32
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree1"

/obj/structure/flora/tree/jungle/small/style_2
	icon_state = "tree2"
/obj/structure/flora/tree/jungle/small/style_3
	icon_state = "tree3"
/obj/structure/flora/tree/jungle/small/style_4
	icon_state = "tree4"
/obj/structure/flora/tree/jungle/small/style_5
	icon_state = "tree5"
/obj/structure/flora/tree/jungle/small/style_6
	icon_state = "tree6"
/obj/structure/flora/tree/jungle/small/style_random/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1, 6)]"

/**************
 * Pine Trees *
 **************/

/obj/structure/flora/tree/pine
	name = "pine tree"
	desc = "A coniferous pine tree."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/style_2
	icon_state = "pine_2"
/obj/structure/flora/tree/pine/style_3
	icon_state = "pine_3"
/obj/structure/flora/tree/pine/style_random/Initialize(mapload)
	. = ..()
	icon_state = "pine_[rand(1,3)]"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	desc = "A wondrous decorated Christmas tree."
	icon_state = "pine_c"
	flags_1 = NODECONSTRUCT_1 //protected by the christmas spirit

/obj/structure/flora/tree/pine/xmas/presents
	icon_state = "pinepresents"
	desc = "A wondrous decorated Christmas tree. It has presents!"
	var/gift_type = /obj/item/a_gift/anything
	var/unlimited = FALSE
	var/static/list/took_presents //shared between all xmas trees

/obj/structure/flora/tree/pine/xmas/presents/Initialize(mapload)
	. = ..()
	if(!took_presents)
		took_presents = list()

/obj/structure/flora/tree/pine/xmas/presents/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.ckey)
		return

	if(took_presents[user.ckey] && !unlimited)
		to_chat(user, span_warning("There are no presents with your name on."))
		return
	to_chat(user, span_warning("After a bit of rummaging, you locate a gift with your name on it!"))

	if(!unlimited)
		took_presents[user.ckey] = TRUE

	var/obj/item/G = new gift_type(src)
	user.put_in_hands(G)

/obj/structure/flora/tree/pine/xmas/presents/unlimited
	desc = "A wonderous decorated Christmas tree. It has a seemly endless supply of presents!"
	unlimited = TRUE

/obj/structure/festivus
	name = "festivus pole"
	desc = "During last year's Feats of Strength the Research Director was able to suplex this passing immobile rod into a planter."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "festivus_pole"

/obj/structure/festivus/anchored
	name = "suplexed rod"
	desc = "A true feat of strength, almost as good as last year."
	icon_state = "anchored_rod"
	anchored = TRUE

/**************
 * Palm Trees *
 **************/

/obj/structure/flora/tree/palm
	name = "palm tree"
	desc = "A tree straight from the tropics."
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	pixel_x = 0

/obj/structure/flora/tree/palm/style_2
	icon_state = "palm2"
/obj/structure/flora/tree/palm/style_random/Initialize(mapload)
	. = ..()
	icon_state = "palm[rand(1,2)]"

/*********
 * Grass *
 *********/
/obj/structure/flora/grass
	name = "grass"
	desc = "A patch of overgrown grass."
	icon = 'icons/obj/flora/snowflora.dmi'
	gender = PLURAL //"this is grass" not "this is a grass"
	product_types = list(/obj/item/food/grown/grass = 10, /obj/item/seeds/grass = 1)
	harvest_with_hands = TRUE
	harvest_amount_low = 0
	harvest_amount_high = 2
	harvest_message_low = "You uproot the grass from the ground, just for the fun of it."
	harvest_message_med = "You gather up some grass."
	harvest_message_high = "You gather up a handful grass."
	can_uproot = TRUE
	flora_flags = FLORA_HERBAL

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"
/obj/structure/flora/grass/brown/style_2
	icon_state = "snowgrass2bb"
/obj/structure/flora/grass/brown/style_3
	icon_state = "snowgrass2bb"
/obj/structure/flora/grass/brown/style_random/Initialize(mapload)
	. = ..()
	icon_state = "snowgrass[rand(1, 3)]bb"

/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"
/obj/structure/flora/grass/green/style_2
	icon_state = "snowgrass2gb"
/obj/structure/flora/grass/green/style_3
	icon_state = "snowgrass3gb"
/obj/structure/flora/grass/green/style_random/Initialize(mapload)
	. = ..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"
/obj/structure/flora/grass/both/style_2
	icon_state = "snowgrassall2"
/obj/structure/flora/grass/both/style_3
	icon_state = "snowgrassall3"
/obj/structure/flora/grass/both/style_random/Initialize(mapload)
	. = ..()
	icon_state = "snowgrassall[rand(1, 3)]"
<<<<<<< HEAD
	. = ..()


//bushes
/obj/structure/flora/bush
	name = "bush"
	desc = "Some type of shrub."
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	anchored = TRUE
	herbage = TRUE

/obj/structure/flora/bush/Initialize(mapload)
	icon_state = "snowbush[rand(1, 6)]"
	. = ..()

//newbushes

/obj/structure/flora/ausbushes
	name = "bush"
	desc = "Some kind of plant."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	herbage = TRUE

/obj/structure/flora/ausbushes/Initialize(mapload)
	if(icon_state == "firstbush_1")
		icon_state = "firstbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/Initialize(mapload)
	icon_state = "reedbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/Initialize(mapload)
	icon_state = "leafybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/Initialize(mapload)
	icon_state = "palebush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/Initialize(mapload)
	icon_state = "stalkybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/Initialize(mapload)
	icon_state = "grassybush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/Initialize(mapload)
	icon_state = "fernybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/Initialize(mapload)
	icon_state = "sunnybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/Initialize(mapload)
	icon_state = "genericbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/Initialize(mapload)
	icon_state = "pointybush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/Initialize(mapload)
	icon_state = "lavendergrass_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/Initialize(mapload)
	icon_state = "ywflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/Initialize(mapload)
	icon_state = "brflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/Initialize(mapload)
	icon_state = "ppflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/Initialize(mapload)
	icon_state = "sparsegrass_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/Initialize(mapload)
	icon_state = "fullgrass_[rand(1, 3)]"
	. = ..()

/obj/item/kirbyplants
	name = "potted plant"
	icon = 'icons/obj/flora/plants.dmi'
	icon_state = "plant-01"
	desc = "A little bit of nature contained in a pot."
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 13
	throw_speed = 2
	throw_range = 4
	item_flags = NO_PIXEL_RANDOM_DROP

	/// Can this plant be trimmed by someone with TRAIT_BONSAI
	var/trimmable = TRUE
	var/list/static/random_plant_states

	var/random_state_cap = 43 //SKYRAT EDIT ADDITION - KEEP THIS TO THE HIGHEST POTTED PLANT ICON STATE

/obj/item/kirbyplants/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/tactical)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=10, force_wielded=10)
	AddElement(/datum/element/beauty, 500)

/obj/item/kirbyplants/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(trimmable && HAS_TRAIT(user,TRAIT_BONSAI) && isturf(loc) && I.get_sharpness())
		to_chat(user,span_notice("You start trimming [src]."))
		if(do_after(user,3 SECONDS,target=src))
			to_chat(user,span_notice("You finish trimming [src]."))
			change_visual()

/// Cycle basic plant visuals
/obj/item/kirbyplants/proc/change_visual()
	if(!random_plant_states)
		generate_states()
	var/current = random_plant_states.Find(icon_state)
	var/next = WRAP(current+1,1,length(random_plant_states))
	icon_state = random_plant_states[next]

/obj/item/kirbyplants/random
	icon = 'icons/obj/flora/_flora.dmi'
	icon_state = "random_plant"

/obj/item/kirbyplants/random/Initialize(mapload)
	. = ..()
	icon = 'modular_skyrat/modules/aesthetics/plants/plants.dmi' //SKYRAT EDIT CHANGE
	if(!random_plant_states)
		generate_states()
	icon_state = pick(random_plant_states)

/obj/item/kirbyplants/proc/generate_states()
	random_plant_states = list()
	for(var/i in 1 to random_state_cap) //SKYRAT EDIT CHANGE
		random_plant_states += "plant-[i]" //SKYRAT EDIT CHANGE
	random_plant_states += list("applebush", "monkeyplant") //SKYRAT EDIT CHANGE


/obj/item/kirbyplants/dead
	name = "RD's potted plant"
	desc = "A gift from the botanical staff, presented after the RD's reassignment. There's a tag on it that says \"Y'all come back now, y'hear?\"\nIt doesn't look very healthy..."
	icon_state = "plant-25"
	trimmable = FALSE

//SKYRAT EDIT START
/obj/item/kirbyplants/monkey
	name = "monkey plant"
	desc = "Something that seems to have been made by the Nanotrasen science division, one might call it an abomination. It's heads seem... alive."
	icon_state = "monkeyplant"
	trimmable = FALSE
//SKYRAT EDIT END

/obj/item/kirbyplants/photosynthetic
	name = "photosynthetic potted plant"
	desc = "A bioluminescent plant."
	icon_state = "plant-9" //SKYRAT EDIT CHANGE
	light_color = COLOR_BRIGHT_BLUE
	light_range = 3

/obj/item/kirbyplants/fullysynthetic
	name = "plastic potted plant"
	desc = "A fake, cheap looking, plastic tree. Perfect for people who kill every plant they touch."
	icon_state = "plant-26"
	custom_materials = (list(/datum/material/plastic = 8000))
	trimmable = FALSE

/obj/item/kirbyplants/fullysynthetic/Initialize(mapload)
	. = ..()
	icon_state = "plant-[rand(26, 29)]"

/obj/item/kirbyplants/potty
	name = "Potty the Potted Plant"
	desc = "A secret agent staffed in the station's bar to protect the mystical cakehat."
	icon_state = "potty"
	trimmable = FALSE

/obj/item/kirbyplants/fern
	name = "neglected fern"
	desc = "An old botanical research sample collected on a long forgotten jungle planet."
	icon_state = "fern"
	trimmable = FALSE

/obj/item/kirbyplants/fern/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_ALGAE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 5)

//a rock is flora according to where the icon file is
//and now these defines

/obj/structure/flora/rock
	icon_state = "basalt"
	desc = "A volcanic rock. Pioneers used to ride these babies for miles."
	icon = 'icons/obj/flora/rocks.dmi'
	resistance_flags = FIRE_PROOF
	density = TRUE
	/// Itemstack that is dropped when a rock is mined with a pickaxe
	var/obj/item/stack/mineResult = /obj/item/stack/ore/glass/basalt
	/// Amount of the itemstack to drop
	var/mineAmount = 20
	rock = TRUE

/obj/structure/flora/rock/Initialize(mapload)
	. = ..()
	icon_state = "[icon_state][rand(1,3)]"

/obj/structure/flora/rock/attackby(obj/item/attacking_item, mob/user, params)
	if(!mineResult || attacking_item.tool_behaviour != TOOL_MINING)
		return ..()
	if(flags_1 & NODECONSTRUCT_1)
		return ..()
	to_chat(user, span_notice("You start mining..."))
	if(!attacking_item.use_tool(src, user, 40, volume=50))
		return
	to_chat(user, span_notice("You finish mining the rock."))
	if(mineResult && mineAmount)
		new mineResult(loc, mineAmount)
	SSblackbox.record_feedback("tally", "pick_used_mining", 1, attacking_item.type)
	qdel(src)

/obj/structure/flora/rock/pile
	icon_state = "lavarocks"
	desc = "A pile of rocks."
	density = FALSE //SKYRAT EDIT ADDITION

//Jungle grass
=======
>>>>>>> 89650214fd8 ([MDB Ignore] Refactoring Flora code (#66978))

/obj/structure/flora/grass/jungle
	name = "jungle grass"
	desc = "Thick alien flora."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa1"

/obj/structure/flora/grass/jungle/a/style_2
	icon_state = "grassa2"
/obj/structure/flora/grass/jungle/a/style_3
	icon_state = "grassa3"
/obj/structure/flora/grass/jungle/a/style_4
	icon_state = "grassa4"
/obj/structure/flora/grass/jungle/a/style_5
	icon_state = "grassa5"
/obj/structure/flora/grass/jungle/a/style_random/Initialize(mapload)
	. = ..()
	icon_state = "grassa[rand(1, 5)]"

/obj/structure/flora/grass/jungle/b
	icon_state = "grassb1"
/obj/structure/flora/grass/jungle/b/style_2
	icon_state = "grassb2"
/obj/structure/flora/grass/jungle/b/style_3
	icon_state = "grassb3"
/obj/structure/flora/grass/jungle/b/style_4
	icon_state = "grassb4"
/obj/structure/flora/grass/jungle/b/style_5
	icon_state = "grassb5"
/obj/structure/flora/grass/jungle/b/style_random/Initialize(mapload)
	. = ..()
	icon_state = "grassb[rand(1, 5)]"

/**********
 * Bushes *
 **********/

/obj/structure/flora/bush
	name = "bush"
	desc = "Some type of shrubbery. Known for causing considerable economic stress on designers."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	flora_flags = FLORA_HERBAL

/obj/structure/flora/bush/style_2
	icon_state = "firstbush_2"
/obj/structure/flora/bush/style_3
	icon_state = "firstbush_3"
/obj/structure/flora/bush/style_4
	icon_state = "firstbush_4"
/obj/structure/flora/bush/style_random/Initialize(mapload)
	. = ..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/bush/reed
	icon_state = "reedbush_1"
/obj/structure/flora/bush/reed/style_2
	icon_state = "reedbush_2"
/obj/structure/flora/bush/reed/style_3
	icon_state = "reedbush_3"
/obj/structure/flora/bush/reed/style_4
	icon_state = "reedbush_4"
/obj/structure/flora/bush/reed/style_random/Initialize(mapload)
	. = ..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/bush/leafy
	icon_state = "leafybush_1"
/obj/structure/flora/bush/leavy/style_2
	icon_state = "leafybush_2"
/obj/structure/flora/bush/leavy/style_3
	icon_state = "leafybush_3"
/obj/structure/flora/bush/leavy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/bush/pale
	icon_state = "palebush_1"
/obj/structure/flora/bush/pale/style_2
	icon_state = "palebush_2"
/obj/structure/flora/bush/pale/style_3
	icon_state = "palebush_3"
/obj/structure/flora/bush/pale/style_4
	icon_state = "palebush_4"
/obj/structure/flora/bush/pale/style_random/Initialize(mapload)
	. = ..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/bush/stalky
	icon_state = "stalkybush_1"
/obj/structure/flora/bush/stalky/style_2
	icon_state = "stalkybush_2"
/obj/structure/flora/bush/stalky/style_3
	icon_state = "stalkybush_3"
/obj/structure/flora/bush/stalky/style_random/Initialize(mapload)
	. = ..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/bush/grassy
	icon_state = "grassybush_1"
/obj/structure/flora/bush/grassy/style_2
	icon_state = "grassybush_2"
/obj/structure/flora/bush/grassy/style_3
	icon_state = "grassybush_3"
/obj/structure/flora/bush/grassy/style_4
	icon_state = "grassybush_4"
/obj/structure/flora/bush/grassy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/bush/sparsegrass
	icon_state = "sparsegrass_1"
/obj/structure/flora/bush/sparsegrass/style_2
	icon_state = "sparsegrass_2"
/obj/structure/flora/bush/sparsegrass/style_3
	icon_state = "sparsegrass_3"
/obj/structure/flora/bush/sparsegrass/style_random/Initialize(mapload)
	. = ..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/bush/fullgrass
	icon_state = "fullgrass_1"
/obj/structure/flora/bush/fullgrass/style_2
	icon_state = "fullgrass_2"
/obj/structure/flora/bush/fullgrass/style_3
	icon_state = "fullgrass_3"
/obj/structure/flora/bush/fullgrass/style_random/Initialize(mapload)
	. = ..()
	icon_state = "fullgrass_[rand(1, 3)]"

/obj/structure/flora/bush/ferny
	icon_state = "fernybush_1"
/obj/structure/flora/bush/ferny/style_2
	icon_state = "fernybush_2"
/obj/structure/flora/bush/ferny/style_3
	icon_state = "fernybush_3"
/obj/structure/flora/bush/ferny/style_random/Initialize(mapload)
	. = ..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/bush/sunny
	icon_state = "sunnybush_1"
/obj/structure/flora/bush/sunny/style_2
	icon_state = "sunnybush_2"
/obj/structure/flora/bush/sunny/style_3
	icon_state = "sunnybush_3"
/obj/structure/flora/bush/sunny/style_random/Initialize(mapload)
	. = ..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/bush/generic
	icon_state = "genericbush_1"
/obj/structure/flora/bush/generic/style_2
	icon_state = "genericbush_2"
/obj/structure/flora/bush/generic/style_3
	icon_state = "genericbush_3"
/obj/structure/flora/bush/generic/style_4
	icon_state = "genericbush_4"
/obj/structure/flora/bush/generic/style_random/Initialize(mapload)
	. = ..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/bush/pointy
	icon_state = "pointybush_1"
/obj/structure/flora/bush/pointy/style_2
	icon_state = "pointybush_2"
/obj/structure/flora/bush/pointy/style_3
	icon_state = "pointybush_3"
/obj/structure/flora/bush/pointy/style_4
	icon_state = "pointybush_4"
/obj/structure/flora/bush/pointy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/bush/lavendergrass
	icon_state = "lavendergrass_1"
/obj/structure/flora/bush/lavendergrass/style_2
	icon_state = "lavendergrass_2"
/obj/structure/flora/bush/lavendergrass/style_3
	icon_state = "lavendergrass_3"
/obj/structure/flora/bush/lavendergrass/style_4
	icon_state = "lavendergrass_4"
/obj/structure/flora/bush/lavendergrass/style_random/Initialize(mapload)
	. = ..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/bush/flowers_yw
	icon_state = "ywflowers_1"
/obj/structure/flora/bush/flowers_yw/style_2
	icon_state = "ywflowers_2"
/obj/structure/flora/bush/flowers_yw/style_3
	icon_state = "ywflowers_3"
/obj/structure/flora/bush/flowers_yw/style_random/Initialize(mapload)
	. = ..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/bush/flowers_br
	icon_state = "brflowers_1"
/obj/structure/flora/bush/flowers_br/style_2
	icon_state = "brflowers_2"
/obj/structure/flora/bush/flowers_br/style_3
	icon_state = "brflowers_3"
/obj/structure/flora/bush/flowers_br/style_random/Initialize(mapload)
	. = ..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/bush/flowers_pp
	icon_state = "ppflowers_1"
/obj/structure/flora/bush/flowers_pp/style_2
	icon_state = "ppflowers_2"
/obj/structure/flora/bush/flowers_pp/style_3
	icon_state = "ppflowers_3"
/obj/structure/flora/bush/flowers_pp/style_random/Initialize(mapload)
	. = ..()
	icon_state = "ppflowers_[rand(1, 3)]"

/obj/structure/flora/bush/snow
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"

/obj/structure/flora/bush/snow/style_2
	icon_state = "snowbush2"
/obj/structure/flora/bush/snow/style_3
	icon_state = "snowbush3"
/obj/structure/flora/bush/snow/style_4
	icon_state = "snowbush4"
/obj/structure/flora/bush/snow/style_5
	icon_state = "snowbush5"
/obj/structure/flora/bush/snow/style_6
	icon_state = "snowbush6"
/obj/structure/flora/bush/snow/style_random/Initialize(mapload)
	. = ..()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/bush/jungle
	desc = "A wild plant that is found in jungles."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "busha1"
	flora_flags = FLORA_HERBAL

/obj/structure/flora/bush/jungle/a/style_2
	icon_state = "busha2"
/obj/structure/flora/bush/jungle/a/style_3
	icon_state = "busha3"
/obj/structure/flora/bush/jungle/a/style_random/Initialize(mapload)
	. = ..()
	icon_state = "busha[rand(1, 3)]"

/obj/structure/flora/bush/jungle/b
	icon_state = "bushb1"
/obj/structure/flora/bush/jungle/b/style_2
	icon_state = "bushb2"
/obj/structure/flora/bush/jungle/b/style_3
	icon_state = "bushb3"
/obj/structure/flora/bush/jungle/b/style_random/Initialize(mapload)
	. = ..()
	icon_state = "bushb[rand(1, 3)]"

/obj/structure/flora/bush/jungle/c
	icon_state = "bushc1"
/obj/structure/flora/bush/jungle/c/style_2
	icon_state = "bushc2"
/obj/structure/flora/bush/jungle/c/style_3
	icon_state = "bushc3"
/obj/structure/flora/bush/jungle/c/style_random/Initialize(mapload)
	. = ..()
	icon_state = "bushc[rand(1, 3)]"

/obj/structure/flora/bush/large
	icon = 'icons/obj/flora/largejungleflora.dmi'
	icon_state = "bush1"
	pixel_x = -16
	pixel_y = -12
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/structure/flora/bush/large/style_2
	icon_state = "bush2"
/obj/structure/flora/bush/large/style_3
	icon_state = "bush3"
/obj/structure/flora/bush/large/style_random/Initialize(mapload)
	. = ..()
	icon_state = "bush[rand(1, 3)]"

/*********
 * Rocks *
 *********/
// (I know these aren't plants)

/obj/structure/flora/rock
	name = "large rock"
	icon_state = "basalt1"
	desc = "A volcanic rock. Pioneers used to ride these babies for miles."
	icon = 'icons/obj/flora/rocks.dmi'
	density = TRUE
	resistance_flags = FIRE_PROOF
	product_types = list(/obj/item/stack/ore/glass/basalt = 1)
	harvest_amount_low = 10
	harvest_amount_high = 20
	harvest_message_med = "You finish mining the rock."
	harvest_verb = "mine"
	flora_flags = FLORA_STONE
	can_uproot = FALSE
	delete_on_harvest = TRUE

/obj/structure/flora/rock/style_2
	icon_state = "basalt2"
/obj/structure/flora/rock/style_3
	icon_state = "basalt3"
/obj/structure/flora/rock/style_random/Initialize(mapload)
	. = ..()
	icon_state = "basalt[rand(1, 3)]"

/obj/structure/flora/rock/pile
	name = "rock pile"
	desc = "A pile of rocks."
	icon_state = "lavarocks1"
	harvest_amount_low = 5
	harvest_amount_high = 10
	harvest_message_med = "You finish mining the pile of rocks."
	density = FALSE

/obj/structure/flora/rock/pile/style_2
	icon_state = "lavarocks2"
/obj/structure/flora/rock/pile/style_3
	icon_state = "lavarocks3"
/obj/structure/flora/rock/pile/style_random/Initialize(mapload)
	. = ..()
	icon_state = "lavarocks[rand(1, 3)]"

/obj/structure/flora/rock/pile/jungle
	icon_state = "rock1"
	icon = 'icons/obj/flora/jungleflora.dmi'
/obj/structure/flora/rock/pile/jungle/style_2
	icon_state = "rock2"
/obj/structure/flora/rock/pile/jungle/style_3
	icon_state = "rock3"
/obj/structure/flora/rock/pile/jungle/style_4
	icon_state = "rock4"
/obj/structure/flora/rock/pile/jungle/style_5
	icon_state = "rock5"
/obj/structure/flora/rock/pile/jungle/style_random/Initialize(mapload)
	. = ..()
	icon_state = "rock[rand(1, 5)]"

/obj/structure/flora/rock/pile/jungle/large
	name = "pile of large rocks"
	icon_state = "rocks1"
	icon = 'icons/obj/flora/largejungleflora.dmi'
	pixel_x = -16
	pixel_y = -16
	harvest_amount_low = 9
	harvest_amount_high = 13

/obj/structure/flora/rock/pile/jungle/large/style_2
	icon_state = "rocks2"
/obj/structure/flora/rock/pile/jungle/large/style_3
	icon_state = "rocks3"
/obj/structure/flora/rock/pile/jungle/large/style_random/Initialize(mapload)
	. = ..()
	icon_state = "rocks[rand(1, 3)]"

//TODO: Make new sprites for these. the pallete in the icons are grey, and a white color here still makes them grey
/obj/structure/flora/rock/icy
	name = "icy rock"
	icon_state = "basalt1"
	color = rgb(204,233,235)

/obj/structure/flora/rock/icy/style_2
	icon_state = "basalt2"
/obj/structure/flora/rock/icy/style_3
	icon_state = "basalt3"
/obj/structure/flora/rock/icy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "basalt[rand(1, 3)]"

/obj/structure/flora/rock/pile/icy
	name = "icy rocks"
	icon_state = "lavarocks1"
	color = rgb(204,233,235)

/obj/structure/flora/rock/pile/icy/style_2
	icon_state = "lavarocks2"
/obj/structure/flora/rock/pile/icy/style_3
	icon_state = "lavarocks3"
/obj/structure/flora/rock/pile/icy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "lavarocks[rand(1, 3)]"
