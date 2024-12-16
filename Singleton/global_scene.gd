extends Node
class_name global_scene

var current_scene_name: String = ""
var dir_path: String = "res://Scenes/"
var full_dir_path: String = ""
func set_scene_name(scene: String):
	current_scene_name = scene
	full_dir_path = dir_path + current_scene_name + ".tscn"

func get_current_scene_name() -> String:
	return full_dir_path
