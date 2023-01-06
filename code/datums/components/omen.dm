/**
 * omen.dm: For when you want someone to have a really bad day
 *
 * When you attach an omen component to someone, they start running the risk of all sorts of bad environmental injuries, like nearby vending machines randomly falling on you,
 * or hitting your head really hard when you slip and fall, or... well, for now those two are all I have. More will come.
 *
 * Omens are removed once the victim is either maimed by one of the possible injuries, or if they receive a blessing (read: bashing with a bible) from the chaplain.
 */
/datum/component/omen
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Whatever's causing the omen, if there is one. Destroying the vessel won't stop the omen, but we destroy the vessel (if one exists) upon the omen ending
	var/obj/vessel

	/// Whether this is a permanent omen that cannot be removed by any non-admin means.
	var/permanent = FALSE

/datum/component/omen/Initialize(silent = FALSE, _vessel, _permanent = FALSE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	vessel = _vessel
	permanent = _permanent
	if(!silent)
		var/warning = "You get a bad feeling..."
		if(permanent)
			warning += " A very bad feeling... As if you are surrounded by a twisted aura of pure malevolence..."
		to_chat(parent, span_warning("[warning]"))


/datum/component/omen/Destroy(force, silent)
	if(!silent)
		var/mob/living/person = parent
		to_chat(person, span_nicegreen("You feel a horrible omen lifted off your shoulders!"))
	if(vessel)
		vessel.visible_message(span_warning("[vessel] burns up in a sinister flash, taking an evil energy with it..."))
		vessel = null
	return ..()

/datum/component/omen/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_accident))
	RegisterSignal(parent, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(check_slip))
	RegisterSignal(parent, COMSIG_CARBON_MOOD_UPDATE, PROC_REF(check_bless))

/datum/component/omen/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_STATUS_KNOCKDOWN, COMSIG_MOVABLE_MOVED, COMSIG_CARBON_MOOD_UPDATE))

/**
 * check_accident() is called each step we take
 *
 * While we're walking around, roll to see if there's any environmental hazards (currently only vending machines) on one of the adjacent tiles we can trigger.
 * We do the prob() at the beginning to A. add some tension for /when/ it will strike, and B. (more importantly) ameliorate the fact that we're checking up to 5 turfs's contents each time
 */
/datum/component/omen/proc/check_accident(atom/movable/our_guy)
	SIGNAL_HANDLER

	if(!isliving(our_guy))
		return

	var/mob/living/living_guy = our_guy

	if(!prob(15))
		return
	var/our_guy_pos = get_turf(living_guy)
	for(var/turf_content in our_guy_pos)
		if(istype(turf_content, /obj/machinery/door/airlock))
			to_chat(living_guy, span_warning("A malevolent force launches your body to the floor..."))
			var/obj/machinery/door/airlock/darth_airlock = turf_content
			living_guy.apply_status_effect(/datum/status_effect/incapacitating/paralyzed, 10)
			INVOKE_ASYNC(darth_airlock, TYPE_PROC_REF(/obj/machinery/door/airlock, close), TRUE)
			if(!permanent)
				qdel(src)
			return

	for(var/turf/the_turf as anything in get_adjacent_open_turfs(living_guy))
		if(the_turf.zPassOut(living_guy, DOWN) && living_guy.can_z_move(DOWN, the_turf, z_move_flags = ZMOVE_FALL_FLAGS))
			to_chat(living_guy, span_warning("A malevolent force guides you towards the edge..."))
			living_guy.throw_at(the_turf, 1, 10, force = MOVE_FORCE_EXTREMELY_STRONG)
			if(!permanent)
				qdel(src)
			return

		for(var/obj/machinery/vending/darth_vendor in the_turf)
			if(darth_vendor.tiltable)
				to_chat(living_guy, span_warning("A malevolent force tugs at the [darth_vendor]..."))
				INVOKE_ASYNC(darth_vendor, TYPE_PROC_REF(/obj/machinery/vending, tilt), living_guy)
				if(!permanent)
					qdel(src)
				return

/// If we get knocked down, see if we have a really bad slip and bash our head hard
/datum/component/omen/proc/check_slip(mob/living/our_guy, amount)
	SIGNAL_HANDLER

	if(amount <= 0 || prob(50)) // 50% chance to bonk our head
		return

	var/obj/item/bodypart/the_head = our_guy.get_bodypart(BODY_ZONE_HEAD)
	if(!the_head)
		return

	playsound(get_turf(our_guy), 'sound/effects/tableheadsmash.ogg', 90, TRUE)
	our_guy.visible_message(span_danger("[our_guy] hits [our_guy.p_their()] head really badly falling down!"), span_userdanger("You hit your head really badly falling down!"))
	the_head.receive_damage(75)
	our_guy.adjustOrganLoss(ORGAN_SLOT_BRAIN, 100)
	if(!permanent)
		qdel(src)

/// Hijack the mood system to see if we get the blessing mood event to cancel the omen
/datum/component/omen/proc/check_bless(mob/living/our_guy, category)
	SIGNAL_HANDLER

	if(permanent)
		return

	if (!("blessing" in our_guy.mob_mood.mood_events))
		return

	qdel(src)
<<<<<<< HEAD
=======

/// Severe deaths. Normally lifts the curse.
/datum/component/omen/proc/check_death(mob/living/our_guy)
	SIGNAL_HANDLER

	qdel(src)

/// Creates a localized explosion that shakes the camera
/datum/component/omen/proc/death_explode(mob/living/our_guy)
	explosion(our_guy, explosion_cause = src)

	for(var/mob/witness in view(2, our_guy))
		shake_camera(witness, 1 SECONDS, 2)

/**
 * The smite omen. Permanent.
 */
/datum/component/omen/smite

/datum/component/omen/smite/Initialize(vessel, permanent)
	. = ..()
	src.permanent = permanent

/datum/component/omen/smite/check_bless(mob/living/our_guy, category)
	if(!permanent)
		return ..()

	return

/datum/component/omen/smite/check_death(mob/living/our_guy)
	if(!permanent)
		return ..()

	death_explode(our_guy)
	our_guy.gib()

/**
 * The quirk omen. Permanent.
 * Has only a 50% chance of bad things happening, and takes only 25% of normal damage.
 */
/datum/component/omen/quirk
	permanent = TRUE
	luck_mod = 0.5 // 50% chance of bad things happening
	damage_mod = 0.25 // 25% of normal damage

/datum/component/omen/quirk/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_accident))
	RegisterSignal(parent, COMSIG_ON_CARBON_SLIP, PROC_REF(check_slip))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(check_death))

/datum/component/omen/quirk/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ON_CARBON_SLIP, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_DEATH))

/datum/component/omen/quirk/check_death(mob/living/our_guy)
	if(!iscarbon(our_guy))
		our_guy.gib()
		return

	// Don't explode if buckled to a stasis bed
	if(our_guy.buckled)
		var/obj/machinery/stasis/stasis_bed = our_guy.buckled
		if(istype(stasis_bed))
			return

	death_explode(our_guy)
	var/mob/living/carbon/player = our_guy
	player.spread_bodyparts(skip_head = TRUE)
	player.spawn_gibs()

	return
>>>>>>> 2a6c6b5df20 (Fixes a bad `as anything` in cursed quirk (#72485))
