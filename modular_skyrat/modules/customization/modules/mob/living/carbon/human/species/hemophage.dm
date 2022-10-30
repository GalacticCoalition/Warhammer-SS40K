/// Maximum an Hemophage will drain, they will drain less if they hit their cap.
#define HEMOPHAGE_DRAIN_AMOUNT 50
/// How much blood do Hemophages normally lose per second (visible effect is every two seconds, so twice this value).
#define NORMAL_BLOOD_DRAIN 0.125
/// Minimum amount of blood that you can reach via blood regeneration, regeneration will stop below this.
#define MINIMUM_VOLUME_FOR_REGEN BLOOD_VOLUME_BAD + 1 // We do this to avoid any jankiness, and because we want to ensure that they don't fall into a state where they're constantly passing out in a locker.
/// Minimum amount of light for Hemophages to be considered in pure darkness, and therefore be allowed to heal just like in a closet.
#define MINIMUM_LIGHT_THRESHOLD_FOR_REGEN 0

/// How much brute damage their body regenerates per second (calculated every two seconds) while under the proper conditions.
#define BLOOD_REGEN_BRUTE_AMOUNT 1.5
/// How much burn damage their body regenerates per second (calculated every two seconds) while under the proper conditions.
#define BLOOD_REGEN_BURN_AMOUNT 1.5
/// How much toxin damage their body regenerates per second (calculated every two seconds) while under the proper conditions.
#define BLOOD_REGEN_TOXIN_AMOUNT 1
/// How much cellular damage their body regenerates per second (calculated every two seconds) while under the proper conditions.
#define BLOOD_REGEN_CELLULAR_AMOUNT 0.5


/datum/species/hemophage
	name = "Hemophage"
	id = SPECIES_HEMOPHAGE
	species_traits = list(
		EYECOLOR,
		HAIR,
		FACEHAIR,
		LIPS,
		DRINKSBLOOD,
		HAS_FLESH,
		HAS_BONE,
	)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_VIRUSIMMUNE,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_LITERATE,
	)
	inherent_biotypes = MOB_HUMANOID
	mutant_bodyparts = list("wings" = "None")
	exotic_bloodtype = "U"
	use_skintones = TRUE
	mutantheart = /obj/item/organ/internal/heart/hemophage
	mutanttongue = /obj/item/organ/internal/tongue/hemophage
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	examine_limb_id = SPECIES_HUMAN
	skinned_type = /obj/item/stack/sheet/animalhide/human
	/// Some starter text sent to the hemophage initially, because hemophages have shit to do to stay alive.
	var/info_text = "You are a <span class='danger'>Hemophage</span>. You will slowly but constantly lose blood if outside of a closet-like object. If inside a closet-like object, you will slowly heal. You may gain more blood by grabbing a live victim and using your drain ability."
	/// The shapeshifting action, attached to the datum itself to avoid cloning memes, and other duplicates.
	var/obj/effect/proc_holder/spell/targeted/shapeshift/bat/batform
	/// Is it currently Halloween and are we the Halloween version? If not, we do not get a batform nor do we burn in the chapel.
	var/halloween_version = FALSE
	/// Current multiplier for how fast their blood drains on spec_life(). Higher values mean it goes down faster.
	var/bloodloss_speed_multiplier = 1
	/// Current multiplier for how much blood they spend healing themselves for every point of damage healed.
	var/blood_to_health_multiplier = 1
	veteran_only = TRUE


/datum/species/hemophage/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE

	return ..()


/datum/species/hemophage/on_species_gain(mob/living/carbon/human/new_hemophage, datum/species/old_species)
	. = ..()
	to_chat(new_hemophage, info_text)
	new_hemophage.update_body()
	new_hemophage.set_safe_hunger_level()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		halloween_version = TRUE


/datum/species/hemophage/spec_life(mob/living/carbon/human/hemophage, delta_time, times_fired)
	. = ..()
	if(hemophage.stat == DEAD)
		return

	if(hemophage.health < hemophage.maxHealth && hemophage.blood_volume > MINIMUM_VOLUME_FOR_REGEN && (in_closet(hemophage) || in_total_darkness(hemophage)))
		var/max_blood_for_regen = hemophage.blood_volume - MINIMUM_VOLUME_FOR_REGEN
		var/blood_used = NONE

		var/brutes_to_heal = NONE
		var/brute_damage = hemophage.getBruteLoss()
		if(brute_damage)
			brutes_to_heal = min(max_blood_for_regen, min(BLOOD_REGEN_BRUTE_AMOUNT, brute_damage) * delta_time)
			blood_used += brutes_to_heal * blood_to_health_multiplier
			max_blood_for_regen -= brutes_to_heal * blood_to_health_multiplier

		var/burns_to_heal = NONE
		var/burn_damage = hemophage.getFireLoss()
		if(burn_damage && max_blood_for_regen > NONE)
			burns_to_heal = min(max_blood_for_regen, min(BLOOD_REGEN_BURN_AMOUNT, burn_damage) * delta_time)
			blood_used += burns_to_heal * blood_to_health_multiplier
			max_blood_for_regen -= burns_to_heal * blood_to_health_multiplier

		if(brutes_to_heal || burns_to_heal)
			hemophage.heal_overall_damage(brutes_to_heal, burns_to_heal, NONE, BODYTYPE_ORGANIC)

		var/toxin_damage = hemophage.getToxLoss()
		if(toxin_damage && max_blood_for_regen > NONE)
			var/toxins_to_heal = min(max_blood_for_regen, min(BLOOD_REGEN_TOXIN_AMOUNT, toxin_damage) * delta_time)
			blood_used += toxins_to_heal * blood_to_health_multiplier
			max_blood_for_regen -= toxins_to_heal * blood_to_health_multiplier
			hemophage.adjustToxLoss(-toxins_to_heal)

		var/cellular_damage = hemophage.getCloneLoss()
		if(cellular_damage && max_blood_for_regen > NONE)
			var/cells_to_heal = min(max_blood_for_regen, min(BLOOD_REGEN_TOXIN_AMOUNT, cellular_damage) * delta_time)
			blood_used += cells_to_heal * blood_to_health_multiplier
			max_blood_for_regen -= cells_to_heal * blood_to_health_multiplier
			hemophage.adjustCloneLoss(-cells_to_heal)

		if(blood_used)
			hemophage.blood_volume = max(hemophage.blood_volume - blood_used, MINIMUM_VOLUME_FOR_REGEN) // Just to clamp the value, to ensure we don't get anything weird.
			hemophage.apply_status_effect(/datum/status_effect/blood_regen_active)

	else
		hemophage.remove_status_effect(/datum/status_effect/blood_regen_active)

	if(in_closet(hemophage)) // No regular bloodloss if you're in a closet
		return

	hemophage.blood_volume -= NORMAL_BLOOD_DRAIN * delta_time * bloodloss_speed_multiplier

	if(hemophage.blood_volume <= BLOOD_VOLUME_SURVIVE)
		to_chat(hemophage, span_danger("You ran out of blood!"))
		hemophage.death() // Owch! Ran out of blood.

	if(halloween_version)// If hemophages have bat form, they cannot enter the church
		if(istype(get_area(hemophage), /area/station/service/chapel))
			to_chat(hemophage, span_warning("You don't belong here!"))
			hemophage.adjustFireLoss(10 * delta_time)
			hemophage.adjust_fire_stacks(3 * delta_time)
			hemophage.ignite_mob()


/// Simple helper proc that returns whether or not the given hemophage is in a closet subtype (but not in any bodybag subtype).
/datum/species/hemophage/proc/in_closet(mob/living/carbon/human/hemophage)
	return istype(hemophage.loc, /obj/structure/closet) && !istype(hemophage.loc, /obj/structure/closet/body_bag)


/// Simple helper proc that returns whether or not the given hemophage is in total darkness.
/datum/species/hemophage/proc/in_total_darkness(mob/living/carbon/human/hemophage)
	var/turf/current_turf = get_turf(hemophage)
	if(!istype(current_turf))
		return FALSE

	return current_turf.get_lumcount() <= MINIMUM_LIGHT_THRESHOLD_FOR_REGEN


/datum/species/hemophage/get_species_description()
	return "Oftentimes feared for the different bits of folklore surrounding their condition, \
		Hemophages are typically mixed amongst the crew, hiding away their blood-deficiency and \
		the benefits that come from it from most, to enjoy a nearly-normal existence on the Frontier."


/datum/species/hemophage/get_species_lore()
	return list(
		"Though known by many other names, 'Hemophages' are those that have found themselves the host of a bloodthirsty infection. Initially entering their hosts through the bloodstream, or activating after a period of dormancy in infants, this infection initially travels to the chest first. Afterwards, it infects several cells, making countless alterations to their genetic sequence, until it starts rapidly expanding and taking over every nearby organ, notably the heart, lungs, and stomach, forming a massive tumor vaguely reminiscent of an overgrown, coal-black heart, that hijacks them for its own benefit, and in exchange, allows the host to 'sense' the quality, and amount of blood currently occupying their body.",
		"While this kills the host initially, the tumor will jumpstart the body and begin functioning as a surrogate to keep their host going. This does confer certain advantages to the host, in the interest of keeping them alive; working anaerobically, requiring no food to function, and extending their lifespan dramatically. However, this comes at a cost, as the tumor changes their host into an obligate hemophage; only the enzymes, and iron in blood being able to fuel them. If they are to run out of blood, the tumor will begin consuming its own host.",
		"Historically, Hemophages have caused great societal strife through their very existence. Many have reported dread on having someone reveal they require blood to survive, worse on learning they have been undead, espiecally in 'superstitious' communities. In many places they occupy a sort of second class, unable to live normal lives due to their condition being a sort of skeleton in their closet. Some can actually be found in slaughterhouses or the agricultural industry, gaining easy access to a large supply of animal blood to feed their eternal thirst.",
		"Others find their way into mostly-vampiric communities, turning others into their own kind; though, the virus can only transmit to hosts that are incredibly low on blood, taking advantage of their reduced immune system efficiency and higher rate of blood creation to be able to survive the initial few days within their host.",
		"\"What the fuck does any of this mean?\" - Doctor Micheals, reading their CentCom report about the new 'hires'.",
	)


/datum/species/hemophage/prepare_human_for_preview(mob/living/carbon/human/human)
	human.skin_tone = "albino"
	human.hair_color = "#1d1d1d"
	human.hairstyle = "Pompadour (Big)"
	human.update_mutant_bodyparts(TRUE)
	human.update_body(TRUE)


/datum/species/hemophage/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bed",
			SPECIES_PERK_NAME = "Locker Brooding",
			SPECIES_PERK_DESC = "Hemophages can delay their Thirst and mend their injuries by \
	   							resting in a sturdy rectangular-shaped object. So THAT'S why they do that!",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "skull",
			SPECIES_PERK_NAME = "Viral Symbiosis",
			SPECIES_PERK_DESC = "Hemophages, due to their condition, cannot get infected by \
								other viruses and don't actually require an external source of oxygen \
								to stay alive.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "recycle",
			SPECIES_PERK_NAME = "Bat Form",
			SPECIES_PERK_DESC = "During Halloween, Hemophages can become bats. Bats are very weak, but \
								are great for escaping bad situations. They can also travel through \
								vents, giving Hemophages a lot of access. Just remember that access \
								doesn't equal permission, and people may be unhappy with you showing \
								up uninvited!",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "tint",
			SPECIES_PERK_NAME = "The Thirst",
			SPECIES_PERK_DESC = "In place of eating, Hemophages suffer from the Thirst, caused by their tumor. \
								Thirst of what? Blood! Their tongue allows them to grab people and drink \
								their blood, and they will suffer severe consequences if they run out. As a note, \
								it doesn't matter whose blood you drink, it will all be converted into your blood \
								type when consumed.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "cross",
			SPECIES_PERK_NAME = "Against God and Nature",
			SPECIES_PERK_DESC = "During Halloween, almost all higher powers are disgusted by the existence of \
								Hemophages, and entering the chapel is essentially suicide. Do not do it!",
		),
	)

	return to_add


/datum/species/hemophage/create_pref_blood_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "tint",
		SPECIES_PERK_NAME = "Universal Blood",
		SPECIES_PERK_DESC = "[plural_form] have blood that appears to be an amalgamation of all other \
							blood types, made possible thanks to some special antigens produced by \
							their tumor, making them able to receive blood of any other type, so \
							long as it is still human-like blood.",
		),
	)

	return to_add


// We don't need to mention that they're undead, as the perks that come from it are otherwise already explicited, and they might no longer be actually undead from a gameplay perspective, eventually.
/datum/species/hemophage/create_pref_biotypes_perks()
	return


/obj/item/organ/internal/tongue/hemophage
	name = "hemophage tongue"
	color = "#333333"
	actions_types = list(/datum/action/item_action/organ_action/hemophage)
	COOLDOWN_DECLARE(drain_cooldown)


/datum/action/item_action/organ_action/hemophage
	name = "Drain Victim"
	desc = "Leech blood from any carbon victim you are passively grabbing."


/datum/action/item_action/organ_action/hemophage/Trigger(trigger_flags)
	. = ..()
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/hemophage = owner
	var/obj/item/organ/internal/tongue/hemophage/tongue = target

	if(!COOLDOWN_FINISHED(tongue, drain_cooldown))
		hemophage.balloon_alert(hemophage, "just drained blood, wait a few seconds!")
		return

	if(!hemophage.pulling || !iscarbon(hemophage.pulling) || isalien(hemophage.pulling))
		hemophage.balloon_alert(hemophage, "not pulling any valid target!")
		return

	var/mob/living/carbon/victim = hemophage.pulling
	if(hemophage.blood_volume >= BLOOD_VOLUME_MAXIMUM)
		hemophage.balloon_alert(hemophage, "already full!")
		return

	if(victim.stat == DEAD)
		hemophage.balloon_alert(hemophage, "needs a living victim!")
		return

	if(!victim.blood_volume || (victim.dna && ((NOBLOOD in victim.dna.species.species_traits) || victim.dna.species.exotic_blood)))
		hemophage.balloon_alert(hemophage, "[victim] doesn't have blood!")
		return


	var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - hemophage.blood_volume //How much capacity we have left to absorb blood
	// We start by checking that the victim is a human and they have a client, so we can give them the
	// beneficial status effect for drinking higher-quality blood.
	var/is_target_human_with_client = istype(victim, /mob/living/carbon/human) && victim.client

	if(ismonkey(victim))
		if(hemophage.blood_volume >= BLOOD_VOLUME_NORMAL)
			hemophage.balloon_alert(hemophage, "their inferior blood cannot sate you any further!")
			return

		is_target_human_with_client = FALSE // Sorry, not going to get the status effect from monkeys, even if they have a client in them.

		blood_volume_difference = BLOOD_VOLUME_NORMAL - hemophage.blood_volume


	COOLDOWN_START(tongue, drain_cooldown, 3 SECONDS)
	if(victim.can_block_magic(MAGIC_RESISTANCE_HOLY, charge_cost = 0))
		victim.show_message(span_warning("[hemophage] tries to bite you, but stops before touching you!"))
		to_chat(hemophage, span_warning("[victim] is blessed! You stop just in time to avoid catching fire."))
		return

	if(victim.has_reagent(/datum/reagent/consumable/garlic))
		victim.show_message(span_warning("[hemophage] tries to bite you, but recoils in disgust!"))
		to_chat(hemophage, span_warning("[victim] reeks of garlic! You can't bring yourself to drain such tainted blood."))
		return

	if(!do_after(hemophage, 3 SECONDS, target = victim))
		hemophage.balloon_alert(hemophage, "stopped feeding")
		return

	var/drained_blood = min(victim.blood_volume, HEMOPHAGE_DRAIN_AMOUNT, blood_volume_difference)

	victim.blood_volume = clamp(victim.blood_volume - drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
	hemophage.blood_volume = clamp(hemophage.blood_volume + drained_blood, 0, BLOOD_VOLUME_MAXIMUM)

	log_combat(hemophage, victim, "drained [drained_blood]u of blood from", addition = " (NEW BLOOD VOLUME: [victim.blood_volume] cL)")
	victim.show_message(span_danger("[hemophage] drains some of your blood!"))
	to_chat(hemophage, span_notice("You drink some blood from [victim]![is_target_human_with_client ? " That tasted particularly good!" : ""]"))

	playsound(hemophage, 'sound/items/drink.ogg', 30, TRUE, -2)

	if(victim.blood_volume <= BLOOD_VOLUME_OKAY)
		to_chat(hemophage, span_warning("That definitely left them looking pale..."))

	if(is_target_human_with_client)
		hemophage.apply_status_effect(/datum/status_effect/blood_thirst_satiated)

	if(!victim.blood_volume || victim.blood_volume < BLOOD_VOLUME_SURVIVE)
		to_chat(hemophage, span_warning("You finish off [victim]'s blood supply."))


/obj/item/organ/internal/heart/hemophage
	name = "pulsating tumor"
	desc = "Just looking at how it pulsates at the beat of the heart it's wrapped around sends shivers down your spine... <i>The fact it's what keeps them alive makes it all the more terrifying.</i>"
	color = "#1C1C1C"


// We need to override it here because we changed their vampire heart with an Hemophage heart
/mob/living/carbon/get_status_tab_items()
	. = ..()
	var/obj/item/organ/internal/heart/hemophage/tumor_heart = getorgan(/obj/item/organ/internal/heart/hemophage)
	if(tumor_heart)
		. += "Current blood level: [blood_volume]/[BLOOD_VOLUME_MAXIMUM]"

	return .


/datum/status_effect/blood_thirst_satiated
	id = "blood_thirst_satiated"
	duration = 20 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/blood_thirst_satiated
	/// What will the bloodloss_speed_multiplier of the Hemophage be changed by upon receiving this status effect?
	var/bloodloss_speed_multiplier = 0.5


/datum/status_effect/blood_thirst_satiated/on_apply()
	// This status effect should not exist on its own, or on a non-human.
	if(!owner || !ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/human_owner = owner

	// This only ever applies to Hemophages, shoo if you're not an Hemophage!
	if(!ishemophage(human_owner))
		return FALSE

	var/datum/species/hemophage/owner_species = human_owner.dna.species
	owner_species.bloodloss_speed_multiplier *= bloodloss_speed_multiplier

	return TRUE


/datum/status_effect/blood_thirst_satiated/on_remove()
	// This status effect should not exist on its own, or on a non-human.
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner

	// This only ever applies to Hemophages, shoo if you're not an Hemophage!
	if(!ishemophage(human_owner))
		return

	var/datum/species/hemophage/owner_species = human_owner.dna.species
	owner_species.bloodloss_speed_multiplier /= bloodloss_speed_multiplier


/datum/status_effect/blood_regen_active
	id = "blood_regen_active"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/blood_regen_active


/datum/status_effect/blood_regen_active/on_apply()
	// This status effect should not exist on its own, or on a non-human.
	if(!owner || !ishuman(owner))
		return FALSE

	to_chat(owner, span_notice("You feel your skin tingle, as your body's natural regeneration rate drastically increases, thanks to the darkness that enrobes it."))

	return TRUE


/datum/status_effect/blood_regen_active/on_creation(mob/living/new_owner, ...)
	. = ..()
	if(!.)
		return

	if(!linked_alert)
		return

	var/obj/item/organ/internal/heart/hemophage/tumor_heart = owner.getorgan(/obj/item/organ/internal/heart/hemophage)
	if(tumor_heart)
		var/old_layer = tumor_heart.layer
		var/old_plane = tumor_heart.plane
		// reset the x & y offset so that item is aligned center
		tumor_heart.pixel_x = 0
		tumor_heart.pixel_y = 0
		tumor_heart.layer = FLOAT_LAYER //AAAH
		tumor_heart.plane = FLOAT_PLANE //^ what that guy said
		linked_alert.cut_overlays()
		linked_alert.add_overlay(tumor_heart)
		tumor_heart.layer = old_layer
		tumor_heart.plane = old_plane

	return .


/datum/status_effect/blood_regen_active/on_remove()
	// This status effect should not exist on its own.
	if(!owner)
		return

	to_chat(owner, span_notice("The tingling sensation on your skin fades away."))


/atom/movable/screen/alert/status_effect/blood_thirst_satiated
	name = "Thirst Satiated"
	desc = "Substitutes and taste-thin imitations keep your pale body standing, but nothing abates eternal thirst and slakes the infection quite like the real thing: Hot blood from a real sentient being."
	icon = 'icons/effects/bleed.dmi'
	icon_state = "bleed10"


/atom/movable/screen/alert/status_effect/blood_regen_active
	name = "Enhanced Regeneration"
	desc = "Being in a sufficiently dark location allows your tumor to allocate more energy to enhancing your body's natural regeneration, at the cost of blood volume proportional to the damage healed."
	icon = 'icons/hud/screen_alert.dmi'
	icon_state = "template"


#undef HEMOPHAGE_DRAIN_AMOUNT
