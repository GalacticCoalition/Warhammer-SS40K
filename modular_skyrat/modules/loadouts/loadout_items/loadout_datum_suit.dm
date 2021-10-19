// --- Loadout item datums for exosuits / suits ---

/// Exosuit / Outersuit Slot Items (Moves items to backpack)
GLOBAL_LIST_INIT(loadout_exosuits, generate_loadout_items(/datum/loadout_item/suit))

/datum/loadout_item/suit
	category = LOADOUT_ITEM_SUIT

/datum/loadout_item/suit/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.suit)
			LAZYADD(outfit.backpack_contents, outfit.suit)
		outfit.suit = item_path
	else
		outfit.suit = item_path

/datum/loadout_item/suit/winter_coat
	name = "Winter Coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat

/datum/loadout_item/suit/winter_coat_greyscale
	name = "Greyscale Winter Coat"
	can_be_greyscale = TRUE
	item_path = /obj/item/clothing/suit/hooded/wintercoat/custom

/datum/loadout_item/suit/denim_overalls
	name = "Denim Overalls"
	item_path = /obj/item/clothing/suit/apron/overalls

/datum/loadout_item/suit/black_suit_jacket
	name = "Black Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/black

/datum/loadout_item/suit/blue_suit_jacket
	name = "Blue Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer

/datum/loadout_item/suit/purple_suit_jacket
	name = "Purple Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/purple

/datum/loadout_item/suit/white_suit_jacket
	name = "White Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/white

/datum/loadout_item/suit/suitblackbetter
	name = "Light Black Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/black/better

/datum/loadout_item/suit/suitwhite
	name = "Texan Suit Jacket"
	item_path = /obj/item/clothing/suit/texas

/datum/loadout_item/suit/purple_apron
	name = "Purple Apron"
	item_path = /obj/item/clothing/suit/apron/purple_bartender

/datum/loadout_item/suit/Suspenders_blue
	name = "Blue Suspenders"
	item_path = /obj/item/clothing/suit/toggle/suspenders/blue

/datum/loadout_item/suit/suspenders_grey
	name = "Grey Suspenders"
	item_path = /obj/item/clothing/suit/toggle/suspenders/gray

/datum/loadout_item/suit/suspenders_red
	name = "Red Suspenders"
	item_path = /obj/item/clothing/suit/toggle/suspenders

/datum/loadout_item/suit/white_dress
	name = "White Dress"
	item_path = /obj/item/clothing/suit/whitedress

/datum/loadout_item/suit/labcoat
	name = "Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat

/datum/loadout_item/suit/labcoat_green
	name = "Green Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/mad

/datum/loadout_item/suit/bomber_jacket
	name = "Bomber Jacket"
	item_path = /obj/item/clothing/suit/jacket

/datum/loadout_item/suit/military_jacket
	name = "Military Jacket"
	item_path = /obj/item/clothing/suit/jacket/miljacket

/datum/loadout_item/suit/puffer_jacket
	name = "Puffer Jacket"
	item_path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_item/suit/puffer_vest
	name = "Puffer Vest"
	item_path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/loadout_item/suit/leather_jacket
	name = "Leather Jacket"
	item_path = /obj/item/clothing/suit/jacket/leather

/datum/loadout_item/suit/leather_coat
	name = "Leather Coat"
	item_path = /obj/item/clothing/suit/jacket/leather/overcoat

/datum/loadout_item/suit/brown_letterman
	name = "Brown Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman

/datum/loadout_item/suit/red_letterman
	name = "Red Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman_red

/datum/loadout_item/suit/blue_letterman
	name = "Blue Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman_nanotrasen

/datum/loadout_item/suit/bee
	name = "Bee Outfit"
	item_path = /obj/item/clothing/suit/hooded/bee_costume

/datum/loadout_item/suit/plague_doctor
	name = "Plague Doctor Suit"
	item_path = /obj/item/clothing/suit/bio_suit/plaguedoctorsuit

/datum/loadout_item/suit/snowman
	name = "Snowman Outfit"
	item_path = /obj/item/clothing/suit/snowman

/datum/loadout_item/suit/chicken
	name = "Chicken Suit"
	item_path = /obj/item/clothing/suit/chickensuit

/datum/loadout_item/suit/monky
	name = "Monkey Suit"
	item_path = /obj/item/clothing/suit/monkeysuit

/datum/loadout_item/suit/cardborg
	name = "Cardborg Suit"
	item_path = /obj/item/clothing/suit/cardborg

/datum/loadout_item/suit/xenos
	name = "Xenos Suit"
	item_path = /obj/item/clothing/suit/xenos

/datum/loadout_item/suit/ian_costume
	name = "Corgi Costume"
	item_path = /obj/item/clothing/suit/hooded/ian_costume

/datum/loadout_item/suit/carp_costume
	name = "Carp Costume"
	item_path = /obj/item/clothing/suit/hooded/carp_costume

//MISC
/datum/loadout_item/suit/poncho
	name = "Poncho"
	item_path = /obj/item/clothing/suit/poncho

/datum/loadout_item/suit/ponchogreen
	name = "Green poncho"
	item_path = /obj/item/clothing/suit/poncho/green

/datum/loadout_item/suit/ponchored
	name = "Red poncho"
	item_path = /obj/item/clothing/suit/poncho/red

/datum/loadout_item/suit/redhood
	name = "Red cloak"
	item_path = /obj/item/clothing/suit/hooded/cloak/david

/datum/loadout_item/suit/ianshirt
	name = "Ian Shirt"
	item_path = /obj/item/clothing/suit/ianshirt

/datum/loadout_item/suit/wornshirt
	name = "Worn Shirt"
	item_path = /obj/item/clothing/suit/wornshirt

/datum/loadout_item/suit/tailcoat
	name = "Tailcoat"
	item_path = /obj/item/clothing/suit/costume/tailcoat

/datum/loadout_item/suit/duster
	name = "Greyscale Duster"
	item_path = /obj/item/clothing/suit/duster
	can_be_greyscale = TRUE

/datum/loadout_item/suit/peacoat
	name = "Greyscale Peacoat"
	item_path = /obj/item/clothing/suit/toggle/peacoat
	can_be_greyscale = TRUE

/datum/loadout_item/suit/dresscoat
	name = "Black Dresscoat"
	item_path = /obj/item/clothing/suit/costume/vic_dresscoat

/datum/loadout_item/suit/dresscoat_red
	name = "Red Dresscoat"
	item_path = /obj/item/clothing/suit/costume/vic_dresscoat/red

/datum/loadout_item/suit/trackjacket
	name = "Track Jacket"
	item_path = /obj/item/clothing/suit/toggle/trackjacket

/*Flannels*/
/datum/loadout_item/suit/flannel_black
	name = "Black Flannel"
	item_path = /obj/item/clothing/suit/toggle/jacket/flannel
	can_be_greyscale = TRUE

/datum/loadout_item/suit/flannel_black
	name = "Black Flannel"
	item_path = /obj/item/clothing/suit/toggle/jacket/flannel/black

/datum/loadout_item/suit/flannel_red
	name = "Red Flannel"
	item_path = /obj/item/clothing/suit/toggle/jacket/flannel/red

/datum/loadout_item/suit/flannel_aqua
	name = "Aqua Flannel"
	item_path = /obj/item/clothing/suit/toggle/jacket/flannel/aqua

/datum/loadout_item/suit/flannel_brown
	name = "Brown Flannel"
	item_path = /obj/item/clothing/suit/toggle/jacket/flannel/brown

/*Hawaiian Shirts*/
/datum/loadout_item/suit/hawaiian
	name = "Greyscale Hawaiian Shirt"
	item_path = /obj/item/clothing/suit/hawaiian
	can_be_greyscale = TRUE

/datum/loadout_item/suit/hawaiian_blue
	name = "Blue Hawaiian Shirt"
	item_path = /obj/item/clothing/suit/hawaiian	//Thats right, its the same item, I cheated!!! MWAHAHAHAHA!

/datum/loadout_item/suit/hawaiian_orange
	name = "Orange Hawaiian Shirt"
	item_path = /obj/item/clothing/suit/hawaiian/orange

/datum/loadout_item/suit/hawaiian_purple
	name = "Purple Hawaiian Shirt"
	item_path = /obj/item/clothing/suit/hawaiian/purple

/datum/loadout_item/suit/hawaiian_green
	name = "Green Hawaiian Shirt"
	item_path = /obj/item/clothing/suit/hawaiian/green

/datum/loadout_item/suit/frenchtrench
	name = "Blue Trenchcoat"
	item_path = /obj/item/clothing/suit/frenchtrench

/datum/loadout_item/suit/cossak
	name = "Ukrainian Coat"
	item_path = /obj/item/clothing/suit/cossack

//COATS

/datum/loadout_item/suit/aformal
	name = "Assistant's formal winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/aformal

/datum/loadout_item/suit/runed
	name = "Runed winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/narsie/fake

/datum/loadout_item/suit/brass
	name = "Brass winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/ratvar/fake

/datum/loadout_item/suit/korea
	name = "Eastern winter coat"
	item_path = /obj/item/clothing/suit/koreacoat

/datum/loadout_item/suit/czech
	name = "Modern winter coat"
	item_path = /obj/item/clothing/suit/modernwintercoatthing

/datum/loadout_item/suit/parka
	name = "Falls Parka"
	item_path = /obj/item/clothing/suit/fallsparka

/datum/loadout_item/suit/poly
	name = "Polychromic Wintercoat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/polychromic

/*
/datum/loadout_item/suit/urban
	name = "Greyscale Urban Coat"
	item_path = /obj/item/clothing/suit/urban
	can_be_greyscale = TRUE
*/
//READD TO CLOTHESMATE

/datum/loadout_item/suit/maxson
	name = "Fancy Brown Coat"
	item_path = /obj/item/clothing/suit/brownbattlecoat

/datum/loadout_item/suit/bossu
	name = "Fancy Black Coat"
	item_path = /obj/item/clothing/suit/blackfurrich

/datum/loadout_item/suit/dutchjacket
	name = "Dutch Jacket"
	item_path = /obj/item/clothing/suit/dutchjacketsr

/datum/loadout_item/suit/caretaker
	name = "Caretaker Jacket"
	item_path = /obj/item/clothing/suit/victoriantailcoatbutler

/datum/loadout_item/suit/yakuzajacket
	name = "Asian Jacket"
	item_path = /obj/item/clothing/suit/yakuza

/datum/loadout_item/suit/jacketbomber_alt
	name = "Bomber Jacket w/ Zipper"
	item_path = /obj/item/clothing/suit/toggle/jacket

/datum/loadout_item/suit/leatherjacket_greyscale
	name = "Greyscale Leather Jacket"
	item_path = /obj/item/clothing/suit/jacket/leather/greyscale
	can_be_greyscale = TRUE

/datum/loadout_item/suit/woolcoat
	name = "Leather overcoat"
	item_path = /obj/item/clothing/suit/woolcoat

/datum/loadout_item/suit/jacketpuffer
	name = "Puffer jacket"
	item_path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_item/suit/flakjack
	name = "Flak Jacket"
	item_path = /obj/item/clothing/suit/flakjack


//HOODIES
/datum/loadout_item/suit/hoodie/greyscale
	name = "Greyscale Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie
	can_be_greyscale = TRUE

/datum/loadout_item/suit/hoodie/greyscale_trim
	name = "Greyscale Trimmed Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/trim
	can_be_greyscale = TRUE

/datum/loadout_item/suit/hoodie/greyscale_trim_alt
	name = "Greyscale Trimmed(Alt) Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/trim/alt
	can_be_greyscale = TRUE

/datum/loadout_item/suit/black
	name = "Black Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/black

/datum/loadout_item/suit/red
	name = "Red Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/red

/datum/loadout_item/suit/blue
	name = "Blue Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/blue

/datum/loadout_item/suit/green
	name = "Green Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/green

/datum/loadout_item/suit/orange
	name = "Orange Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/orange

/datum/loadout_item/suit/yellow
	name = "Yellow Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/yellow

/datum/loadout_item/suit/white
	name = "White Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/white

/datum/loadout_item/suit/cti
	name = "CTI Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/branded/cti

/datum/loadout_item/suit/mu
	name = "Mojave University Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/branded/mu

/datum/loadout_item/suit/nt
	name = "NT Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/branded

/datum/loadout_item/suit/smw
	name = "SMW Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/branded/smw

/datum/loadout_item/suit/nrti
	name = "NRTI Hoodie"
	item_path = /obj/item/clothing/suit/toggle/jacket/hoodie/branded/nrti

//JOB RELATED

/datum/loadout_item/suit/coat_med
	name = "Medical winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/medical
	restricted_roles = list("Chief Medical Officer", "Medical Doctor") // Reserve it to Medical Doctors and their boss, the Chief Medical Officer

/datum/loadout_item/suit/coat_paramedic
	name = "Paramedic winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/paramedic
	restricted_roles = list("Chief Medical Officer", "Paramedic") // Reserve it to Paramedics and their boss, the Chief Medical Officer

/datum/loadout_item/suit/coat_robotics
	name = "Robotics winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/robotics
	restricted_roles = list("Research Director", "Roboticist")

/datum/loadout_item/suit/coat_sci
	name = "Science winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/science
	restricted_roles = list("Research Director", "Scientist", "Roboticist", "Vanguard Operative") // Reserve it to the Science Departement

/datum/loadout_item/suit/coat_eng
	name = "Engineering winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/engineering
	restricted_roles = list("Chief Engineer", "Station Engineer") // Reserve it to Station Engineers and their boss, the Chief Engineer

/datum/loadout_item/suit/coat_atmos
	name = "Atmospherics winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos
	restricted_roles = list("Chief Engineer", "Atmospheric Technician") // Reserve it to Atmos Techs and their boss, the Chief Engineer

/datum/loadout_item/suit/coat_hydro
	name = "Hydroponics winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/hydro
	restricted_roles = list("Head of Personnel", "Botanist") // Reserve it to Botanists and their boss, the Head of Personnel

/datum/loadout_item/suit/coat_bar
	name = "Bartender winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/bartender
	restricted_roles = list("Head of Personnel", "Bartender") //Reserved for Bartenders and their head-of-staff

/datum/loadout_item/suit/coat_cargo
	name = "Cargo winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/cargo
	restricted_roles = list("Quartermaster", "Cargo Technician") // Reserve it to Cargo Techs and their boss, the Quartermaster

/datum/loadout_item/suit/coat_miner
	name = "Mining winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/miner
	restricted_roles = list("Quartermaster", "Shaft Miner") // Reserve it to Miners and their boss, the Quartermaster

/datum/loadout_item/suit/navybluejacketofficer
	name = "security officer's navyblue jacket"
	item_path = /obj/item/clothing/suit/armor/navyblue
	restricted_roles = list("Security Officer","Security Medic","Security Sergeant","Head of Security", "Warden") // I aint making a medic one, maybe i'll add some rank thing from cm or civ for it

/datum/loadout_item/suit/navybluejacketwarden
	name = "warden navyblue jacket"
	item_path = /obj/item/clothing/suit/armor/vest/warden/navyblue
	restricted_roles = list("Warden")

/datum/loadout_item/suit/security_jacket
	name = "Security Jacket"
	item_path = /obj/item/clothing/suit/toggle/jacket/sec
	restricted_roles = list("Head of Security", "Security Officer", "Warden", "Detective", "Security Medic", "Security Sergeant") //Not giving this one to CDOs or COs because it's actually better than the one they spawn with

/datum/loadout_item/suit/cossak/sec
	name = "Ukrainian Security Jacket"
	item_path = /obj/item/clothing/suit/cossack/sec
	restricted_roles = list("Head of Security", "Security Officer", "Warden", "Detective", "Security Medic", "Security Sergeant", "Civil Disputes Officer", "Corrections Officer")

/datum/loadout_item/suit/brit
	name = "High Vis Armored Vest"
	item_path = /obj/item/clothing/suit/toggle/brit/sec
	restricted_roles = list("Head of Security", "Security Officer", "Warden", "Detective", "Security Medic", "Security Sergeant", "Civil Disputes Officer", "Corrections Officer")
/datum/loadout_item/suit/british_jacket
	name = "Peacekeeper Officer Coat"
	item_path = /obj/item/clothing/suit/british_officer
	restricted_roles = list("Head of Security", "Warden","Detective","Security Sergeant")

/datum/loadout_item/suit/engi_jacket
	name = "Engineering Jacket"
	item_path = /obj/item/clothing/suit/toggle/jacket/engi
	restricted_roles = list("Chief Engineer", "Station Engineer", "Atmospheric Technician")

/datum/loadout_item/suit/sci_jacket
	name = "Science Jacket"
	item_path = /obj/item/clothing/suit/toggle/jacket/sci
	restricted_roles = list("Research Director", "Scientist", "Roboticist", "Geneticist", "Vanguard Operative")

/datum/loadout_item/suit/med_jacket
	name = "Medbay Jacket"
	item_path = /obj/item/clothing/suit/toggle/jacket/med
	restricted_roles = list("Chief Medical Officer", "Medical Doctor", "Paramedic", "Chemist", "Virologist")

/datum/loadout_item/suit/supply_jacket
	name = "Supply Jacket"
	item_path = /obj/item/clothing/suit/toggle/jacket/supply
	restricted_roles = list("Quartermaster", "Cargo Technician", "Miner")

/datum/loadout_item/suit/supply_gorka_jacket
	name = "Supply Gorka Jacket"
	item_path = /obj/item/clothing/suit/gorka/supply
	restricted_roles = list("Quartermaster", "Cargo Technician", "Miner")


/datum/loadout_item/suit/labcoat_parared
	name = "Red Paramedic Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/para_red
	restricted_roles = list("Chief Medical Officer", "Paramedic","Security Medic") // its a medic jacket anyway screw you

/datum/loadout_item/suit/labcoat_highvis
	name = "High-Vis Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/highvis
	restricted_roles = list("Chief Medical Officer", "Paramedic", "Atmospheric Technician", "Detective", "Security Medic") // why does the atmos get this? sec med is more of a first responder lmao

/datum/loadout_item/suit/discojacket
	name = "Disco Ass Blazer"
	item_path = /obj/item/clothing/suit/discoblazer
	restricted_roles = list("Detective")

/datum/loadout_item/suit/deckard
	name = "Runner Coat"
	item_path = /obj/item/clothing/suit/toggle/deckard
	restricted_roles = list("Detective")

/datum/loadout_item/suit/bltrench
	name = "Black Trenchcoat"
	item_path = /obj/item/clothing/suit/trenchblack


/datum/loadout_item/suit/brtrench
	name = "Brown Trenchcoat"
	item_path = /obj/item/clothing/suit/trenchbrown

/datum/loadout_item/suit/cardigan
	name = "Cardigan"
	item_path = /obj/item/clothing/suit/toggle/jacket/cardigan

//Families Gear
/datum/loadout_item/suit/osi
	name = "OSI Coat"
	item_path = /obj/item/clothing/suit/osi

/datum/loadout_item/suit/tmc
	name = "TMC Coat"
	item_path = /obj/item/clothing/suit/tmc

/datum/loadout_item/suit/pg
	name = "PG Coat"
	item_path = /obj/item/clothing/suit/pg

/datum/loadout_item/suit/driscoll
	name = "Driscoll Coat"
	item_path = /obj/item/clothing/suit/driscoll

/datum/loadout_item/suit/deckers
	name = "Deckers Coat"
	item_path = /obj/item/clothing/suit/deckers

/datum/loadout_item/suit/morningstar
	name = "Morningstar Coat"
	item_path = /obj/item/clothing/suit/morningstar

/datum/loadout_item/suit/saints
	name = "Saints Coat"
	item_path = /obj/item/clothing/suit/saints

/datum/loadout_item/suit/phantom
	name = "Phantom Coat"
	item_path = /obj/item/clothing/suit/phantom

/datum/loadout_item/suit/sybil
	name = "Sybil Coat"
	item_path = /obj/item/clothing/suit/sybil_slickers

/datum/loadout_item/suit/basil
	name = "Basil Coat"
	item_path = /obj/item/clothing/suit/basil_boys

//Donator sutis here
/datum/loadout_item/suit/donator
	donator_only = TRUE

/datum/loadout_item/suit/donator/furredjacket
	name = "Furred Jacket"
	item_path = /obj/item/clothing/suit/brownfurrich/public

/datum/loadout_item/suit/donator/whitefurredjacket
	name = "White Furred Jacket"
	item_path = /obj/item/clothing/suit/brownfurrich/white

/datum/loadout_item/suit/donator/creamfurredjacket
	name = "Cream Furred Jacket"
	item_path = /obj/item/clothing/suit/brownfurrich/cream

/datum/loadout_item/suit/donator/british_officer
	name = "British Officers Coat"
	item_path = /obj/item/clothing/suit/british_officer

/datum/loadout_item/suit/donator/british_officer
	name = "Modern Winter Coat"
	item_path = /obj/item/clothing/suit/modern_winter

/datum/loadout_item/suit/donator/blondie
	name = "Cowboy Vest"
	item_path = /obj/item/clothing/suit/cowboyvest

