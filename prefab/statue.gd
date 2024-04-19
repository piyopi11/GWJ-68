extends StaticBody

var mock_data = [
	{"type": "cube", "position": [0.0, 1.0, 0.0]},
	{"type": "cube", "position": [2.5, 3.0, 0.0]},
	{"type": "cube", "position": [-2.5, 3.0, 0.0]},
	{"type": "cube", "position": [0.0, 3.0, 0.0]}
]

var type = "statue"
export (String) var id = "statue1"
export (int) var idx = 0
var forged = false

func _ready():
	setup_statue()

func reset_statue() :
	for c in $mesh_group.get_children() :
		c.queue_free()

func setup_statue() :
	var data = GameManager.get_statue(idx).data
	for d in data.data :
		var m = MeshInstance.new()
		match d.type :
			"cube" :
				m.mesh = CubeMesh.new()
				m.mesh.size= Vector3(2.0, 2.0, 2.0)*0.5
				m.translate(Vector3(d.position[0], d.position[1], d.position[2])*0.5)
			"cone" :
				m.mesh = PrismMesh.new()
				m.mesh.size= Vector3(2.0, 2.0, 2.0)*0.5
				m.translate(Vector3(d.position[0], d.position[1], d.position[2])*0.5)
			"sphere" :
				m.mesh = SphereMesh.new()
				m.mesh.radius = 1.0*0.5
				m.mesh.height = 2.0*0.5
				m.translate(Vector3(d.position[0], d.position[1], d.position[2])*0.5)
		m.mesh.material = SpatialMaterial.new()
		forged = GameManager.get_statue(idx).forged
		if forged == false :
			m.mesh.material.albedo_color = Color("#f6e58d")
		else :
			m.mesh.material.albedo_color = Color("#636e72")
		$mesh_group.add_child(m)

func swap_data (key) :
	var data = GameManager.get_inventory(key).data
	GameManager.get_statue(idx).data.data = data
	GameManager.get_statue(idx).forged = true
	LevelManager.art_taken.append({"t": "s", "k": idx})
	LevelManager.art_name.append( GameManager.get_statue(idx).data.name )
	LevelManager.calculate_statue_likeness(data)
	reset_statue()
	setup_statue()
	GameManager.delete_inventory(key)
