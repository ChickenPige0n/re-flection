@tool
class_name Lens
extends "intersectable.gd"

@export
var focus:float = 128.0


func calculate_light_direction(intersection: Vector2, light_direction: Vector2) -> Vector2:
	# 计算光线与透镜的交点到透镜中心的距离
	var distance_to_center = intersection.distance_to(position)
	
	# 计算入射光方向与透镜轴之间的夹角
	var light_angle = light_direction.angle()
	var lens_angle = rotation  # 直接使用rotation而不是额外计算
	var incident_angle = light_angle - lens_angle
	
	# 当光线几乎平行于透镜轴时，不发生折射
	if abs(sin(incident_angle)) < 0.001:
		return light_direction
	
	# 确定透镜类型和焦距的绝对值
	var is_convex = focus > 0
	var abs_focus = abs(focus)
	
	# 计算光路参数
	var focus_sine_ratio = abs_focus / sin(incident_angle)
	var third_side = sqrt(distance_to_center*distance_to_center + focus_sine_ratio*focus_sine_ratio 
						 - 2*distance_to_center*focus_sine_ratio*cos(incident_angle))
	var base_angle = acos((focus_sine_ratio*focus_sine_ratio + third_side*third_side - distance_to_center*distance_to_center) 
						 / (2*focus_sine_ratio*third_side))
	
	# 根据透镜类型确定基础偏转角度
	var deflection_angle = base_angle if is_convex else -base_angle
	
	# 计算基准角度（从透镜位置到交点的方向）
	var reference_angle = intersection.angle_to_point(position)
	
	# 整合透镜类型判断逻辑
	var angle_diff1 = abs(light_angle + deflection_angle - reference_angle)
	var angle_diff2 = abs(light_angle - deflection_angle - reference_angle)
	if (is_convex && angle_diff1 > angle_diff2) || (!is_convex && angle_diff1 < angle_diff2):
		deflection_angle = -deflection_angle
	
	# 计算透镜法线向量
	var lens_normal = Vector2.from_angle(rotation + PI/2).normalized()
	return light_direction.rotated(deflection_angle).bounce(lens_normal)
