extends Node2D

const canvas_rect = preload("res://prefab/canvas_rect.tscn")

var selected_color = Color("#000000")
const colors = ["#000000", "#ffffff", "#e74c3c", "#f1c40f", "#3498db", "#2ecc71", "#f39c12", "#9b59b6"]

var pressed = false
var focused_node = null

var mode = "single"

var paint_name = ""

var mock_data = [] #["000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","e74c3c","000000","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","ffffff","3498db","ffffff","ffffff","000000","000000","e74c3c","000000","000000","3498db","3498db","ffffff","3498db","3498db","ffffff","3498db","3498db","3498db","000000","f1c40f","000000","000000","e74c3c","000000","ffffff","ffffff","000000","000000","000000","000000","000000","000000","000000","000000","000000","f1c40f","000000","000000","e74c3c","ffffff","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","f1c40f","000000","000000","ffffff","ffffff","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","000000","000000","9b59b6","000000","f1c40f","000000","000000","ffffff","000000","000000","000000","000000","000000","000000","000000","e74c3c","000000","000000","9b59b6","000000","f1c40f","000000","000000","ffffff","ffffff","000000","000000","000000","000000","000000","000000","e74c3c","000000","000000","9b59b6","000000","f1c40f","000000","000000","f39c12","ffffff","9b59b6","000000","000000","2ecc71","000000","000000","000000","000000","000000","000000","000000","f1c40f","000000","000000","f39c12","ffffff","9b59b6","000000","000000","2ecc71","000000","000000","000000","000000","000000","000000","000000","000000","ffffff","000000","f39c12","000000","ffffff","ffffff","000000","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","ffffff","000000","f39c12","000000","000000","ffffff","ffffff","000000","000000","000000","000000","000000","000000","000000","000000","2ecc71","ffffff","000000","f39c12","000000","000000","000000","000000","000000","ffffff","000000","000000","000000","000000","000000","000000","ffffff","ffffff","000000","f39c12","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","ffffff","ffffff","000000","ffffff","2ecc71","000000","000000","f39c12","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","000000","2ecc71","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000"]

var tut = ""

func _ready():
	AudioManager.change_bgm("res://PerituneMaterial_Bustling_Village_loop.ogg")
	AudioManager.play_bgm()
	setup_canvas()
	setup_palette()
	if GameManager.photo != null :
		$photo/photo.texture = GameManager.photo
	if GameManager.guide[5] == false :
		tut = "make_painting"
		show_guide()

func show_guide () : 
	var t = GuideManager.get_text(tut)
	if t == "fin" :
		$tutorial.visible = false
		GameManager.guide[0] == false
	else :
		$tutorial/frame/content.text = t
		$tutorial.visible = true

func _on_ok_pressed():
	AudioManager.ok()
	GuideManager.next_guide(tut)
	show_guide()

func setup_palette() :
	for i in range(8) :
		$root/palette.get_node("color{0}".format([i+1])).connect("pressed", self, "_on_color_pressed", [i])
		

func setup_canvas () :
	var x = 0
	var y = 0
	for i in range(16) :
		for j in range(16) :
			var c = canvas_rect.instance()
			c.rect_position = Vector2(x, y)
			c.focus_mode = 0
			if mock_data.size() > (i * 16) + j :
				c.get_node("color").color = Color(mock_data[(i * 16) + j])
			c.connect("mouse_entered", self, "_on_color_rect_mouse_enter", [c])
			c.connect("mouse_exited", self, "_on_color_rect_mouse_exit", [c])
			c.connect("gui_input", self, "_on_color_rect_gui_input", [c])
			x += 32
			$root/canvas.add_child(c)
		x = 0
		y += 32

func _on_color_pressed (i) :
	AudioManager.select()
	selected_color = Color(colors[i])
	pressed = false

func _on_color_rect_mouse_enter (node) :
	focused_node = node
	if pressed == true :
		node.get_node("color").color = selected_color
	else :
		node.get_node("overlay").color = Color(selected_color.r, selected_color.g, selected_color.b, 0.5)

func _on_color_rect_mouse_exit (node) :
	if pressed == false :
		node.get_node("overlay").color = Color(1.0, 1.0, 1.0, 0.0)
	focused_node = null

func _on_color_rect_gui_input (event, node) :
	if event is InputEventMouseButton :
		if event.pressed == true && event.button_index == BUTTON_LEFT  :
			if focused_node != null :
				focused_node.get_node("color").color = selected_color
			if mode != "single" :
				pressed = !pressed

func _on_mode_pressed():
	AudioManager.ok()
	pressed = false
	if mode == "single" :
		mode = "continuous"
		$root/palette/mode.text = mode
	else :
		mode = "single"
		$root/palette/mode.text = mode

func _on_save_button_pressed():
	AudioManager.ok()
	paint_name = $root/save_dialog/name_edit.text
	if paint_name == "" :
		paint_name = "New Painting"
		$root/save_dialog/name_edit.text = paint_name
	$root/save_dialog.visible = true

func _on_cancel_button_pressed():
	AudioManager.cancel()
	SceneManager.change_scene("res://home_menu.tscn")

func _on_save_ok_pressed():
	AudioManager.ok()
	paint_name = $root/save_dialog/name_edit.text
	if paint_name == "" :
		paint_name = "New Painting"
		$root/save_dialog/name_edit.text = paint_name
	var arr = []
	for c in $root/canvas.get_children() :
		arr.append(c.get_node("color").color.to_html(false))
	
	GameManager.save_artwork("painting", paint_name, arr)
	GameManager.setup_day()
	SceneManager.change_scene("res://home_menu.tscn")

func _on_save_cancel_pressed():
	AudioManager.cancel()
	$root/save_dialog.visible = false

func _on_reference_pressed():
	AudioManager.ok()
	$photo.visible = true

func _on_photo_cancel_pressed():
	AudioManager.cancel()
	$photo.visible = false
