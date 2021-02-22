// Attempts to offload processing for the spreading plants from the MC.
// Processes vines/spreading plants.

#define PLANTS_PER_TICK 500 // Cap on number of plant segments processed.
#define PLANT_TICK_TIME 75  // Number of ticks between the plant processor cycling.

// Debug for testing seed genes.
/client/proc/show_plant_genes()
	set category = "Debug"
	set name = "Show Plant Genes"
	set desc = "Prints the round's plant gene masks."

	if(!holder)	return

	if(!plant_controller || !plant_controller.gene_tag_masks)
		to_chat(usr, "Gene masks not set.")
		return

	for(var/mask in plant_controller.gene_tag_masks)
		to_chat(usr, "[mask]: [plant_controller.gene_tag_masks[mask]]")

var/global/datum/controller/plants/plant_controller // Set in New().

/datum/controller/plants

	var/list/product_descs = list()         // Stores generated fruit descs.
	var/list/seeds = list()                 // All seed data stored here.
	var/list/gene_tag_masks = list()        // Gene obfuscation for delicious trial and error goodness.
	var/list/plant_icon_cache = list()      // Stores images of growth, fruits and seeds.
	var/list/plant_sprites = list()         // List of all harvested product sprites.
	var/list/plant_product_sprites = list() // List of all growth sprites plus number of growth stages.
	var/list/gene_masked_list = list()		// Stored gene masked list, rather than recreating it when needed.
	var/list/plant_gene_datums = list()		// Stored datum versions of the gene masked list.

/datum/controller/plants/New()
	if(plant_controller && plant_controller != src)
		log_debug("Rebuilding plant controller.")
		qdel(plant_controller)
	plant_controller = src
	setup()

// Predefined/roundstart varieties use a string key to make it
// easier to grab the new variety when mutating. Post-roundstart
// and mutant varieties use their uid converted to a string instead.
// Looks like shit but it's sort of necessary.
/datum/controller/plants/proc/setup()

	// Build the icon lists.
	for(var/icostate in icon_states('icons/obj/hydroponics_growing.dmi'))
		var/split = findtext(icostate,"-")
		if(!split)
			// invalid icon_state
			continue

		var/ikey = copytext(icostate,(split+1))
		if(ikey == "dead")
			// don't count dead icons
			continue
		ikey = text2num(ikey)
		var/base = copytext(icostate,1,split)

		if(!(plant_sprites[base]) || (plant_sprites[base]<ikey))
			plant_sprites[base] = ikey

	for(var/icostate in icon_states('icons/obj/hydroponics_products.dmi'))
		var/split = findtext(icostate,"-")
		if(split)
			plant_product_sprites |= copytext(icostate,1,split)

	// Populate the global seed datum list.
	for(var/type in typesof(/datum/seed)-/datum/seed)
		var/datum/seed/S = new type
		seeds[S.name] = S
		S.uid = "[seeds.len]"
		S.roundstart = 1

	// Make sure any seed packets that were mapped in are updated
	// correctly (since the seed datums did not exist a tick ago).
	for(var/obj/item/seeds/S in world)
		S.update_seed()

/*
	//Might as well mask the gene types while we're at it.
	var/list/gene_datums = decls_repository.get_decls_of_subtype(/decl/plantgene)
	var/list/used_masks = list()
	var/list/plant_traits = ALL_GENES
	while(plant_traits && plant_traits.len)
		var/gene_tag = pick(plant_traits)
		var/gene_mask = "[uppertext(num2hex(rand(0,255)))]"

		while(gene_mask in used_masks)
			gene_mask = "[uppertext(num2hex(rand(0,255)))]"

		var/decl/plantgene/G

		for(var/D in gene_datums)
			var/decl/plantgene/P = gene_datums[D]
			if(gene_tag == P.gene_tag)
				G = P
				gene_datums -= D
		used_masks += gene_mask
		plant_traits -= gene_tag
		gene_tag_masks[gene_tag] = gene_mask
		plant_gene_datums[gene_mask] = G
		gene_masked_list.Add(list(list("tag" = gene_tag, "mask" = gene_mask)))
*/
// Proc for creating a random seed type.
/datum/controller/plants/proc/create_random_seed(var/survive_on_station)
	var/datum/seed/seed = new()
	seed.randomize()
	seed.uid = plant_controller.seeds.len + 1
	seed.name = "[seed.uid]"
	seeds[seed.name] = seed

	if(survive_on_station)
		if(seed.consume_gasses)
			seed.consume_gasses[MATERIAL_PHORON] = null
			seed.consume_gasses["carbon_dioxide"] = null
		if(seed.chems && !isnull(seed.chems[/datum/reagent/acid/triflicacid]))
			seed.chems[/datum/reagent/acid/triflicacid] = null // Eating through the hull will make these plants completely inviable, albeit very dangerous.
			seed.chems -= null // Setting to null does not actually remove the entry, which is weird.
		seed.set_trait(TRAIT_IDEAL_HEAT,293)
		seed.set_trait(TRAIT_HEAT_TOLERANCE,20)
		seed.set_trait(TRAIT_IDEAL_LIGHT,4)
		seed.set_trait(TRAIT_LIGHT_TOLERANCE,5)
		seed.set_trait(TRAIT_LOWKPA_TOLERANCE,25)
		seed.set_trait(TRAIT_HIGHKPA_TOLERANCE,200)
	return seed
