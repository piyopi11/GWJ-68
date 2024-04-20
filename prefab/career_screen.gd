extends Control

var can_update = false

func _ready():
	setup_data()

func setup_data () :
	update_time()
	$scroll/rows/row_1/value.text = str(GameManager.total_heist)
	$scroll/rows/row_2/value.text = str(GameManager.art_stolen)
	var t_score = 0
	var f_score = 0
	var t_used = 0
	var s_alert = 0
	for c in GameManager.career_data :
		t_score += c.score
		f_score += c.forgery
		t_used += c.tool_used
		s_alert += c.security_alerted
	$scroll/rows/row_10/value.text = str(t_score)
	$scroll/rows/row_9/value.text = str(GameManager.total_art)
	$scroll/rows/row_3/value.text = "{0}%".format([f_score/max(GameManager.career_data.size(), 1)])
	$scroll/rows/row_6/value.text = GameManager.best_forgery
	$scroll/rows/row_4/value.text = str(t_used)
	var m = 0
	var c = 0
	for i in range(GameManager.tool_used.size()) :
		if GameManager.tool_used[i] > m :
			m = GameManager.tool_used[i]
			c = i 
	if m != 0 :
		$scroll/rows/row_5/value.text = GameManager.tools_base[c].name
	$scroll/rows/row_7/value.text = str(s_alert)
	
func _process (_delta) :
	if self.visible == true && can_update == true :
		update_time()

func update_time () :
	var s = int(GameManager.total_time) % 60
	var m = int(GameManager.total_time) / 60
	$scroll/rows/row_8/value.text = "{0}:{1}".format([m if m >= 10 else "0"+str(m), s if s >= 10 else "0"+str(s)])
