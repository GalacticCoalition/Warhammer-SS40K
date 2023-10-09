// Machine categories

#define FABRICATOR_CATEGORY_APPLIANCES "/Appliances"
#define FABRICATOR_SUBCATEGORY_POWER "/Power"
#define FABRICATOR_SUBCATEGORY_ATMOS "/Atmospherics"
#define FABRICATOR_SUBCATEGORY_FLUIDS "/Liquids"
#define FABRICATOR_SUBCATEGORY_HYDRO "/Hydroponics"

// Techweb node that shouldnt show up anywhere ever specifically for the fabricator to work with

/datum/techweb_node/colony_fabricator_appliances
	id = "colony_fabricator_appliances"
	display_name = "Colony Fabricator Appliance Designs"
	description = "Contains all of the colony fabricator's appliance machine designs."
	design_ids = list(
		"wall_multi_cell_rack",
		"portable_lil_pump",
		"portable_scrubbs",
		"co2_cracker",
		"survival_knife", // I just don't want to make a whole new node for this one sorry
		"soup_pot", // This one too
		"water_synth",
		"hydro_synth",
		"organic_printer",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000000000000000) // God save you
	hidden = TRUE
	show_on_wiki = FALSE
	starting_node = TRUE

// Wall mountable multi cell charger

/datum/design/wall_mounted_multi_charger
	name = "Mounted Multi-Cell Charging Rack"
	id = "wall_multi_cell_rack"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1,
	)
	build_path = /obj/item/wallframe/cell_charger_multi
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_APPLIANCES + FABRICATOR_SUBCATEGORY_POWER,
	)
	construction_time = 15 SECONDS

// Portable scrubber and pumps for all your construction atmospherics needs

/datum/design/portable_gas_pump
	name = "Portable Air Pump"
	id = "portable_lil_pump"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/machinery/portable_atmospherics/pump
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_APPLIANCES + FABRICATOR_SUBCATEGORY_ATMOS,
	)
	construction_time = 30 SECONDS

/datum/design/portable_gas_scrubber
	name = "Portable Air Scrubber"
	id = "portable_scrubbs"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/machinery/portable_atmospherics/scrubber
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_APPLIANCES + FABRICATOR_SUBCATEGORY_ATMOS,
	)
	construction_time = 30 SECONDS

// CO2 cracker, portable machines that takes CO2 and turns it into oxygen

/datum/design/co2_cracker
	name = "Portable Carbon Dioxide Cracker"
	id = "co2_cracker"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT, // We're gonna pretend plasma is the catalyst for co2 cracking
	)
	build_path = /obj/machinery/electrolyzer/co2_cracker
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_APPLIANCES + FABRICATOR_SUBCATEGORY_ATMOS,
	)
	construction_time = 30 SECONDS

// Plumbable chem machine that makes nothing but water

/datum/design/water_synthesizer
	name = "Water Synthesizer"
	id = "water_synth"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/machinery/plumbing/synthesizer/water_synth
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_APPLIANCES + FABRICATOR_SUBCATEGORY_FLUIDS,
	)
	construction_time = 10 SECONDS

// Plumbable chem machine that makes nothing but water

/datum/design/hydro_synthesizer
	name = "Hydroponics Chemical Synthesizer"
	id = "hydro_synth"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/machinery/plumbing/synthesizer/water_synth/hydroponics
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_APPLIANCES + FABRICATOR_SUBCATEGORY_FLUIDS,
	)
	construction_time = 10 SECONDS

// Plumbable chem machine that makes nothing but water

/datum/design/organic_printer
	name = "Organic Materials Printer"
	id = "organic_printer"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 5.5,
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/machinery/biogenerator/organic_printer
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_APPLIANCES + FABRICATOR_SUBCATEGORY_HYDRO,
	)
	construction_time = 45 SECONDS

#undef FABRICATOR_CATEGORY_APPLIANCES
#undef FABRICATOR_SUBCATEGORY_POWER
#undef FABRICATOR_SUBCATEGORY_ATMOS
#undef FABRICATOR_SUBCATEGORY_FLUIDS
#undef FABRICATOR_SUBCATEGORY_HYDRO
