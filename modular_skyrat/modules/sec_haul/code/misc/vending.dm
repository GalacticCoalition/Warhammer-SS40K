/obj/machinery/vending/security_peacekeeper
	name = "\improper Armadyne Peacekeeper Equipment Vendor"
	desc = "An Armadyne peacekeeper equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon = 'modular_skyrat/modules/sec_haul/icons/vending/vending.dmi'
	icon_state = "sec"
	icon_deny = "sec-deny"
	light_mask = "sec-light-mask"
	req_access = list(ACCESS_SECURITY)
	products = list(
		/obj/item/restraints/handcuffs = 8,
		/obj/item/restraints/handcuffs/cable/zipties = 10,
		/obj/item/grenade/flashbang = 4,
		/obj/item/assembly/flash/handheld = 5,
		/obj/item/food/donut/plain = 12,
		/obj/item/storage/box/evidence = 6,
		/obj/item/flashlight/seclite = 4,
		/obj/item/restraints/legcuffs/bola/energy = 7
	)
	contraband = list(
		/obj/item/clothing/glasses/sunglasses = 2,
		/obj/item/storage/fancy/donut_box = 2
	)
	premium = list(
		/obj/item/storage/belt/security/webbing = 5,
		/obj/item/coin/antagtoken = 1,
		/obj/item/clothing/head/helmet/blueshirt = 1,
		/obj/item/clothing/suit/armor/vest/blueshirt = 1,
		/obj/item/clothing/gloves/tackler/security = 5,
		/obj/item/grenade/stingbang = 1,
		/obj/item/watertank/pepperspray = 2
	)
	refill_canister = /obj/item/vending_refill/security_peacekeeper
	default_price = PAYCHECK_MEDIUM
	extra_price = PAYCHECK_HARD * 1.5
	payment_department = ACCOUNT_SEC

/obj/machinery/vending/security_peacekeeper/pre_throw(obj/item/I)
	if(istype(I, /obj/item/grenade))
		var/obj/item/grenade/G = I
		G.arm_grenade()
	else if(istype(I, /obj/item/flashlight))
		var/obj/item/flashlight/F = I
		F.on = TRUE
		F.update_brightness()

/obj/item/vending_refill/security_peacekeeper
	icon_state = "refill_sec"

/obj/machinery/vending/wardrobe/sec_wardrobe/peacekeeper
	name = "\improper Peacekeeper Outfitting Station"
	desc = "A vending machine stocked with Lopland's \"Peacekeeper\" security package, including standardized uniforms and general equipment."
	icon = 'modular_skyrat/modules/sec_haul/icons/vending/vending.dmi'
	icon_state = "peace"
	product_ads = "Beat perps in style!;The stains wash right out!;You have the right to be fashionable!;Now you can be the fashion police you always wanted to be!"
	vend_reply = "Good luck, Peacekeeper!"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/security = 5,
					/obj/item/clothing/suit/toggle/jacket/sec = 3,
					/obj/item/clothing/neck/security_cape = 5,
					/obj/item/clothing/neck/security_cape/armplate = 5,
					/obj/item/storage/backpack/security = 3,
					/obj/item/storage/backpack/satchel/sec = 3,
					/obj/item/storage/backpack/duffelbag/sec = 3,
					/obj/item/clothing/under/rank/security/officer = 10,
					/obj/item/clothing/shoes/jackboots/security = 10,
					/obj/item/clothing/head/security_garrison = 10,
					/obj/item/clothing/head/security_cap = 10,
					/obj/item/clothing/gloves/security = 10)
	premium = list(/obj/item/clothing/suit/security/officer = 3,
					/obj/item/clothing/head/beret/sec/navyofficer = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/peacekeeper_wardrobe
	payment_department = ACCOUNT_SEC
	light_color = COLOR_MODERATE_BLUE

/obj/item/vending_refill/wardrobe/peacekeeper_wardrobe
	machine_name = "Peacekeeper outfitting station"
