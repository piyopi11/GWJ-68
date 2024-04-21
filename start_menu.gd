extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_start_game_pressed():
	AudioManager.ok()
	get_parent().get_parent().get_node("camera_movement").play("settings")
#	yield(get_parent().get_parent().get_node("camera_movement"), "animation_finished")
#	GameManager.new_game()
#	SceneManager.change_scene("res://home_menu.tscn")
