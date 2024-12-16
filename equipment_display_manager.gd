extends Sprite2D
class_name sprite_manager

var SPRITE_DIR_PATH = "res://Assets/32 Free Weapon Icons/32 Free Weapon Icons/Icons/"
var SCENE_DIR_PATH = "res://scenes/"
var full_path = ""
var slot_1_full = false
var slot_2_full = false
var new_texture
var full_scene_path = ""
# Called when the node enters the scene tree for the first time.

func set_weapon_display(sprite_name: String):
	full_path = SPRITE_DIR_PATH + sprite_name
	#new_texture = ResourceLoader.load(full_path)
	#texture = new_texture

func get_weapon_display() -> String :
	return full_path

func set_weapon_scene(scene_name: String):
	full_scene_path = SCENE_DIR_PATH + scene_name + ".tscn"
