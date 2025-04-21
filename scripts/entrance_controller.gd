extends Control

@export 
var exampleLightUp: Light
@export 
var exampleLightDown: Light

@export var levelContainer: FlowContainer
@export var changeSceneButton: PackedScene

var nums_of_levels: int = 3
var passedTime: Array = []

func _ready() -> void:
	doTween()
	passedTime.resize(nums_of_levels)
	
	for i in range(1,nums_of_levels + 1):
		var scene = changeSceneButton.instantiate() as Button
		levelContainer.add_child(scene)
		scene.text = "第%s关" % [i]
		scene.pressed.connect(loadGame.bind(i))
		

func loadGame(index: int):
	curIndex = index
	var sceneStr = "res://scenes/game_%s.tscn" % [index]
	var scene = load(sceneStr) as PackedScene
	var game = scene.instantiate() as Game
	print("instantiated " + sceneStr)
	game.completed.connect(showResult)
	get_tree().root.add_child(game)
	self.visible = false

var curIndex: int
func showResult(timeCost: float):
	self.visible = true
	passedTime[curIndex-1] = timeCost
	# TODO
	print(passedTime)

func _process(delta: float) -> void:
	pass
	#exampleLight.direction = Vector2.from_angle(exampleLight.direction.angle() + delta)

func doTween():
	var tweenUp = create_tween()\
	.set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_loops()\
	.bind_node(exampleLightUp)
	
	tweenUp.tween_property(exampleLightUp, "direction", Vector2.from_angle(PI / 4), 3)
	tweenUp.tween_property(exampleLightUp, "direction", Vector2.from_angle(0), 3)
	
	var tweenDown = create_tween()\
	.set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_loops()\
	.bind_node(exampleLightDown)
	
	tweenDown.tween_property(exampleLightDown, "direction", Vector2.from_angle(-PI / 4), 3)
	tweenDown.tween_property(exampleLightDown, "direction", Vector2.from_angle(0), 3)

	

@export var animator: AnimationPlayer
func _on_button_pressed() -> void:
	animator.play("goto_select")


func _on_back_button_pressed() -> void:
	animator.play("goto_select", -1, -1, true)
