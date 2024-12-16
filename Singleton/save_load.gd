extends Node

var save_data: Dictionary = {}
var player_data: Dictionary = {}
var first_slot: Dictionary = {}
var second_slot: Dictionary = {}
var biome_layout: Dictionary = {}
const SAVE_FILE_PATH: String = "user://savegame.json"
#dir_path:String, position:Vector2

#func _ready():
	#save_data = {}
	
func save_game():
	var save_nodes = get_tree().get_nodes_in_group("saveObject")
	#save_data = {}  # Reset save_data dictionary
	#
	## Simpan data posisi node
	#save_data["nodes"] = {}
	#for node in save_nodes:
		#if node is CharacterBody2D:
			#save_data["nodes"][node.name] = {
				#"position": {
					#"x": node.position.x,
					#"y": node.position.y
				#}
			#}
	## Simpan path scene saat ini
	#var current_scene = get_tree().current_scene
	#if current_scene:
		#save_data["scene"] = GlobalScene.get_current_scene_name()
	#
	# menyimpan data ke file
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		var json_save_data = JSON.stringify(save_data)
		file.store_string(json_save_data)
		file.close()
		print(json_save_data)
		print("Game Saved Succesfully")
	else:
		print("Failed to save game.")

func load_game():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			var json = file.get_as_text()
			save_data = JSON.parse_string(json)
			print(save_data)
			print("Data Loaded succesfully")
			file.close()
		else:
			print("Failed to load game.")
	else:
		print("Save file does not exist.")
