/datum/gun_company
	/// Name of the company
	var/name
	/// UNUSED, description of the company
	var/desc
	/// Bitflag that should match what guns the company produces
	var/company_flag
	/// If the company needs a multitooled console to see
	var/illegal = FALSE
	/// Var for internal calculations, don't touch
	var/base_cost = 0
	/// How much the company costs, can shift over time
	var/cost = 0
	/// Multiplier added to the cost before showing the final price to the user
	var/cost_mult = 1
	/// On a subsystem fire, will lower/raise company values by a random value between lower and upper
	var/cost_change_lower = -100
	/// On a subsystem fire, will lower/raise company values by a random value between lower and upper
	var/cost_change_upper = 100
	/// If this company can be picked to be a handout company to start
	var/can_roundstart_pick = TRUE
	/// The "interest" value of the company, to determine how much stock the company has, goes down passively and is raised by things being bought
	var/interest = 0
	/// Multiplier for magazine costs
	var/magazine_cost_mult = 1

/datum/gun_company/armadyne
	name = "Armadyne Corporation"
	can_roundstart_pick = FALSE
	company_flag = COMPANY_ARMADYNE
	cost = 7500
	cost_change_lower = -250
	cost_change_upper = 1750

/datum/gun_company/cantalan
	name = "Cantalan Federal Arms"
	can_roundstart_pick = FALSE
	company_flag = COMPANY_CANTALAN
	magazine_cost_mult = 3 //RIP
	cost = 4000
	cost_change_lower = -500
	cost_change_upper = 1000

/datum/gun_company/scarborough
	name = "Scarborough Arms"
	illegal = TRUE
	can_roundstart_pick = FALSE
	company_flag = COMPANY_SCARBOROUGH
	cost = 20000
	cost_change_lower = 0
	cost_change_upper = 2500
	cost_mult = 1.1

/datum/gun_company/bolt
	name = "Bolt Fabrications"
	company_flag = COMPANY_BOLT
	cost = 4000
	cost_change_lower = -500
	cost_change_upper = 1000

/datum/gun_company/oldarms
	name = "Armadyne Oldarms"
	can_roundstart_pick = FALSE
	company_flag = COMPANY_OLDARMS
	cost_change_lower = -250
	cost_change_upper = 2000
	cost = 10000

/datum/gun_company/izhevsk
	name = "Izhevsk Coalition"
	company_flag = COMPANY_IZHEVSK
	cost_change_lower = -250 //cheap as hell "company" is cheap as hell to buy
	cost_change_upper = 500
	cost = 3000
	cost_mult = 0.9

/datum/gun_company/nanotrasen
	name = "Nanotrasen Armories"
	company_flag = COMPANY_NANOTRASEN
	cost_change_lower = -250
	cost_change_upper = 1500
	cost = 7500

/datum/gun_company/allstar
	name = "Allstar Lasers"
	company_flag = COMPANY_ALLSTAR
	cost_change_lower = -500
	cost_change_upper = 1000
	cost = 5000

/datum/gun_company/micron
	name = "Micron Control Systems"
	can_roundstart_pick = FALSE
	company_flag = COMPANY_MICRON
	cost_change_lower = -250
	cost_change_upper = 1750 //This is an alternative to R&D, so it's expensive as hell
	cost = 10000

/datum/gun_company/dynamics
	name = "Armament Dynamics Inc."
	can_roundstart_pick = FALSE
	company_flag = COMPANY_DYNAMICS
	cost_change_lower = -500
	cost_change_upper = 1000
	cost = 3500 //subsidized or smth
