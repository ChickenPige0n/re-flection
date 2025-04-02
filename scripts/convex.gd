@tool
class_name Convex
extends "intersectable.gd"

@export
var focus:float = 128.0


func get_light_forward(intersection: Vector2, light_direction: Vector2):
	
	var a = intersection.distance_to(position)
	var light_rotation = light_direction.angle()
	
	var self_rotation = Vector2.from_angle(rotation).angle()
	# var self_rotation = position.angle_to(intersection)
	
	
	var alpha = light_rotation - self_rotation

	var b = focus / sin(alpha)
	
	var c = sqrt(a*a + b*b - 2*a*b*cos(alpha))

	var delta = acos((b*b + c*c - a*a) / (2*b*c))

	# print(delta)

	delta = min(delta, PI - delta)
	var standard = intersection.angle_to_point(position) 

	print(standard)
	
	if(abs(light_rotation + delta - standard) > abs(light_rotation - delta - standard)):
		delta = -delta
	
	# print(direction)
	return light_direction.rotated(delta)
