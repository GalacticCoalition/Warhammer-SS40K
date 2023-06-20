/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	icon_state = "cap"
	req_access = list(ACCESS_CAPTAIN)

/obj/structure/closet/secure_closet/captains/PopulateContents()
	..()

	new /obj/item/storage/backpack/captain(src)
	new /obj/item/storage/backpack/satchel/cap(src)
	new /obj/item/storage/backpack/duffelbag/captain(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/storage/bag/garment/captain(src)
	new /obj/item/computer_disk/command/captain(src)
	new /obj/item/storage/box/silver_ids(src)
	new /obj/item/radio/headset/heads/captain/alt(src)
	new /obj/item/radio/headset/heads/captain(src)
	new /obj/item/storage/belt/sabre(src)
	new /obj/item/storage/box/gunset/pdh(src) // SKYRAT EDIT CHANGE - ORIGINAL: new /obj/item/gun/energy/e_gun(src)
	new /obj/item/door_remote/captain(src)
	new /obj/item/storage/photo_album/captain(src)

/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	icon_state = "hop"
	req_access = list(ACCESS_HOP)
	storage_capacity = 40 //SKYRAT EDIT ADDITION

/obj/structure/closet/secure_closet/hop/PopulateContents()
	..()
	new /obj/item/dog_bone(src)
	new /obj/item/storage/bag/garment/hop(src)
	new /obj/item/storage/lockbox/medal/service(src)
	new /obj/item/computer_disk/command/hop(src)
	new /obj/item/radio/headset/heads/hop(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/gun/energy/e_gun(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/door_remote/civilian(src)
	new /obj/item/circuitboard/machine/techfab/department/service(src)
	new /obj/item/storage/photo_album/hop(src)
	new /obj/item/storage/lockbox/medal/hop(src)

/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	icon_state = "hos"
	req_access = list(ACCESS_HOS)

/obj/structure/closet/secure_closet/hos/PopulateContents()
	..()

	new /obj/item/computer_disk/command/hos(src)
	new /obj/item/radio/headset/heads/hos(src)
	new /obj/item/storage/bag/garment/hos(src)
	new /obj/item/storage/lockbox/medal/sec(src)
	new /obj/item/megaphone/sec(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/storage/lockbox/loyalty(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/shield/riot/tele(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/circuitboard/machine/techfab/department/security(src)
	new /obj/item/storage/photo_album/hos(src)

/obj/structure/closet/secure_closet/hos/populate_contents_immediate()
	. = ..()

	// Traitor steal objectives
	new /obj/item/gun/energy/e_gun/hos(src)
	new /obj/item/pinpointer/nuke(src)

/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	icon_state = "warden"
	req_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/warden/PopulateContents()
	..()
	new /obj/item/dog_bone(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/clothing/suit/armor/vest/warden(src)
	//new /obj/item/clothing/head/hats/warden(src) SKYRAT EDIT REMOVAL
	//new /obj/item/clothing/head/hats/warden/drill(src) SKYRAT EDIT REMOVAL
	new /obj/item/clothing/head/beret/sec/navywarden(src)
	//new /obj/item/clothing/suit/armor/vest/warden/alt(src) //SKYRAT EDIT REMOVAL
	new /obj/item/clothing/under/rank/security/warden/formal(src)
	new /obj/item/clothing/suit/jacket/warden/blue(src) //SKYRAT ADDITION - FORMAL COAT
	//new /obj/item/clothing/under/rank/security/warden/skirt(src) SKYRAT EDIT REMOVAL
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/clothing/mask/gas/sechailer(src)
	new /obj/item/storage/box/zipties(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/clothing/gloves/krav_maga/sec(src)
	new /obj/item/door_remote/head_of_security(src)


/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	icon_state = "sec"
	req_access = list(ACCESS_BRIG)

/obj/structure/closet/secure_closet/security/PopulateContents()
	..()
//	new /obj/item/clothing/suit/armor/vest(src) //SKYRAT EDIT REMOVAL
	new /obj/item/clothing/suit/armor/vest/alt/sec(src)
	new /obj/item/clothing/head/security_cap(src) //SKYRAT EDIT ADDITION
	new /obj/item/clothing/head/helmet/sec(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/radio/headset/headset_sec/alt(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/flashlight/seclite(src)

/obj/structure/closet/secure_closet/security/sec

/obj/structure/closet/secure_closet/security/sec/PopulateContents()
	..()
	new /obj/item/storage/belt/security/full(src)

// SKYRAT EDIT CHANGE -- GOOFSEC DEP GUARDS
/obj/structure/closet/secure_closet/security/cargo
	name = "\proper customs agent's locker"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_CARGO)
	icon_state = "qm"
	icon = 'icons/obj/storage/closet.dmi'

/obj/structure/closet/secure_closet/security/cargo/PopulateContents()
	new /obj/item/storage/bag/garment/customs_agent(src)
	new /obj/item/restraints/handcuffs/cable/orange(src)
	new /obj/item/assembly/flash/handheld(src)

/obj/structure/closet/secure_closet/security/engine
	name = "\proper engineering guard's locker"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_ENGINEERING)
	icon_state = "eng_secure"
	icon = 'icons/obj/storage/closet.dmi'

/obj/structure/closet/secure_closet/security/engine/PopulateContents()
	new /obj/item/restraints/handcuffs/cable/yellow(src)
	new /obj/item/storage/bag/garment/engineering_guard(src)
	new /obj/item/assembly/flash/handheld(src)

/obj/structure/closet/secure_closet/security/science
	name = "\proper science guard's locker"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_RESEARCH)
	icon_state = "science"
	icon = 'icons/obj/storage/closet.dmi'

/obj/structure/closet/secure_closet/security/science/PopulateContents()
	new /obj/item/restraints/handcuffs/cable/pink(src)
	new /obj/item/storage/bag/garment/science_guard(src)
	new /obj/item/assembly/flash/handheld(src)

/obj/structure/closet/secure_closet/security/med
	name = "\proper orderly's locker"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_MEDICAL)
	icon_state = "med_secure"
	icon = 'icons/obj/storage/closet.dmi'

/obj/structure/closet/secure_closet/security/med/PopulateContents()
	new /obj/item/restraints/handcuffs/cable/blue(src)
	new /obj/item/storage/bag/garment/orderly(src)
	new /obj/item/assembly/flash/handheld(src)
// SKYRAT EDIT CHANGE END -- GOOFSEC DEP GUARDS

/obj/structure/closet/secure_closet/detective
	name = "\improper detective's cabinet"
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	door_anim_time = 0 // no animation
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	req_access = list(ACCESS_DETECTIVE)

/obj/structure/closet/secure_closet/detective/PopulateContents()
	..()
	new /obj/item/storage/box/evidence(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/detective_scanner(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/clothing/suit/armor/vest/det_suit(src)
	new /obj/item/storage/belt/holster/detective/full(src)
	new /obj/item/pinpointer/crew(src)
	new /obj/item/binoculars(src)
	new /obj/item/storage/box/rxglasses/spyglasskit(src)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections"
	req_access = list(ACCESS_HOS)

/obj/structure/closet/secure_closet/injection/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/syringe/lethal/execution(src)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	anchored = TRUE
	req_one_access = list(ACCESS_BRIG)
	var/id = null

/obj/structure/closet/secure_closet/brig/genpop
	name = "genpop storage locker"
	desc = "Used for storing the belongings of genpop's tourists visiting the locals."
	access_choices = FALSE
	paint_jobs = null

/obj/structure/closet/secure_closet/brig/genpop/examine(mob/user)
	. = ..()
	. += span_notice("<b>Right-click</b> with a Security-level ID to reset [src]'s registered ID.")

/obj/structure/closet/secure_closet/brig/genpop/attackby(obj/item/card/id/advanced/prisoner/user_id, mob/user, params)
	if(!secure || !istype(user_id))
		return ..()

	if(isnull(id_card))
		say("Prisoner ID linked to locker.")
		id_card = WEAKREF(user_id)
		name = "genpop storage locker - [user_id.registered_name]"

/obj/structure/closet/secure_closet/brig/genpop/proc/clear_access()
	say("Authorized ID detected. Unlocking locker and resetting ID.")
	locked = FALSE
	id_card = null
	name = initial(name)
	update_appearance()

/obj/structure/closet/secure_closet/brig/genpop/attackby_secondary(obj/item/card/id/advanced/used_id, mob/user, params)
	if(!secure || !istype(used_id))
		return ..()

	var/list/id_access = used_id.GetAccess()
	if(!isnull(id_card) && (ACCESS_BRIG in id_access))
		clear_access()

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/closet/secure_closet/evidence
	anchored = TRUE
	name = "secure evidence closet"
	req_one_access = list(ACCESS_ARMORY, ACCESS_DETECTIVE)

/obj/structure/closet/secure_closet/brig/PopulateContents()
	..()

	new /obj/item/clothing/under/rank/prisoner( src )
	new /obj/item/clothing/under/rank/prisoner/skirt( src )
	new /obj/item/clothing/shoes/sneakers/orange( src )

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(ACCESS_COURT)

/obj/structure/closet/secure_closet/courtroom/PopulateContents()
	..()
	new /obj/item/clothing/shoes/laceup(src)
	for(var/i in 1 to 3)
		new /obj/item/paper/fluff/jobs/security/court_judgement (src)
	new /obj/item/pen (src)
	new /obj/item/clothing/suit/costume/judgerobe (src)
	new /obj/item/clothing/head/costume/powdered_wig (src)
	new /obj/item/storage/briefcase(src)
	new /obj/item/clothing/under/suit/black_really(src)
	new /obj/item/clothing/neck/tie/red(src)

/obj/structure/closet/secure_closet/contraband/armory
	anchored = TRUE
	name = "Contraband Locker"
	req_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/contraband/heads
	name = "contraband locker"
	req_access = list(ACCESS_COMMAND)
	anchored = TRUE

/obj/structure/closet/secure_closet/armory1
	name = "armory armor locker"
	icon_state = "armory" // SKYRAT EDIT ADDITION - NEW ICON ADDED IN peacekeeper_lockers.dm
	req_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/armory1/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/riot(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/toggleable/riot(src)
	for(var/i in 1 to 3)
		new /obj/item/shield/riot(src)

/obj/structure/closet/secure_closet/armory1/populate_contents_immediate()
	. = ..()

	// Traitor steal objective
	new /obj/item/clothing/suit/hooded/ablative(src)

/obj/structure/closet/secure_closet/armory2
	name = "armory ballistics locker"
	icon_state = "armory" // SKYRAT EDIT ADDITION - NEW ICON ADDED IN peacekeeper_lockers.dm
	req_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/armory2/PopulateContents()
	..()
	new /obj/item/storage/box/firingpins(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/rubbershot(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/ballistic/shotgun/riot(src)

/obj/structure/closet/secure_closet/armory3
	name = "armory energy gun locker"
	icon_state = "armory" // SKYRAT EDIT ADDITION - NEW ICON ADDED IN peacekeeper_lockers.dm
	req_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/armory3/PopulateContents()
	..()
	new /obj/item/storage/box/firingpins(src)
	new /obj/item/gun/energy/ionrifle(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/e_gun(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser/thermal(src)

/obj/structure/closet/secure_closet/tac
	name = "armory tac locker"
	icon_state = "tac"
	req_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/tac/PopulateContents()
	..()
	new /obj/item/gun/ballistic/automatic/wt550(src)
	new /obj/item/clothing/head/helmet/alt(src)
	new /obj/item/clothing/mask/gas/sechailer(src)
	new /obj/item/clothing/suit/armor/bulletproof(src)

/obj/structure/closet/secure_closet/labor_camp_security
	name = "labor camp security locker"
	icon_state = "sec"
	req_access = list(ACCESS_SECURITY)

/obj/structure/closet/secure_closet/labor_camp_security/PopulateContents()
	..()
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/head/helmet/sec(src)
	new /obj/item/clothing/under/rank/security/officer(src)
	//new /obj/item/clothing/under/rank/security/officer/skirt(src) SKYRAT EDIT REMOVAL
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/flashlight/seclite(src)
