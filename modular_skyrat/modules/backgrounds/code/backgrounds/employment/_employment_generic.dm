/datum/background_info/employment/squatter
	name = "Station Squatter"
	description = "You are not a Nanotrasen employee. You pretend to work here after tricking the Head of Personnel to give you an ID, \
	so you can stay and eat their food rent-free. \
	<br><br> \
	Lock you into the hidden squatter role if taken. \
	<br><br> \
	You start with an emergency toolbox, a bulky crowbar, a fire extinguisher, and a welding tool."
	features = list(
		/datum/background_feature/penniless,
		/datum/background_feature/off_manifest,
		)
	economic_power = 0
	fake_name = "Nanotrasen Intern"
	veteran = TRUE
	false_if_in_roles = FALSE
	hidden_from_characters = TRUE
	roles = list(/datum/job/assistant/squatter)

/datum/background_info/employment/lopland
	name = "Lopland Contractor"
	description = "Even though you work at a security firm, you are still given clearance to work on other types of work at Nanotrasen. \
	How weird. It must be a tax thing."
	features = list(/datum/background_feature/average)
	groups = BACKGROUNDS_GROUP_FARING

/datum/background_info/employment/veymed
	name = "Vey-Med Contractor"
	description = "You are one of the many Vey-Med employees, one of the more recent alien corporations to begin operating within Sector 13 space. \
	Founded by the Vulpkan-Skrell'aan Assembly, it is exclusively staffed with Vulpkanin and Skrell. Despite being a newborn corporation within the sector, \
	Vey-Med still pays you well for work alongside Nanotrasen. Despite a few unfounded rumors of corporate espionage from either company, \
	you're still given clearance to work in all the various departments of Nanotrasen, for some reason."
	features = list(/datum/background_feature/good)
	groups = BACKGROUNDS_SKRELL_VULPAKIN

/datum/background_info/employment/unathi
	name = "Unathi Migrant Worker"
	description = "You are a documented worker from Unathi. Due to your exceptional strength, endurance, or talent along with willingness to work for less, \
	you have been brought from Moghes to work in the Sol Federation for Nanotrasen. You may not be culturally compatible with your co-workers. \
	No, Crew Resources doesn't care."
	features = list(/datum/background_feature/poor)
	groups = BACKGROUNDS_MOHGES
