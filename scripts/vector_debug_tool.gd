class_name VectorDebugTool
extends Node2D

## 存储要显示的所有向量
var _vectors:Array[DebugVector] = []
var arrow_size: float = 10.0
var font_size: int = 16
var line_width: float = 2.0
var auto_clear: bool = true  # 是否自动清除向量

## 存储单个向量的类
class DebugVector:
	var start: Vector2
	var direction: Vector2
	var color: Color
	var label: String
	var draw_scale: float
	
	func _init(start_pos: Vector2, dir: Vector2, col: Color, lbl: String, scl: float):
		start = start_pos
		direction = dir
		color = col
		label = lbl
		draw_scale = scl

## 添加一个新向量进行显示
func add_vector(start_pos: Vector2, direction: Vector2, color: Color = Color.WHITE, 
				label: String = "", draw_scale: float = 1.0) -> void:
	var vec = DebugVector.new(start_pos, direction, color, label, draw_scale)
	_vectors.append(vec)
	queue_redraw()

	if auto_clear:
		# 一帧后自动清除这个向量
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.01
		timer.one_shot = true
		timer.start()
		await timer.timeout
		timer.queue_free()
		remove_vector(vec)

## 移除特定向量
func remove_vector(vec: DebugVector) -> void:
	_vectors.erase(vec)
	queue_redraw()

## 清除所有向量
func clear() -> void:
	_vectors.clear()
	queue_redraw()

## 绘制所有向量
func _draw() -> void:
	for vec in _vectors:
		var end_pos = vec.start + vec.direction * vec.draw_scale
		
		# 绘制主线
		draw_line(vec.start, end_pos, vec.color, line_width)
		
		# 绘制箭头
		if arrow_size > 0:
			var dir_normalized = vec.direction.normalized()
			var arrow_perp = Vector2(-dir_normalized.y, dir_normalized.x)
			
			var arrow_p1 = end_pos - dir_normalized * arrow_size + arrow_perp * arrow_size * 0.5
			var arrow_p2 = end_pos - dir_normalized * arrow_size - arrow_perp * arrow_size * 0.5
			
			var points = PackedVector2Array([end_pos, arrow_p1, arrow_p2])
			draw_colored_polygon(points, vec.color)
		
		# 绘制标签
		if vec.label != "":
			draw_string(ThemeDB.fallback_font, vec.start + Vector2(5, -5), 
						vec.label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, vec.color)

## 静态方法相关
static var _instance: VectorDebugTool

## 获取或创建单例实例
static func get_instance() -> VectorDebugTool:
	if not _instance or not is_instance_valid(_instance):
		_instance = VectorDebugTool.new()
		var root = Engine.get_main_loop().root
		root.call_deferred("add_child", _instance)
	return _instance

## 静态方法：快速绘制向量
static func draw(start_pos: Vector2, direction: Vector2, color: Color = Color.WHITE, 
				label: String = "", draw_scale: float = 1.0) -> void:
	var instance = get_instance()
	instance.add_vector(start_pos, direction, color, label, draw_scale)
