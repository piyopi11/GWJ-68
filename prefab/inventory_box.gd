extends Control

var _name = ""
var _type = ""
var _key = ""

var pressed = false

signal selected

func setup_box () :
	$name.text = _name

func _on_button_pressed():
	emit_signal("selected", _key)
