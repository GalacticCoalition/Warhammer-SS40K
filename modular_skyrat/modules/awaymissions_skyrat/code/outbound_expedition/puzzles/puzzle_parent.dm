/datum/outbound_teamwork_puzzle
	/// Name of the puzzle
	var/name = "Generic"
	/// Reference to the terminal that this puzzle is accessable through
	var/obj/machinery/outbound_puzzle_terminal/terminal
	/// Name of the TGUI UI the terminal will open
	var/tgui_name = ""
	/// Name of the terminal
	var/terminal_name = ""
	/// Description of the terminal
	var/terminal_desc = ""

/datum/outbound_teamwork_puzzle/Destroy(force, ...)
	if(terminal)
		terminal = null // terminal destroys the puzzle, puzzle does not destroy the terminal
	return ..()

/// What happens when the puzzle is fucked up and answered incorrectly
/datum/outbound_teamwork_puzzle/proc/fail()
	return
