/var/max_lighting_z = 1
/var/lighting_corners_initialised = FALSE
/var/setup_lighting = FALSE

/proc/create_all_lighting_overlays()
	for(var/zlevel = 1 to max_lighting_z)
		create_lighting_overlays_zlevel(zlevel)

/proc/create_lighting_overlays_zlevel(var/zlevel)
	ASSERT(zlevel)

	for(var/turf/T in block(locate(1, TRUE, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if (T.supports_lighting_overlays())

			var/area/T_area = get_area(T)
			if (T_area.is_void_area)
				if (istype(T, /turf/wall/rockwall))
					T.icon_state = "black"
					continue
				else if (istype(T, /turf/wall/indestructable))
					var/turf/wall/W = T
					W.icon = 'icons/turf/walls.dmi'
					W.icon_state = "black"
					qdel_list(W.overlays)
					qdel_list(W.damage_overlays)
					continue

			PoolOrNew(/atom/movable/lighting_overlay, T, TRUE)

/proc/create_all_lighting_corners()
	for(var/zlevel = 1 to max_lighting_z)
		create_lighting_corners_zlevel(zlevel)
	global.lighting_corners_initialised = TRUE

/proc/create_lighting_corners_zlevel(var/zlevel)
	for(var/turf/T in block(locate(1, TRUE, zlevel), locate(world.maxx, world.maxy, zlevel)))

		if (!T.supports_lighting_overlays())
			continue

		var/area/T_area = get_area(T)
		if (T_area.is_void_area && (istype(T, /turf/wall/rockwall) || istype(T, /turf/wall/indestructable)))
			continue

		for(var/i = 1 to 4)
			if(T.corners[i]) // Already have a corner on this direction.
				continue

			T.corners[i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[i])

/hook/startup/proc/setup_lighting()
	create_lighting()
	return TRUE

var/created_lighting_corners_and_overlays = FALSE
/proc/create_lighting(_time_of_day)

	if (_time_of_day)
		time_of_day = _time_of_day
	else
		time_of_day = pick_TOD()

	create_all_lighting_corners()
	create_all_lighting_overlays()

	created_lighting_corners_and_overlays = TRUE

/proc/update_lighting(_time_of_day, var/client/admincaller = null, var/announce = TRUE)

	while (!created_lighting_corners_and_overlays)
		sleep(1)

	time_of_day_change_process.changeto = _time_of_day
	time_of_day_change_process.admincaller = admincaller
	time_of_day_change_process.announce = announce
	time_of_day_change_process.ready = TRUE