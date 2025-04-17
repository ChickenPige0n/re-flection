class_name Game
extends Node2D


var judgePoints

var timeCost = 0.0

signal completed(timeCost: float)

func _ready() -> void:
	judgePoints = get_children().filter(func(it): return it is Photosensitive) as Array[Photosensitive]
var winning: bool = false
func _process(delta: float) -> void:
	timeCost += delta
	var win:bool = true
	for point in judgePoints:
		if !point.active:
			win = false
	if win and not winning:
		winning = true
		
		var label:Label = Label.new()
		label.text = "游戏结束"
		label.position = Vector2(1152,648) / 2
		#label.pivot_offset = label.size / 2
		label.scale = Vector2.ZERO
		add_child(label)
		label.create_tween()\
		.bind_node(label)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)\
		.tween_property(label, "scale", Vector2(4,4), 3)
		
		var timer = Timer.new()
		timer.wait_time = 3
		add_child(timer)
		timer.timeout.connect(gameOver)
		timer.start()
func gameOver():
	print("game is over")
	completed.emit(timeCost)
	self.queue_free()
