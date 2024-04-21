extends KinematicBody

var chatter = "Nothing to see here"

enum MODE {SENTRY, AWARE, PATROL, CHASE, RETURNING, NEUTRAL, INVESTIGATE}

export (MODE) var mode = MODE.SENTRY
export var alert_level = 0.0

var is_moving = false
var is_chasing = false

var move_x = 0.0
var move_z = 0.0
var target_path = Vector3(0.0,0.0,0.0)

var target_node = null
var move_speed = 5.0

export (PoolVector3Array) var patrol_path = []
var patrol_index = 0

var initial_position = Vector3(0.0, 0.0, 0.0)
var initial_mode = MODE.NEUTRAL

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = translation
	initial_mode = mode

func start_cop () :
	if mode == MODE.PATROL :
		setup_movement()

func path_find(target):
	yield(get_tree(), "idle_frame")
	$nav_agent.set_target_location(target)

func _physics_process (delta) :
	if LevelManager.level_start == true :
		if is_moving && !is_chasing :
			if mode == MODE.RETURNING || mode == MODE.INVESTIGATE : 
				target_path = $nav_agent.get_next_location()
				yield(adjust_steps(0.3), "completed")
			if translation != target_path :
				look_at(target_path, Vector3(0.0, 1.0, 0.0))
			rotation.y += deg2rad(180)
			rotation.z = 0.0
			rotation.x = 0.0
			if $animation/animation.is_playing() == false :
				$animation/animation.play("walking")
			move_and_collide(Vector3(move_x * delta, 0.0, move_z * delta))
			check_target()
		elif is_moving && is_chasing :
			if target_node.stealth == true :
				_on_vision_body_exited(target_node)
			yield(get_target_position(), "completed")
			if $animation/animation.is_playing() == false :
				$animation/animation.play("walking")
			move_and_collide(Vector3(move_x * delta, 0.0, move_z * delta))
	#		check_target()

func get_target_position () :
	yield(get_tree(), "idle_frame")
	if target_node != null :
		look_at(target_node.translation, Vector3(0.0, 1.0, 0.0))
		rotation.y += deg2rad(180)
		rotation.z = 0.0
		rotation.x = 0.0
	if is_chasing && target_node != null :
		target_path = target_node.translation
		yield(adjust_steps(0.3), "completed")

func check_target () :
	var c_x = false
	var c_z = false

	if move_x > 0.0 :
		c_x = translation.x >= target_path.x
	elif move_x < 0.0 :
		c_x = translation.x <= target_path.x
	else :
		c_x = true

	if move_z > 0.0 :
		c_z = translation.z >= target_path.z
	elif move_z < 0.0 :
		c_z = translation.z <= target_path.z
	else :
		c_z = true

	if c_x && c_z :
		translation.y = 0.0
		if mode == MODE.RETURNING && $nav_agent.is_navigation_finished() :
			if initial_mode == MODE.PATROL :
				patrol_index = -1
				move_speed = 5.0
				setup_movement()
			mode = initial_mode
		else :
			stop_moving()

func stop_moving () :
	yield(get_tree(), "idle_frame")
	is_moving = false
	translation = target_path
	if mode == MODE.PATROL :
		setup_movement()

func adjust_steps (margin = 0.0) :
	yield(get_tree(), "idle_frame")
	#x first
	if translation.x < (target_path.x - margin) :
		move_x = move_speed * 1.0
	elif translation.x > (target_path.x + margin) :
		move_x = move_speed * -1.0
	else :
		move_x = 0.0
	#then z
	if translation.z < (target_path.z - margin) :
		move_z = move_speed * 1.0
	elif translation.z > (target_path.z + margin) :
		move_z = move_speed * -1.0
	else :
		move_z = 0.0

func setup_movement () :
	if patrol_path.size() > 1 :
		patrol_index = 0 if patrol_index == patrol_path.size() - 1 else patrol_index + 1
		target_path = patrol_path[patrol_index]
		#adjust rotation
		var rot = 0.0
		if translation.x < target_path.x :
			rot = 90.0
		elif translation.x > target_path.x :
			rot = -90.0
		elif translation.z > target_path.z :
			rot = 180.0
		else :
			rot = 0.0
		rotation.y = deg2rad(rot)
		
		#adjust steps
		yield(adjust_steps(), "completed")
		
		is_moving = true

func setup_chase () :
	AudioManager.alert()
	LevelManager.alert_time += 1
	is_moving = false
	move_speed = 10.0
	is_chasing = true
	is_moving = true

func _on_vision_body_entered(body) :
	if body.is_in_group("player") && mode != MODE.NEUTRAL :
		if body.stealth == false :
			target_node = body
			mode = MODE.CHASE
			setup_chase()

func _on_vision_body_exited(body) :
	if body.is_in_group("player") && mode != MODE.NEUTRAL :
		target_node = null
		target_path = translation
		is_chasing = false
		yield(stop_moving(), "completed")
		yield(path_find(initial_position), "completed")
		mode = MODE.RETURNING
		is_moving = true

func return_to_initial_position () :
	yield(path_find(initial_position), "completed")
	mode = MODE.RETURNING
	is_moving = true

func _on_detection_body_entered(body):
	if mode == MODE.CHASE && body.is_in_group("player") :
		body.trigger_game_over()
