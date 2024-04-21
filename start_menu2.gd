extends Spatial

var listen_rebind = false
var key_rebind = 0

var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera.translation = Vector3(0, 4, 11)
	$Camera.rotation = Vector3(deg2rad(-15.0), 0.0, 0.0)
	$Camera.fov = 70
	$canvas/root/ColorRect3.modulate = Color(1.0,1.0,1.0,0.0)
	$canvas/root/ColorRect3.visible = true
	$canvas/root/settings.visible = false
	$canvas/root/show_guide.visible = false
	$canvas/root/credits.visible = false
	$canvas/root/start_game.visible = true
	$canvas/root/settings/frame/setting_root/bgm_slider.value = int(db2linear(AudioServer.get_bus_volume_db(2)) * 100)
	$canvas/root/settings/frame/setting_root/sfx_slider.value = int(db2linear(AudioServer.get_bus_volume_db(1)) * 100)
	setup_input()
	randomize()
	var r = clamp(int(rand_range(0, 8)), 0, 7)
	$painting1.idx = r
	$painting1.setup_painting()
	AudioManager.change_bgm("res://PeriTune_Alleyway_loop.ogg")
	AudioManager.play_bgm()

func _input (event) :
	if listen_rebind == true :
		if event is InputEventKey :
			if event.pressed && pressed == false :
				pressed = true
			elif event.pressed == false && pressed == true :
				pressed = false
				listen_rebind = false
				rebind_key(event.scancode)

func rebind_key (scancode) :
	AudioManager.ok()
	var e = false
	var t = 0
	#check if key exist
	if InputMap.get_action_list("ui_interact")[0].scancode == scancode && key_rebind != 0 :
		e = true
		t = 0
	elif InputMap.get_action_list("ui_first_person")[0].scancode == scancode && key_rebind != 1 :
		e = true
		t = 1
	elif InputMap.get_action_list("ui_sprinting")[0].scancode == scancode && key_rebind != 2 :
		e = true
		t = 2
	elif InputMap.get_action_list("ui_up")[0].scancode == scancode && key_rebind != 3 :
		e = true
		t = 3
	elif InputMap.get_action_list("ui_down")[0].scancode == scancode && key_rebind != 4 :
		e = true
		t = 4
	elif InputMap.get_action_list("ui_left")[0].scancode == scancode && key_rebind != 5 :
		e = true
		t = 5
	elif InputMap.get_action_list("ui_right")[0].scancode == scancode && key_rebind != 6 :
		e = true
		t = 6
	elif InputMap.get_action_list("ui_tool_1")[0].scancode == scancode && key_rebind != 7 :
		e = true
		t = 7
	elif InputMap.get_action_list("ui_tool_2")[0].scancode == scancode && key_rebind != 8 :
		e = true
		t = 8
	elif InputMap.get_action_list("ui_tool_3")[0].scancode == scancode && key_rebind != 9 :
		e = true
		t = 9
	#rebind key
	var temp = 0
	if key_rebind == 0 :
		if e == true :
			temp = InputMap.get_action_list("ui_interact")[0].scancode
		InputMap.get_action_list("ui_interact")[0].scancode = scancode
	elif key_rebind == 1 :
		if e == true :
			temp = InputMap.get_action_list("ui_first_person")[0].scancode
		InputMap.get_action_list("ui_first_person")[0].scancode = scancode
	elif key_rebind == 2 :
		if e == true :
			temp = InputMap.get_action_list("ui_sprinting")[0].scancode
		InputMap.get_action_list("ui_sprinting")[0].scancode = scancode
	elif key_rebind == 3 :
		if e == true :
			temp = InputMap.get_action_list("ui_up")[0].scancode
		InputMap.get_action_list("ui_up")[0].scancode = scancode
	elif key_rebind == 4 :
		if e == true :
			temp = InputMap.get_action_list("ui_down")[0].scancode
		InputMap.get_action_list("ui_down")[0].scancode = scancode
	elif key_rebind == 5 :
		if e == true :
			temp = InputMap.get_action_list("ui_left")[0].scancode
		InputMap.get_action_list("ui_left")[0].scancode = scancode
	elif key_rebind == 6 :
		if e == true :
			temp = InputMap.get_action_list("ui_right")[0].scancode
		InputMap.get_action_list("ui_right")[0].scancode = scancode
	elif key_rebind == 7 :
		if e == true :
			temp = InputMap.get_action_list("ui_tool_1")[0].scancode
		InputMap.get_action_list("ui_tool_1")[0].scancode = scancode
	elif key_rebind == 8 :
		if e == true :
			temp = InputMap.get_action_list("ui_tool_2")[0].scancode
		InputMap.get_action_list("ui_tool_2")[0].scancode = scancode
	elif key_rebind == 9 :
		if e == true :
			temp = InputMap.get_action_list("ui_tool_3")[0].scancode
		InputMap.get_action_list("ui_tool_3")[0].scancode = scancode
	#swap if necessary
	if e == true :
		if t == 0 :
			InputMap.get_action_list("ui_interact")[0].scancode = temp
		elif t == 1 :
			InputMap.get_action_list("ui_first_person")[0].scancode = temp
		elif t == 2 :
			InputMap.get_action_list("ui_sprinting")[0].scancode = temp
		elif t == 3 :
			InputMap.get_action_list("ui_up")[0].scancode = temp
		elif t == 4 :
			InputMap.get_action_list("ui_down")[0].scancode = temp
		elif t == 5 :
			InputMap.get_action_list("ui_left")[0].scancode = temp
		elif t == 6 :
			InputMap.get_action_list("ui_right")[0].scancode = temp
		elif t == 7 :
			InputMap.get_action_list("ui_tool_1")[0].scancode = temp
		elif t == 8 :
			InputMap.get_action_list("ui_tool_2")[0].scancode = temp
		elif t == 9 :
			InputMap.get_action_list("ui_tool_3")[0].scancode = temp
	#redraw input
	setup_input()
	$canvas/root/settings/listener_box.visible = false

func setup_input () :
	$canvas/root/settings/frame/rebind_key/button_1.text = OS.get_scancode_string(InputMap.get_action_list("ui_interact")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_2.text = OS.get_scancode_string(InputMap.get_action_list("ui_first_person")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_3.text = OS.get_scancode_string(InputMap.get_action_list("ui_sprinting")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_4.text = OS.get_scancode_string(InputMap.get_action_list("ui_up")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_5.text = OS.get_scancode_string(InputMap.get_action_list("ui_down")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_6.text = OS.get_scancode_string(InputMap.get_action_list("ui_left")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_7.text = OS.get_scancode_string(InputMap.get_action_list("ui_right")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_8.text = OS.get_scancode_string(InputMap.get_action_list("ui_tool_1")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_9.text = OS.get_scancode_string(InputMap.get_action_list("ui_tool_2")[0].scancode)
	$canvas/root/settings/frame/rebind_key/button_10.text = OS.get_scancode_string(InputMap.get_action_list("ui_tool_3")[0].scancode)

func _on_settings_cancel_pressed():
	AudioManager.cancel()
	if $canvas/root/settings/frame/setting_root.visible == true :
		$camera_movement.play("settings_to_home")
		yield($camera_movement, "animation_finished")
		$canvas/root/start_game.visible = true
	elif $canvas/root/settings/frame/rebind_key.visible == true :
		$canvas/root/settings/frame/rebind_key.visible = false
		$canvas/root/settings/frame/setting_root.visible = true

func _on_start_game_pressed():
	AudioManager.ok()
	$camera_movement.play("start_game")
	yield($camera_movement, "animation_finished")
	$canvas/root/show_guide.visible = true

func _on_settings_button_pressed():
	$canvas/root/start_game.visible = false
	AudioManager.ok()
	$camera_movement.play("settings")
	yield($camera_movement, "animation_finished")

func fade_out_bgm() :
	AudioManager.fade_out_bgm()

func _on_bgm_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear2db(float(value/100.0)) )

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear2db(float(value/100.0)) )

func _on_rebind_key(arg):
	key_rebind = arg
	listen_rebind = true
	$canvas/root/settings/listener_box.visible = true

func _on_rebind_key_pressed():
	AudioManager.ok()
	$canvas/root/settings/frame/setting_root.visible = false
	$canvas/root/settings/frame/rebind_key.visible = true

func _on_gameplay_no_pressed():
	AudioManager.cancel()
	$canvas/root/show_guide.visible = false
	GameManager.guide = [true, true, true, true, true, true, true, true]
	GameManager.new_game()
	SceneManager.change_scene("res://home_menu.tscn")


func _on_gameplay_yes_pressed():
	AudioManager.ok()
	$canvas/root/show_guide.visible = false
	GameManager.new_game()
	SceneManager.change_scene("res://home_menu.tscn")

func _on_credits_button_pressed():
	$canvas/root/start_game.visible = false
	AudioManager.ok()
	$camera_movement.play("credits")
	yield($camera_movement, "animation_finished")

func _on_credits_cancel_pressed():
	AudioManager.cancel()
	$camera_movement.play("credits_to_home")
	yield($camera_movement, "animation_finished")
	$canvas/root/start_game.visible = true
