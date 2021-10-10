// MODULAR PLUSHES

/obj/item/toy/plush/borbplushie
	name = "borb plushie"
	desc = "An adorable stuffed toy that resembles a round, fluffy looking bird. Not to be mistaken for his friend, the birb plushie."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_borb"
	inhand_icon_state = "plushie_borb"
	attack_verb_continuous = list("pecks", "peeps")
	attack_verb_simple = list("peck", "peep")
	squeak_override = list('modular_skyrat/modules/emotes/sound/voice/peep_once.ogg' = 1)

/obj/item/toy/plush/deer
	name = "deer plushie"
	desc = "An adorable stuffed toy that resembles a deer."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_deer"
	inhand_icon_state = "plushie_deer"
	attack_verb_continuous = list("headbutts", "boops", "bapps", "bumps")
	attack_verb_simple = list("headbutt", "boop", "bap", "bump")
	squeak_override = list('modular_skyrat/modules/customization/game/objects/items/sound/deerplush.ogg' = 1)

/obj/item/toy/plush/fermis
	name = "medcat plushie"
	desc = "An affectionate stuffed toy that resembles a certain medcat, comes complete with battery operated wagging tail!! You get the impression she's cheering you on to find happiness and be kind to people."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_fermis"
	inhand_icon_state = "plushie_fermis"
	attack_verb_continuous = list("cuddles", "petpatts", "wigglepurrs")
	attack_verb_simple = list("cuddle", "petpatt", "wigglepurr")
	squeak_override = list('modular_skyrat/modules/customization/game/objects/items/sound/merowr.ogg' = 1)
	gender = FEMALE

/obj/item/toy/plush/fermis/chen
	name = "securicat plushie"
	desc = "The official stuffed companion to the medcat plushie!! It resembles a certain securicat. You get the impression she's encouraging you to be brave and protect those you care for."
	icon_state = "plushie_chen"
	inhand_icon_state = "plushie_chen"
	attack_verb_continuous = list("snuggles", "meowhuggies", "wigglepurrs")
	attack_verb_simple = list("snuggle", "meowhuggie", "wigglepurr")
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list("Assistant", "Head of Security")
	special_desc = "There's a pocket under the coat hiding a tiny picture of the medcat plushie and a tinier ribbon diamond ring. D'awww."

/obj/item/toy/plush/sechound
	name = "Sechound plushie"
	desc = "An adorable stuffed toy of a SecHound, the trusty Nanotrasen sponsored security borg!"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_securityk9"
	inhand_icon_state = "plushie_securityk9"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep.ogg' = 1)

/obj/item/toy/plush/medihound
	name = "Medihound plushie"
	desc = "An adorable stuffed toy of a medihound."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_medihound"
	inhand_icon_state = "plushie_medihound"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep.ogg' = 1)

/obj/item/toy/plush/scrubpuppy
	name = "Scrubpuppy plushie"
	desc = "An adorable stuffed toy of a Scrubpuppy, the hard-working pup who keeps the station clean!"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_scrubpuppy"
	inhand_icon_state = "plushie_scrubpuppy"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep.ogg' = 1)

/obj/item/toy/plush/meddrake
	name = "MediDrake Plushie"
	desc = "An adorable stuffed toy of a Medidrake."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_meddrake"
	inhand_icon_state = "plushie_meddrake"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep.ogg' = 1)

/obj/item/toy/plush/secdrake
	name = "SecDrake Plushie"
	desc = "An adorable stuffed toy of a Secdrake."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_secdrake"
	inhand_icon_state = "plushie_secdrake"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep.ogg' = 1)


/obj/item/toy/plush/fox
	name = "Fox plushie"
	desc = "An adorable stuffed toy of a Fox."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_fox"
	inhand_icon_state = "plushie_fox"
	attack_verb_continuous = list("geckers", "boops","nuzzles")
	attack_verb_simple = list("gecker", "boop", "nuzzle")
	squeak_override = list('modular_skyrat/modules/customization/game/objects/items/sound/deerplush.ogg' = 1)

/obj/item/toy/plush/duffmoth
	name = "Suspicious moth plushie"
	desc = "A plushie depicting a certain moth. He probably got turned into a marketable plushie."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_duffy"
	inhand_icon_state = "plushie_duffy"
	attack_verb_continuous = list("flutters", "flaps", "squeaks")
	attack_verb_simple = list("flutter", "flap", "squeak")
	squeak_override = list('modular_skyrat/modules/emotes/sound/emotes/mothsqueak.ogg'= 1)
	gender = MALE

/obj/item/toy/plush/leaplush
	name = "Suspicious deer plushie"
	desc = "A cute and all too familiar deer."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_lea"
	inhand_icon_state = "plushie_lea"
	attack_verb_continuous = list("headbutts", "plaps")
	attack_verb_simple = list("headbutt", "plap")
	squeak_override = list('modular_skyrat/modules/customization/game/objects/items/sound/leaplush.ogg' = 1)
	gender = FEMALE

/obj/item/toy/plush/sarmieplush
	name = "Cosplayer plushie"
	desc = "A stuffed toy who look like a familiar cosplayer, <b>He looks sad.</b>"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_sarmie"
	inhand_icon_state = "plushie_sarmie"
	attack_verb_continuous = list("baps")
	attack_verb_simple = list("bap")
	squeak_override = list('modular_skyrat/modules/emotes/sound/voice/weh.ogg' = 1)
	gender = MALE

/obj/item/toy/plush/sharknet
	name = "Gluttonous Shark plushie"
	desc = "A heavy plushie of a rather large and hungry shark"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_sharknet"
	inhand_icon_state = "plushie_sharknet"
	attack_verb_continuous = list("cuddles", "squishes", "wehs")
	attack_verb_simple = list("cuddle", "squish", "weh")
	w_class = WEIGHT_CLASS_NORMAL
	squeak_override = list('modular_skyrat/modules/emotes/sound/voice/slime_squish.ogg' = 1)
	young = 1 //No.
//Storage component for Sharknet Plushie//
/obj/item/toy/plush/sharknet/ComponentInitialize()
	var/datum/component/storage/concrete/storage = AddComponent(/datum/component/storage/concrete)
	storage.max_items = 2
	storage.max_w_class = WEIGHT_CLASS_SMALL
	storage.set_holdable(list(
		/obj/item/toy/plush/pintaplush,
		/obj/item/toy/plush/arcplush
		))
//End of storage component//

/obj/item/toy/plush/pintaplush
	name = "Smaller Deer plushie"
	desc = "A pint-sized cervine with a vacant look."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_pinta"
	inhand_icon_state = "plushie_pinta"
	attack_verb_continuous = list("bonks", "snugs")
	attack_verb_simple = list("bonk", "snug")
	squeak_override = list('modular_skyrat/modules/emotes/sound/voice/slime_squish.ogg' = 1)
	young = 1 //No.

/obj/item/toy/plush/arcplush
	name = "Familiar lizard plushie"
	desc = "A small plushie that resembles a lizard-- Or, not a lizard, it's mouth seems to go horizontally too.. Are those limbs in it's maw?"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_arc"
	inhand_icon_state = "plushie_arc"
	attack_verb_continuous = list("claws", "bites", "wehs")
	attack_verb_simple = list("claw", "bite", "weh")
	squeak_override = list('modular_skyrat/modules/emotes/sound/voice/weh.ogg' = 1)
	young = 1 //No.

/obj/item/toy/plush/oleplush
	name = "Irritable goat plushie"
	desc = "A plush recreation of a purple ovine. Made with 100% real, all natural wool from the creator herself."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_ole"
	inhand_icon_state = "plushie_ole"
	attack_verb_continuous = list("headbutts", "plaps")
	attack_verb_simple = list("headbutt", "plap")
	squeak_override = list('sound/weapons/punch1.ogg'= 1)
	young = 1 //No.
	gender = FEMALE

/obj/item/toy/plush/szaplush
	name = "Suspicious spider"
	desc = "A plushie of a shy looking drider, colored in floortile gray."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_sza"
	inhand_icon_state = "plushie_sza"
	attack_verb_continuous = list("scuttles", "chitters", "bites")
	attack_verb_simple = list("scuttle", "chitter", "bite")
	squeak_override = list('modular_skyrat/modules/customization/game/objects/items/sound/spiderplush.ogg' = 1)
	young = 1 //No.

/obj/item/toy/plush/riffplush
  name = "Valid plushie"
  desc = "A stuffed toy in the likeness of a peculiar demonic one. Likely turned into a plushie to sell such. They look quite alright about it."
  icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
  icon_state = "plushie_riffy"
  inhand_icon_state = "plushie_riffy"
  attack_verb_continuous = list("slaps", "challenges")
  attack_verb_simple = list("slap", "challenge")
  squeak_override = list('sound/weapons/slap.ogg' = 1)

/obj/item/toy/plush/ian
	name = "plush corgi"
	desc = "A plushie of an adorable corgi! Don't you just want to hug it and squeeze it and call it \"Ian\"?"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "ianplushie"
	inhand_icon_state = "corgi"
	attack_verb_continuous = list("barks", "woofs", "wags his tail at")
	attack_verb_simple = list("lick", "nuzzle", "bite")
	squeak_override = list('modular_skyrat/modules/emotes/sound/voice/bark2.ogg' = 1)
	young = 1 //No.

/obj/item/toy/plush/ian/small
	name = "small plush corgi"
	desc = "A plushie of an adorable corgi! Don't you just want to hug it and squeeze it and call it \"Ian\"?"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "corgi"
	inhand_icon_state = "corgi"

/obj/item/toy/plush/ian/lisa
	name = "plush girly corgi"
	desc = "A plushie of an adorable corgi! Don't you just want to hug it and squeeze it and call it \"Lisa\"?"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "girlycorgi"
	inhand_icon_state = "girlycorgi"
	attack_verb_continuous = list("barks", "woofs", "wags her tail at")
	gender = FEMALE

/obj/item/toy/plush/cat
	name = "cat plushie"
	desc = "A small cat plushie with black beady eyes."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "blackcat"
	inhand_icon_state = "blackcat"
	attack_verb_continuous = list("cuddles", "meows", "hisses")
	attack_verb_simple = list("cuddle", "meow", "hiss")
	squeak_override = list('modular_skyrat/modules/customization/game/objects/items/sound/merowr.ogg' = 1)

/obj/item/toy/plush/cat/tux
	name = "tux cat plushie"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "tuxedocat"
	inhand_icon_state = "tuxedocat"

/obj/item/toy/plush/cat/white
	name = "white cat plushie"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "whitecat"
	inhand_icon_state = "whitecat"

/obj/item/toy/plush/seaduplush
	name = "Sneed plushie"
	desc = "A plushie of a particular, bundled up IPC. Underneath the cloak, you can see a plush recreation of the captain's sabre."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_seadu"
	inhand_icon_state = "plushie_seadu"
	attack_verb_continuous = list("beeps","sneeds","swords")
	attack_verb_simple = list("beep","sneed","sword")
	squeak_override = list('modular_skyrat/modules/emotes/sound/emotes/synth_yes.ogg' = 1,'modular_skyrat/modules/emotes/sound/emotes/synth_no.ogg' = 1)

/obj/item/toy/plush/lizzyplush
	name = "Odd yoga lizzy plushie"
	desc = "Brought to you by Nanotrasen Wellness Program is the Yoga Odd Lizzy! He smells vaguely of blueberries, and likely resembles a horrible lover."
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_lizzy"
	inhand_icon_state = "plushie_lizzy"
	attack_verb_continuous = list("wehs")
	attack_verb_simple = list("weh")
	squeak_override = list('modular_skyrat/modules/emotes/sound/voice/weh.ogg' = 1)

/obj/item/toy/plush/fox/mia
	name = "Mia’s fox plushie"
	desc = "A small stuffed silver fox with a collar tag that says “Eavy” and a tiny bell in its fluffy tail."
	icon_state = "miafox"

/obj/item/toy/plush/fox/kailyn
	name = "teasable fox plushie"
	desc = "A familiar looking vixen in a peacekeeper attire, perfect for everyone who intends on venturing in the dark alone! There's a little tag which tells you to not boop its nose."
	icon_state = "teasefox"
	attack_verb_continuous = list("sneezes on", "detains", "tazes")
	attack_verb_simple = list("sneeze on", "detain", "taze")
	squeak_override = list('modular_skyrat/modules/emotes/sound/emotes/female/female_sneeze.ogg' = 1)

/obj/item/toy/plush/tay
	name = "Talking Tay plushie"
	desc = "Resembling a certain catboy, he repeats whatever you say!"
	icon = 'modular_skyrat/master_files/icons/obj/plushes.dmi'
	icon_state = "plushie_tay"
	attack_verb_continuous = list("meows")
	attack_verb_simple = list("meow")
	squeak_override = list('modular_skyrat/modules/emotes/sound/emotes/meow.ogg' = 1)
	gender = MALE
	var/talking_tay_turned_on = FALSE
	var/on_cooldown = FALSE
	var/cooldown_time = 25
	var/message_delay = 5

/obj/item/toy/plush/tay/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()

/obj/item/toy/plush/tay/examine(mob/user)
	. = ..()
	. += span_notice("Alt-Click \the [src.name] to turn it [talking_tay_turned_on ? "off" : "on"].")

/obj/item/toy/plush/tay/AltClick(mob/user)
	. = ..()
	talking_tay_turned_on = !talking_tay_turned_on
	if(talking_tay_turned_on)
		playsound(src, 'modular_skyrat/modules/emotes/sound/emotes/synth_yes.ogg', 50, TRUE)
	else
		playsound(src, 'modular_skyrat/modules/emotes/sound/emotes/synth_no.ogg', 50, TRUE)
	to_chat(user, span_notice("The [src] is now [talking_tay_turned_on ? "on" : "off"]."))

/obj/item/toy/plush/tay/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods)
	. = ..()
	if(!iscarbon(speaker)) //only allows it to hear humans, also in effect prevents infinite loops from occuring
		return
	if(!on_cooldown && talking_tay_turned_on)
		addtimer(CALLBACK(src, .proc/stutter_message, raw_message, message_language), message_delay) //delays the message

		on_cooldown = TRUE
		addtimer(CALLBACK(src, .proc/clear_cooldown), cooldown_time) //just so you cant spam the shit out of it

/obj/item/toy/plush/tay/proc/stutter_message(message, message_language)

	playsound(src, 'modular_skyrat/modules/emotes/sound/emotes/twobeep.ogg', 50, TRUE)

	if(prob(5))
		say("[pick_list_replacements(TAY_DEMON_FILE, "tay_demonic_ramblings")]", language = message_language) //these are all just metal song lyrics
		icon_state = "plushie_tay_peaceinhell"
		return

	//THE STUTTERSLUT ALGORITH

	var/list/message_split = splittext(message, " ")
	var/list/new_message = list()

	for(var/word in message_split)
		if(prob(10) && word != message_split[1]) //%10 chance of filler
			new_message += pick("uh...","eh...","um...")

		if(prob(35)) //%35 chance of stutter
			word = html_decode(word)
			var/leng = length(word)
			var/stuttered = ""
			var/newletter = ""
			var/rawchar = ""
			var/stuttered_letters = 0

			var/static/regex/nostutter = regex(@@[ ""''()[\]{}.!?,:;_`~-]@)

			for(var/i = 1, i <= leng, i += length(rawchar))
				rawchar = newletter = word[i]
				if(stuttered_letters < 2 && !nostutter.Find(rawchar)) //will only stutter on two letters
					if(prob(5) || (stuttered_letters == 0)) //will always stutter the first possible letter
						newletter = "[newletter]-[newletter]"
						stuttered_letters++
				stuttered += newletter
				sanitize(stuttered)

			new_message += stuttered
		else
			new_message += word

	message = jointext(new_message, " ")

	say("[message]", language = message_language)

/obj/item/toy/plush/tay/proc/clear_cooldown()
	on_cooldown = FALSE
	icon_state = "plushie_tay" //clear demon sprite
