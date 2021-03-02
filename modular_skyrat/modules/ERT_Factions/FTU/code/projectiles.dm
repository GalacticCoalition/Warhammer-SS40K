/obj/projectile/bullet/pulse/65mm
	name = "6.5mm XJ Pulse flechette"
  icon = 'modular_skyrat/modules/ERT_Factions/FTU/icons/weapons/projectiles.dmi'
	icon_state = "pulsebullet"
	damage = 36
	wound_bonus = 25
	embedding = list(embed_chance=30, fall_chance=3, jostle_chance=4, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=6, rip_time=10)
	armour_penetration = 40
  damage_type = BRUTE | BURN
  
  
  /obj/projectile/bullet/pulse/72mm
  	name = "7.2mm XJ accelerated Pulse flechette"
  icon = 'modular_skyrat/modules/ERT_Factions/FTU/icons/weapons/projectiles.dmi'
	icon_state = "pulsebullet_mg"
	damage = 22
	wound_bonus = 60
	embedding = list(embed_chance=80, fall_chance=1, jostle_chance=20, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=0.8, rip_time=20)
	armour_penetration = 60
  damage_type = BRUTE | BURN
  
  
  /obj/projectile/bullet/pulse/12mm/SAPHE
  	name = "12.7x35mm Saboted AP-HE bullet"
  icon = 'modular_skyrat/modules/ERT_Factions/FTU/icons/weapons/projectiles.dmi'
	icon_state = "pulsebullet"
	damage = 70
	wound_bonus = 90
	embedding = list(embed_chance=10, fall_chance=1, jostle_chance=6, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=5, rip_time=80)
	armour_penetration = 40
  damage_type = BRUTE
