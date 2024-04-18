extends Node

#player related
var score = 0
var inventory = []
var total_art = 0

var tools = []
var art = "0"

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

func _ready () :
	setup_data()

func setup_data () :
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
