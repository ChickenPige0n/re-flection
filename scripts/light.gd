extends Line2D

@export
var direction: Vector2 # normalized starting point direction
@export
var starting_pos: Vector2
func _process(_delta: float) -> void:
	direction = direction.normalized()
	self.clear_points()
	self.add_point(starting_pos)
	var now_position: Vector2 = starting_pos
	var now_direction = direction
	var mirrors = get_parent().get_children().filter(func(it): return it is Mirror)
	
	var max_reflections = 100  # Prevent infinite loops
	var reflection_count = 0
	
	while reflection_count < max_reflections:
		var closest_mirror = null
		var closest_point = Vector2.ZERO
		var closest_distance = INF
		var last_mirror = closest_mirror  # Track the last mirror we reflected off
		
		# Find the closest intersection
		for mirror in mirrors:
			# Skip the mirror we just reflected off to prevent immediate re-reflection
			if mirror == last_mirror and reflection_count > 0:
				continue
				
			var intersection = mirror.get_intersection(now_position, now_direction)
			if intersection != Vector2.ZERO:
				var distance = now_position.distance_to(intersection)
				# Use a small epsilon to prevent detecting intersections too close to starting point
				if distance > 0.001 and distance < closest_distance:
					closest_distance = distance
					closest_point = intersection
					closest_mirror = mirror
		
		# If we found a mirror, add the reflection
		if closest_mirror:
			self.add_point(closest_point)
			now_position = closest_point
			now_direction = now_direction.bounce(closest_mirror.get_normal())
			reflection_count += 1
		else:
			# No more intersections found
			break
	
	# Add the final ray extending outward
	self.add_point(now_position + now_direction * 1000)
