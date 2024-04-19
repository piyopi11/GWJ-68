extends Node

#tools related
const tools_base = [
	{
		"name": "Night Vision Googles", 
		"desc": "Improves vision in the dark.", 
		"usable": false, 
		"limit": 0, 
		"cool": 0, 
		"icon": "night_vision", 
		"unlocked": 1
	},
	{
		"name": "Booster Boots", 
		"desc": "Increase move speed for 5 seconds. 10 seconds cooldown.", 
		"usable": true, 
		"limit": -1, 
		"cool": 10, 
		"icon": "booster_boots", 
		"unlocked": 2
	},
	{
		"name": "\"Take-Me-Away\"inator", 
		"desc": "Has a 50% chance to leave the stage when used. Also has a 50% chance to teleport you to a random spot instead. Can only be used once.", 
		"usable": true, 
		"limit": 1, 
		"cool": 0, 
		"icon": "take_me_away_inator", 
		"unlocked": 3
	},
	{
		"name": "AI Gloves", 
		"desc": "Triples the speed of replacing artworks", 
		"usable": false, 
		"limit": 0, 
		"cool": 0, 
		"icon": "swift_gloves", 
		"unlocked": 5
	},
	{
		"name": "Noisy Cricket", 
		"desc": "Press once to place a cricket on a spot. Hold and press to activate the cricket and alert all security guards to the cricket for 15 seconds. Can only be used once.", 
		"usable": true, 
		"limit": 1, 
		"cool": 0, 
		"icon": "noisy_cricket", 
		"unlocked": 7
	},
	{
		"name": "Camo-Suit", 
		"desc": "Becomes invisible for 3 seconds. 20 seconds cooldown.", 
		"usable": true, 
		"limit": -1, 
		"cool": 20, 
		"icon": "camo_lens", 
		"unlocked": 9
	},
	{
		"name": "Golden Time", 
		"desc": "Increase heist time by 30 seconds", 
		"usable": false, 
		"limit": 0, 
		"cool": 0, 
		"icon": "time_stopper", 
		"unlocked": 10
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

#gallery related
var paintings = []
var statues = []
var security_level = 1

#constraint related
var day = 0
var in_demand = []
const demand_refresh_time = 5

#level related
var threat_level = 0.0

#career related
var game_start = false
var total_time = 0.0

func _ready () :
	new_game()

func _process (delta) :
	if game_start :
		total_time += delta

func quit_game () :
	game_start = false

func new_game () :
	game_start = true
	setup_data()

func setup_data () :
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
	threat_level = 0.0

	for k in Artwork.paintings.keys() :
		var o = {"data": Artwork.paintings[k].duplicate(true), "sentiment": 0, "forged": false, "key": k}
		paintings.append(o)
	for k in Artwork.statues.keys() :
		var o = {"data": Artwork.statues[k].duplicate(true), "sentiment": 0, "forged": false, "key": k}
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
