@tool
extends Line2D

@onready var tween: Tween = create_tween()  # 动态创建 Tween

var start_point := Vector2(100, 100)
var end_point := Vector2(400, 300)
var duration := 2.0

func _ready():
	# 初始化线条：起点和终点相同
	clear_points()
	add_point(start_point)
	add_point(start_point)

	# 使用 Tween 动态更新终点
	tween.tween_method(_update_line_end, start_point, end_point, duration).set_trans(Tween.TRANS_QUART)

# 被 Tween 调用的方法，更新终点坐标
func _update_line_end(position: Vector2):
	set_point_position(1, position)
