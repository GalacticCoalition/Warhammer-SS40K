/**
 * Little tidbits of past events generated by the player doing things.
 *
 * Can be used in engravings, dreams, and changeling succs.
 *
 * All of those things are supposed to be taken vaguely -
 * Engravings crossround and should not include names, dreams and succs are memory goop.
 * As such, the generated text of the memory is vague.
 *
 * Don't hold any references in this, it's not necessary.
 */
/datum/memory
	/// The name of the MEMORY that the user sees.
	/// Something like "The time the Clown did a sweet flip".
	var/name
	/// Job of the person memorizing the event
	var/memorizer
	/// Mind of who is memorizing the event
	var/datum/mind/memorizer_mind
	/// The value of the mood in it's worth as a story.
	/// Defines how beautiful art from it can be, and whether or not it stays in persistence.
	var/story_value = STORY_VALUE_NONE
	/// Flags of any special behavior for the memory
	var/memory_flags = NONE
	/// If this memory changes based on mood, this is the verb it uses.
	var/mood_verb

	// Below are common infobits passed to memories, placed into strings.
	// You can add your own to subtypes of memories to add more infobits.
	// Just remember to override New() with your additional arguments
	// (And call parent at the end of your override, not the beginning).

	/// The main character of the memory.
	var/protagonist_name
	/// The side character of the memory.
	var/deuteragonist_name
	/// The main villain of the memory.
	var/antagonist_name
	/// Where this memory took place.
	var/where

/datum/memory/New(
	datum/mind/memorizer_mind,
	atom/protagonist,
	atom/deuteragonist,
	atom/antagonist,
	...
)

	// If we weren't supplied a protag, use our memorizer by default.
	if(isnull(protagonist))
		protagonist = memorizer_mind.current

	src.memorizer_mind = memorizer_mind
	src.memorizer = build_story_character(memorizer_mind)
	src.protagonist_name = build_story_character(protagonist)
	src.deuteragonist_name = build_story_character(deuteragonist)
	src.antagonist_name = build_story_character(antagonist)

	if(!src.where && isatom(protagonist) && !(memory_flags & MEMORY_FLAG_NOLOCATION))
		src.where = get_area_name(protagonist)

	if(!(memory_flags & MEMORY_FLAG_NOMOOD))
		var/story_mood = MOODLESS_MEMORY
		if(isliving(protagonist))
			var/mob/living/the_main_character = protagonist
			story_mood = the_main_character.mob_mood?.mood_level || MOODLESS_MEMORY

		select_mood_verb(story_mood)

	// This happens after everything's all set, remember this for New overrides
	generate_memory_name()

/datum/memory/Destroy(force, ...)
	memorizer_mind = null
	return ..()

/datum/memory/serialize_list(list/options, list/semvers)
	. = ..()

	.["name"] = name
	.["memorizer"] = memorizer
	.["story_value"] = story_value
	.["memory_flags"] = memory_flags
	.["mood_verb"] = mood_verb
	.["protagonist_name"] = protagonist_name
	.["deuteragonist_name"] = deuteragonist_name
	.["antagonist_name"] = antagonist_name
	.["where"] = where

	SET_SERIALIZATION_SEMVER(semvers, "1.0.0")
	return .

/**
 * Generates a name for the memory.
 */
/datum/memory/proc/generate_memory_name()
	var/list/potential_names = get_names()
	if(!length(potential_names))
		// Someone forgot to implement get_names - it will stack trace, so we just need to return
		name = "Erroneous memory - This is a bug"
		story_value = STORY_VALUE_SHIT
		memory_flags |= (MEMORY_FLAG_NOPERSISTENCE|MEMORY_NO_STORY)
		return

	name = capitalize(pick(potential_names))

/**
 * Selects a mood related verb for the memory.
 *
 * Arguments
 * * story_mood - What mood level should we use to select a verb from?
 */
/datum/memory/proc/select_mood_verb(story_mood)
	if(story_mood == MOODLESS_MEMORY)
		// The protagonist didn't end up having a mood, so just continue on
		memory_flags |= MEMORY_FLAG_NOMOOD
		return

	var/list/possible_verbs
	switch(story_mood)
		if(MOOD_SAD4 to MOOD_SAD2)
			possible_verbs = get_sad_moods()

		if(MOOD_SAD2 to MOOD_HAPPY2)
			possible_verbs = get_neutral_moods()

		if(MOOD_HAPPY2 to MOOD_HAPPY4)
			possible_verbs = get_happy_moods()

	if(!length(possible_verbs))
		return

	mood_verb = pick(possible_verbs)

/**
 * Returns a list of names for [proc/select_mood_verb] to select from.
 *
 * This is necessary to implement. Names should be at-a-glance summaries of what the memory entails.
 *
 * For example: "The time the Clown did a sweet flip.".
 * You can use any information tidbits in your names to fill them out.
 * Your names should be puncuated.
 */
/datum/memory/proc/get_names()
	SHOULD_CALL_PARENT(FALSE)
	stack_trace("[type] didn't have any names setup, these are necessary for all memories!")
	return list()

/**
 * Returns a list of story starts for the memory.
 *
 * Starts are necessary if [MEMORY_FLAG_NOSTORY] is not set. They are used in generating stories out of memories.
 *
 * For example: "The Clown cracks his hands and honks his horn as he prepares to do a backflip".
 * You can use any information tidbits in your names to fill them out.
 * If the memory is not [MEMORY_FLAG_NOMOOD], your starts should NOT be puncuated, as a mood phrase will follow.
 * They should also be in the present tense.
 */
/datum/memory/proc/get_starts()
	SHOULD_CALL_PARENT(FALSE)
	stack_trace("[type] didn't have any starts setup, these are necessary if the MEMORY_FLAG_NOSTORY is not set!")
	return list()

/**
 * Returns a list of mood phrases for the memory.
 *
 * Mood phrases are necessary if [MEMORY_FLAG_NOMOOD] is not set. They are used in making stories out of memories.
 * These are phrases that change in their verbage depending on the mood of the PROTAGONIST at the time of the memory.
 *
 * For example: "The clown grins (this is the mood verb) at the audience.".
 * You can use any information tidbits in your names to fill them out.
 * Mood phrases should be punctated, as they are their own independent clause.
 * Mood phrases should always include the [mood_verb] var, as well.
 */
/datum/memory/proc/get_moods()
	SHOULD_CALL_PARENT(FALSE)
	stack_trace("[type] didn't have any mood phrases, these are necessary if the MEMORY_FLAG_NOMOOD is not set!")
	return list()

/**
 * Used to select a mood verb if the protagonist is happy for memories that do not have [MEMORY_FLAG_NOMOOD] set.
 */
/datum/memory/proc/get_happy_moods()
	return list(
		"chuckles",
		"has a huge grin",
		"has a twisted grin like a maniac",
		"is silently working away like a pro",
		"looks determined",
		"seems cheerful about it all",
		"seems confident",
		"whistles to themselves",
	)

/**
 * Used to select a mood verb if the protagonist is neither happy or sad for memories that do not have [MEMORY_FLAG_NOMOOD] set.
 */
/datum/memory/proc/get_neutral_moods()
	return list(
		"appears clueless",
		"is darting their eyes around",
		"is impatient",
		"is uninterested",
		"looks around cautiously",
		"seems a bit sleepy",
		"seems okay",
		"works diligently",
	)


/**
 * Used to select a mood verb if the protagonist is sad for memories that do not have [MEMORY_FLAG_NOMOOD] set.
 */
/datum/memory/proc/get_sad_moods()
	return list(
		"appears crushed",
		"has dried tears on their face",
		"is complaining loudly",
		"is having a temper tantrum",
		"is whiney about it all",
		"looks angry",
		"seems sad",
	)

/**
 * Returns a list of locations for use in stories which do not have [MEMORY_FLAG_NOLOCATION] set.
 */
/datum/memory/proc/get_locations()
	return list(
		"in [where].",
		"while in [where]."
	)

/**
 * Generates a story based on this memory.
 *
 * Arguments
 * * story_type - for used in grabbing phrases from memories.json involving specific types of stories.
 * * story_flags - any additional flags involving the story
 */
/datum/memory/proc/generate_story(story_type, story_flags)

	//entirely independent vars (not related to the action or story type)

	var/static/list/something_pool = list(
		/mob/living/basic/bat,
		/mob/living/basic/butterfly,
		/mob/living/basic/carp,
		/mob/living/basic/carp/magic,
		/mob/living/basic/carp/magic/chaos,
		/mob/living/basic/chick,
		/mob/living/basic/chicken,
		/mob/living/basic/cow,
		/mob/living/basic/cow/wisdom,
		/mob/living/basic/crab,
		/mob/living/basic/giant_spider,
		/mob/living/basic/giant_spider/hunter,
		/mob/living/basic/mining/goliath,
		/mob/living/basic/headslug,
		/mob/living/basic/killer_tomato,
		/mob/living/basic/lizard,
		/mob/living/basic/mouse,
		/mob/living/basic/pet/dog/breaddog,
		/mob/living/basic/pet/dog/corgi,
		/mob/living/basic/pet/dog/pug,
		/mob/living/basic/pet/fox,
		/mob/living/basic/statue,
		/mob/living/basic/stickman,
		/mob/living/basic/stickman/dog,
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher,
		/mob/living/simple_animal/hostile/bear,
		/mob/living/simple_animal/hostile/blob/blobbernaut/independent,
		/mob/living/simple_animal/hostile/gorilla,
		/mob/living/simple_animal/hostile/megafauna/dragon/lesser,
		/mob/living/simple_animal/hostile/morph,
		/mob/living/simple_animal/hostile/mushroom,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/pet/cat,
		/mob/living/simple_animal/pet/cat/cak,
		/obj/item/food/sausage/american,
		/obj/item/skub,
	)

	// These are picked from the json
	var/list/forewords = strings(MEMORY_FILE, story_type + "_forewords")
	var/list/somethings = strings(MEMORY_FILE, story_type + "_somethings")
	var/list/styles
	if(!(story_flags & STORY_FLAG_NO_STYLE))
		styles = strings(MEMORY_FILE, "styles")
		if("[story_type]_styles" in GLOB.string_cache[MEMORY_FILE])
			styles += strings(MEMORY_FILE, story_type + "_styles")

	// These are picked from the datum
	var/list/wheres = (memory_flags & MEMORY_FLAG_NOLOCATION) ? null : get_locations()
	var/list/story_starts = get_starts()
	var/list/story_mood_sentences = (memory_flags & MEMORY_FLAG_NOMOOD) ? null : get_moods()
	var/mob/living/crew_member
	var/atom/something = pick(something_pool) //Pick a something for the potential something line

	// This can be signalized or something in the future
	var/datum/antagonist/obsessed/creeper = memorizer_mind.has_antag_datum(/datum/antagonist/obsessed)
	if(creeper && creeper.trauma.obsession)
		crew_member = creeper.trauma.obsession //ALWAYS ENGRAVE MY OBSESSION!

	// Get a random crewmember
	else
		var/list/crew_members = list()
		for(var/mob/living/carbon/human/potential_crew_member as anything in GLOB.human_list)
			if(potential_crew_member.mind?.assigned_role.job_flags & JOB_CREW_MEMBER)
				crew_members += potential_crew_member

		crew_member = length(crew_members) ? pick(crew_members) : "an unknown crewmember"

	//storybuilding
	var/list/story_pieces = list()

	//The forewords for this specific type of story (E.g. This engraving depicts)
	story_pieces += pick(forewords)
	//The story start for this specific action. (E.g. The Chef carving into The Clown)
	story_pieces += pick(story_starts)
	//The location it happend, which isn't always included, but commonly is. (E.g. in Space, while in the Bar)
	if(length(wheres))
		story_pieces += pick(wheres)
	//Shows how the protagonist felt about it all (E.g. The Chef is looking sad as they tear into The Clown.)
	if(length(story_mood_sentences))
		story_pieces += pick(story_mood_sentences)
	//A nonsensical addition, using the memorizer, protagonist or even random crew / things (E.g. in the meantime, the Clown is being arrested, clutching a skub.")
	if(prob(75))
		var/chosen_addition = pick(somethings)
		chosen_addition = replacetext(chosen_addition, "%MEMORIZER", "[memorizer]")
		chosen_addition = replacetext(chosen_addition, "%PROTAGONIST", protagonist_name)
		chosen_addition = replacetext(chosen_addition, "%SOMETHING", initial(something.name))
		chosen_addition = replacetext(chosen_addition, "%CREWMEMBER", build_story_character(crew_member))
		chosen_addition = replacetext(chosen_addition, "%STORY_TYPE", story_type)

		story_pieces += chosen_addition
	//Explains any unique styling the art has. e.g. (The engraving has a cubist style.)
	if(length(styles) && prob(75))
		story_pieces += pick(styles)

	var/parsed_story = ""

	var/capitalize_next_line = FALSE

	for(var/line in story_pieces)
		if(capitalize_next_line)
			line = capitalize(line)
			capitalize_next_line = FALSE

		if(line[length(line)] == ".")//End of sentence, next sentence needs to start with a capital.'
			capitalize_next_line = TRUE

		if(line != story_pieces[story_pieces.len]) //not the last line
			parsed_story += "[line] "

	//after replacement section for performance
	if(story_flags & STORY_FLAG_DATED)
		if(memory_flags & MEMORY_FLAG_NOSTATIONNAME)
			parsed_story += "This took place in [time2text(world.realtime, "Month")] of [CURRENT_STATION_YEAR]."
		else
			parsed_story += "This took place in [time2text(world.realtime, "Month")] of [CURRENT_STATION_YEAR] on [station_name()]."

	parsed_story = trim_right(parsed_story)

	return parsed_story

/**
 * When passed a "character", returns the name of the character formatted for stories
 *
 * If character is a string, it will just return it back.
 *
 * Otherwise, it will try to generate a title based on the mob's assigned role.
 *
 * If the character has no mind or no assigned role, it'll just return their name.
 */
/datum/memory/proc/build_story_character(character)
	if(isnull(character))
		return
	if(istext(character))
		return character

	if(isliving(character))
		var/mob/living/living_character = character
		if(living_character.mind && !is_unassigned_job(living_character.mind.assigned_role))
			character = living_character.mind

		else if(ishuman(character))
			// This can slip into memories involving monkey humans.
			return "the unfamiliar person"

	if(istype(character, /datum/mind))
		var/datum/mind/character_mind = character
		return "\the [lowertext(initial(character_mind.assigned_role.title))]"

	// Generic result - mobs get "the guy", objs / turfs get "a thing"
	return ismob(character) ? "\the [character]" : "\a [character]"

/**
 * Creates a "quick copy" of the memory for another mind,
 * copying just basic memory information (name, major charactecrs) over.
 *
 * The copied memory cannot be used for stories or anything.
 * They should generally only be used to give a new mind an idea of another mind's memories.
 */
/datum/memory/proc/quick_copy_memory(datum/mind/new_memorizer)
	var/datum/memory/copy/new_copy = new(new_memorizer, protagonist_name, deuteragonist_name, antagonist_name, where, memory_flags)
	new_copy.name = name
	new_copy.story_value = story_value
	return new_copy

// To only be used by quick copies of memories
/datum/memory/copy
	memory_flags = MEMORY_NO_STORY

/datum/memory/copy/New(datum/mind/memorizer_mind, atom/protagonist, atom/deuteragonist, atom/antagonist, where, new_memory_flags)
	src.where = where
	src.memory_flags |= new_memory_flags
	return ..()

/datum/memory/copy/generate_memory_name()
	// We just copy the original memory's name anyways
	return
