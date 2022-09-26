/obj/machinery/modular_computer/console
	name = "console"
	desc = "A stationary computer."

	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_powered = "console"
	icon_state_unpowered = "console-off"
	screen_icon_state_menu = "menu"
	hardware_flag = PROGRAM_CONSOLE
	density = TRUE
	base_idle_power_usage = 100
	base_active_power_usage = 500
	max_hardware_size = 4
	steel_sheet_cost = 10
	light_strength = 2
	max_integrity = 300
	integrity_failure = 0.5
	///Used in New() to set network tag according to our area.
	var/console_department = ""

/obj/machinery/modular_computer/console/buildable/Initialize(mapload)
	. = ..()
	// User-built consoles start as empty frames.
	var/obj/item/computer_hardware/hard_drive/hard_drive = cpu.all_components[MC_HDD]
<<<<<<< HEAD
	var/obj/item/computer_hardware/hard_drive/network_card = cpu.all_components[MC_NET]
	var/obj/item/computer_hardware/hard_drive/recharger = cpu.all_components[MC_CHARGE]
	qdel(recharger)
	qdel(network_card)
=======
>>>>>>> 7c990173e0b (Removes network cards and printers from tablets (#70110))
	qdel(hard_drive)

/obj/machinery/modular_computer/console/Initialize(mapload)
	. = ..()
	var/obj/item/computer_hardware/battery/battery_module = cpu.all_components[MC_CELL]
	if(battery_module)
		qdel(battery_module)

<<<<<<< HEAD
	var/obj/item/computer_hardware/network_card/wired/network_card = new()

	cpu.install_component(network_card)
	cpu.install_component(new /obj/item/computer_hardware/recharger/apc_recharger)
=======
>>>>>>> 7c990173e0b (Removes network cards and printers from tablets (#70110))
	cpu.install_component(new /obj/item/computer_hardware/hard_drive/super) // Consoles generally have better HDDs due to lower space limitations

	if(cpu)
		cpu.screen_on = TRUE
	update_appearance()
