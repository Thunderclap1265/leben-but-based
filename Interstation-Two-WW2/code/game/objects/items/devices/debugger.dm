/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/device/debugger
	name = "debugger"
	desc = "Used to debug electronic equipment."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	flags = CONDUCT
	force = WEAPON_FORCE_HARMLESS
	w_class = 2.0
	throwforce = WEAPON_FORCE_HARMLESS
	throw_range = 15
	throw_speed = 3
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."

	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	var/obj/machinery/telecomms/buffer // simple machine buffer for device linkage

/obj/item/device/debugger/is_used_on(obj/O, mob/user)
	if(istype(O, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = O
		if(A.emagged || A.hacker)
			user << "<span class='warning'>There is a software error with the device.</span>"
		else
			user << "<span class='notice'>The device's software appears to be fine.</span>"
		return 1
	if(istype(O, /obj/machinery/door))
		var/obj/machinery/door/D = O
		if(D.operating == -1)
			user << "<span class='warning'>There is a software error with the device.</span>"
		else
			user << "<span class='notice'>The device's software appears to be fine.</span>"
		return 1
	else if(istype(O, /obj/machinery))
		var/obj/machinery/A = O
		if(A.emagged)
			user << "<span class='warning'>There is a software error with the device.</span>"
		else
			user << "<span class='notice'>The device's software appears to be fine.</span>"
		return 1