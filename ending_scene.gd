extends Node2D

func _ready():
	AudioManager.stop_bgm()
	$career_screen.setup_data()

#func _input(event) :
#	if event is InputEventMouseButton || event is InputEventKey :
#		SceneManager.change_scene("res://start_menu.tscn")
