/datum/mod_theme/frontline
	name = "frontline"
	desc = "A Novaya Rossiyskaya Imperiya Defense Collegia protective suit, designed for fortified positions operation and humanitarian aid."
	extended_desc = "PLACEHOLDER WOOOOOOOOOOOOOOOOOOOOOOO"
	default_skin = "frontline"
	armor = list(MELEE = 30, BULLET = 40, LASER = 25, ENERGY = 20, BOMB = 30, BIO = 100, FIRE = 40, ACID = 75, WOUND = 15)
	complexity_max = DEFAULT_MAX_COMPLEXITY
	charge_drain = DEFAULT_CHARGE_DRAIN * 1.5
	skins = list(
		"frontline" = list(
			MOD_ICON_OVERRIDE = 'modular_skyrat/modules/novaya_ert/icons/mod.dmi',
			MOD_WORN_ICON_OVERRIDE = 'modular_skyrat/modules/novaya_ert/icons/wornmod.dmi',
			HELMET_FLAGS = list(
				UNSEALED_LAYER = NECK_LAYER,
				UNSEALED_CLOTHING = SNUG_FIT,
				SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY =  HIDEFACIALHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
				SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
			),
			CHESTPLATE_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY = HIDEJUMPSUIT|HIDETAIL,
			),
			GAUNTLETS_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
			),
			BOOTS_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
			),
		),
	)

/obj/item/mod/control/pre_equipped/frontline
	theme = /datum/mod_theme/frontline
	initial_modules = list(
		/obj/item/mod/module/storage,
		/obj/item/mod/module/flashlight)

/obj/item/mod/control/pre_equipped/frontline/pirate
	initial_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/thermal_regulator,
		/obj/item/mod/module/status_readout/generic,
		/obj/item/mod/module/visor/night,
		/obj/item/mod/module/emp_shield,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/tether,
		/obj/item/mod/module/magboot
	)

/obj/item/mod/control/pre_equipped/frontline/ert
	applied_cell = /obj/item/stock_parts/cell/hyper
	initial_modules = list(
		/obj/item/mod/module/storage/syndicate,
		/obj/item/mod/module/thermal_regulator,
		/obj/item/mod/module/status_readout/generic,
		/obj/item/mod/module/auto_doc,
		/obj/item/mod/module/visor/thermal,
		/obj/item/mod/module/emp_shield,
		/obj/item/mod/module/jetpack/advanced,
		/obj/item/mod/module/magboot/advanced
	)

///Unrelated-to-Spider-Clan version of the module.
/obj/item/mod/module/status_readout/generic
	name = "MOD status readout module"
	desc = "A once-common module, this technology went unfortunately out of fashion; \
		but still remaining in older suit variations. This hooks into the suit's spine, \
		capable of capturing and displaying all possible biometric data of the wearer; sleep, nutrition, fitness, fingerprints, \
		and even useful information such as their overall health and wellness."

///Blatant copy of the adrenaline boost module.
/obj/item/mod/module/auto_doc
	name = "MOD automatic paramedical module"
	desc = "The reverse-engineered and redesigned medical assistance system, previously used by the now decommissioned VOSKHOD combat armor. \
		The technology it uses is very similar to the one of Spider Clan, yet Innovations and Defense Collegium reject any similarities. \
		Using a built-in storage of chemical compounds and miniature surgical robots capable of pinpoint damage treatment,\
		it's capable of injecting its user with simple painkillers and coagulants, assisting them with their restoration, as long as they don't overdose themselves. \
		However, this system heavily relies on some rarely combat-available chemical compounds to prepare its injections, mainly Cryptobiolin, which appear in the user's bloodstream from time to time, \
		and its trivial damage assesment systems are inadequate for complete restoration purposes."
	icon_state = "adrenaline_boost"
	module_type = MODULE_TOGGLE
	incompatible_modules = list(/obj/item/mod/module/adrenaline_boost, /obj/item/mod/module/auto_doc)
	cooldown_time = null
	complexity = 4
	use_power_cost = DEFAULT_CHARGE_DRAIN*20
	/// What reagent we need to refill?
	var/reagent_required = /datum/reagent/cryptobiolin
	/// How much of a reagent we need to refill a single boost.
	var/reagent_required_amount = 20
	/// Maximum amount of reagents this module can hold.
	var/reagent_max_amount = 120
	/// Health threshold above which the module won't heal.
	var/health_threshold = 80
	/// Amount of raw damage heal per treatment.
	var/heal_amount = 10
	/// Amount of raw stamdamage heal per treatment.
	var/stamina_heal_amount = 50
	/// Cooldown betwen each treatment.
	var/heal_cooldown = 30 SECONDS

	/// Timer for the cooldown
	COOLDOWN_DECLARE(heal_timer)

/obj/item/mod/module/auto_doc/Initialize(mapload)
	. = ..()
	create_reagents(reagent_max_amount)
	reagents.add_reagent(reagent_required, reagent_max_amount)

/obj/item/mod/module/auto_doc/on_activation()
	. = ..()
	if(!.)
		return
	RegisterSignal(mod.wearer, COMSIG_CARBON_HEALTH_UPDATE, .proc/on_use)
	drain_power(use_power_cost)

/obj/item/mod/module/auto_doc/on_use()
	if(!COOLDOWN_FINISHED(src, heal_timer))
		return FALSE
	if(!check_power(use_power_cost))
		balloon_alert(mod.wearer, "not enough charge!")
		SEND_SIGNAL(src, COMSIG_MODULE_DEACTIVATED)
		return FALSE
	if(!allowed_in_phaseout && istype(mod.wearer.loc, /obj/effect/dummy/phased_mob))
		to_chat(mod.wearer, span_warning("You cannot activate this right now."))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_MODULE_TRIGGERED) & MOD_ABORT_USE)
		return FALSE
	if(!reagents.has_reagent(reagent_required, reagent_required_amount))
		balloon_alert(mod.wearer, "not enough chems!")
		SEND_SIGNAL(src, COMSIG_MODULE_DEACTIVATED)
		return FALSE
	if(mod.wearer.health > health_threshold)
		return
	var/new_bruteloss = mod.wearer.getBruteLoss()
	var/new_fireloss = mod.wearer.getFireLoss()
	var/new_toxloss = mod.wearer.getToxLoss()
	var/new_stamloss = mod.wearer.getStaminaLoss()
	playsound(mod.wearer, 'modular_skyrat/modules/hev_suit/sound/hev/hiss.ogg', 100)
	if(new_bruteloss)
		mod.wearer.adjustBruteLoss(-heal_amount)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/mine_salve, 10)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/sal_acid, 5)
		to_chat(mod.wearer, span_warning("Brute treatment administered. Overdose risks present on further use, consult your first-aid analyzer."))
	if(new_fireloss)
		mod.wearer.adjustFireLoss(-heal_amount)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/mine_salve, 10)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/oxandrolone, 5)
		to_chat(mod.wearer, span_warning("Burn treatment administered. Overdose risks present on further use, consult your first-aid analyzer."))
	if(new_toxloss)
		mod.wearer.adjustToxLoss(-heal_amount)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/mine_salve, 10)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/pen_acid, 5)
		to_chat(mod.wearer, span_warning("Toxin treatment administered. Overdose risks present on further use, consult your first-aid analyzer."))
	if(new_stamloss)
		mod.wearer.adjustStaminaLoss(-stamina_heal_amount)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/mine_salve, 10)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/stimulants, 10)
		to_chat(mod.wearer, span_warning("Combat stimulants administered. Overdose risks present on further use, consult your first-aid analyzer."))
	mod.wearer.reagents.add_reagent(/datum/reagent/medicine/coagulant, 5)
	reagents.remove_reagent(reagent_required, reagent_required_amount)
	drain_power(use_power_cost*10)
	addtimer(CALLBACK(src, .proc/boost_aftereffects, mod.wearer), 45 SECONDS)
	COOLDOWN_START(src, heal_timer, heal_cooldown)

/obj/item/mod/module/auto_doc/proc/charge_boost(obj/item/attacking_item, mob/user)
	if(!attacking_item.is_open_container())
		return FALSE
	if(reagents.has_reagent(reagent_required, reagent_max_amount))
		balloon_alert(mod.wearer, "already full!")
		return FALSE
	if(!attacking_item.reagents.trans_id_to(src, reagent_required, reagent_required_amount))
		return FALSE
	balloon_alert(mod.wearer, "charge reloaded")
	return TRUE

/obj/item/mod/module/auto_doc/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	UnregisterSignal(mod.wearer, COMSIG_CARBON_HEALTH_UPDATE)

/obj/item/mod/module/auto_doc/on_install()
	RegisterSignal(mod, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)

/obj/item/mod/module/auto_doc/on_uninstall(deleting)
	UnregisterSignal(mod, COMSIG_PARENT_ATTACKBY)

/obj/item/mod/module/auto_doc/attackby(obj/item/attacking_item, mob/user, params)
	if(charge_boost(attacking_item, user))
		return TRUE
	return ..()

/obj/item/mod/module/auto_doc/proc/on_attackby(datum/source, obj/item/attacking_item, mob/user)
	SIGNAL_HANDLER

	if(charge_boost(attacking_item, user))
		return COMPONENT_NO_AFTERATTACK
	return NONE

/obj/item/mod/module/auto_doc/proc/boost_aftereffects(mob/affected_mob)
	if(!affected_mob)
		return
	mod.wearer.reagents.add_reagent(/datum/reagent/cryptobiolin, 10)
	mod.wearer.reagents.add_reagent(/datum/reagent/drug/maint/sludge, 5)
	to_chat(affected_mob, span_danger("Your head starts slightly spinning, and your chest hurts."))

/// Not exactly a MODsuit thing but it's needed for the refills huh?
/obj/item/reagent_containers/cup/glass/waterbottle/large/cryptobiolin
	name = "bottle of cryptobiolin"
	desc = "Nothing screams budget cuts like bottled suit fluid."
	list_reagents = list(/datum/reagent/cryptobiolin = 100)
