/obj/machinery/rnd/production/circuit_imprinter
	name = "circuit imprinter"
	desc = "Manufactures circuit boards for the construction of machines."
	icon_state = "circuit_imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter
<<<<<<< HEAD
	categories = list(
								RND_CATEGORY_AI_MODULES,
								RND_CATEGORY_COMPUTER_BOARDS,
								RND_CATEGORY_TELEPORTATION_MACHINERY,
								RND_CATEGORY_MEDICAL_MACHINERY,
								RND_CATEGORY_ENGINEERING_MACHINERY,
								RND_CATEGORY_EXOSUIT_MODULES,
								RND_CATEGORY_HYDROPONICS_MACHINERY,
								RND_CATEGORY_SUBSPACE_TELECOMMS,
								RND_CATEGORY_RESEARCH_MACHINERY,
								RND_CATEGORY_MISC_MACHINERY,
								RND_CATEGORY_COMPUTER_PARTS,
								RND_CATEGORY_CIRCUITRY,
								RND_CATEGORY_WEAPONS_MACHINERY
								)
=======
>>>>>>> 8be2c1e2d26 (TGUI for techfabs (#69353))
	production_animation = "circuit_imprinter_ani"
	allowed_buildtypes = IMPRINTER

/obj/machinery/rnd/production/circuit_imprinter/calculate_efficiency()
	. = ..()

	var/rating = 0

	for(var/obj/item/stock_parts/manipulator/manipulator in component_parts)
		rating += manipulator.rating // There is only one.

	efficiency_coeff = 0.5 ** max(rating - 1, 0) // One sheet, half sheet, quarter sheet, eighth sheet.

/obj/machinery/rnd/production/circuit_imprinter/offstation
	name = "ancient circuit imprinter"
	desc = "Manufactures circuit boards for the construction of machines. Its ancient construction may limit its ability to print all known technology."
	allowed_buildtypes = AWAY_IMPRINTER
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/offstation
	charges_tax = FALSE
