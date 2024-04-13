extends KinematicBody

var move_x = 0.0
var move_z = 0.0

var front = null
var npc_group = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta) :
	check_input()
	check_raycast()

func check_raycast() :
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
	

func check_input() :
	if Input.is_action_pressed("ui_right") :
		move_x = 20.0
	elif Input.is_action_pressed("ui_left") :
		move_x = -20.0
	else :
		move_x = 0.0
	if Input.is_action_pressed("ui_down") :
		move_z = 20.0
	elif Input.is_action_pressed("ui_up") :
		move_z = -20.0	
	else :
		move_z = 0.0

func is_moving () -> bool :
	return move_x != 0.0 || move_z != 0.0

func _physics_process(delta) :
	if is_moving() :
		if $animation/animation.is_playing() == false :
			$animation/animation.play("walking")
		move_and_collide(Vector3(move_x * delta, 0.0, move_z * delta))

func _on_detection_body_entered(body):
	
	if body.is_in_group("npc") :
		npc_group.append(body)
	print(npc_group)

func _on_detection_body_exited(body):
	if body.is_in_group("npc") && npc_group.has(body) :
		npc_group.erase(body)
	print(npc_group)
