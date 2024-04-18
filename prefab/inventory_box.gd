extends Control

var _name = ""
var _type = ""
var _key = ""

var pressed = false
var selected_box = false

signal selected

const EMPTY = preload("res://ui/ui_frame.png")
const ART = preload("res://ui/forge_painting.png")
const STATUE = preload("res://ui/forge_statue.png")

func setup_box () :
	$name.text = _name
	if _type == "painting" :
		$icon.texture = ART
	elif _type == "statue" :
		$icon.texture = STATUE
	else :
		$icon.texture = EMPTY

func _on_button_pressed():
	emit_signal("selected", _key)

func select_item () :
	if selected_box == false :
		if GameManager.bag.size() < GameManager.art_limit :
			GameManager.bag.append(_key)
			selected_box = true
			$button.add_stylebox_override("normal", $button.get_stylebox("hover"))
	else :
		GameManager.bag.erase(_key)
		selected_box = false
		$button.add_stylebox_override("normal", StyleBoxEmpty.new())

func deselect_item () :
	selected_box = false
	$button.add_stylebox_override("normal", StyleBoxEmpty.new())
	
