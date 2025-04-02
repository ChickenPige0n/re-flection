@tool
class_name Mirror
extends "intersectable.gd"
# extends Sprite2D

func get_light_forward(intersection: Vector2 ,light_direction: Vector2):
	var direction = get_direction_xy()
	return light_direction.bounce(Vector2(-direction.y, direction.x).normalized())
