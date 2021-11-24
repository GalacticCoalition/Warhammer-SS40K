/obj/item/ammo_casing
	///What volume should the sound play at?
	var/fire_sound_volume = 50
	/// Damage override for pellets leaving the barrel.
	var/damage_override = 0
	/// Piercing flags to be applied to projectile....
	var/projectile_piercing = NONE

/obj/item/ammo_casing/energy/laser/microfusion
	name = "microfusion energy lens"
	projectile_type = /obj/projectile/beam/laser/microfusion
	e_cost = 100 // 10 shots with a normal cell.
	select_name = "laser"
	fire_sound = 'modular_skyrat/modules/microfusion/sound/laser_1.ogg'
	fire_sound_volume = 100

 // Not a real bullet, but visually looks like one. For the aesthetic of bullets, while keeping the balance intact.
 // Every piece of armor in the game is currently balanced around "sec has lasers, syndies have bullets". This allows us to keep that balance
 // without sacrificing the bullet aesthetic.
/obj/projectile/beam/laser/microfusion
	name = "microfusion laser"
	icon = 'modular_skyrat/modules/microfusion/icons/projectiles.dmi'

