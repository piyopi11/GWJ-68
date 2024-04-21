extends Spatial

var map

var tut = ""

func _ready():
	AudioManager.change_bgm("res://PeriTune_Alleyway_loop.ogg")
	AudioManager.play_bgm()
	if GameManager.threat_level < 3.0 :
		$cop/cop2.queue_free()
	if GameManager.threat_level < 2.0 :
		$cop/cop3.queue_free()
	$player.mode = "visit"
	$player.setup_ui()
	if GameManager.guide[1] == false :
		tut = "visit"
		$player.block = true
		show_guide()

func show_guide () : 
	var t = GuideManager.get_text(tut)
	if t == "fin" :
		$tutorial/tutorial.visible = false
		$player.block = false
		GameManager.guide[0] == false
	else :
		$tutorial/tutorial/frame/content.text = t
		$tutorial/tutorial.visible = true

func _on_ok_pressed():
	AudioManager.ok()
	GuideManager.next_guide(tut)
	show_guide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
