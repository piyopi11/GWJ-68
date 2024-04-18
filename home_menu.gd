extends Node2D

const INVENTORYBOX = preload("res://prefab/inventory_box.tscn")

var inventories = []
var selected_key = ""

func _ready():
	AudioManager.change_bgm("res://PeriTune_Alleyway_loop.ogg")
	AudioManager.play_bgm()
	$root_control/time_space/day.text = "DAY {0}".format([GameManager.day])
	setup_in_demand()
	setup_inventory()

func reset_inventory () :
	inventories = []
	for c in $inventory_control/inventory_box/scroll/content.get_children() :
		c.queue_free()

func setup_inventory () :
	var idx = 0
	for i in GameManager.inventory :
		var o = INVENTORYBOX.instance()
		o._name = i.name
		o._type = i.type
		o._key = i.key
		o.setup_box()
		o.connect("selected", self, "_on_inventory_box_pressed")
		inventories.append(o)
		$inventory_control/inventory_box/scroll/content.add_child(o)
		idx += 1

func setup_in_demand() :
	for a in GameManager.in_demand :
		var l = Label.new()
		l.add_color_override("font_color", Color("#000000"))
		if a.find("painting") != -1 :
			l.text = "\"{0}\" by {1}".format([Artwork.paintings[a].name, Artwork.artists[Artwork.paintings[a].artist]])
		else :
			l.text = "\"{0}\" by {1}".format([Artwork.statues[a].name, Artwork.artists[Artwork.statues[a].artist]])
		$root_control/target_frame/content.add_child(l)
	var d_l = GameManager.demand_refresh_time-(GameManager.day % GameManager.demand_refresh_time)
	$root_control/target_frame/refreshes.text = "Refreshes in {0} {1}".format([d_l, "day" if (d_l) == 1 else "days"])

func _on_scout_button_pressed():
	SceneManager.change_scene("res://art_gallery_day.tscn")

func _on_paint_button_pressed():
	SceneManager.change_scene("res://make_painting.tscn")

func _on_statue_button_pressed():
	SceneManager.change_scene("res://make_sculpture.tscn")

func _on_infiltrate_button_pressed():
	SceneManager.change_scene("res://art_gallery_night.tscn")

func _on_cancel_pressed():
	$inventory_control.visible = false
	$root_control.visible = true

func _on_inventory_button_pressed():
	$root_control.visible = false
	$inventory_control.visible = true

func _on_inventory_box_pressed (key) :
	selected_key = key
	var i = GameManager.get_inventory(key)
	if i.type == "statue":
		for d in i.data :
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
			m.mesh.material = SpatialMaterial.new()
			m.mesh.material.albedo_color = Color("#636e72")
			$model_3d/root/mesh_group.add_child(m)
		$inventory_control/statue_detail/frame/name_3d.text = i.name
		$inventory_control/statue_detail.visible = true
	elif i.type == "painting" :
		var x = 0
		var y = 0
		var p = i.data
		for j in range(16) :
			for k in range(16) :
				var c = ColorRect.new()
				c.rect_position = Vector2(x, y)
				var s = p[(16 * (16 - j - 1)) + k]
				if s != null:
					c.color = Color(s)
				c.rect_size=Vector2(19.2,19.2)
				x += 19.2
				$inventory_control/paint_detail/frame/canvas.add_child(c)
			x = 0
			y += 19.2
		$inventory_control/paint_detail/frame/name_2d.text = i.name
		$inventory_control/paint_detail.visible = true

func _on_cancel_3d_pressed():
	$inventory_control/statue_detail.visible = false
	for c in $model_3d/root/mesh_group.get_children() :
		c.queue_free()

func _on_trash_3d_pressed():
	GameManager.delete_inventory(selected_key)
	reset_inventory()
	setup_inventory()
	_on_cancel_3d_pressed()

func _on_cancel_2d_pressed():
	$inventory_control/paint_detail.visible = false
	for c in $inventory_control/paint_detail/frame/canvas.get_children() :
		c.queue_free()

func _on_trash_2d_pressed():
	GameManager.delete_inventory(selected_key)
	reset_inventory()
	setup_inventory()
	_on_cancel_2d_pressed()