@tool
extends Sprite2D
class_name Intersectable # 可相交的

@export var length: float = 256
@export var movable: bool = true
@export var rotatable: bool = true

func calculate_light_direction(_intersection: Vector2 ,_light_direction: Vector2):
	return Vector2.ZERO
	
	

func get_intersection(starting_pos: Vector2, direction: Vector2) -> Vector2:
	# VectorDebugTool.get_instance().clear()
	# Calculate the intersection point with the line defined by starting_pos and direction
	var self_center = position
	var self_half_length = length / 2
	var self_direction = get_direction_xy()
	
	# VectorDebugTool.draw(position, self_normal, Color.RED, "", 100.0)
	var self_start = self_center - self_direction * self_half_length
	var self_end = self_center + self_direction * self_half_length
	var line_start = starting_pos
	var line_end = starting_pos + direction * 1000 # Arbitrary large length
	var line_intersection = get_line_intersection(self_start, self_end, line_start, line_end)
	if line_intersection:
		return line_intersection
	return Vector2.ZERO # Return a default Vector2 value when no intersection is found

func get_direction_xy() -> Vector2:
	return Vector2.from_angle(rotation) # Get the direction of the mirror


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


#Move and rotate functions
var is_selected: bool = false
var dragging: bool = false
var rotating: bool = false
var bias: Vector2 = Vector2.ZERO
var facing_mouse: Vector2 = Vector2.ZERO
var facing_origin: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if dragging:
		self.position = get_global_mouse_position() - bias
	if rotating:
		var angle = facing_mouse.angle_to(self.position.direction_to(get_global_mouse_position()))
		self.rotation = facing_origin.rotated(angle).angle()
	pass

func _input(event):
	if event is InputEventMouseButton:
		handle_click(event)

func handle_click(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if event.ctrl_pressed:
				if rotatable and is_selected:
					rotating = true
					facing_mouse = self.position.direction_to(event.position)
					facing_origin = Vector2.from_angle(self.rotation)
			elif self.get_rect().has_point(to_local(event.position)):
				is_selected = true
				if movable:
					dragging = true
					bias = event.position - self.position
				
			else:
				is_selected = false
		else:
			dragging = false
			rotating = false
				
		
