@tool
class_name FaceMirror
extends Intersectable

# 曲率半径：正值表示凸面镜，负值表示凹面镜
@export var radius: float = 128.0:
	set(value):
		radius = value
		queue_redraw()  # 当半径改变时重绘

@export var show_radius: bool = true:
	set(value):
		show_radius = value
		queue_redraw()  # 当显示设置改变时重绘

# 添加颜色自定义选项
@export var radius_color: Color = Color(0.2, 0.8, 1.0, 0.4)

# 当工具激活或值改变时调用此函数来刷新显示
func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()

# 绘制函数，用于可视化曲率半径
func _draw():
	if not Engine.is_editor_hint() or not show_radius:
		return
	
	# 圆心就是position，所以偏移为零向量
	draw_arc(Vector2.ZERO, abs(radius), 0, PI if radius > 0 else -PI, 64, radius_color)
	
# 覆写获取交点的方法，计算光线与曲面镜的交点
func get_intersection(starting_pos: Vector2, direction: Vector2) -> Vector2:
	var mirror_dir = get_direction_xy()
	# 圆心就是position
	var circle_center = position
	
	# 计算光线与圆的交点
	var ray_dir = direction.normalized()
	var a = ray_dir.dot(ray_dir)  # 应该是1，因为是单位向量
	var b = 2 * ray_dir.dot(starting_pos - circle_center)
	var c = (starting_pos - circle_center).dot(starting_pos - circle_center) - abs(radius) * abs(radius)
	
	# 计算判别式
	var discriminant = b * b - 4 * a * c
	if discriminant < 0:
		return Vector2.ZERO
	
	# 计算可能的交点
	var t1 = (-b - sqrt(discriminant)) / (2 * a)
	var t2 = (-b + sqrt(discriminant)) / (2 * a)
	
	# 选择有效的交点
	var t = INF
	var normal_dir = mirror_dir.rotated(PI/2)
	
	# 检查第一个交点
	if t1 > 0.001:
		var point1 = starting_pos + t1 * ray_dir
		var to_point1 = point1 - circle_center
		var on_reflection_side1 = false
		
		if radius > 0:  # 凸面镜
			on_reflection_side1 = to_point1.dot(normal_dir) > 0
		else:  # 凹面镜
			on_reflection_side1 = to_point1.dot(normal_dir) < 0
			
		if on_reflection_side1:
			t = t1
	
	# 检查第二个交点
	if t2 > 0.001:
		var point2 = starting_pos + t2 * ray_dir
		var to_point2 = point2 - circle_center
		var on_reflection_side2 = false
		
		if radius > 0:  # 凸面镜
			on_reflection_side2 = to_point2.dot(normal_dir) > 0
		else:  # 凹面镜
			on_reflection_side2 = to_point2.dot(normal_dir) < 0
			
		# 如果第二个点在反射面上，且之前没找到有效点或第二个点更近
		if on_reflection_side2 and (t == INF || (t2 < t)):
			t = t2
	
	if t == INF:
		return Vector2.ZERO
	
	# 计算交点坐标
	var intersection = starting_pos + t * ray_dir
	
	# 检查交点是否在镜面的有效范围内
	# 计算交点在镜面坐标系中的位置
	var local_pos = intersection - position
	var along_mirror = local_pos.dot(mirror_dir)
	
	# 检查交点是否在镜面长度范围内
	if abs(along_mirror) <= length / 2:
		# 曲面镜的反射面检查 - 只有半圆部分可以反射
		var to_intersection = intersection - circle_center
		
		# 判断交点是否在反射面的半圆上
		# 凸面镜和凹面镜的判断条件不同
		var on_reflection_side
		if radius > 0:  # 凸面镜
			on_reflection_side = to_intersection.dot(normal_dir) > 0
		else:  # 凹面镜
			on_reflection_side = to_intersection.dot(normal_dir) < 0
		
		if on_reflection_side:
			# 计算交点处的法线
			var normal = to_intersection.normalized()
			if radius < 0:
				normal = -normal  # 凹面镜法线方向相反
				
			# 判断光线是否从反射面方向入射
			var incident_dot = -ray_dir.dot(normal)  # 入射光与法线夹角的余弦值
			
			# 光线与反射面法线夹角小于90度(dot > 0)，说明光线从反射面方向射入
			if incident_dot > 0:
				return intersection
			
	return Vector2.ZERO

# 覆写计算反射方向的方法
func calculate_light_direction(intersection: Vector2, light_direction: Vector2) -> Vector2:
	# 圆心就是position
	var circle_center = position
	
	# 计算交点处的法线方向
	var normal = (intersection - circle_center).normalized()
	# 凹面镜和凸面镜法线方向相反
	if radius < 0:
		normal = -normal
	
	# 计算反射方向
	return light_direction.bounce(normal)
