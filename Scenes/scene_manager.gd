extends Node2D
@export var player = CharacterBody2D
@onready var global: GlobalScene = get_node("/root/GlobalScene")
var scene_name: String
@export var previous: String

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_name = self.name
	global.set_scene_name(scene_name)
	#print(global.get_current_scene_name())
	
	#if SaveLoad.save_data.has("Hellsword"):
			#print("current weapon :", SaveLoad.save_data["Hellsword"])
	
	var current_scene = get_tree().current_scene
	print("current_scene : ", current_scene)
	if current_scene:
			
		SourcePath.global_scene_path = get_tree().current_scene.scene_file_path
		if SaveLoad.save_data.has("player_data") and not null:
			var player_position_dict = SaveLoad.save_data["player_data"]["player_position"]
			var dirx = SaveLoad.save_data["player_data"]["player_position"]["x"]
			var diry = SaveLoad.save_data["player_data"]["player_position"]["y"]
			
			if dirx != null && diry != null:
				var player_x = player_position_dict.get("x", 0)
				var player_y = player_position_dict.get("y", 0)
				var player_position = Vector2(player_x, player_y)
				if player:
					player.position = player_position
					print("player position = ", player.position)
				else:
					print("cannot load player position")

		#if SaveLoad.save_data.has("first_slot") and not null:
			#if SaveLoad.first_slot != {}:
				#if SaveLoad.save_data["first_slot"]["is_full"] == true:
					#EquipmentManager.slot_1_not_full = false
#
		#elif SaveLoad.save_data.has("second_slot") and not null:
			#if SaveLoad.save_data["second_slot"]["is_full"] == true:
				#EquipmentManager.slot_2_not_full = false
	else:
		print("failed to load save data")
