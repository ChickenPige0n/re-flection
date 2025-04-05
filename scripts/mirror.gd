@tool
class_name Mirror
extends "intersectable.gd"
# extends Sprite2D

func calculate_light_direction(_intersection: Vector2 ,light_direction: Vector2):
	var direction = get_direction_xy()
	return light_direction.bounce(Vector2(-direction.y, direction.x).normalized())
