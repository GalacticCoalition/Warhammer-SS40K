#define RND_CATEGORY_NRI_FOOD "Provision"
#define RND_CATEGORY_NRI_MEDICAL "Medicine"
#define RND_CATEGORY_NRI_CLOTHING "Apparel"

/obj/machinery/biogenerator/food_replicator
	name = "\improper BEEP colonial supplier"
	desc = "This handy, ancient machine replicates food and clothing and medicine previously utilised by the pioneer colonists of what's now known as the NRI."
	icon = 'modular_skyrat/modules/novaya_ert/icons/biogenerator.dmi'
	circuit = /obj/item/circuitboard/machine/biogenerator/food_replicator
	efficiency = 0.75
	productivity = 0.75
	show_categories = list(
		RND_CATEGORY_NRI_FOOD,
		RND_CATEGORY_NRI_MEDICAL,
		RND_CATEGORY_NRI_CLOTHING,
	)

/obj/item/circuitboard/machine/biogenerator/food_replicator
	name = "Food Replicator"
	build_path = /obj/machinery/biogenerator/food_replicator
