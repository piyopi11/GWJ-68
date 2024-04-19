extends Spatial

var placed = false
var activated = false
var dead = false

var duration = 15.0

signal playing
signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate () :
	duration = 15.0
	activated = true
	$sound.play()
	emit_signal("playing", translation)

func dead () :
	activated = false
	dead = true
	$sound.stop()
	emit_signal("dead")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activated == true :
		duration -= delta
		if duration <= 0.0 :
			dead()
