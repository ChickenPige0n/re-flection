@tool
class_name Mirror
extends "intersectable.gd"
# extends Sprite2D

func calculate_light_direction(_intersection: Vector2 ,light_direction: Vector2):
	
	if Vector2.from_angle(self.rotation).angle_to(light_direction) < 0: # 一侧不能反射
		return Vector2.ZERO
	var direction = get_direction_xy()
	return light_direction.bounce(Vector2(-direction.y, direction.x).normalized())
