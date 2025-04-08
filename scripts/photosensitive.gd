@tool
class_name Photosensitive
extends Sprite2D


var active_texture = preload("res://images/photosensitive/photosensitive_active.png")
var inactive_texture = preload("res://images/photosensitive/photosensitive_inactive.png")
var active : bool = false
var radius = 32



func _ready():
	set_texture(inactive_texture)

func _process(delta):
	if active:
		set_texture(active_texture)
	else:
		set_texture(inactive_texture)
	active = false
		

func shine(starting_pos: Vector2, direction: Vector2, ending_pos: Vector2) -> void:
	var angle = starting_pos.direction_to(position).angle_to(direction) # 光线与光对判定点的夹角
	#确保在射线一侧
	if ending_pos == Vector2.ZERO: #射线
		if abs(angle) > PI/2:
			return
	else: #线段
		var dis = starting_pos.distance_to(ending_pos)
		if starting_pos.distance_to(position) > dis + radius or ending_pos.distance_to(position) > dis + radius: #两侧
			return
	
	#确保照的到
	if abs (starting_pos.distance_to(position) * sin(angle)) > radius:
		return 
	active = true
	



func calculate_light_direction(_intersection: Vector2 ,_light_direction: Vector2):
	return _light_direction
