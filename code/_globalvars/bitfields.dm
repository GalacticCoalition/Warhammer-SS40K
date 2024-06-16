GLOBAL_LIST_INIT(bitfields, generate_bitfields())

/// Specifies a bitfield for smarter debugging
/datum/bitfield
	/// The variable name that contains the bitfield
	var/variable

	/// An associative list of the readable flag and its true value
	var/list/flags

/// Turns /datum/bitfield subtypes into a list for use in debugging
/proc/generate_bitfields()
	var/list/bitfields = list()
	for (var/_bitfield in subtypesof(/datum/bitfield))
		var/datum/bitfield/bitfield = new _bitfield
		bitfields[bitfield.variable] = bitfield.flags
	return bitfields

DEFINE_BITFIELD(admin_flags, list(
	"ADMIN" = R_ADMIN,
	"AUTOLOGIN" = R_AUTOADMIN,
	"BAN" = R_BAN,
	"BUILDMODE" = R_BUILD,
	"DBRANKS" = R_DBRANKS,
	"DEBUG" = R_DEBUG,
	"FUN" = R_FUN,
	"PERMISSIONS" = R_PERMISSIONS,
	"POLL" = R_POLL,
	"POSSESS" = R_POSSESS,
	"SERVER" = R_SERVER,
	"SOUNDS" = R_SOUND,
	"SPAWN" = R_SPAWN,
	"STEALTH" = R_STEALTH,
	"VAREDIT" = R_VAREDIT,
))

DEFINE_BITFIELD(appearance_flags, list(
	"KEEP_APART" = KEEP_APART,
	"KEEP_TOGETHER" = KEEP_TOGETHER,
	"LONG_GLIDE" = LONG_GLIDE,
	"NO_CLIENT_COLOR" = NO_CLIENT_COLOR,
	"PIXEL_SCALE" = PIXEL_SCALE,
	"PLANE_MASTER" = PLANE_MASTER,
	"RESET_ALPHA" = RESET_ALPHA,
	"RESET_COLOR" = RESET_COLOR,
	"RESET_TRANSFORM" = RESET_TRANSFORM,
	"TILE_BOUND" = TILE_BOUND,
	"PASS_MOUSE" = PASS_MOUSE,
	"TILE_MOVER" = TILE_MOVER,
))

DEFINE_BITFIELD(area_flags, list(
	"BLOBS_ALLOWED" = BLOBS_ALLOWED,
	"BLOCK_SUICIDE" = BLOCK_SUICIDE,
	"CAVES_ALLOWED" = CAVES_ALLOWED,
	"CULT_PERMITTED" = CULT_PERMITTED,
	"FLORA_ALLOWED" = FLORA_ALLOWED,
	"HIDDEN_AREA" = HIDDEN_AREA,
	"MEGAFAUNA_SPAWN_ALLOWED" = MEGAFAUNA_SPAWN_ALLOWED,
	"MOB_SPAWN_ALLOWED" = MOB_SPAWN_ALLOWED,
	"NOTELEPORT" = NOTELEPORT,
	"NO_DEATH_MESSAGE" = NO_DEATH_MESSAGE,
	"PERSISTENT_ENGRAVINGS" = PERSISTENT_ENGRAVINGS,
	"UNIQUE_AREA" = UNIQUE_AREA,
	"VALID_TERRITORY" = VALID_TERRITORY,
	"XENOBIOLOGY_COMPATIBLE" = XENOBIOLOGY_COMPATIBLE,
))

DEFINE_BITFIELD(turf_flags, list(
	"NO_LAVA_GEN" = NO_LAVA_GEN,
	"NO_RUINS" = NO_RUINS,
	"NO_RUST" = NO_RUST,
	"NOJAUNT" = NOJAUNT,
	"IS_SOLID" = IS_SOLID,
	"UNUSED_RESERVATION_TURF" = UNUSED_RESERVATION_TURF,
	"RESERVATION_TURF" = RESERVATION_TURF,
	"TURF_BLOCKS_PLACEATOM" = TURF_BLOCKS_POPULATE_TERRAIN_FLORAFEATURES,
))

DEFINE_BITFIELD(car_traits, list(
	"CAN_KIDNAP" = CAN_KIDNAP,
))

DEFINE_BITFIELD(clothing_flags, list(
	"ANTI_TINFOIL_MANEUVER" = ANTI_TINFOIL_MANEUVER,
	"BLOCKS_SPEECH" = BLOCKS_SPEECH,
	"BLOCK_GAS_SMOKE_EFFECT" = BLOCK_GAS_SMOKE_EFFECT,
	"CASTING_CLOTHES" = CASTING_CLOTHES,
	"GAS_FILTERING" = GAS_FILTERING,
	"HEADINTERNALS" = HEADINTERNALS,
	"INEDIBLE_CLOTHING" = INEDIBLE_CLOTHING,
	"LARGE_WORN_ICON" = LARGE_WORN_ICON,
	"LAVAPROTECT" = LAVAPROTECT,
	"MASKINTERNALS" = MASKINTERNALS,
	"STACKABLE_HELMET_EXEMPT" = STACKABLE_HELMET_EXEMPT,
	"PLASMAMAN_PREVENT_IGNITION" = PLASMAMAN_PREVENT_IGNITION,
	"SNUG_FIT" = SNUG_FIT,
	"STOPSPRESSUREDAMAGE" = STOPSPRESSUREDAMAGE,
	"THICKMATERIAL" = THICKMATERIAL,
	"VOICEBOX_DISABLED" = VOICEBOX_DISABLED,
	"VOICEBOX_TOGGLABLE" = VOICEBOX_TOGGLABLE,
))

DEFINE_BITFIELD(datum_flags, list(
	"DF_ISPROCESSING" = DF_ISPROCESSING,
	"DF_VAR_EDITED" = DF_VAR_EDITED,
	"DF_USE_TAG" = DF_USE_TAG,
))

DEFINE_BITFIELD(disease_flags, list(
	"CAN_CARRY" = CAN_CARRY,
	"CAN_RESIST" = CAN_RESIST,
	"CURABLE" = CURABLE,
))

DEFINE_BITFIELD(flags_1, list(
	"ADMIN_SPAWNED_1" = ADMIN_SPAWNED_1,
	"ALLOW_DARK_PAINTS_1" = ALLOW_DARK_PAINTS_1,
	"ATMOS_IS_PROCESSING_1" = ATMOS_IS_PROCESSING_1,
	"CAN_BE_DIRTY_1" = CAN_BE_DIRTY_1,
	"HAS_CONTEXTUAL_SCREENTIPS_1" = HAS_CONTEXTUAL_SCREENTIPS_1,
	"HAS_DISASSOCIATED_STORAGE_1" = HAS_DISASSOCIATED_STORAGE_1,
	"HOLOGRAM_1" = HOLOGRAM_1,
	"INITIALIZED_1" = INITIALIZED_1,
	"IS_ONTOP_1" = IS_ONTOP_1,
	"IS_PLAYER_COLORABLE_1" = IS_PLAYER_COLORABLE_1,
	"NO_SCREENTIPS_1" = NO_SCREENTIPS_1,
	"ON_BORDER_1" = ON_BORDER_1,
	"PREVENT_CLICK_UNDER_1" = PREVENT_CLICK_UNDER_1,
	"PREVENT_CONTENTS_EXPLOSION_1" = PREVENT_CONTENTS_EXPLOSION_1,
	"SUPERMATTER_IGNORES_1" = SUPERMATTER_IGNORES_1,
	"UNPAINTABLE_1" = UNPAINTABLE_1,
))

DEFINE_BITFIELD(flags_ricochet, list(
	"RICOCHET_HARD" = RICOCHET_HARD,
	"RICOCHET_SHINY" = RICOCHET_SHINY,
))

DEFINE_BITFIELD(interaction_flags_atom, list(
	"INTERACT_ATOM_ATTACK_HAND" = INTERACT_ATOM_ATTACK_HAND,
	"INTERACT_ATOM_CHECK_GRAB" = INTERACT_ATOM_CHECK_GRAB,
	"INTERACT_ATOM_IGNORE_INCAPACITATED" = INTERACT_ATOM_IGNORE_INCAPACITATED,
	"INTERACT_ATOM_IGNORE_RESTRAINED" = INTERACT_ATOM_IGNORE_RESTRAINED,
	"INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND" = INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND,
	"INTERACT_ATOM_NO_FINGERPRINT_INTERACT" = INTERACT_ATOM_NO_FINGERPRINT_INTERACT,
	"INTERACT_ATOM_REQUIRES_ANCHORED" = INTERACT_ATOM_REQUIRES_ANCHORED,
	"INTERACT_ATOM_REQUIRES_DEXTERITY" = INTERACT_ATOM_REQUIRES_DEXTERITY,
	"INTERACT_ATOM_UI_INTERACT" = INTERACT_ATOM_UI_INTERACT,
	"INTERACT_ATOM_ALLOW_USER_LOCATION" = INTERACT_ATOM_ALLOW_USER_LOCATION,
	"INTERACT_ATOM_IGNORE_MOBILITY" = INTERACT_ATOM_IGNORE_MOBILITY,
))

DEFINE_BITFIELD(interaction_flags_machine, list(
	"INTERACT_MACHINE_OPEN" = INTERACT_MACHINE_OPEN,
	"INTERACT_MACHINE_OFFLINE" = INTERACT_MACHINE_OFFLINE,
	"INTERACT_MACHINE_WIRES_IF_OPEN" = INTERACT_MACHINE_WIRES_IF_OPEN,
	"INTERACT_MACHINE_ALLOW_SILICON" = INTERACT_MACHINE_ALLOW_SILICON,
	"INTERACT_MACHINE_OPEN_SILICON" = INTERACT_MACHINE_OPEN_SILICON,
	"INTERACT_MACHINE_REQUIRES_SILICON" = INTERACT_MACHINE_REQUIRES_SILICON,
	"INTERACT_MACHINE_REQUIRES_SIGHT" = INTERACT_MACHINE_REQUIRES_SIGHT,
	"INTERACT_MACHINE_REQUIRES_LITERACY" = INTERACT_MACHINE_REQUIRES_LITERACY,
))

DEFINE_BITFIELD(interaction_flags_item, list(
	"INTERACT_ITEM_ATTACK_HAND_PICKUP" = INTERACT_ITEM_ATTACK_HAND_PICKUP,
))

DEFINE_BITFIELD(item_flags, list(
	"ABSTRACT" = ABSTRACT,
	"BEING_REMOVED" = BEING_REMOVED,
	"DROPDEL" = DROPDEL,
	"EXAMINE_SKIP" = EXAMINE_SKIP,
	"FORCE_STRING_OVERRIDE" = FORCE_STRING_OVERRIDE,
	"HAND_ITEM" = HAND_ITEM,
	"IGNORE_DIGITIGRADE" = IGNORE_DIGITIGRADE,
	"IMMUTABLE_SLOW" = IMMUTABLE_SLOW,
	"IN_INVENTORY" = IN_INVENTORY,
	"IN_STORAGE" = IN_STORAGE,
	"ITEM_HAS_CONTEXTUAL_SCREENTIPS" = ITEM_HAS_CONTEXTUAL_SCREENTIPS,
	"NEEDS_PERMIT" = NEEDS_PERMIT,
	"NOBLUDGEON" = NOBLUDGEON,
	"NO_MAT_REDEMPTION" = NO_MAT_REDEMPTION,
	"NO_PIXEL_RANDOM_DROP" = NO_PIXEL_RANDOM_DROP,
	"SLOWS_WHILE_IN_HAND" = SLOWS_WHILE_IN_HAND,
	"SURGICAL_TOOL" = SURGICAL_TOOL,
	"CRUEL_IMPLEMENT" = CRUEL_IMPLEMENT,
	"XENOMORPH_HOLDABLE" = XENOMORPH_HOLDABLE,
	"NO_BLOOD_ON_ITEM" = NO_BLOOD_ON_ITEM,
))

DEFINE_BITFIELD(flags_inv, list(
	"HIDEEARS" = HIDEEARS,
	"HIDEEYES" = HIDEEYES,
	"HIDEFACE" = HIDEFACE,
	"HIDEFACIALHAIR" = HIDEFACIALHAIR,
	"HIDEGLOVES" = HIDEGLOVES,
	"HIDEHAIR" = HIDEHAIR,
	"HIDEHEADGEAR" = HIDEHEADGEAR,
	"HIDEJUMPSUIT" = HIDEJUMPSUIT,
	"HIDEMASK" = HIDEMASK,
	"HIDENECK" = HIDENECK,
	"HIDESHOES" = HIDESHOES,
	"HIDESNOUT" = HIDESNOUT,
	"HIDESUITSTORAGE" = HIDESUITSTORAGE,
	"SHOWSPRITEEARS" = SHOWSPRITEEARS, // SKYRAT EDIT ADDITION START
	"HIDETAIL" = HIDETAIL,
	"HIDESPINE" = HIDESPINE,
	"HIDESEXTOY" = HIDESEXTOY, // SKYRAT EDIT ADDITION END
))

DEFINE_BITFIELD(machine_stat, list(
	"BROKEN" = BROKEN,
	"EMPED" = EMPED,
	"MAINT" = MAINT,
	"NOPOWER" = NOPOWER,
))

DEFINE_BITFIELD(mat_container_flags, list(
	"MATCONTAINER_EXAMINE" = MATCONTAINER_EXAMINE,
	"MATCONTAINER_NO_INSERT" = MATCONTAINER_NO_INSERT,
	"MATCONTAINER_ANY_INTENT" = MATCONTAINER_ANY_INTENT,
	"MATCONTAINER_SILENT" = MATCONTAINER_SILENT
))

DEFINE_BITFIELD(internal_damage, list(
	"MECHA_INT_FIRE" = MECHA_INT_FIRE,
	"MECHA_INT_TEMP_CONTROL" = MECHA_INT_TEMP_CONTROL,
	"MECHA_CABIN_AIR_BREACH" = MECHA_CABIN_AIR_BREACH,
	"MECHA_INT_CONTROL_LOST" = MECHA_INT_CONTROL_LOST,
	"MECHA_INT_SHORT_CIRCUIT" = MECHA_INT_SHORT_CIRCUIT,
))

DEFINE_BITFIELD(mecha_flags, list(
	"ID_LOCK_ON" = ID_LOCK_ON,
	"CAN_STRAFE" = CAN_STRAFE,
	"LIGHTS_ON" = LIGHTS_ON,
	"SILICON_PILOT" = SILICON_PILOT,
	"IS_ENCLOSED" = IS_ENCLOSED,
	"HAS_LIGHTS" = HAS_LIGHTS,
))

DEFINE_BITFIELD(mob_biotypes, list(
	"MOB_BEAST" = MOB_BEAST,
	"MOB_BUG" = MOB_BUG,
	"MOB_HUMANOID" = MOB_HUMANOID,
	"MOB_MINERAL" = MOB_MINERAL,
	"MOB_ORGANIC" = MOB_ORGANIC,
	"MOB_PLANT" = MOB_PLANT,
	"MOB_REPTILE" = MOB_REPTILE,
	"MOB_ROBOTIC" = MOB_ROBOTIC,
	"MOB_SLIME" = MOB_SLIME,
	"MOB_SPECIAL" = MOB_SPECIAL,
	"MOB_SPIRIT" = MOB_SPIRIT,
	"MOB_UNDEAD" = MOB_UNDEAD,
))

DEFINE_BITFIELD(mob_respiration_type, list(
	"RESPIRATION_OXYGEN" = RESPIRATION_OXYGEN,
	"RESPIRATION_N2" = RESPIRATION_N2,
	"RESPIRATION_PLASMA" = RESPIRATION_PLASMA,
))

DEFINE_BITFIELD(mobility_flags, list(
	"MOVE" = MOBILITY_MOVE,
	"PICKUP" = MOBILITY_PICKUP,
	"PULL" = MOBILITY_PULL,
	"STAND" = MOBILITY_STAND,
	"STORAGE" = MOBILITY_STORAGE,
	"UI" = MOBILITY_UI,
	"USE" = MOBILITY_USE,
))

DEFINE_BITFIELD(movement_type, list(
	"FLOATING" = FLOATING,
	"FLYING" = FLYING,
	"GROUND" = GROUND,
	"PHASING" = PHASING,
	"VENTCRAWLING" = VENTCRAWLING,
	"UPSIDE_DOWN" = UPSIDE_DOWN,
))

DEFINE_BITFIELD(obj_flags, list(
	"EMAGGED" = EMAGGED,
	"CAN_BE_HIT" = CAN_BE_HIT,
	"DANGEROUS_POSSESSION" = DANGEROUS_POSSESSION,
	"UNIQUE_RENAME" = UNIQUE_RENAME,
	"BLOCK_Z_OUT_DOWN" = BLOCK_Z_OUT_DOWN,
	"BLOCK_Z_OUT_UP" = BLOCK_Z_OUT_UP,
	"BLOCK_Z_IN_DOWN" = BLOCK_Z_IN_DOWN,
	"BLOCK_Z_IN_UP" = BLOCK_Z_IN_UP,
	"BLOCKS_CONSTRUCTION" = BLOCKS_CONSTRUCTION,
	"BLOCKS_CONSTRUCTION_DIR" = BLOCKS_CONSTRUCTION_DIR,
	"IGNORE_DENSITY" = IGNORE_DENSITY,
	"INFINITE_RESKIN" = INFINITE_RESKIN,
	"CONDUCTS_ELECTRICITY" = CONDUCTS_ELECTRICITY,
	"NO_DEBRIS_AFTER_DECONSTRUCTION" = NO_DEBRIS_AFTER_DECONSTRUCTION,
))

DEFINE_BITFIELD(pass_flags, list(
	"LETPASSTHROW" = LETPASSTHROW,
	"PASSBLOB" = PASSBLOB,
	"PASSCLOSEDTURF" = PASSCLOSEDTURF,
	"PASSGLASS" = PASSGLASS,
	"PASSGRILLE" = PASSGRILLE,
	"PASSMOB" = PASSMOB,
	"PASSTABLE" = PASSTABLE,
	"PASSWINDOW" = PASSWINDOW,
))

DEFINE_BITFIELD(resistance_flags, list(
	"LAVA_PROOF" = LAVA_PROOF,
	"FIRE_PROOF" = FIRE_PROOF,
	"FLAMMABLE" = FLAMMABLE,
	"ON_FIRE" = ON_FIRE,
	"UNACIDABLE" = UNACIDABLE,
	"ACID_PROOF" = ACID_PROOF,
	"INDESTRUCTIBLE" = INDESTRUCTIBLE,
	"FREEZE_PROOF" = FREEZE_PROOF,
	"SHUTTLE_CRUSH_PROOF" = SHUTTLE_CRUSH_PROOF
))

DEFINE_BITFIELD(sight, list(
	"BLIND" = BLIND,
	"SEE_BLACKNESS" = SEE_BLACKNESS,
	"SEE_INFRA" = SEE_INFRA,
	"SEE_MOBS" = SEE_MOBS,
	"SEE_OBJS" = SEE_OBJS,
	"SEE_PIXELS" = SEE_PIXELS,
	"SEE_SELF" = SEE_SELF,
	"SEE_THRU" = SEE_THRU,
	"SEE_TURFS" = SEE_TURFS,
))

DEFINE_BITFIELD(vis_flags, list(
	"VIS_HIDE" = VIS_HIDE,
	"VIS_INHERIT_DIR" = VIS_INHERIT_DIR,
	"VIS_INHERIT_ICON" = VIS_INHERIT_ICON,
	"VIS_INHERIT_ICON_STATE" = VIS_INHERIT_ICON_STATE,
	"VIS_INHERIT_ID" = VIS_INHERIT_ID,
	"VIS_INHERIT_LAYER" = VIS_INHERIT_LAYER,
	"VIS_INHERIT_PLANE" = VIS_INHERIT_PLANE,
	"VIS_UNDERLAY" = VIS_UNDERLAY,
))

// I am so sorry. Required because vis_flags is both undefinable and unreadable on mutable_appearance
// But we need to display them anyway. See /mutable_appearance/appearance_mirror
DEFINE_BITFIELD(_vis_flags, list(
	"VIS_HIDE" = VIS_HIDE,
	"VIS_INHERIT_DIR" = VIS_INHERIT_DIR,
	"VIS_INHERIT_ICON" = VIS_INHERIT_ICON,
	"VIS_INHERIT_ICON_STATE" = VIS_INHERIT_ICON_STATE,
	"VIS_INHERIT_ID" = VIS_INHERIT_ID,
	"VIS_INHERIT_LAYER" = VIS_INHERIT_LAYER,
	"VIS_INHERIT_PLANE" = VIS_INHERIT_PLANE,
	"VIS_UNDERLAY" = VIS_UNDERLAY,
))

DEFINE_BITFIELD(zap_flags, list(
	"ZAP_ALLOW_DUPLICATES" = ZAP_ALLOW_DUPLICATES,
	"ZAP_MACHINE_EXPLOSIVE" = ZAP_MACHINE_EXPLOSIVE,
	"ZAP_MOB_DAMAGE" = ZAP_MOB_DAMAGE,
	"ZAP_MOB_STUN" = ZAP_MOB_STUN,
	"ZAP_OBJ_DAMAGE" = ZAP_OBJ_DAMAGE,
	"ZAP_GENERATES_POWER" = ZAP_GENERATES_POWER,
))

DEFINE_BITFIELD(chemical_flags, list(
	"REAGENT_DEAD_PROCESS" = REAGENT_DEAD_PROCESS,
	"REAGENT_DONOTSPLIT" = REAGENT_DONOTSPLIT,
	"REAGENT_INVISIBLE" = REAGENT_INVISIBLE,
	"REAGENT_SNEAKYNAME" = REAGENT_SNEAKYNAME,
	"REAGENT_SPLITRETAINVOL" = REAGENT_SPLITRETAINVOL,
	"REAGENT_CAN_BE_SYNTHESIZED" = REAGENT_CAN_BE_SYNTHESIZED,
	"REAGENT_IGNORE_STASIS" = REAGENT_IGNORE_STASIS,
	"REAGENT_NO_RANDOM_RECIPE" = REAGENT_NO_RANDOM_RECIPE,
	"REAGENT_CLEANS" = REAGENT_CLEANS,
))

DEFINE_BITFIELD(reaction_flags, list(
	"REACTION_CLEAR_IMPURE" = REACTION_CLEAR_IMPURE,
	"REACTION_CLEAR_INVERSE" = REACTION_CLEAR_INVERSE,
	"REACTION_CLEAR_RETAIN" = REACTION_CLEAR_RETAIN,
	"REACTION_INSTANT" = REACTION_INSTANT,
	"REACTION_HEAT_ARBITARY" = REACTION_HEAT_ARBITARY,
	"REACTION_COMPETITIVE" = REACTION_COMPETITIVE,
	"REACTION_PH_VOL_CONSTANT" = REACTION_PH_VOL_CONSTANT,
	"REACTION_REAL_TIME_SPLIT" = REACTION_REAL_TIME_SPLIT,
))

DEFINE_BITFIELD(bodytype, list(
	"BODYTYPE_ORGANIC" = BODYTYPE_ORGANIC,
	"BODYTYPE_ROBOTIC" = BODYTYPE_ROBOTIC,
	"BODYTYPE_LARVA_PLACEHOLDER" = BODYTYPE_LARVA_PLACEHOLDER,
	"BODYTYPE_ALIEN" = BODYTYPE_ALIEN,
	"BODYTYPE_GOLEM" = BODYTYPE_GOLEM,
))

DEFINE_BITFIELD(acceptable_bodytype, list(
	"BODYTYPE_ORGANIC" = BODYTYPE_ORGANIC,
	"BODYTYPE_ROBOTIC" = BODYTYPE_ROBOTIC,
	"BODYTYPE_LARVA_PLACEHOLDER" = BODYTYPE_LARVA_PLACEHOLDER,
	"BODYTYPE_ALIEN" = BODYTYPE_ALIEN,
	"BODYTYPE_GOLEM" = BODYTYPE_GOLEM,
))

DEFINE_BITFIELD(bodyshape, list(
	"BODYSHAPE_HUMANOID" = BODYSHAPE_HUMANOID,
	"BODYSHAPE_MONKEY" = BODYSHAPE_MONKEY,
	"BODYSHAPE_DIGITIGRADE" = BODYSHAPE_DIGITIGRADE,
	"BODYSHAPE_SNOUTED" = BODYSHAPE_SNOUTED,
	// SKYRAT EDIT ADDITION - customization
	"BODYSHAPE__CUSTOM" = BODYSHAPE_CUSTOM,
	"BODYSHAPE__TAUR" = BODYSHAPE_TAUR,
	"BODYSHAPE__HIDE_SHOES" = BODYSHAPE_HIDE_SHOES,
	"BODYSHAPE__ALT_FACEWEAR_LAYER" = BODYSHAPE_ALT_FACEWEAR_LAYER,
	// SKYRAT EDIT END
))

DEFINE_BITFIELD(acceptable_bodyshape, list(
	"BODYSHAPE_HUMANOID" = BODYSHAPE_HUMANOID,
	"BODYSHAPE_MONKEY" = BODYSHAPE_MONKEY,
	"BODYSHAPE_DIGITIGRADE" = BODYSHAPE_DIGITIGRADE,
	"BODYSHAPE_SNOUTED" = BODYSHAPE_SNOUTED,
	// SKYRAT EDIT ADDITION - customization
	"BODYSHAPE__CUSTOM" = BODYSHAPE_CUSTOM,
	"BODYSHAPE__TAUR" = BODYSHAPE_TAUR,
	"BODYSHAPE__HIDE_SHOES" = BODYSHAPE_HIDE_SHOES,
	"BODYSHAPE__ALT_FACEWEAR_LAYER" = BODYSHAPE_ALT_FACEWEAR_LAYER,
	// SKYRAT EDIT END
))

DEFINE_BITFIELD(bodypart_flags, list(
	"BODYPART_UNREMOVABLE" = BODYPART_UNREMOVABLE,
	"BODYPART_PSEUDOPART" = BODYPART_PSEUDOPART,
	"BODYPART_IMPLANTED" = BODYPART_IMPLANTED,
))

DEFINE_BITFIELD(change_exempt_flags, list(
	"BP_BLOCK_CHANGE_SPECIES" = BP_BLOCK_CHANGE_SPECIES,
))

DEFINE_BITFIELD(head_flags, list(
	"HEAD_HAIR" = HEAD_HAIR,
	"HEAD_FACIAL_HAIR" = HEAD_FACIAL_HAIR,
	"HEAD_LIPS" = HEAD_LIPS,
	"HEAD_EYESPRITES" = HEAD_EYESPRITES,
	"HEAD_EYECOLOR" = HEAD_EYECOLOR,
	"HEAD_EYEHOLES" = HEAD_EYEHOLES,
	"HEAD_DEBRAIN" = HEAD_DEBRAIN,
))

DEFINE_BITFIELD(supports_variations_flags, list(
	"CLOTHING_NO_VARIATION" = CLOTHING_NO_VARIATION,
	"CLOTHING_DIGITIGRADE_VARIATION" = CLOTHING_DIGITIGRADE_VARIATION,
	"CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON" = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON,
	"CLOTHING_MONKEY_VARIATION" = CLOTHING_MONKEY_VARIATION, // SKYRAT EDIT ADDITION BEGIN
	"CLOTHING_SNOUTED_VARIATION" = CLOTHING_SNOUTED_VARIATION,
	"CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON" = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON,
	"CLOTHING_SNOUTED_VOX_VARIATION" = CLOTHING_SNOUTED_VOX_VARIATION,
	"CLOTHING_SNOUTED_VOX_VARIATION_NO_NEW_ICON" = CLOTHING_SNOUTED_VOX_VARIATION_NO_NEW_ICON, // SKYRAT EDIT END
))

DEFINE_BITFIELD(flora_flags, list(
	"FLORA_HERBAL" = FLORA_HERBAL,
	"FLORA_WOODEN" = FLORA_WOODEN,
	"FLORA_STONE" = FLORA_STONE,
))

DEFINE_BITFIELD(emote_flags, list(
	"EMOTE_AUDIBLE" = EMOTE_AUDIBLE,
	"EMOTE_VISIBLE" = EMOTE_VISIBLE,
	"EMOTE_IMPORTANT" = EMOTE_IMPORTANT,
))

DEFINE_BITFIELD(organ_flags, list(
	"ORGAN_ORGANIC" = ORGAN_ORGANIC,
	"ORGAN_ROBOTIC" = ORGAN_ROBOTIC,
	"ORGAN_MINERAL" = ORGAN_MINERAL,
	"ORGAN_FROZEN" = ORGAN_FROZEN,
	"ORGAN_FAILING" = ORGAN_FAILING,
	"ORGAN_EMP" = ORGAN_EMP,
	"ORGAN_VITAL" = ORGAN_VITAL,
	"ORGAN_EDIBLE" = ORGAN_EDIBLE,
	"ORGAN_UNREMOVABLE" = ORGAN_UNREMOVABLE,
	"ORGAN_HIDDEN" = ORGAN_HIDDEN,
	"ORGAN_VIRGIN" = ORGAN_VIRGIN,
))

DEFINE_BITFIELD(respiration_type, list(
	"RESPIRATION_OXYGEN" = RESPIRATION_OXYGEN,
	"RESPIRATION_N2" = RESPIRATION_N2,
	"RESPIRATION_PLASMA" = RESPIRATION_PLASMA,
))

DEFINE_BITFIELD(liked_foodtypes, list(
	"MEAT" = MEAT,
	"VEGETABLES" = VEGETABLES,
	"RAW" = RAW,
	"JUNKFOOD" = JUNKFOOD,
	"GRAIN" = GRAIN,
	"FRUIT" = FRUIT,
	"DAIRY" = DAIRY,
	"FRIED" = FRIED,
	"ALCOHOL" = ALCOHOL,
	"SUGAR" = SUGAR,
	"GROSS" = GROSS,
	"TOXIC" = TOXIC,
	"PINEAPPLE" = PINEAPPLE,
	"BREAKFAST" = BREAKFAST,
	"CLOTH" = CLOTH,
	"NUTS" = NUTS,
	"SEAFOOD" = SEAFOOD,
	"ORANGES" = ORANGES,
	"BUGS" = BUGS,
	"GORE" = GORE,
	"STONE" = STONE,
	"BLOODY" = BLOODY, // SKYRAT EDIT - Hemophage Food
))

DEFINE_BITFIELD(disliked_foodtypes, list(
	"MEAT" = MEAT,
	"VEGETABLES" = VEGETABLES,
	"RAW" = RAW,
	"JUNKFOOD" = JUNKFOOD,
	"GRAIN" = GRAIN,
	"FRUIT" = FRUIT,
	"DAIRY" = DAIRY,
	"FRIED" = FRIED,
	"ALCOHOL" = ALCOHOL,
	"SUGAR" = SUGAR,
	"GROSS" = GROSS,
	"TOXIC" = TOXIC,
	"PINEAPPLE" = PINEAPPLE,
	"BREAKFAST" = BREAKFAST,
	"CLOTH" = CLOTH,
	"NUTS" = NUTS,
	"SEAFOOD" = SEAFOOD,
	"ORANGES" = ORANGES,
	"BUGS" = BUGS,
	"GORE" = GORE,
	"STONE" = STONE,
	"BLOODY" = BLOODY, // SKYRAT EDIT - Hemophage Food
))

DEFINE_BITFIELD(toxic_foodtypes, list(
	"MEAT" = MEAT,
	"VEGETABLES" = VEGETABLES,
	"RAW" = RAW,
	"JUNKFOOD" = JUNKFOOD,
	"GRAIN" = GRAIN,
	"FRUIT" = FRUIT,
	"DAIRY" = DAIRY,
	"FRIED" = FRIED,
	"ALCOHOL" = ALCOHOL,
	"SUGAR" = SUGAR,
	"GROSS" = GROSS,
	"TOXIC" = TOXIC,
	"PINEAPPLE" = PINEAPPLE,
	"BREAKFAST" = BREAKFAST,
	"CLOTH" = CLOTH,
	"NUTS" = NUTS,
	"SEAFOOD" = SEAFOOD,
	"ORANGES" = ORANGES,
	"BUGS" = BUGS,
	"GORE" = GORE,
	"STONE" = STONE,
	"BLOODY" = BLOODY, // SKYRAT EDIT - Hemophage Food
))

DEFINE_BITFIELD(sharpness, list(
	"SHARP_EDGED" = SHARP_EDGED,
	"SHARP_POINTY" = SHARP_POINTY,
))

DEFINE_BITFIELD(gun_flags, list(
	"NOT_A_REAL_GUN" = NOT_A_REAL_GUN,
	"TOY_FIREARM_OVERLAY" = TOY_FIREARM_OVERLAY,
	"TURRET_INCOMPATIBLE" = TURRET_INCOMPATIBLE,
))

DEFINE_BITFIELD(bot_mode_flags, list(
	"POWER_ON" = BOT_MODE_ON,
	"AUTO_PATROL" = BOT_MODE_AUTOPATROL,
	"REMOTE_CONTROL" = BOT_MODE_REMOTE_ENABLED,
	"SAPIENCE_ALLOWED" = BOT_MODE_CAN_BE_SAPIENT,
	"STARTS_POSSESSABLE" = BOT_MODE_ROUNDSTART_POSSESSION,
))
