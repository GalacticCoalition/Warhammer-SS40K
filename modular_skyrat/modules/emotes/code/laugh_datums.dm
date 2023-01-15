GLOBAL_LIST_EMPTY(laugh_types)

/datum/laugh_type
	var/name
	var/donator_only = FALSE
	var/list/male_laughsounds
	var/list/female_laughsounds
	var/restricted_species_type

/datum/laugh_type/none //Why would you want this?
	name = "No Laugh"
	male_laughsounds = null
	female_laughsounds = null

/datum/laugh_type/human
	name = "Human Laugh"
	male_laughsounds = list('sound/voice/human/manlaugh1.ogg',
						'sound/voice/human/manlaugh2.ogg')
	female_laughsounds = list('modular_skyrat/modules/emotes/sound/emotes/female/female_giggle_1.ogg',
					'modular_skyrat/modules/emotes/sound/emotes/female/female_giggle_2.ogg')

/datum/laugh_type/felinid
	name = "Felinid Laugh"
	male_laughsounds = list('modular_skyrat/modules/emotes/sound/emotes/nyahaha1.ogg',
			'modular_skyrat/modules/emotes/sound/emotes/nyahaha2.ogg',
			'modular_skyrat/modules/emotes/sound/emotes/nyaha.ogg',
			'modular_skyrat/modules/emotes/sound/emotes/nyahehe.ogg')
	female_laughsounds = null
	
/datum/laugh_type/hyena
	name = "Hyena Laugh"
	male_laughsounds = list('modular_skyrat/modules/emotes/sound/emotes/hyenalaugh1.ogg',
			'modular_skyrat/modules/emotes/sound/emotes/hyenalaugh2.ogg',
			'modular_skyrat/modules/emotes/sound/emotes/hyenalaugh3.ogg',
			'modular_skyrat/modules/emotes/sound/emotes/hyenalaugh4.ogg')
	female_laughsounds = null

/datum/laugh_type/snake
	name = "Snake Laugh"
	male_laughsounds = list('modular_skyrat/modules/emotes/sound/emotes/sneklaugh1.ogg')
	female_laughsounds = null

/datum/laugh_type/corvid
	name = "Corvid Laugh"
	male_laughsounds = list('modular_skyrat/modules/emotes/sound/emotes/crowlaugh1.ogg',
			'modular_skyrat/modules/emotes/sound/emotes/crowlaugh2.ogg')
	female_laughsounds = null

/datum/laugh_type/moth
	name = "Moth Laugh"
	male_laughsounds = list('modular_skyrat/modules/emotes/sound/emotes/mothlaugh.ogg')
	female_laughsounds = null
	restricted_species_type = /datum/species/moth

/datum/laugh_type/insect
	name = "Insect Laugh"
	male_laughsounds = list('modular_skyrat/modules/emotes/sound/emotes/mothlaugh.ogg')
	female_laughsounds = null
	restricted_species_type = /datum/species/insect
