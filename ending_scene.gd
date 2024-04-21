extends Node2D

var career = false
var achieve = false
var thank = false

func _ready():
	if GameManager.game_over == true :
		AudioManager.change_bgm("res://Peritune_Echoed_Art.ogg")
	elif (GameManager.art_stolen >= GameManager.total_gallery_art ) :
		AudioManager.change_bgm("res://Peritune_Zephyr_Fields_loop.ogg")
	AudioManager.play_bgm()
	$career_screen.setup_data()
	yield(get_tree().create_timer(1.0), "timeout")
	career = true

func _input(event) :
	if event is InputEventMouseButton || event is InputEventKey :
		if event is InputEventMouseButton && (event.button_index == 5 || event.button_index == 4) :
			return false
		if career == true :
			AudioManager.ok()
			$career_screen.get_node("title").text = "Your Achievements"
			$career_screen.get_node("scroll").visible = false
			$career_screen.get_node("scroll2").visible = true
			yield(get_tree().create_timer(1.0), "timeout")
			career = false
			achieve = true
		elif achieve == true :
			$career_screen.visible = false
			$thank_you.visible = true
			yield(get_tree().create_timer(1.0), "timeout")
			achieve = false
			thank = true
		elif thank == true :
			AudioManager.ok()
			SceneManager.change_scene("res://start_menu.tscn")
