extends Control

@export 
var exampleLightUp: Light
@export 
var exampleLightDown: Light
@export
var line_stars: Line2D

@export var levelContainer: Container
@export var changeSceneButton: PackedScene

var nums_of_levels: int = 7
var nums_of_passed_levels: int = 0
var passedTime: Array = []
var buttons : Array = []
var stars_position: Array = [
	Vector2(64, 62),
	Vector2(272, 26),
	Vector2(392, 92),
	Vector2(543, 159),
	Vector2(572, 324),
	Vector2(817, 304),
	Vector2(854, 141)
]
var light_bias = Vector2(1239, 188)

@onready var tween_stars: Tween

func _ready() -> void:
	doTween()
	line_stars.clear_points()
	# line_stars.position = stars_position[0]
	line_stars.add_point(stars_position[0] + light_bias)
	#levelContainer.add_child(line_stars)
	#line_stars.z_index = 5
	#for p in stars_position:
		#line_stars.add_point(p)
	
	for i in range(1,nums_of_levels+1):
		var scene = changeSceneButton.instantiate() as TextureButton
		levelContainer.add_child(scene)
		scene.set_text("第%s关" % [i])
		scene.pressed.connect(loadGame.bind(i))
		scene.visible = (i == 1)
		scene.z_index = 10
		scene.scale = Vector2(0.7, 0.7)
		scene.position = stars_position[i-1]
		buttons.append(scene)

func loadGame(index: int):
	curIndex = index
	var sceneStr = "res://scenes/game_%s.tscn" % [index]
	var scene = load(sceneStr) as PackedScene
	var game = scene.instantiate() as Game
	print("instantiated " + sceneStr)
	game.completed.connect(_showResult)
	get_tree().root.add_child(game)
	self.visible = false

var curIndex: int
func _showResult(timeCost: float): # 通关后处理
	self.visible = true
	if curIndex == nums_of_passed_levels + 1:
		nums_of_passed_levels += 1
		passedTime.append(timeCost)
		buttons[nums_of_passed_levels-1].passed = true
		buttons[nums_of_passed_levels-1].set_text("第%s关\n" % [nums_of_passed_levels] + "时间：%.2f" % [passedTime[nums_of_passed_levels-1]] + "s")
		if nums_of_passed_levels < nums_of_levels:
			line_stars.add_point(stars_position[nums_of_passed_levels]+ light_bias)
			#line_stars.visible = true
			#print(line_stars.get_point_position(nums_of_passed_levels-1))
			#buttons[nums_of_passed_levels].visible = true
			tween_stars = create_tween()
			tween_stars.tween_method(
				_update_line_end,
				stars_position[nums_of_passed_levels-1]+ light_bias,
				stars_position[nums_of_passed_levels]+ light_bias,
				2
				).set_trans(Tween.TRANS_QUAD)
		
		#延迟出按钮
		var timer = Timer.new()
		timer.wait_time = 2.05
		add_child(timer)
		timer.timeout.connect(show_button.bind(nums_of_passed_levels))
		timer.start()
	else:
		passedTime[curIndex-1] = timeCost

func _process(delta: float) -> void:
	pass
	#exampleLight.direction = Vector2.from_angle(exampleLight.direction.angle() + delta)

func show_button(index):
	buttons[index].visible = true

var speed = 3
func doTween(): # 开始界面光线
	var tweenUp = create_tween()\
	.set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_loops()\
	.bind_node(exampleLightUp)
	
	tweenUp.tween_property(exampleLightUp, "direction", Vector2.from_angle(PI / 4), speed)
	tweenUp.tween_property(exampleLightUp, "direction", Vector2.from_angle(0), speed)
	
	var tweenDown = create_tween()\
	.set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_loops()\
	.bind_node(exampleLightDown)
	
	tweenDown.tween_property(exampleLightDown, "direction", Vector2.from_angle(-PI / 4), speed)
	tweenDown.tween_property(exampleLightDown, "direction", Vector2.from_angle(0), speed)
	
@export var animator: AnimationPlayer
func _on_button_pressed() -> void:
	animator.play("goto_select")

func _on_back_button_pressed() -> void:
	animator.play("goto_select", -1, -1, true)

func _update_line_end(position: Vector2):
	line_stars.set_point_position(nums_of_passed_levels, position)
