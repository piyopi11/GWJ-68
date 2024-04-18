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
var interaction_step = 30.0
var swiping_item = null
var can_interact = false

var changing_camera = false
var is_first_person = false

var last_mouse_pos = Vector2(0.0, 0.0)
var mode = "visit"

var result_screen = false
var result_complete = false

const EMPTY = preload("res://ui/ui_frame.png")
const ART = preload("res://ui/forge_painting.png")
const STATUE = preload("res://ui/forge_statue.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup_ui() :
	if mode == "visit": 
		$ui/time_counter.visible = false
		$ui/back_button.visible = true
		$ui/tool_box.visible = false
		$ui/result_screen.visible = false
	elif mode == "heist" :
		$ui/time_counter.visible = true
		$ui/back_button.visible = false
		$ui/tool_box.visible = true
		$ui/result_screen.visible = false
		$ui/current_frame/name.text = GameManager.get_inventory(GameManager.bag[0]).name
		if GameManager.get_inventory(GameManager.bag[0]).type == "painting" :
			$ui/current_frame.texture = ART
		elif  GameManager.get_inventory(GameManager.bag[0]).type == "statue" :
			$ui/current_frame.texture = STATUE

func _process(_delta) :
	if result_screen == false :
		check_input()
		if interacting && interaction_progress < 100.0:
			perform_interaction(_delta)
		check_raycast()

func perform_interaction (delta) :
	interaction_progress = min(interaction_progress + (interaction_step * delta), 100.0)
	$ui/interaction_progress.value = interaction_progress
	if interaction_progress >= 100.0 :
		swiping_item.swap_data(GameManager.bag.pop_front())
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
	if result_screen == false :
		check_mouse_movement(event)
	elif result_screen == true && result_complete == true :
		if event is InputEventMouseButton || event is InputEventKey :
			GameManager.setup_day()
			SceneManager.change_scene("res://home_menu.tscn")

func check_raycast() :
	if is_first_person == false :
		var b = $Camera/RayCast.get_collider()
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
				$fps_camera.rotate_x(deg2rad(m_y * 0.5) )
				$fps_camera.rotation.x = clamp($fps_camera.rotation.x, deg2rad(0.0), deg2rad(45.0))
				$fps_camera.rotate_y(deg2rad(m_x * 0.5) )
				$fps_camera.rotation.z = 0.0

func check_input() :
	if is_first_person == false :
		if interacting == false :
			#check sprinting first 
			if Input.is_action_pressed("ui_sprinting") :
				sprint_modifier = 1.5
			else :
				sprint_modifier = 1.0
			#movement block
			if Input.is_action_pressed("ui_right") :
				$fps_camera.rotation = Vector3(0.0, deg2rad(-90.0), 0.0)
				move_x = speed * 1.0 * sprint_modifier
			elif Input.is_action_pressed("ui_left") :
				$fps_camera.rotation = Vector3(0.0, deg2rad(90.0), 0.0)
				move_x = speed * -1.0 * sprint_modifier
			else :
				move_x = 0.0
			if Input.is_action_pressed("ui_down") :
				$fps_camera.rotation = Vector3(0.0, deg2rad(180.0), 0.0)
				move_z = speed * 1.0 * sprint_modifier
			elif Input.is_action_pressed("ui_up") :
				$fps_camera.rotation = Vector3(0.0, 0.0, 0.0)
				move_z = speed * -1.0 * sprint_modifier
			else :
				move_z = 0.0
			#tool block
			if Input.is_action_just_pressed("ui_tool_1") && mode == "heist" :
				random_teleport()
				
		if Input.is_action_pressed("ui_interact") && mode == "heist" && interact_node != null:
			if interact_node.is_in_group("exit") :
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
		else :
			if mode == "visit" :
				$ui/back_button.visible = true
			$ui/info_box.visible = false
			$fps_camera.current = false
			$fps_camera/ray.enabled = false
			$Camera.current = true
			$Camera/RayCast.enabled = true
			is_first_person = false
			changing_camera = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

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
	if is_moving() :
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

func interact_with_object () :
	if interact_node != null && mode == "heist" :
		pass

func _on_text_decay_timeout():
	$ui/chatter.visible = false

func _on_back_button_pressed():
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
	$ui/result_screen/forge_row/value.text = "{0}%".format([int(LevelManager.likeness*100)])
	$ui/result_screen/rank.text = LevelManager.stage_rank
	if LevelManager.art_taken.size() == 0 :
		$ui/result_screen/title.text = "Escaped"
	$ui/result_screen.visible = true
	yield(get_tree(), "idle_frame")
	result_screen = true
	yield(get_tree().create_timer(1.0), "timeout")
	$ui/result_screen/continue.visible = true
	result_complete = true
#	GameManager.setup_day()
#	SceneManager.change_scene("res://home_menu.tscn")

func trigger_game_over () :
	LevelManager.level_start = false
	$ui/game_over_screen.visible = true
