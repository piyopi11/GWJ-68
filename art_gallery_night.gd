extends Spatial

var map

var tut = ""

func _ready():
	AudioManager.stop_bgm()
	if GameManager.threat_level < 3.0 :
		$cop/cop2.queue_free()
	if GameManager.threat_level < 2.0 :
		$cop/cop3.queue_free()
	$player.mode = "heist"
	$player.speed = 10.0
	$player.can_interact = true
	$player.setup_ui()
	if GameManager.tools.has(0) :
		$world.environment.ambient_light_color = Color("#3d5d38")
	if GameManager.tools.has(3) :
		$player.interaction_step *= 3.0
#	GameManager.art = GameManager.inventory[0].key
	LevelManager.setup_level()
	LevelManager.time_node = $player.get_node("ui/time_counter")
	LevelManager.player = $player
	call_deferred("setup_navserver")
	if GameManager.guide[4] == false :
		tut = "heist"
		$player.block = true
		show_guide()
	else :
		LevelManager.level_start = true
		for c in $cop.get_children() :
			c.start_cop()

func show_guide () : 
	var t = GuideManager.get_text(tut)
	if t == "fin" :
		$tutorial/tutorial.visible = false
		LevelManager.level_start = true
		for c in $cop.get_children() :
			c.start_cop()
		$player.block = false
		GameManager.guide[0] == false
	else :
		$tutorial/tutorial/frame/content.text = t
		$tutorial/tutorial.visible = true

func _on_ok_pressed():
	AudioManager.ok()
	GuideManager.next_guide(tut)
	show_guide()

func setup_navserver():
	map = NavigationServer.map_create()
	NavigationServer.map_set_up(map, Vector3.UP)
	NavigationServer.map_set_active(map, true)
	
	for c in $cop.get_children() :
		NavigationServer.agent_set_map(c.get_node("nav_agent"), map)

	var region = NavigationServer.region_create()
	NavigationServer.region_set_transform(region, Transform())
	NavigationServer.region_set_map(region, map)

	var navigation_mesh = NavigationMesh.new()
	navigation_mesh = $navigation_mesh.navmesh
	NavigationServer.region_set_navmesh(region, navigation_mesh)

	yield(get_tree(), "physics_frame")

func _on_cricket_playing(target):
	for c in $cop.get_children() :
		c.mode = c.MODE.INVESTIGATE
		c.path_find(target)

func _on_cricket_dead():
	for c in $cop.get_children() :
		if c.mode==c.MODE.INVESTIGATE :
			c.return_to_initial_position()
