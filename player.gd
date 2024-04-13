extends KinematicBody

var move_x = 0.0
var move_z = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta) :
	check_input()

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
