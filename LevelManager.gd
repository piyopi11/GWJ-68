extends Node

var level_start = false

var time : float = 0.0
var alert_time = 0
var alert_level = 0
var time_node = null

var art_name = []
var art_taken = []

var tool_used = 0
var total_score = 0
var stage_rank = "A"

var likeness = 0.0

var to_compare = []

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup_level () :
	time = 180.0
	alert_time = 0
	tool_used = 0
	art_name = []
	art_taken = []
	to_compare = []
	alert_level = GameManager.threat_level

func _process(delta):
	if level_start == true :
		time -= delta
		update_time()
		if time <= 0.0 :
			level_start = false
			player.trigger_game_over()

func update_time () :
	var s = int(time) % 60
	var m = int(time) / 60
	time_node.text = "{0}:{1}".format([m if m >= 10 else "0"+str(m), s if s >= 10 else "0"+str(s)])

func calculate_score () :
	
	var b = 100 * art_taken.size()
	b += (5 * int(time))
	b -= 50 if tool_used >= 10 else 0
	b -= (20 * int(alert_time))
	b = max(b, 0)
	total_score = b
	
	stage_rank = "S" if total_score >= 1000 else "A" if total_score >= 850 else "B" if total_score >= 600 else "C" if total_score >= 300 else "D" if total_score > 0 else "F"

func calculate_painting_likeness (data) :
	likeness = 0.0
	
	var s1 : Array = data
	var s2 : Array = Artwork.paintings[GameManager.paintings[int(art_taken.back())].key].colors
	
#	var matrix_a = []
#	var matrix_b = []
	var matrix_w = 0.0
	#sort painting to matrix
	for a in range(16) :
		var off_x = 4 * (a % 4)
		var off_y = 64 * int((a / 4))
		var w = 0.0
		for i in range(4) :
#			var o1 = []
#			var o2 = []
			for j in range(4) :
				var x1 = ((i * 16) + off_y) + j + off_x
#				print(s1[x1], " ", s2[x1], " ", s1[x1].match(s2[x1]))
				if s1[x1].match(s2[x1]) :
					w += 1.0
		if w / 16.0 >= 0.8 :
			matrix_w += w / 16.0
		else :
			matrix_w += (0.0)
	likeness = matrix_w / 16.0
#				o1.append(s1[x1])
#				o2.append(s2[x1])
#			matrix_a.append(o1)
#			matrix_b.append(o2)

func calculate_statue_likeness (data) :
	likeness = 0.0
	
	var s1 : Array = data
	var s2 : Array = Artwork.statues[GameManager.statues[int(art_taken.back())].key].data
	
	var margin = 1.0
	
	if s1.size() != s2.size() :
		if s1.size() < s2.size() :
			margin = float(s1.size()) / float(s2.size())
		else :
			margin = float(s2.size()) / float(s1.size())
	
	var w = 0.0
	for d in s1 :
		var t_check = false
		var p_check = false
		for b in s2 :
			t_check = d.type.match(b.type)
			p_check = d.position[0] == b.position[0] && d.position[1] == b.position[1] && d.position[2] == b.position[2]
			if t_check && p_check :
				w += 1.0
				break
	likeness = (w / float(s1.size())) * margin
