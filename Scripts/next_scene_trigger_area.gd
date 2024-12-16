extends Area2D

var dir_to_path = "res://Scenes/"

@export var player : CharacterBody2D
@export var scene_to_path : String
@export var biome_scene_path : String
@export var transition: transition_screen

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
			transition.transition_black()
			await transition.on_transition_finished
			
			# Memasukan Nama Path untuk masuk ke cutscene
			var cutscene_path = dir_to_path + scene_to_path + ".tscn"
			
			# Memasukan Nama Biome Path untuk save data
			var biome_full_path = dir_to_path + biome_scene_path + ".tscn"
			
			var scene_tree = get_tree()
			SaveLoad.save_data["scene"] = biome_full_path
			auto_save(player)
			# Memanggil Biome setelah Animasi selesai
			scene_tree.call_deferred("change_scene_to_file", cutscene_path)
			SaveLoad.save_data["player_data"]["player_position"] = {
			"x": null,
			"y": null
		}

func auto_save(player: CharacterBody2D):
	var player_position = player.position
		
	SaveLoad.player_data["player_position"] = {
		"x": null,
		"y": null
	}

	SaveLoad.save_data["player_data"] = SaveLoad.player_data
	
	if SaveLoad.first_slot != null:
		SaveLoad.save_data["first_slot"] = SaveLoad.first_slot
		
	SaveLoad.save_game()
