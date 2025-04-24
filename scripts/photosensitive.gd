@tool
class_name Photosensitive
extends Sprite2D


var active_texture = preload("res://images/candle/candle_lit_8.png")
var inactive_texture = preload("res://images/candle/candle_unlit.png")
var bias: Vector2 = Vector2(0, -32)
var active : bool = false
var litting : bool = false
var litting_time :float = 0
@export
var radius = 16

func _ready():
	set_texture(inactive_texture)


func _process(delta):
	if litting:
		litting_time += delta
		if litting_time > 2:
			set_texture(inactive_texture)
			active = true
	else:
		litting_time = 0
	litting = false
	
	if active:
		set_texture(active_texture)
	else:
		set_texture(inactive_texture)
	
	

func shine(starting_pos: Vector2, direction: Vector2, ending_pos: Vector2) -> void:
	var lit_position = position + bias
	var angle = starting_pos.direction_to(lit_position).angle_to(direction) # 光线与光对判定点的夹角
	#确保在射线一侧
	if ending_pos == Vector2.ZERO: #射线
		if abs(angle) > PI/2:
			return
	else: #线段
		var dis = starting_pos.distance_to(ending_pos)
		if starting_pos.distance_to(lit_position) > dis + radius or ending_pos.distance_to(lit_position) > dis + radius: #两侧
			return
	
	#确保照的到
	if abs (starting_pos.distance_to(lit_position) * sin(angle)) > radius:
		return
	litting = true
	



func calculate_light_direction(_intersection: Vector2 ,_light_direction: Vector2):
	return _light_direction
