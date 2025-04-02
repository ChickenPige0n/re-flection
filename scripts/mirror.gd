@tool
class_name Mirror
extends Sprite2D

@export
var length: float

func get_intersection(starting_pos: Vector2, direction: Vector2) -> Vector2:
	#VectorDebugTool.get_instance().clear()
	# Calculate the intersection point with the line defined by starting_pos and direction
	var self_center = position
	var self_half_length = length / 2
	var self_normal = get_normal()
	
	#VectorDebugTool.draw(position, self_normal, Color.RED, "", 100.0)
	var self_start = self_center - self_normal.rotated(PI / 2) * self_half_length
	var self_end = self_center + self_normal.rotated(PI / 2) * self_half_length
	var line_start = starting_pos
	var line_end = starting_pos + direction * 1000 # Arbitrary large length
	var line_intersection = get_line_intersection(self_start, self_end, line_start, line_end)
	if line_intersection:
		return line_intersection
	return Vector2.ZERO # Return a default Vector2 value when no intersection is found

func get_normal() -> Vector2:
	var direction = Vector2.from_angle(rotation) # Get the direction of the mirror
	# Calculate the normal vector of the mirror
	var self_normal = Vector2(-direction.y, direction.x).normalized()
	return self_normal

func get_line_intersection(line1_start: Vector2, line1_end: Vector2, line2_start: Vector2, line2_end: Vector2):	
	# Calculate the intersection point of two lines defined by their start and end points
	var denom = (line1_end.x - line1_start.x) * (line2_end.y - line2_start.y) - (line1_end.y - line1_start.y) * (line2_end.x - line2_start.x)
	if denom == 0:
		return null # Lines are parallel or coincident
	var ua = ((line2_end.x - line2_start.x) * (line1_start.y - line2_start.y) - (line2_end.y - line2_start.y) * (line1_start.x - line2_start.x)) / denom
	var ub = ((line1_end.x - line1_start.x) * (line1_start.y - line2_start.y) - (line1_end.y - line1_start.y) * (line1_start.x - line2_start.x)) / denom
	if ua < 0 or ua > 1 or ub < 0 or ub > 1:
		return null # Intersection is outside the segments
	return line1_start + ua * (line1_end - line1_start)

func is_point_on_line(point: Vector2, line_start: Vector2, line_end: Vector2) -> bool:
	# Check if a point is on the line segment defined by line_start and line_end
	var cross_product = (point - line_start).cross(line_end - line_start)
	if abs(cross_product) > 0.001: # Tolerance for floating point precision
		return false
	var dot_product = (point - line_start).dot(line_end - line_start)
	if dot_product < 0 or dot_product > (line_end - line_start).length_squared():
		return false
	return true
