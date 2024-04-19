extends Spatial

var map

func _ready():
	AudioManager.stop_bgm()
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
	LevelManager.level_start = true
	for c in $cop.get_children() :
		c.start_cop()

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
