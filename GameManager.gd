extends Node

#tools related
const tools_base = [
	{
		"name": "Night Vision Googles", 
		"desc": "Improves vision in the dark. Passive effect.", 
		"usable": false, 
		"limit": 0, 
		"cool": 0, 
		"icon": "night_vision", 
		"unlocked": 0
	},
	{
		"name": "Booster Boots", 
		"desc": "Increase move speed for 5 seconds. 10 seconds cooldown.", 
		"usable": true, 
		"limit": -1, 
		"cool": 10, 
		"icon": "booster_boots", 
		"unlocked": 0
	},
	{
		"name": "\"Take-Me-Away\"inator", 
		"desc": "Has a 50% chance to leave the stage when used. Also has a 50% chance to teleport you to a random spot instead. Can only be used once.", 
		"usable": true, 
		"limit": 1, 
		"cool": 0, 
		"icon": "take_me_away_inator", 
		"unlocked": 0
	},
	{
		"name": "AI Gloves", 
		"desc": "Triples the speed of replacing artworks. Passive effect.", 
		"usable": false, 
		"limit": 0, 
		"cool": 0, 
		"icon": "swift_gloves", 
		"unlocked": 0
	},
	{
		"name": "Noisy Cricket", 
		"desc": "Press once to place a cricket on a spot. Hold and press to activate the cricket and alert all security guards to the cricket for 15 seconds. 2 uses.", 
		"usable": true, 
		"limit": 2, 
		"cool": 0, 
		"icon": "noisy_cricket", 
		"unlocked": 0
	},
	{
		"name": "Camo-Suit", 
		"desc": "Becomes invisible for 3 seconds. 20 seconds cooldown.", 
		"usable": true, 
		"limit": -1, 
		"cool": 20, 
		"icon": "camo_lens", 
		"unlocked": 0
	},
	{
		"name": "Golden Time", 
		"desc": "Increase heist time by 30 seconds. Passive effect.", 
		"usable": false, 
		"limit": 0, 
		"cool": 0, 
		"icon": "time_stopper", 
		"unlocked": 0
	},
]

#player related
var score = 0
var inventory = []
var total_art = 0
var art_stolen = 0

var tools = []
var art = "0"
var bag = []
var art_limit = 2

var total_heist = 0

var career_data = []
var tool_used = [0, 0, 0, 0, 0, 0, 0]

#gallery related
var paintings = []
var statues = []
var security_level = 1
var total_gallery_art = 16

#constraint related
var day = 0
var in_demand = []
const demand_refresh_time = 5

#level related
var threat_level = 0.0

#career related
var game_start = false
var total_time = 0.0
var bonus_triggered = 0

var best_forgery = ""
var best_forgery_score = 0.0

var game_over = false

var photo = null

#home, visit, heist, gadget, heist game, make painting, make statue, inventory
var guide = [false, false, false, false, false, false, false, false]

func _ready () :
	for k in Artwork.paintings.keys() :
		var o = {"data": Artwork.paintings[k].duplicate(true), "sentiment": 1.0, "forged": false, "key": k}
		paintings.append(o)
	for k in Artwork.statues.keys() :
		var o = {"data": Artwork.statues[k].duplicate(true), "sentiment": 1.0, "forged": false, "key": k}
		statues.append(o)

func _process (delta) :
	if game_start :
		total_time += delta

func quit_game () :
	game_start = false

func new_game () :
	game_start = true
	setup_data()

func setup_data () :
	bonus_triggered = 0
	total_time = 0.0
	game_over = false
	score = 0
	inventory = []
	total_art = 0
	art_stolen = 0
	tools = []
	art = "0"
	bag = []
	art_limit = 2
	paintings = []
	statues = []
	security_level = 1
	day = 0
	in_demand = []
	threat_level = 1.0
	total_heist = 0
	career_data = []
	best_forgery = ""
	best_forgery_score = 0.0
	photo = null

	for k in Artwork.paintings.keys() :
		var o = {"data": Artwork.paintings[k].duplicate(true), "sentiment": 1.0, "forged": false, "key": k}
		paintings.append(o)
	for k in Artwork.statues.keys() :
		var o = {"data": Artwork.statues[k].duplicate(true), "sentiment": 1.0, "forged": false, "key": k}
		statues.append(o)
	randomize_demand()
	setup_day()
 
func setup_day () :
	day += 1
	if day % demand_refresh_time == 0 :
		randomize_demand()

func randomize_demand () :
	in_demand = []
	var bag = []
	for m in paintings :
		if m.forged == false :
			bag.append(m.key)
	for m in statues :
		if m.forged == false :
			bag.append(m.key)
	var l = min(bag.size(), 3)
	for i in range(l) :
		randomize()
		bag.shuffle()
		in_demand.append(bag.pop_front())

func save_artwork (type, name, data) :
	var o = {"type": type, "name": name, "data": data, "key": total_art}
	inventory.append(o)
	total_art += 1

func get_painting (idx) :
	return paintings[idx if idx < paintings.size() else 0]

func get_statue (idx) :
	return statues[idx if idx < statues.size() else 0]

func get_inventory (key) :
	for i in inventory :
		if i.key == int(key) :
			return i

func delete_inventory (key) :
	var idx = 0
	for i in inventory :
		if i.key == int(key) :
			break
		idx += 1
	inventory.remove(idx)

func save_career_data (obj) :
	career_data.append(obj)
