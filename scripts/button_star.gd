@tool
class_name ButtonStar
extends TextureButton

var passed = false

var unpassed_unhover = preload("res://images/button_star/unpassed_unhover.png")
var passed_unhover = preload("res://images/button_star/passed_unhover.png")
var unpassed_hover = preload("res://images/button_star/unpassed_hover.png")
var passed_hover = preload("res://images/button_star/passed_hover.png")

func _process(delta):
	texture_hover = passed_hover if passed else unpassed_hover
	texture_normal = passed_unhover if passed else unpassed_unhover

func set_text(str):
	get_children()[0].text = str
