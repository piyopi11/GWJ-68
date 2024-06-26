extends KinematicBody

var move_x = 0.0
var move_z = 0.0
var speed = 20.0

var sprinting = false
var sprint_modifier = 1.0

var front = null
var npc_group = []
var interact_node = null
var interacting = false
var interaction_progress = 0.0
var interaction_step = 5.0
var swiping_item = null
var can_interact = false

var changing_camera = false
var is_first_person = false

var last_mouse_pos = Vector2(0.0, 0.0)
var mode = "visit"

var result_screen = false
var result_complete = false

const EMPTY = preload("res://ui/ui_frame.png")
const ART = preload("res://ui/painting.png")
const STATUE = preload("res://ui/statue.png")

var tool_lock=0
var tool_hold=0.0

var active_tool = [false, false, false]
var tool_cooldown = [0.0, 0.0, 0.0]
var tool_use = [0, 0, 0]
var tool_duration = [0.0, 0.0, 0.0]

var stealth = false
export (NodePath) var cricket_path
onready var cricket = get_node(cricket_path)

var block = false

var career_screen = false

var facing = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup_ui() :
	if mode == "visit": 
		$ui/time_counter.visible = false
		$ui/back_button.visible = true
		$ui/tool_box.visible = false
		$ui/result_screen.visible = false
		$ui/current_frame.visible = false
		$"ui/camera instruction".visible = false
		$ui/texture.visible = true
		$"ui/camera instruction".text = "Press {0} to take a photo".format([OS.get_scancode_string(InputMap.get_action_list("ui_interact")[0].scancode)])
	elif mode == "heist" :
		$ui/time_counter.visible = true
		$ui/back_button.visible = false
		$ui/tool_box.visible = true
		$ui/result_screen.visible = false
		$"ui/camera instruction".visible = false
		$ui/texture.visible = false
		$ui/current_frame/name.text = GameManager.get_inventory(GameManager.bag[0]).name
		if GameManager.get_inventory(GameManager.bag[0]).type == "painting" :
			$ui/current_frame.texture = ART
		elif  GameManager.get_inventory(GameManager.bag[0]).type == "statue" :
			$ui/current_frame.texture = STATUE
		$ui/current_frame.visible = true
		for i in range(GameManager.tools.size()) :
			tool_use[i] = GameManager.tools_base[GameManager.tools[i]].limit
			if (GameManager.tools_base[GameManager.tools[i]].cool != 0) :
				$ui/tool_box.get_node("tool{0}".format([i+1])).max_value=GameManager.tools_base[GameManager.tools[i]].cool
			$ui/tool_box.get_node("tool{0}".format([i+1])).get_node("icon").texture = load("res://tools/{0}.png".format([GameManager.tools_base[GameManager.tools[i]].icon]))
		$ui/swipe_popup/interact_button/Label.text = OS.get_scancode_string(InputMap.get_action_list("ui_interact")[0].scancode)
		$ui/door_popup/interact_button/Label.text = OS.get_scancode_string(InputMap.get_action_list("ui_interact")[0].scancode)
		$ui/tool_box/tool1/number.text = OS.get_scancode_string(InputMap.get_action_list("ui_tool_1")[0].scancode)
		$ui/tool_box/tool2/number.text = OS.get_scancode_string(InputMap.get_action_list("ui_tool_2")[0].scancode)
		$ui/tool_box/tool3/number.text = OS.get_scancode_string(InputMap.get_action_list("ui_tool_3")[0].scancode)

func _process(_delta) :
	if result_screen == false && block == false :
		check_input(_delta)
		if interacting && interaction_progress < 100.0:
			perform_interaction(_delta)
		check_raycast()
		tool_decay(_delta)
		cooldown_tool(_delta)

func perform_interaction (delta) :
	interaction_progress = min(interaction_progress + (interaction_step * delta), 100.0)
	$ui/interaction_progress.value = interaction_progress
	if interaction_progress >= 100.0 :
		AudioManager.ok()
		swiping_item.swap_data(GameManager.bag.pop_front())
		GameManager.art_stolen += 1
		can_interact = GameManager.bag.size() > 0
		if can_interact :
			$ui/current_frame/name.text = GameManager.get_inventory(GameManager.bag[0]).name
			if GameManager.get_inventory(GameManager.bag[0]).type == "painting" :
				$ui/current_frame.texture = ART
			elif  GameManager.get_inventory(GameManager.bag[0]).type == "statue" :
				$ui/current_frame.texture = STATUE
		else :
			$ui/current_frame/name.text = "Empty"
			$ui/current_frame.texture = EMPTY
		$ui/interaction_progress.visible = false
		interacting = false

func _input(event) :
	if result_screen == false && GameManager.game_over == false && is_first_person == true :
		check_mouse_movement(event)
	elif result_screen == true && result_complete == true :
		if event is InputEventMouseButton || event is InputEventKey :
			if AudioManager.is_not_playing("ok") :
				AudioManager.ok()
			if GameManager.art_stolen < GameManager.total_gallery_art :
				GameManager.setup_day()
				SceneManager.change_scene("res://home_menu.tscn")
			else :
				SceneManager.change_scene("res://ending_scene.tscn")
	elif GameManager.game_over == true && $ui/game_over_screen.visible == true :
		if event is InputEventMouseButton || event is InputEventKey :
			if AudioManager.is_not_playing("ok") :
				AudioManager.ok()
			SceneManager.change_scene("res://ending_scene.tscn")
#			$ui/career_screen.setup_data()
#			$ui/career_screen.visible = true
#			$ui/game_over_screen.visible = false
#			yield(get_tree().create_timer(1.0), "timeout")
#			career_screen = true
	elif GameManager.game_over == true && career_screen == true && $ui/career_screen.visible == true :
		if event is InputEventMouseButton || event is InputEventKey :
			if AudioManager.is_not_playing("ok") :
				AudioManager.ok()
			SceneManager.change_scene("res://start_menu.tscn")

func check_raycast() :
	if is_first_person == false :
		var b = $Camera/RayCast.get_collider()
		if b != null :
			if b.is_in_group("cullable") && front != b :
		#		b.visible = false
				b.get_node("mesh").mesh.material.albedo_color = Color(1.0, 1.0, 1.0, 0.5)
			if front != b && front != null :
				if front.is_in_group("cullable") :
					front.get_node("mesh").mesh.material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
				front = b
			elif front == null :
				front = b
	else :
		var b = $fps_camera/ray.get_collider()
		if b != null && mode == "visit" :
			if b.is_in_group("interactable") && interact_node != b :
				interact_node = b
				var d = null
				if interact_node.is_in_group("painting") :
					d = GameManager.get_painting(interact_node.idx).data
				elif interact_node.is_in_group("statue") :
					d = GameManager.get_statue(interact_node.idx).data
				$ui/info_box/content/title.text = d.name
				$ui/info_box/content/author_row/author.text = Artwork.artists[d.artist]
				$ui/info_box.visible = true
		else :
			interact_node = null
			$ui/info_box.visible = false
		

func check_mouse_movement (event) :
	if is_first_person == true :
		if event is InputEventMouseMotion :
			var s = event.relative
			if last_mouse_pos != s :
				var m_x = -2.0 if last_mouse_pos.x < s.x else 2.0 if last_mouse_pos.x > s.x else 0.0
				var m_y = -2.0 if last_mouse_pos.y < s.y else 2.0 if last_mouse_pos.y > s.y else 0.0
#				$fps_camera.rotate_x(deg2rad(m_y * 0.5) )
				$fps_camera.rotation.x = lerp_angle($fps_camera.rotation.x, $fps_camera.rotation.x + deg2rad(m_y), 0.7)
				$fps_camera.rotation.x = clamp($fps_camera.rotation.x, deg2rad(0.0), deg2rad(45.0))
#				rotate_y(deg2rad(m_x * 0.5) )
				rotation.y = lerp_angle(rotation.y, rotation.y + deg2rad(m_x), 0.7)
				rotation.z = 0.0
				$fps_camera.rotation.z = 0.0

func check_input(delta) :
	if is_first_person == false :
		if interacting == false :
			#check sprinting first 
			if Input.is_action_pressed("ui_sprinting") :
				sprint_modifier = 1.2
			else :
				sprint_modifier = 1.0
			#movement block
			if Input.is_action_pressed("ui_right") :
				facing = 1
				move_x = speed * 1.0 * sprint_modifier
			elif Input.is_action_pressed("ui_left") :
				facing = 2
				move_x = speed * -1.0 * sprint_modifier
			else :
				move_x = 0.0
			if Input.is_action_pressed("ui_down") :
				facing = 3
				move_z = speed * 1.0 * sprint_modifier
			elif Input.is_action_pressed("ui_up") :
				facing = 0
				move_z = speed * -1.0 * sprint_modifier
			else :
				move_z = 0.0
			#tool block
			if Input.is_action_pressed("ui_tool_1") && mode == "heist" && active_tool[0] == false :
				if tool_lock == 0 :
					tool_lock = 1
				tool_hold += delta
				if tool_hold > 1.0 :
					AudioManager.select()
					process_hold(0)
					tool_lock = 0
					tool_hold = 0.0
			elif Input.is_action_pressed("ui_tool_2") && mode == "heist" && active_tool[1] == false :
				if tool_lock == 0 :
					tool_lock = 2
				tool_hold += delta
				if tool_hold > 1.0 :
					AudioManager.select()
					process_hold(1)
					tool_lock = 0
					tool_hold = 0.0
			elif Input.is_action_pressed("ui_tool_3") && mode == "heist" && active_tool[2] == false :
				if tool_lock == 0 :
					tool_lock = 3
				tool_hold += delta
				if tool_hold > 1.0 :
					AudioManager.select()
					process_hold(2)
					tool_lock = 0
					tool_hold = 0.0
			elif Input.is_action_just_released("ui_tool_1") && mode =="heist" && tool_lock == 1 && active_tool[0] == false:
				AudioManager.select()
				if tool_hold >= 0.3 :
					process_hold(0)
				else :
					process_tap(0)
				tool_lock = 0
				tool_hold = 0.0
			elif Input.is_action_just_released("ui_tool_2") && mode =="heist" && tool_lock == 2 && active_tool[1] == false :
				AudioManager.select()
				if tool_hold >= 0.3 :
					process_hold(1)
				else :
					process_tap(1)
				tool_lock = 0
				tool_hold = 0.0
			elif Input.is_action_just_released("ui_tool_3") && mode =="heist" && tool_lock == 3 && active_tool[0] == false :
				AudioManager.select()
				if tool_hold >= 0.3 :
					process_hold(2)
				else :
					process_tap(2)
				tool_lock = 0
				tool_hold = 0.0
			if Input.is_action_just_pressed("ui_switch") && mode == "heist" :
				if GameManager.bag.size() > 1 :
					AudioManager.ok()
					var temp = GameManager.bag[0]
					GameManager.bag[0] = GameManager.bag[1]
					GameManager.bag[1] = temp
					$ui/current_frame/name.text = GameManager.get_inventory(GameManager.bag[0]).name
					if GameManager.get_inventory(GameManager.bag[0]).type == "painting" :
						$ui/current_frame.texture = ART
					elif  GameManager.get_inventory(GameManager.bag[0]).type == "statue" :
						$ui/current_frame.texture = STATUE
				else :
					AudioManager.cancel()
		if Input.is_action_pressed("ui_interact") && mode == "heist" && interact_node != null:
			if interact_node.is_in_group("exit") :
				if AudioManager.is_not_playing("ok") :
					AudioManager.ok()
				end_stage()
				return false
			elif interact_node.is_in_group("swipable") && can_interact == true && interact_node.forged == false :
				if interact_node.type == GameManager.get_inventory(GameManager.bag[0]).type :
					interacting = true
					if swiping_item != interact_node :
						interaction_progress = 0.0
						swiping_item = interact_node
					if interact_node.is_in_group("swipable") :
						$ui/swipe_popup.visible = false
					elif interact_node.is_in_group("exit") :
						$ui/door_popup.visible = false
					$ui/interaction_progress.visible = true
				else :
					if AudioManager.is_not_playing("cancel") :
						AudioManager.cancel()
		elif Input.is_action_just_released("ui_interact") && interacting == true :
			$ui/interaction_progress.visible = false
			if interact_node.is_in_group("swipable") && interact_node.forged == false :
				$ui/swipe_popup.visible = true
			elif interact_node.is_in_group("exit") :
				$ui/door_popup.visible = true
#			interaction_progress = 0.0
			interacting = false
	if Input.is_action_just_pressed("ui_first_person") && changing_camera == false && interacting == false:
		changing_camera = true
		if $Camera.current == true :
			match facing :
				0 :
					rotation.y = deg2rad(0.0)
				1 : 
					rotation.y = deg2rad(-90.0)
				2 :
					rotation.y = deg2rad(90.0)
				3 :
					rotation.y = deg2rad(180.0)
			$Camera.current = false
			$Camera/RayCast.enabled = false
			$fps_camera.current = true
			$fps_camera/ray.enabled = true
			is_first_person = true
			changing_camera = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			$ui/swipe_popup.visible = false
			if mode == "visit" :
				$ui/back_button.visible = false
				$"ui/camera instruction".visible = true
		else :
			rotation.y = 0.0
			$fps_camera.rotation = Vector3(0.0, 0.0, 0.0)
			if mode == "visit" :
				$ui/back_button.visible = true
				$"ui/camera instruction".visible = false
			$ui/info_box.visible = false
			$fps_camera.current = false
			$fps_camera/ray.enabled = false
			$Camera.current = true
			$Camera/RayCast.enabled = true
			is_first_person = false
			changing_camera = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("ui_interact") && is_first_person == true && interacting == false && mode == "visit" :
		AudioManager.ok()
		if $ui/texture.texture != null :
			$ui/texture.texture = null
		$ui.visible = false
		yield(get_tree(), "idle_frame")
		var t : Image = get_viewport().get_texture().get_data()
		t.flip_y()
		GameManager.photo = ImageTexture.new()
		GameManager.photo.create_from_image(t)
		$ui/texture.texture = GameManager.photo
		$ui.visible = true

func process_tap (idx) :
	if active_tool[idx]==false && tool_cooldown[idx]==0.0 && tool_use[idx] != 0:
		match (GameManager.tools[idx]) :
			1 :
				LevelManager.tool_used += 1
				$ui/tool_box.get_node("tool{0}".format([idx+1])).value = float(GameManager.tools_base[GameManager.tools[idx]].cool)
				speed *= 2.0
				active_tool[idx]=true
				tool_duration[idx]=5.0
				tool_use[idx]-=1
			2 :
				LevelManager.tool_used += 1
				active_tool[idx]=true
				var r = int(rand_range(0, 2))
				if r == 0 :
					end_stage()
				else :
					random_teleport()
					tool_duration[idx] = 0.1
					tool_use[idx]-=1
			4 :
				cricket.translation = self.translation
				cricket.placed = true
			5 :
				LevelManager.tool_used += 1
				$ui/tool_box.get_node("tool{0}".format([idx+1])).value = float(GameManager.tools_base[GameManager.tools[idx]].cool)
				stealth = true
				active_tool[idx]=true
				tool_duration[idx]=3.0
				tool_use[idx]-=1
			

func process_hold (idx) :
	if active_tool[idx]==false && tool_cooldown[idx]==0.0 && tool_use[idx] != 0 :
		match (GameManager.tools[idx]) :
			4 :
				LevelManager.tool_used += 1
				if cricket.placed == true :
					active_tool[idx]=true
					cricket.activate()
					tool_duration[idx] = 15.0
					tool_use[idx]-=1
			_ :
				process_tap(idx)

func remove_tool_effect (idx) :
	match(idx) :
		1 : 
			speed /= 2.0
		5 :
			stealth = false

func tool_decay (delta) :
	for i in range(3) :
		if tool_duration[i] > 0.0 :
			tool_duration[i]=max(tool_duration[i]-delta, 0.0)
			if tool_duration[i]==0.0 :
				remove_tool_effect(GameManager.tools[i])
				tool_cooldown[i]=float(GameManager.tools_base[GameManager.tools[i]].cool)
				active_tool[i] = false
func cooldown_tool (delta) :
	for i in range(3) :
		if tool_cooldown[i] > 0.0 :
			tool_cooldown[i]=max(tool_cooldown[i]-delta, 0.0)
			$ui/tool_box.get_node("tool{0}".format([i+1])).value = tool_cooldown[i]

func random_teleport () :
	randomize()
	var x = rand_range(-24.0, 24.0)
	var z = rand_range(-24.0, 24.0)
	$teleport_marker.global_translation = Vector3(x, $teleport_marker.global_translation.y, z)
	
	yield(get_tree(), "physics_frame")
	while ($teleport_marker.get_overlapping_bodies().size() > 0) :
		yield(get_tree(), "idle_frame")
		x = rand_range(-24.0, 24.0)
		z = rand_range(-24.0, 24.0)
		$teleport_marker.global_translation = Vector3(x, $teleport_marker.global_translation.y, z)
	translation = $teleport_marker.global_translation
	$teleport_marker.translation = Vector3(0.0, 0.0, 0.0)

func is_moving () -> bool :
	return move_x != 0.0 || move_z != 0.0 && is_first_person != true

func _physics_process(delta) :
	if is_moving() && block == false  :
		if $animation/animation.is_playing() == false :
			$animation/animation.play("walking")
		move_and_collide(Vector3(move_x * delta, 0.0, move_z * delta))

func _on_detection_body_entered(body):
	yield(get_tree(), "idle_frame")
	if body.is_in_group("npc") && mode == "visit" :
		npc_group.append(body)
		$ui/chatter.text = body.chatter
		$ui/chatter.visible = true
		$text_decay.start(3.0)
	elif body.is_in_group("interactable") :
		if body != interact_node :
			interact_node = body
			if mode == "heist" :
				if body.is_in_group("swipable") && can_interact == true && body.forged == false :
					$ui/swipe_popup.visible = true
				elif body.is_in_group("exit") :
					$ui/door_popup.visible = true
			elif mode == "visit" :
				var d = null
				if interact_node.is_in_group("painting") :
					d = GameManager.get_painting(interact_node.idx).data
				elif interact_node.is_in_group("statue") :
					d = GameManager.get_statue(interact_node.idx).data
				$ui/info_box/content/title.text = d.name
				$ui/info_box/content/author_row/author.text = Artwork.artists[d.artist]
				$ui/info_box.visible = true

func _on_detection_body_exited(body):
	yield(get_tree(), "idle_frame")
	if body.is_in_group("npc") && npc_group.has(body) && mode == "visit" :
		npc_group.erase(body)
	elif body.is_in_group("interactable") :
		if body == interact_node :
			if mode == "heist" : 
				if body.is_in_group("swipable") :
					$ui/swipe_popup.visible = false
				elif body.is_in_group("exit") :
					$ui/door_popup.visible = false
			elif mode == "visit" :
				$ui/info_box.visible = false
			interact_node = null

func _on_text_decay_timeout():
	$ui/chatter.visible = false

func _on_back_button_pressed():
	AudioManager.cancel()
	GameManager.setup_day()
	SceneManager.change_scene("res://home_menu.tscn")

func end_stage () :
	LevelManager.level_start = false
	LevelManager.calculate_score()
	$ui/result_screen/time_row/value.text = str(int(LevelManager.time))
	$ui/result_screen/alert_row/value.text = str(LevelManager.alert_time)
	$ui/result_screen/tool_row/value.text = str(LevelManager.tool_used)
	$ui/result_screen/score_row/value.text = str(LevelManager.total_score)
	for n in LevelManager.art_name :
		$ui/result_screen/art_row/value.text += "[" +n+"] "
	$ui/result_screen/forge_row/value.text = "{0}%".format([int((LevelManager.likeness/max(LevelManager.art_taken.size(), 1))*100)])
	$ui/result_screen/rank.text = LevelManager.stage_rank
	if LevelManager.art_taken.size() == 0 :
		$ui/result_screen/title.text = "Escaped"
	$ui/result_screen.visible = true
	GameManager.save_career_data({
		"day": GameManager.day, 
		"time": LevelManager.max_time - LevelManager.time, 
		"rank": LevelManager.stage_rank, 
		"artwork_stolen": LevelManager.art_name.duplicate(true), 
		"tool_used": LevelManager.tool_used, 
		"security_alerted": LevelManager.alert_time, 
		"score": LevelManager.total_score, 
		"forgery": int((LevelManager.likeness/max(LevelManager.art_taken.size(), 1))*100)
	})
	yield(get_tree(), "idle_frame")
	result_screen = true
	yield(get_tree().create_timer(1.0), "timeout")
	$ui/result_screen/continue.visible = true
	result_complete = true
#	GameManager.setup_day()
#	SceneManager.change_scene("res://home_menu.tscn")

func trigger_game_over () :
	AudioManager.alert()
	GameManager.save_career_data({
		"day": GameManager.day, 
		"time": LevelManager.max_time - LevelManager.time, 
		"rank": LevelManager.stage_rank, 
		"artwork_stolen": LevelManager.art_name.duplicate(true), 
		"tool_used": LevelManager.tool_used, 
		"security_alerted": LevelManager.alert_time, 
		"score": LevelManager.total_score, 
		"forgery": int((LevelManager.likeness/max(LevelManager.art_taken.size(), 1))*100)
	})
	LevelManager.level_start = false
	GameManager.game_over = true
	$ui/game_over_screen.visible = true
