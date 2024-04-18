extends Spatial

var map

func _ready():
	AudioManager.change_bgm("res://PeriTune_Alleyway_loop.ogg")
	AudioManager.play_bgm()
	$player.mode = "visit"
	$player.setup_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
