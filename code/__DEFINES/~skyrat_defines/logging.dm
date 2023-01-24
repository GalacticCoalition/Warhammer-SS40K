// Logging types for log_message()
#define LOG_SUBTLER (1 << 22)

//Individual logging panel pages
#undef INDIVIDUAL_EMOTE_LOG
#define INDIVIDUAL_EMOTE_LOG (LOG_EMOTE | LOG_SUBTLER)
#undef INDIVIDUAL_SHOW_ALL_LOG
#define INDIVIDUAL_SHOW_ALL_LOG (LOG_ATTACK | LOG_SAY | LOG_WHISPER | LOG_EMOTE | LOG_SUBTLER | LOG_DSAY | LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS | LOG_OOC | LOG_ADMIN | LOG_OWNERSHIP | LOG_GAME | LOG_ADMIN_PRIVATE | LOG_ASAY | LOG_MECHA | LOG_VIRUS | LOG_SHUTTLE | LOG_ECON)

// Investigate
#define INVESTIGATE_CIRCUIT			"circuit"

GLOBAL_VAR(event_vote_log)
GLOBAL_PROTECT(event_vote_log)

	start_log(GLOB.event_vote_log)
	start_log(GLOB.character_creation_log)
