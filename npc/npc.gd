extends KinematicBody

export (String, "A", "B", "C") var type = "A"
export (String, "static", "path") var movement = "static"
export (float) var speed = 1.0
export (String, "painting", "statue", "none") var focus_type = "none"
export (int) var focus_idx = 0


const GREEN_COLOR = Color("#badc58")
const BLUE_COLOR = Color("#686de0")
const RED_COLOR = Color("#ff7979")

var parent_path : PathFollow = null
var next_movement = Vector3(0.0, 0.0, 0.0)

var chatter = "Simply astounding"

func _ready():
	setup_npc()
	if movement == "path" :
		parent_path = get_parent()
		
func setup_npc () :
	var mat = SpatialMaterial.new()
	var head = SphereMesh.new()
	head.radius = 0.5
	head.height = 1.0
	$mesh/head.mesh = head
	match type :
		"A" :
			mat.albedo_color = GREEN_COLOR
			$mesh/head.mesh.material = mat
		"B" :
			mat.albedo_color = BLUE_COLOR
			$mesh/head.mesh.material = mat
		"C" :
			mat.albedo_color = RED_COLOR
			$mesh/head.mesh.material = mat
	if focus_type != "none" :
		var s = GameManager.paintings[focus_idx].sentiment if focus_type == "painting" else GameManager.statues[focus_idx].sentiment
		if s > 0.7 :
			chatter = "Simply Astounding"
		elif s > 0.4 :
			chatter = "Something feels off"
		else :
			chatter = "This has to be a fake"

func _process(_delta):
	pass

func get_next_movement(delta) :
	parent_path.offset += speed * delta

func _physics_process(delta):
	if movement == "path" :
		if $animation/animation.is_playing() == false :
			$animation/animation.play("walking")
		get_next_movement(delta)
