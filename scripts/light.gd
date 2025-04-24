@tool
class_name Light
extends Line2D

@export var direction: Vector2 # normalized starting point direction
@export var starting_pos: Vector2

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	direction = direction.normalized()
	self.clear_points()
	self.add_point(starting_pos)
	var now_position: Vector2 = starting_pos
	var now_direction = direction
	
	var components = get_parent().get_children().filter(func(it): return it is Intersectable)
	var photosensitives = get_parent().get_children().filter(func(it): return it is Photosensitive)
	var active_photosensitives:Array = []
	
	var max_reflections = 100  # Prevent infinite loops
	var reflection_count = 0
	
	while reflection_count < max_reflections and now_position != Vector2.ZERO:
		var closest_component: Intersectable = null
		var closest_component_point = Vector2.ZERO
		var closest_component_distance = INF
		var last_component = closest_component  # Track the last component we reflected off
		
		# Find the closest intersection
		for component in components:
			# Skip the component we just reflected off to prevent immediate re-reflection
			if component == last_component and reflection_count > 0:
				continue
				
			var intersection = component.get_intersection(now_position, now_direction)  # Get the intersection point with the component
			if intersection != Vector2.ZERO:
				var distance = now_position.distance_to(intersection)
				# Use a small epsilon to prevent detecting intersections too close to starting point
				if distance > 0.01 and distance < closest_component_distance:
					closest_component_distance = distance
					closest_component_point = intersection
					closest_component = component
		
		# If we found a component, add the reflection
		if closest_component:
			#判断感光
			for photosensitive in photosensitives:
				if photosensitive.shine(now_position, now_direction, closest_component_point):
					active_photosensitives.append(photosensitive)

			self.add_point(closest_component_point)
			now_position = closest_component_point
			now_direction = closest_component.calculate_light_direction(closest_component_point, now_direction)
			if now_direction == Vector2.ZERO:
				break
			reflection_count += 1
		else:
			for photosensitive in photosensitives:
				photosensitive.shine(now_position, now_direction, Vector2.ZERO)
			# No more intersections found
			break
	
	#photosensitive activate
	for active_photosensitive in active_photosensitives:
		active_photosensitive.litting = true
	
	# Add the final ray extending outward
	self.add_point(now_position + now_direction * 10000)
