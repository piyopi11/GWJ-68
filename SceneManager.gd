extends Node

func change_scene (path) :
	AudioManager.stop_bgm()
	var s = ResourceLoader.load(path)
	get_tree().change_scene_to(s)
