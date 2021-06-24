//Medigun Cells/
obj/item/stock_parts/cell/medigun/ //This is the cell that mediguns from cargo will come with//
	name = "Basic Medigun Cell"
	maxcharge = 1200
	chargerate = 80

obj/item/stock_parts/cell/medigun/upgraded
	name = "Upgraded Medigun Cell"
	maxcharge = 1500
	chargerate = 160
obj/item/stock_parts/cell/medigun/experimental //This cell type is meant to be used in self charging mediguns like CMO and ERT one.//
	name = "Experiemental Medigun Cell"
	maxcharge = 1800
	chargerate = 120
//End of cells

/obj/item/ammo_casing/energy/medical
	projectile_type = /obj/projectile/energy/medical/default
	select_name = "Default"
	fire_sound = 'sound/weapons/taser.ogg'
	e_cost = 60
	harmful = FALSE

/obj/projectile/energy/medical
	name = "medical heal shot"
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/projectiles.dmi'
	icon_state = "electro_bolt"
	damage = 0

/obj/item/ammo_casing/energy/medical/default
	name = "oxygen heal shot"

/obj/projectile/energy/medical/default/on_hit(mob/living/target)
	.=..()
	target.adjustOxyLoss(-5)

//T1 Healing Projectiles//
//The Basic Brute Heal Projectile//
/obj/item/ammo_casing/energy/medical/brute1
	projectile_type = /obj/projectile/energy/medical/brute1
	select_name = "Brute"

/obj/projectile/energy/medical/brute1
	name = "brute heal shot"

/obj/projectile/energy/medical/brute1/on_hit(mob/living/target)
	.=..()
	target.adjustBruteLoss(-5)
//The Basic Burn Heal//
/obj/item/ammo_casing/energy/medical/burn1
	projectile_type = /obj/projectile/energy/medical/burn1
	select_name = "Burn I"

/obj/projectile/energy/medical/burn1
	name = "burn heal shot"

/obj/projectile/energy/medical/burn1/on_hit(mob/living/target)
	.=..()
	target.adjustFireLoss(-5)
//Basic Toxin Heal//
/obj/item/ammo_casing/energy/medical/toxin1
	projectile_type = /obj/projectile/energy/medical/toxin1
	select_name = "Toxin I"

/obj/projectile/energy/medical/toxin1
	name = "toxin heal shot"

/obj/projectile/energy/medical/toxin1/on_hit(mob/living/target)
	.=..()
	target.adjustToxLoss(-2.5) //Toxin is treatable, but inefficent//
//T2 Healing Projectiles//
