/datum/job/corporate_diplomat
	// Things that generally |shouldn't| be overridden by role datums
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 14
	exp_requirements = 600
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "CORPORATE_DIPLOMAT"
	department_for_prefs = /datum/job_department/captain
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_CMD
	bounty_types = CIV_JOB_SEC
	veteran_only = TRUE
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_BOLD_SELECT_TEXT | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS


	// Things that probably will be overridden
	supervisors = "Central Command"
	title = JOB_CORPORATE_DIPLOMAT
	description = "Your alternate title will decide the job type if you get picked as the roundstart Corporate Diplomat."
	department_head = list(JOB_CENTCOM)
	departments_list = list(
		/datum/job_department/command,
	)
	outfit = /datum/outfit/job/nanotrasen_consultant/initial
	plasmaman_outfit = /datum/outfit/plasmaman/nanotrasen_consultant
	display_order = JOB_DISPLAY_ORDER_NANOTRASEN_CONSULTANT
	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law)
	mail_goodies = list(
		/obj/item/clothing/mask/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 10,
	)
	alt_titles = list(
		"Nanotrasen Consultant",
		"Solar Federation Liaison",
		"Armadyne Representative",
	)


/datum/job/corporate_diplomat/New()
	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(set_random_type))
	return ..()


// We do this to ensure that the diplomat only spawns with their type's outfit, later.
/datum/job/corporate_diplomat/pre_spawn(mob/living/spawning, client/player_client)
	if(ispath(outfit, /datum/outfit/job/nanotrasen_consultant/initial))
		outfit = /datum/outfit
		plasmaman_outfit = /datum/outfit/plasmaman


/datum/job/corporate_diplomat/after_roundstart_spawn(mob/living/spawning, client/player_client)
	. = ..()
	if(!player_client.prefs.alt_job_titles[JOB_CORPORATE_DIPLOMAT]) // Default to NTC if they didn't choose one
		player_client.prefs.alt_job_titles[JOB_CORPORATE_DIPLOMAT] = "Nanotrasen Consultant"

	switch(player_client.prefs.alt_job_titles[JOB_CORPORATE_DIPLOMAT])
		if("Nanotrasen Consultant")
			set_diplomat_type(/datum/corporate_diplomat_role/nanotrasen_consultant, player_client, spawning)

		if("Solar Federation Liaison")
			set_diplomat_type(/datum/corporate_diplomat_role/solfed_liaison, player_client, spawning)

		if("Armadyne Representative")
			set_diplomat_type(/datum/corporate_diplomat_role/armadyne_representative, player_client, spawning)


/// If someone joins roundstart, it'll set the diplomat type to be their choice.
/// If nobody joins, then it'll be randomly chosen through `set_random_type()`
/datum/job/corporate_diplomat/proc/set_diplomat_type(datum/corporate_diplomat_role/picked_role, client/player_client, mob/living/carbon/human/spawning)
	picked_role = new picked_role

	// SSjob handling
	SSjob.corporate_diplomat_type = picked_role.type
	SSjob.name_occupations -= JOB_CORPORATE_DIPLOMAT
	SSjob.name_occupations[picked_role.title] = src

	SEND_SIGNAL(SSjob, COMSIG_CORPORATE_DIPLOMAT_ROLE_PICKED)

	if(istype(spawning))
		spawning.equipOutfit(new picked_role.outfit)

	// Carrying over data to the job from the datum
	title = picked_role.title
	description = picked_role.description
	department_head = picked_role.department_head.Copy()
	supervisors = picked_role.supervisors
	department_for_prefs = picked_role.department_for_prefs
	departments_list |= picked_role.departments_list
	outfit = picked_role.outfit
	plasmaman_outfit = picked_role.plasmaman_outfit
	display_order = picked_role.display_order
	family_heirlooms = picked_role.family_heirlooms.Copy()
	mail_goodies = picked_role.mail_goodies.Copy()

	// Code for sticking in a new department to SSjob
	var/type_dept = picked_role.departments_list[1]
	var/datum/job_department/our_dept = new type_dept
	SSjob.joinable_departments += our_dept
	SSjob.joinable_departments_by_type[our_dept.type] = our_dept
	sortTim(SSjob.joinable_departments_by_type, GLOBAL_PROC_REF(cmp_department_display_asc), associative = TRUE)
	our_dept.add_job(src)

	// Delete the hanging datum
	qdel(picked_role)


/// Selects a random type on round start if nobody took the role.
/datum/job/corporate_diplomat/proc/set_random_type()
	SIGNAL_HANDLER

	if(SSjob.corporate_diplomat_type)
		set_diplomat_type(SSjob.corporate_diplomat_type)
		UnregisterSignal(src, COMSIG_TICKER_ROUND_STARTING)
		return

	if(!current_positions)
		var/datum/corporate_diplomat_role/picked_role = pick(subtypesof(/datum/corporate_diplomat_role))
		set_diplomat_type(picked_role)
		UnregisterSignal(src, COMSIG_TICKER_ROUND_STARTING)
		return


// make sure to fill ALL of these out on the subtype
/datum/corporate_diplomat_role
	/// The associated access level with the role
	var/used_access

	// Everything below is mirrored from /datum/job, including comments

	/// The name of the job , used for preferences, bans and more. Make sure you know what you're doing before changing this.
	var/title

	/// The description of the job, used for preferences menu.
	/// Keep it short and useful. Avoid in-jokes, these are for new players.
	var/description

	/// Determines who can demote this position
	var/list/department_head = list()

	/// Supervisors, who this person answers to directly
	var/supervisors

	/// If specified, this department will be used for the preferences menu.
	var/datum/job_department/department_for_prefs

	/// Lazy list with the departments this job belongs to.
	/// Required to be set for playable jobs.
	/// The first department will be used in the preferences menu,
	/// unless department_for_prefs is set.
	/// For this var specifically, only add the unique dept type, /datum/job_department/command is added automatically
	var/list/departments_list = list()

	/// The job's outfit.
	var/outfit

	/// The job's outfit that will be assigned for plasmamen.
	var/plasmaman_outfit

	var/display_order

	// List of family heirlooms this job can get with the family heirloom quirk. List of types.
	var/list/family_heirlooms = list()

	/// Goodies that can be received via the mail system.
	/// this is a weighted list.
	/// Keep the _job definition for this empty and use /obj/item/mail to define general gifts.
	var/list/mail_goodies = list()

