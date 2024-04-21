extends Spatial

var bgm = ""
var fade_out_time = 0.0
var fade_out = false
var fade_out_step = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func bgm_is_playing () :
	return $bgm.playing

func change_bgm (_bgm) :
	bgm = _bgm
	$bgm.stream = load(bgm)

func play_bgm () :
	fade_out = false
	$bgm.volume_db = -15.0
	if $bgm.playing == false :
		$bgm.play()

func stop_bgm () :
	if $bgm.playing == true :
		$bgm.stop()

func ok () :
	$ok.play()

func cancel () :
	$cancel.play()

func select () :
	$select.play()

func alert () :
	$alert.play()

func is_not_playing (name) -> bool :
	return get_node(name).playing == false

func fade_out_bgm (dur = 1.0) :
	fade_out_time = dur
	fade_out_step = float($bgm.volume_db - (-50.0)) / fade_out_time
	fade_out = true

func _process(delta) :
	if fade_out :
		
		$bgm.volume_db -= fade_out_step * delta
		fade_out_time -= delta
		if fade_out_time <= 0.0 :
			fade_out = false
