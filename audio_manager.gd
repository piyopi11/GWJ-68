extends Spatial

var bgm = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_bgm (_bgm) :
	bgm = _bgm
	$bgm.stream = load(bgm)

func play_bgm () :
	if $bgm.playing == false :
		$bgm.play()

func stop_bgm () :
	if $bgm.playing == true :
		$bgm.stop()
