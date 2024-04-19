extends StaticBody

export (String) var id = "painting1"
export (int) var idx = 0

var type = "painting"
var forged = false

func _ready():
	setup_painting()

func setup_painting () :
	forged = GameManager.get_painting(idx).forged
	var mat = SpatialMaterial.new()
	if forged == true :
		mat.albedo_color = Color("#6a89cc")
#		$outer_frame.mesh.material.albedo_color = Color("#6a89cc")
	else :
		mat.albedo_color = Color("#f6b93b")
#		$outer_frame.mesh.material.albedo_color = Color("#f6b93b")
	$outer_frame.material_override = mat
	if get_node("painting") != null :
		var p = GameManager.get_painting(idx).data
		var x = 0
		var y = 0
		for i in range(16) :
			for j in range(16) :
				var c = ColorRect.new()
				c.rect_position = Vector2(x, y)
				var s = p.colors[(16 * (16 - i - 1)) + j]
				if s != null:
					c.color = Color(s)
				c.rect_size=Vector2(8.0,8.0)
				x += 8
				$painting/canvas.add_child(c)
			x = 0
			y += 8

func swap_data (key) :
	var data = GameManager.get_inventory(key).data
	GameManager.get_painting(idx).data.colors = data
	GameManager.get_painting(idx).forged = true
	LevelManager.art_taken.append({"t": "p", "k": idx})
	LevelManager.art_name.append(GameManager.get_painting(idx).data.name)
	LevelManager.calculate_painting_likeness(data)
	setup_painting()
	GameManager.delete_inventory(key)
