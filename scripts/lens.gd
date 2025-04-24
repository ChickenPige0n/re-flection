@tool
class_name Lens
extends "intersectable.gd"

@export
var focus:float = 128.0


func calculate_light_direction(intersection: Vector2, light_direction: Vector2) -> Vector2:
	if(intersection.distance_to(position) < 0.01): # 光线与透镜中心重合
		return light_direction

	# 计算光线与透镜的交点到透镜中心的距离
	var distance_to_center = intersection.distance_to(position)
	
	# 计算入射光方向与透镜轴之间的夹角
	var light_angle:float = light_direction.angle()
	var lens_angle:float = position.angle_to_point(intersection) # 镜子方向定为与光线同侧
	var incident_angle = abs(fmod(lens_angle - light_angle, PI))
	
	var abs_focus = abs(focus) # 焦距的绝对值
	
	# 计算光路参数
	var focus_sine_ratio = abs_focus / sin(incident_angle)
	var third_side = sqrt(distance_to_center*distance_to_center + focus_sine_ratio*focus_sine_ratio 
						 - 2*distance_to_center*focus_sine_ratio*cos(incident_angle))
	var base_angle = asin(distance_to_center*sin(incident_angle) / third_side)

	# # 计算基准角度（从透镜位置到交点的方向）
	var reference_angle = (intersection.angle_to_point(position))
	
	#通过夹角大小来判断偏转方向 trans cis 好像反了 不重要
	var angle_trans = abs(Vector2.from_angle(light_angle + base_angle).angle_to(Vector2.from_angle(reference_angle)))
	var angle_cis = abs(Vector2.from_angle(light_angle - base_angle).angle_to(Vector2.from_angle(reference_angle)))

	# print(lens_angle)
	# print("light_angle "+str(light_angle) + "base_ange"+str(base_angle)+"reference_angle"+str(reference_angle)+" angle_trans: " + str(angle_trans) + " angle_cis: " + str(angle_cis))
	
	# 使用角度绝对值比较，确保选择正确的偏转方向
	var deflection_angle = base_angle * (1.0 if abs(angle_trans) < abs(angle_cis) else -1.0) * sign(focus)

	return light_direction.rotated(deflection_angle)
