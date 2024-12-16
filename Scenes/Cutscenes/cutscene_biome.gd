extends Node2D

@export var animation_player: AnimationPlayer
var dir_to_path = "res://Scenes/"
@export var scene_to_path : String
@export var transition: transition_screen

func _ready() -> void:
	animation_player.play("scene")
	transition.transition_normal()
	await transition.on_transition_finished



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scene":
		# Memasukan Nama Path
		var full_path = dir_to_path + scene_to_path + ".tscn"
		var scene_tree = get_tree()
		# Memanggil Biome setelah Animasi selesai
		scene_tree.call_deferred("change_scene_to_file", full_path)
