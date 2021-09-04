//Chameleon causes the owner to slowly become transparent when not moving.
/datum/mutation/human/chameleon
	name = "Chameleon"
	desc = "A genome that causes the holder's skin to become transparent over time."
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = "<span class='notice'>You feel one with your surroundings.</span>"
	text_lose_indication = "<span class='notice'>You feel oddly exposed.</span>"
	time_coeff = 5
	instability = 35 //SKYRAT EDIT BEGIN
	power = /obj/effect/proc_holder/spell/self/chameleon_skin_activate

/obj/effect/proc_holder/spell/self/chameleon_skin_activate
	name = "Activate Chameleon Skin"
	desc = "The chromatophores in your skin adjust to your surroundings, as long as you stay still."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	action_icon_state = "ninja_cloak" //SKYRAT EDIT END

/datum/mutation/human/chameleon/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	/// SKYRAT EDIT BEGIN
	if(HAS_TRAIT(owner,TRAIT_CHAMELEON_SKIN))
		return 
	/// SKYRAT EDIT END
	owner.alpha = CHAMELEON_MUTATION_DEFAULT_TRANSPARENCY
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/on_move)
	RegisterSignal(owner, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, .proc/on_attack_hand)

/datum/mutation/human/chameleon/on_life(delta_time, times_fired)
	if(HAS_TRAIT(owner, TRAIT_CHAMELEON_SKIN)) //SKYRAT EDIT BEGIN
		owner.alpha = max(owner.alpha - (12.5 * delta_time), 0) //SKYRAT EDIT END

/datum/mutation/human/chameleon/proc/on_move()
	SIGNAL_HANDLER

	/// SKYRAT EDIT BEGIN
	if(HAS_TRAIT(owner, TRAIT_CHAMELEON_SKIN))
		owner.alpha = CHAMELEON_MUTATION_DEFAULT_TRANSPARENCY
	else
		owner.alpha = 255
		/// SKYRAT EDIT END

/datum/mutation/human/chameleon/proc/on_attack_hand(atom/target, proximity)
	SIGNAL_HANDLER

	if(!proximity) //stops tk from breaking chameleon
		return

	/// SKYRAT EDIT BEGIN
	if(HAS_TRAIT(owner, TRAIT_CHAMELEON_SKIN))
		owner.alpha = CHAMELEON_MUTATION_DEFAULT_TRANSPARENCY
	else
		owner.alpha = 255
	/// SKYRAT EDIT END

/datum/mutation/human/chameleon/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.alpha = 255
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
