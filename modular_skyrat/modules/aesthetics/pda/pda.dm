//greyscale config
/datum/greyscale_config/pda/aesthetics
	icon_file = 'modular_skyrat/modules/aesthetics/pda/pda.dmi'
	json_config = 'code/datums/greyscale/json_configs/pda.json'

/datum/greyscale_config/pda/aesthetics/chaplain
	json_config = 'code/datums/greyscale/json_configs/pda_chaplain.json'
/datum/greyscale_config/pda/aesthetics/head
	json_config = 'code/datums/greyscale/json_configs/pda_head.json'

/datum/greyscale_config/pda/aesthetics/mime
	json_config = 'code/datums/greyscale/json_configs/pda_mime.json'

/datum/greyscale_config/pda/aesthetics/stripe_split
	json_config = 'code/datums/greyscale/json_configs/pda_stripe_split.json'

/datum/greyscale_config/pda/aesthetics/stripe_thick
	json_config = 'code/datums/greyscale/json_configs/pda_stripe_thick.json'

/datum/greyscale_config/pda/aesthetics/stripe_thick/head
	json_config = 'code/datums/greyscale/json_configs/pda_stripe_thick_head.json'

//PDA GAGS
/obj/item/pda/blueshield
	name = "blueshield PDA"
	default_cartridge = /obj/item/cartridge/hos
	greyscale_config = /datum/greyscale_config/pda/aesthetics/stripe_thick
	greyscale_colors = "#a2b4cf#6ab73b#3399cc"

