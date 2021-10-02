// --- Loadout item datums for heads ---

/// Head Slot Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_helmets, generate_loadout_items(/datum/loadout_item/head))

/datum/loadout_item/head
	category = LOADOUT_ITEM_HEAD

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout helmet was not equipped directly due to your envirosuit helmet.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.head = item_path

/datum/loadout_item/head/black_beanie
	name = "Black Beanie"
	item_path = /obj/item/clothing/head/beanie/black

/datum/loadout_item/head/christmas_beanie
	name = "Christmas Beanie"
	item_path = /obj/item/clothing/head/beanie/christmas

/datum/loadout_item/head/cyan_beanie
	name = "Cyan Beanie"
	item_path = /obj/item/clothing/head/beanie/cyan

/datum/loadout_item/head/dark_blue_beanie
	name = "Dark Blue Beanie"
	item_path = /obj/item/clothing/head/beanie/darkblue

/datum/loadout_item/head/green_beanie
	name = "Green Beanie"
	item_path = /obj/item/clothing/head/beanie/green

/datum/loadout_item/head/orange_beanie
	name = "Orange Beanie"
	item_path = /obj/item/clothing/head/beanie/orange

/datum/loadout_item/head/purple_beanie
	name = "Purple Beanie"
	item_path = /obj/item/clothing/head/beanie/purple

/datum/loadout_item/head/red_beanie
	name = "Red Beanie"
	item_path = /obj/item/clothing/head/beanie/red

/datum/loadout_item/head/striped_beanie
	name = "Striped Beanie"
	item_path = /obj/item/clothing/head/beanie/striped

/datum/loadout_item/head/striped_red_beanie
	name = "Striped Red Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedred

/datum/loadout_item/head/striped_blue_beanie
	name = "Striped Blue Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedblue

/datum/loadout_item/head/striped_green_beanie
	name = "Striped Green Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedgreen

/datum/loadout_item/head/white_beanie
	name = "White Beanie"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/yellow_beanie
	name = "Yellow Beanie"
	item_path = /obj/item/clothing/head/beanie/yellow

/datum/loadout_item/head/greyscale_beret
	name = "Greyscale Beret"
	can_be_greyscale = TRUE
	item_path = /obj/item/clothing/head/beret

/datum/loadout_item/head/black_beret
	name = "Black Beret"
	item_path = /obj/item/clothing/head/beret/black

/datum/loadout_item/head/black_cap
	name = "Black Cap"
	item_path = /obj/item/clothing/head/soft/black

/datum/loadout_item/head/blue_cap
	name = "Blue Cap"
	item_path = /obj/item/clothing/head/soft/blue

/datum/loadout_item/head/delinquent_cap
	name = "Delinquent Cap"
	item_path = /obj/item/clothing/head/delinquent

/datum/loadout_item/head/green_cap
	name = "Green Cap"
	item_path = /obj/item/clothing/head/soft/green

/datum/loadout_item/head/grey_cap
	name = "Grey Cap"
	item_path = /obj/item/clothing/head/soft/grey

/datum/loadout_item/head/orange_cap
	name = "Orange Cap"
	item_path = /obj/item/clothing/head/soft/orange

/datum/loadout_item/head/purple_cap
	name = "Purple Cap"
	item_path = /obj/item/clothing/head/soft/purple

/datum/loadout_item/head/rainbow_cap
	name = "Rainbow Cap"
	item_path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_item/head/red_cap
	name = "Red Cap"
	item_path = /obj/item/clothing/head/soft/red

/datum/loadout_item/head/white_cap
	name = "White Cap"
	item_path = /obj/item/clothing/head/soft

/datum/loadout_item/head/yellow_cap
	name = "Yellow Cap"
	item_path = /obj/item/clothing/head/soft/yellow

/datum/loadout_item/head/flatcap
	name = "Flat Cap"
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/beige_fedora
	name = "Beige Fedora"
	item_path = /obj/item/clothing/head/fedora/beige

/datum/loadout_item/head/black_fedora
	name = "Black Fedora"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/white_fedora
	name = "White Fedora"
	item_path = /obj/item/clothing/head/fedora/white

/datum/loadout_item/head/dark_blue_hardhat
	name = "Dark Blue Hardhat"
	item_path = /obj/item/clothing/head/hardhat/dblue

/datum/loadout_item/head/orange_hardhat
	name = "Orange Hardhat"
	item_path = /obj/item/clothing/head/hardhat/orange

/datum/loadout_item/head/red_hardhat
	name = "Red Hardhat"
	item_path = /obj/item/clothing/head/hardhat/red

/datum/loadout_item/head/white_hardhat
	name = "White Hardhat"
	item_path = /obj/item/clothing/head/hardhat/white

/datum/loadout_item/head/yellow_hardhat
	name = "Yellow Hardhat"
	item_path = /obj/item/clothing/head/hardhat

/datum/loadout_item/head/mail_cap
	name = "Mail Cap"
	item_path = /obj/item/clothing/head/mailman

/datum/loadout_item/head/nurse_hat
	name = "Nurse Hat"
	item_path = /obj/item/clothing/head/nursehat

/datum/loadout_item/head/kitty_ears
	name = "Kitty Ears"
	item_path = /obj/item/clothing/head/kitty

/datum/loadout_item/head/rabbit_ears
	name = "Rabbit Ears"
	item_path = /obj/item/clothing/head/rabbitears

/datum/loadout_item/head/bandana
	name = "Bandana"
	item_path = /obj/item/clothing/head/bandana

/datum/loadout_item/head/rastafarian
	name = "Rastafarian Cap"
	item_path = /obj/item/clothing/head/beanie/rasta

/datum/loadout_item/head/top_hat
	name = "Top Hat"
	item_path = /obj/item/clothing/head/that

/datum/loadout_item/head/bowler_hat
	name = "Bowler Hat"
	item_path = /obj/item/clothing/head/bowler

/datum/loadout_item/head/bear_pelt
	name = "Bear Pelt"
	item_path = /obj/item/clothing/head/bearpelt

/datum/loadout_item/head/ushanka
	name ="Ushanka"
	item_path = /obj/item/clothing/head/ushanka

/datum/loadout_item/head/plague_doctor
	name = "Plague Doctor Cap"
	item_path = /obj/item/clothing/head/plaguedoctorhat

/datum/loadout_item/head/wedding_veil
	name = "Wedding Veil"
	item_path = /obj/item/clothing/head/weddingveil

/datum/loadout_item/head/poppy
	name = "Poppy"
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/lily
	name = "Lily"
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/geranium
	name = "Geranium"
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/rose
	name = "Rose"
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/sunflower
	name = "Sunflower"
	item_path = /obj/item/grown/sunflower

/datum/loadout_item/head/harebell
	name = "Harebell"
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/rainbow_bunch
	name = "Rainbow Bunch"
	item_path = /obj/item/food/grown/rainbow_flower
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

//MISC
/datum/loadout_item/head/baseball
	name = "Ballcap"
	item_path = /obj/item/clothing/head/soft/mime

/datum/loadout_item/head/beanie
	name = "Beanie"
	item_path = /obj/item/clothing/head/beanie


/datum/loadout_item/head/beret
	name = "Black beret"
	item_path = /obj/item/clothing/head/beret/black

/datum/loadout_item/head/flatcap
	name = "Flat cap"
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/pflatcap
	name = "Poly Flat cap"
	item_path = /obj/item/clothing/head/polyflatc


/datum/loadout_item/head/pirate
	name = "Pirate hat"
	item_path = /obj/item/clothing/head/pirate

/datum/loadout_item/head/flowerpin
	name = "Flower Pin"
	item_path = /obj/item/clothing/head/flowerpin


/datum/loadout_item/head/rice_hat
	name = "Rice hat"
	item_path = /obj/item/clothing/head/rice_hat

/datum/loadout_item/head/ushanka/soviet
	name = "Soviet Ushanka"
	item_path = /obj/item/clothing/head/ushanka/soviet

/datum/loadout_item/head/wrussian
	name = "Black Papakha"
	item_path = /obj/item/clothing/head/whiterussian

/datum/loadout_item/head/wrussianw
	name = "White Papakha"
	item_path = /obj/item/clothing/head/whiterussian/white

/datum/loadout_item/head/wrussianb
	name = "Black and Red Papakha"
	item_path = /obj/item/clothing/head/whiterussian/black

/datum/loadout_item/head/slime
	name = "Slime hat"
	item_path = /obj/item/clothing/head/collectable/slime

/datum/loadout_item/head/fedora
	name = "Fedora"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/that
	name = "Top Hat"
	item_path = /obj/item/clothing/head/that

/datum/loadout_item/head/flakhelm
	name = "Flak Helmet"
	item_path = /obj/item/clothing/head/flakhelm


/datum/loadout_item/head/bunnyears
	name = "Bunny Ears"
	item_path = /obj/item/clothing/head/rabbitears

/datum/loadout_item/head/mailmanhat
	name = "Mailman's Hat"
	item_path = /obj/item/clothing/head/mailman

/datum/loadout_item/head/whitekepi
	name = "White Kepi"
	item_path = /obj/item/clothing/head/kepi

/datum/loadout_item/head/whitekepiold
	name = "White Kepi, Old"
	item_path = /obj/item/clothing/head/kepi/old

/datum/loadout_item/head/hijab
	name = "Hijab"
	item_path = /obj/item/clothing/head/hijab


/datum/loadout_item/head/turban
	name = "Turban"
	item_path = /obj/item/clothing/head/turb


/datum/loadout_item/head/keff
	name = "Keffiyeh"
	item_path = /obj/item/clothing/head/keffiyeh


/datum/loadout_item/head/maidhead
	name = "Maid Headband"
	item_path = /obj/item/clothing/head/maid

/datum/loadout_item/head/widehat
	name = "Wide Black Hat"
	item_path = /obj/item/clothing/head/costume/widehat

/datum/loadout_item/head/widehat_red
	name = "Wide Red Hat"
	item_path = /obj/item/clothing/head/costume/widehat/red

/datum/loadout_item/head/cardboard
	name = "Cardboard Helmet"
	item_path = /obj/item/clothing/head/cardborg


/datum/loadout_item/head/wig
	name = "Wig"
	item_path = /obj/item/clothing/head/wig


/datum/loadout_item/head/wignatural
	name = "Natural Wig"
	item_path = /obj/item/clothing/head/wig/natural

//Cowboy Stuff
/datum/loadout_item/head/cowboyhat
	name = "Cowboy Hat, Brown"
	item_path = /obj/item/clothing/head/cowboyhat

/datum/loadout_item/head/cowboyhat_black
	name = "Cowboy Hat, Black"
	item_path = /obj/item/clothing/head/cowboyhat/black

/datum/loadout_item/head/cowboyhat_blackwide
	name = "Wide Cowboy Hat, Black"
	item_path = /obj/item/clothing/head/cowboyhat/blackwide

/datum/loadout_item/head/cowboyhat_wide
	name = "Wide Cowboy Hat, Brown"
	item_path = /obj/item/clothing/head/cowboyhat/wide

/datum/loadout_item/head/cowboyhat_white
	name = "Cowboy Hat, White"
	item_path = /obj/item/clothing/head/cowboyhat/white

/datum/loadout_item/head/cowboyhat_pink
	name = "Cowboy Hat, Pink"
	item_path = /obj/item/clothing/head/cowboyhat/pink

/datum/loadout_item/head/cowboyhat_winter
	name = "Winter Cowboy Hat"
	item_path = /obj/item/clothing/head/cowboyhat/sheriff

/datum/loadout_item/head/cowboyhat_sheriff
	name = "Sheriff Hat"
	item_path = /obj/item/clothing/head/cowboyhat/sheriff/alt

/datum/loadout_item/head/cowboyhat_deputy
	name = "Deputy Hat"
	item_path = /obj/item/clothing/head/cowboyhat/deputy

//trek fancy Hats!
/datum/loadout_item/head/trekcap
	name = "Federation Officer's Cap (White)"
	item_path = /obj/item/clothing/head/caphat/formal/fedcover
	restricted_roles = list("Captain","Head of Personnel")

/datum/loadout_item/head/trekcapcap
	name = "Federation Officer's Cap (Black)"
	item_path = /obj/item/clothing/head/caphat/formal/fedcover/black
	restricted_roles = list("Captain","Head of Personnel")

/datum/loadout_item/head/trekcapmedisci
	name = "Federation Officer's Cap (Blue)"
	item_path = /obj/item/clothing/head/caphat/formal/fedcover/medsci
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Security Medic","Paramedic","Chemist","Virologist","Psychologist","Geneticist","Research Director","Scientist","Roboticist","Vanguard Operative")

/datum/loadout_item/head/trekcapeng
	name = "Federation Officer's Cap (Yellow)"
	item_path = /obj/item/clothing/head/caphat/formal/fedcover/eng
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Security Medic","Security Sergeant","Warden","Detective","Security Officer","Head of Security","Civil Disputes Officer","Corrections Officer","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/loadout_item/head/trekcapsec
	name = "Federation Officer's Cap (Red)"
	item_path = /obj/item/clothing/head/caphat/formal/fedcover/sec
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Security Medic","Security Sergeant","Warden","Detective","Security Officer","Head of Security","Civil Disputes Officer","Corrections Officer","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/loadout_item/head/imperial_cap
	name = "Captain's Naval Cap"
	item_path = /obj/item/clothing/head/imperial/cap
	restricted_roles = list("Captain", "Nanotrasen Representative")

/datum/loadout_item/head/imperial_hop
	name = "Head of Personnel's Naval Cap"
	item_path = /obj/item/clothing/head/imperial/hop
	restricted_roles = list("Head of Personnel", "Nanotrasen Representative")

/datum/loadout_item/head/imperial_ce
	name = "Chief Engineer's blast helmet."
	item_path = /obj/item/clothing/head/imperial/ce
	restricted_roles = list("Chief Engineer")

/datum/loadout_item/head/cowboyhat_sec
	name = "Cowboy Hat, Security"
	item_path = /obj/item/clothing/head/cowboyhat/sec
	restricted_roles = list("Warden","Detective","Security Medic","Security Sergeant","Security Officer","Head of Security","Civil Disputes Officer","Corrections Officer")

/datum/loadout_item/head/cowboyhat_secwide
	name = "Wide Cowboy Hat, Security"
	item_path = /obj/item/clothing/head/cowboyhat/widesec
	restricted_roles = list("Warden","Detective","Security Medic","Security Sergeant","Security Officer","Head of Security","Civil Disputes Officer","Corrections Officer")

/datum/loadout_item/head/ushanka/sec
	name = "Security Ushanka"
	item_path = /obj/item/clothing/head/ushankasec
	restricted_roles = list("Warden","Detective","Security Medic","Security Sergeant","Security Officer","Head of Security","Civil Disputes Officer","Corrections Officer")

/datum/loadout_item/head/blasthelmet
	name = "General's Helmet"
	item_path = /obj/item/clothing/head/imperialhelmet
	restricted_roles = list("Warden","Detective","Security Medic","Security Sergeant","Security Officer","Civil Disputes Officer","Corrections Officer","Captain", "Head of Personnel", "Blueshield", "Head of Security", "Research Director", "Quartermaster", "Chief Medical Officer", "Chief Engineer")

/datum/loadout_item/head/navybluehoscap
	name = "Head of Security's Naval Cap"
	item_path = /obj/item/clothing/head/imperial/hos
	restricted_roles = list("Head of Security")

/datum/loadout_item/head/navyblueofficerberet
	name = "Security officer's Navyblue beret"
	item_path = /obj/item/clothing/head/beret/sec/navyofficer
	restricted_roles = list("Security Officer","Security Medic","Security Sergeant",)

/datum/loadout_item/head/solofficercap
	name = "Security officer's Sol Cap"
	item_path = /obj/item/clothing/head/sec/peacekeeper/sol
	restricted_roles = list("Security Officer","Security Medic","Security Sergeant",)

/datum/loadout_item/head/soltrafficoff
	name = "Traffic Officer Cap"
	item_path = /obj/item/clothing/head/soltraffic
	restricted_roles = list("Security Officer","Security Medic","Security Sergeant","Civil Disputes Officer")

/datum/loadout_item/head/navybluewardenberet
	name = "Warden's navyblue beret"
	item_path = /obj/item/clothing/head/beret/sec/navywarden
	restricted_roles = list("Warden")

/datum/loadout_item/head/cybergoggles	//Cyberpunk-P.I. Outfit
	name = "Type-34C Forensics Headwear"
	item_path = /obj/item/clothing/head/fedora/det_hat/cybergoggles
	restricted_roles = list("Detective")

/datum/loadout_item/head/nursehat
	name = "Nurse Hat"
	item_path = /obj/item/clothing/head/nursehat
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist","Security Medic")

/datum/loadout_item/head/imperial_generic
	name = "Naval Officer Cap"
	item_path = /obj/item/clothing/head/imperial
	restricted_roles = list("Captain", "Head of Personnel", "Blueshield", "Head of Security", "Research Director", "Quartermaster", "Chief Medical Officer", "Chief Engineer", "Nanotrasen Representative")

/datum/loadout_item/head/imperial_grey
	name = "Grey Naval Officer Cap"
	item_path = /obj/item/clothing/head/imperial/grey
	restricted_roles = list("Captain", "Head of Personnel", "Blueshield", "Head of Security", "Research Director", "Quartermaster", "Chief Medical Officer", "Chief Engineer", "Nanotrasen Representative")

/datum/loadout_item/head/imperial_red
	name = "Red Naval Officer Cap"
	item_path = /obj/item/clothing/head/imperial/red
	restricted_roles = list("Captain", "Head of Personnel", "Blueshield", "Head of Security", "Research Director", "Quartermaster", "Chief Medical Officer", "Chief Engineer")

// JOB - Berets
/datum/loadout_item/head/atmos_beret
	name = "Atmospherics Beret"
	item_path = /obj/item/clothing/head/beret/atmos
	restricted_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer")

/datum/loadout_item/head/engi_beret
	name = "Engineering Beret"
	item_path = /obj/item/clothing/head/beret/engi
	restricted_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer")
/datum/loadout_item/head/beret_med
	name = "Medical Beret"
	item_path = /obj/item/clothing/head/beret/medical
	restricted_roles = list("Medical Doctor","Virologist", "Chemist", "Chief Medical Officer","Security Medic")

/datum/loadout_item/head/beret_paramedic
	name = "Paramedic Beret"
	item_path = /obj/item/clothing/head/beret/medical/paramedic
	restricted_roles = list("Paramedic", "Chief Medical Officer")

/datum/loadout_item/head/beret_viro
	name = "Virologist Beret"
	item_path = /obj/item/clothing/head/beret/medical/virologist
	restricted_roles = list("Virologist", "Chief Medical Officer")

/datum/loadout_item/head/beret_chem
	name = "Chemist Beret"
	item_path = /obj/item/clothing/head/beret/medical/chemist
	restricted_roles = list("Chemist", "Chief Medical Officer")

/datum/loadout_item/head/beret_sci
	name = "Scientist's Beret"
	item_path = /obj/item/clothing/head/beret/science
	restricted_roles = list("Scientist", "Roboticist", "Geneticist", "Research Director", "Vanguard Operative")

/datum/loadout_item/head/beret_robo
	name = "Roboticist's Beret"
	item_path = /obj/item/clothing/head/beret/science/fancy/robo
	restricted_roles = list("Roboticist", "Research Director")

/datum/loadout_item/head/brfed
	name = "Brown Fedora"
	item_path = /obj/item/clothing/head/fedora/fedbrown

/datum/loadout_item/head/blfed
	name = "Black Fedora"
	item_path = /obj/item/clothing/head/fedora/fedblack

//head
/datum/loadout_item/head/dominacap
	name = "Dominant cap"
	item_path = /obj/item/clothing/head/domina_cap

// Donator hats here
/datum/loadout_item/head/donator
	donator_only = TRUE

/datum/loadout_item/head/donator/poppy
	name = "Poppy Flower"
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/donator/lily
	name = "Lily Flower"
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/donator/geranium
	name = "Geranium Flower"
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/donator/fraxinella
	name = "Fraxinella Flower"
	item_path = /obj/item/food/grown/poppy/geranium/fraxinella

/datum/loadout_item/head/donator/harebell
	name = "Harebell Flower"
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/donator/rose
	name = "Rose Flower"
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/donator/carbon_rose
	name = "Carbon Rose Flower"
	item_path = /obj/item/grown/carbon_rose

/datum/loadout_item/head/donator/enclave
	name = "Enclave Cap"
	item_path = /obj/item/clothing/head/soft/enclave

/datum/loadout_item/head/donator/enclaveo
	name = "Enclave Cap - officer"
	item_path = /obj/item/clothing/head/soft/enclaveo
