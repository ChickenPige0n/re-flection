class_name Game
extends Node2D


var judgePoints

var timeCost = 0.0
@export
var hintLabel: Label
signal completed(timeCost: float)

func _ready() -> void:
	judgePoints = get_children().filter(func(it): return it is Photosensitive) as Array[Photosensitive]

var winning: bool = false

func _process(delta: float) -> void:
	timeCost += delta
	if timeCost > 5 and hintLabel:
		var tween = hintLabel.create_tween().bind_node(hintLabel).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(hintLabel, "position", Vector2(250, 20), 2)
	var win:bool = true
	for point in judgePoints:
		if !point.active:
			win = false
	if win and not winning:
		winning = true
		# endInput()
		# todo: replace with packed sprite
		var label:Label = Label.new()
		label.label_settings = LabelSettings.new()
		label.text = "游戏结束"
		label.position = Vector2(1152,648) / 2
		#label.pivot_offset = label.size / 2
		label.scale = Vector2.ZERO
		add_child(label)
		label.create_tween()\
		.bind_node(label)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)\
		.tween_property(label.label_settings, "font_size", 32, 3)
		
		var timer = Timer.new()
		timer.wait_time = 3
		add_child(timer)
		timer.timeout.connect(gameOver)
		timer.start()

func gameOver():
	print("game is over")
	completed.emit(timeCost)
	self.queue_free()

func endInput():
	var components = get_children().filter(func(it): return it is Intersectable)
	for component in components:
		component.is_selected = false
		component.dragging = false
		component.rotating = false
