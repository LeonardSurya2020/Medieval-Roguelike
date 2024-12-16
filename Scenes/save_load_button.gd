extends Node
class_name save_load_button
@onready var global: GlobalScene = get_node("/root/GlobalScene")
@export var player = CharacterBody2D
var player_position

func _on_save_button_button_up():
	data_save(player)
	#var scene_path = global.get_current_scene_name()
	#var player_position = player.position
	#SaveLoad.player_data["player_position"] = {
		#"x": player_position.x,
		#"y": player_position.y
	#}
	#SaveLoad.save_data["scene"] = scene_path
	#SaveLoad.save_data["player_data"] = SaveLoad.player_data
	#
	#if SaveLoad.first_slot != null:
		#SaveLoad.save_data["first_slot"] = SaveLoad.first_slot
	#
	#if SaveLoad.second_slot != null:
		#SaveLoad.save_data["second_slot"] = SaveLoad.second_slot
		#
	#SaveLoad.save_game()



func _on_load_button_button_up():
	SaveLoad.load_game()
	if SaveLoad.save_data.has("scene"):
		var scene_path = SaveLoad.save_data["scene"]
		var result = get_tree().change_scene_to_file(scene_path)
		print("changing scene to: ", scene_path)
		if result != OK:
			print("Failed to change scene to: ", scene_path)
			return

		#call_deferred("_on_scene_ready")

#func _on_scene_ready() -> void:
	##
	##if SaveLoad.save_data.has("nodes"):
		##var nodes_data = SaveLoad.save_data["nodes"]
		##for node_name in nodes_data.keys():
			##var node_data = nodes_data[node_name]
			##var node = get_tree().current_scene.get_node_or_null(node_name)
			##if node and node is CharacterBody2D:
				##node.position = Vector2(node_data["position"]["x"], node_data["position"]["y"])
				##print("Position for node ", node_name, " set to: ", node.position)
			##else:
				##print("Node ", node_name, " not found or not a Node2D.")
	##else:
		##print("Failed to load nodes data from save data.")
		##
		#if SaveLoad.save_data.has("player_position"):
			#var player_position_dict = SaveLoad.save_data["player_position"]
			#var player_x = player_position_dict.get("x", 0)
			#var player_y = player_position_dict.get("y", 0)
			#player_position = Vector2(player_x, player_y)
			#
			#if player:
				#player.position = player_position
				#print("player position = ", player.position)
			#else:
				#print("cannot load player position")
		#else:
			#print("failed to load save data")


func data_save(player: CharacterBody2D):
	var scene_path = global.get_current_scene_name()
	var player_position = player.position
	
	 
	SaveLoad.player_data["player_position"] = {
		"x": player_position.x,
		"y": player_position.y
	}
	SaveLoad.save_data["scene"] = scene_path
	SaveLoad.save_data["player_data"] = SaveLoad.player_data
	
	if SaveLoad.first_slot != null:
		SaveLoad.save_data["first_slot"] = SaveLoad.first_slot
	
	if SaveLoad.second_slot != null:
		SaveLoad.save_data["second_slot"] = SaveLoad.second_slot
		
	SaveLoad.save_game()
	print("size first slot setelah di save : ", SaveLoad.first_slot.size())
	
	#var current_scene = get_tree().current_scene
	#var player = current_scene.get_node("Player")
	# Menyimpan path scene
	#SaveLoad.save_data["player_position"] = current_scene.get_node("Player").position  # Menyimpan posisi player
