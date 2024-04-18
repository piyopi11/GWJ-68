extends Spatial

var meshes = []
var selected_mesh = null

var rotate_deg = 0.0

var mock_data = [
	
]

var statue_name = ""

func _ready():
	AudioManager.change_bgm("res://PerituneMaterial_Bustling_Village_loop.ogg")
	AudioManager.play_bgm()
	statue_name = "New Statue"
	load_data()

func load_data () :
	for d in mock_data :
		var m = MeshInstance.new()
		match d.type :
			"cube" :
				m.mesh = CubeMesh.new()
				m.mesh.size = Vector3(2.0, 2.0, 2.0)
			"prism" :
				m.mesh = PrismMesh.new()
				m.mesh.size= Vector3(2.0, 2.0, 2.0)
			"sphere" :
				m.mesh = SphereMesh.new()
				m.mesh.radius = 1.0
				m.mesh.height = 2.0
		m.translate(Vector3(d.position[0], d.position[1], d.position[2]))
		add_mesh(d.type.capitalize(), m)

func _process (delta) :
	if rotate_deg != 0.0 :
		$mesh_group.rotate_y(deg2rad(rotate_deg))
		$base.rotate_y(deg2rad(rotate_deg))
	$ui/root/angle.text = str(int(rad2deg($mesh_group.rotation.y)))

func change_selected_mesh (mesh) :
	for m in meshes :
		m.mesh.material.albedo_color = Color("#636e72")
		m.mesh.material.albedo_color.a = 0.5
	mesh.mesh.material.albedo_color = Color("#f8c291")
	selected_mesh = mesh

func add_mesh (type, m) :
	m.mesh.material = SpatialMaterial.new()
	m.mesh.material.albedo_color = Color("#636e72")
	$mesh_group.add_child(m)
	change_selected_mesh(m)
	meshes.append(selected_mesh)
	var b = Button.new()
	b.text = type
	b.connect("pressed", self, "_on_mesh_list_selected", [m])
	$ui/root/scroll/mesh_list.add_child(b)

func _on_add_cube_pressed():
	if meshes.size() < 8 :
		var m = MeshInstance.new()
		m.mesh = CubeMesh.new()
		m.mesh.size= Vector3(2.0, 2.0, 2.0)
		m.translate(Vector3(0.0, 1.0, 0.0))
		add_mesh("Cube", m)

func _on_add_cone_pressed():
	if meshes.size() < 8 :
		var m = MeshInstance.new()
		m.mesh = PrismMesh.new()
		m.mesh.size= Vector3(2.0, 2.0, 2.0)
		m.translate(Vector3(0.0, 1.0, 0.0))
		add_mesh("Prism", m)

func _on_add_sphere_pressed():
	if meshes.size() < 8 :
		var m = MeshInstance.new()
		m.mesh = SphereMesh.new()
		m.mesh.radius = 1.0
		m.mesh.height = 2.0
		m.translate(Vector3(0.0, 1.0, 0.0))
		add_mesh("Sphere", m)

func _on_move_mesh(arg):
	if selected_mesh != null :
		var i = selected_mesh.translation
		match (arg) :
			0 :
				i = Vector3(i.x, i.y, min(i.z + 0.5, 3.0))
			1 :
				i = Vector3(i.x, i.y, max(i.z - 0.5, -3.0))
			2 :
				i = Vector3(max(i.x - 0.5, -3.0), i.y, i.z)
			3 :
				i = Vector3(min(i.x + 0.5, 3.0), i.y, i.z)
			4 :
				i = Vector3(i.x, min(i.y + 1.0, 5.0), i.z)
			5 :
				i = Vector3(i.x, max(i.y - 1.0, 1.0), i.z)
		selected_mesh.translation = i

func _on_mesh_list_selected (arg) :
	change_selected_mesh(arg)

func _on_rotate_left_pressed():
	$mesh_group.rotate_y(deg2rad(1.0))

func _on_delete_pressed():
	if selected_mesh != null :
		var i = meshes.find(selected_mesh)
		$ui/root/scroll/mesh_list.remove_child($ui/root/scroll/mesh_list.get_child(i))
		meshes.erase(selected_mesh)
		selected_mesh.queue_free()
		if meshes.size() > 0 :
			change_selected_mesh(meshes.back())
		else :
			selected_mesh = null

func _on_rotate_left_toggled(button_pressed):
	rotate_deg = 1.0 if button_pressed else 0.0

func _on_rotate_left_gui_input(event):
	if event is InputEventMouseButton :
		if event.pressed && event.button_index == BUTTON_LEFT :
			rotate_deg = 1.0
		elif event.pressed == false && event.button_index == BUTTON_LEFT :
			rotate_deg = 0.0
		else :
			rotate_deg = 0.0

func _on_rotate_right_gui_input(event):
	if event is InputEventMouseButton :
		if event.pressed && event.button_index == BUTTON_LEFT :
			rotate_deg = -1.0
		elif event.pressed == false && event.button_index == BUTTON_LEFT :
			rotate_deg = 0.0
		else :
			rotate_deg = 0.0

func _on_save_pressed():
	statue_name = $ui/root/save_dialog/name_edit.text
	if statue_name == "" :
		statue_name = "New Statue"
		$ui/root/save_dialog/name_edit.text = statue_name
	$ui/root/save_dialog.visible = true

func _on_cancel_pressed():
	SceneManager.change_scene("res://home_menu.tscn")

func _on_save_ok_pressed():
	statue_name = $ui/root/save_dialog/name_edit.text
	if statue_name == "" :
		statue_name = "New Statue"
		$ui/root/save_dialog/name_edit.text = statue_name
		
	var arr = []
	for m in meshes :
		var o = {"type": "", "position": []}
		if m.mesh is CubeMesh :
			o.type = "cube"
		elif m.mesh is PrismMesh :
			o.type = "cone"
		elif m.mesh is SphereMesh :
			o.type = "sphere"
		o.position.append(m.translation.x)
		o.position.append(m.translation.y)
		o.position.append(m.translation.z)
		arr.append(o)
#	print(JSON.print(arr))
	
	GameManager.save_artwork("statue", statue_name, arr)
	GameManager.setup_day()
	SceneManager.change_scene("res://home_menu.tscn")

func _on_save_cancel_pressed():
	$ui/root/save_dialog.visible = false
