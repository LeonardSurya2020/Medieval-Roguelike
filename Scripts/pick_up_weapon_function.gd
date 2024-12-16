extends Node2D

var file_name: String = ""
@export var gravity: float = 500.0
var velocity: Vector2 = Vector2.ZERO
@export var sword_icon: Sprite2D
@export var banner : Banner
var players_in_group
var can_pick_up: bool = false
var weapon_id: String  # Variabel untuk menyimpan ID senjata
var spawn_index: int
@onready var sprite: Sprite2D = $sword_sprt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#banner = MeleeBanner.new()
	if weapon_id == "" or weapon_id == null:
		weapon_id = generate_id_from_spawn()
	
	print("ini senjata : ", self.name, "dengan ID : ", weapon_id)
	
	if SaveLoad.save_data.has("first_slot") && SaveLoad.save_data["first_slot"].size() > 0:
		var is_full = SaveLoad.save_data["first_slot"]["is_full"]
		if is_full == true:
			EquipmentManager.slot_1_not_full = false
		print("status slot 1 adalah ", EquipmentManager.slot_1_not_full)
	else:
		print("hubla")
	
	if SaveLoad.save_data.has("first_slot") && SaveLoad.save_data["first_slot"].size() > 0 and SaveLoad.save_data["first_slot"]["ID"] == weapon_id:
		var first_slot_weapon = SaveLoad.save_data["first_slot"]["weapon_name"]
		print("nama senjata : ", first_slot_weapon)
		if SaveLoad.save_data["first_slot"][first_slot_weapon]["is_taken"] == true && SaveLoad.save_data["first_slot"]["ID"] == weapon_id:
			queue_free()
	else:
		print("ngak")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_on_floor():
		if can_pick_up and EquipmentManager.slot_1_not_full == true:
			if Input.is_action_just_pressed("interact"):
				set_sprite_name()
				var original_string = self.name
				var original_name = set_original_weapon_name(original_string)
				
				queue_free()
				EquipmentManager.weapon_equip= true
				EquipmentManager.is_taken = true
				if EquipmentManager.has_method(original_name):
					EquipmentManager.call(original_name)
					SaveLoad.first_slot["ID"] = weapon_id
					SaveLoad.first_slot["original_string"] = original_string
					print("idnya : ", SaveLoad.first_slot["ID"])
				else:
					print("there's no method called ", original_name)
				var tree = get_tree()
				players_in_group = tree.get_nodes_in_group("Player")
				pick_up_weapon()
				can_pick_up = false
		elif can_pick_up == true and EquipmentManager.slot_1_not_full == false:
			if Input.is_action_just_pressed("interact"):
				var tree = get_tree()
				players_in_group = tree.get_nodes_in_group("Player")
				drop_existing_weapon()
				set_sprite_name()
				var original_string = self.name
				var original_name = set_original_weapon_name(original_string)
				
				queue_free()
				EquipmentManager.weapon_equip= true
				EquipmentManager.is_taken = true
				if EquipmentManager.has_method(original_name):
					EquipmentManager.call(original_name)
					SaveLoad.first_slot["ID"] = weapon_id
					SaveLoad.first_slot["original_string"] = original_string
					print("idnya : ", SaveLoad.first_slot["ID"])
				else:
					print("there's no method called ", original_name)
				#var tree = get_tree()
				#players_in_group = tree.get_nodes_in_group("Player")
				pick_up_weapon()
				can_pick_up = false
	else :
		print("tidak di lantai")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		# Untuk Menampilkan Banner
		banner.visible = true
		var original_name = set_original_weapon_name(self.name)
		var sprite_texture = sprite.texture
		var path = sprite_texture.resource_path
		print("path : ", path)
		banner.set_banner(original_name, path)
		banner.set_full()
		
		
		if EquipmentManager.slot_1_not_full == true:
			print("you can pick the weapon")
			can_pick_up = true
		elif EquipmentManager.slot_1_not_full == false:
			print("you can pick the weapon from false")
			can_pick_up = true
		#set_sprite_name()
		#var original_string = self.name
		#var original_name = set_original_weapon_name(original_string)
		#queue_free()
		#EquipmentManager.weapon_equip= true
		#EquipmentManager.is_taken = true
		#if EquipmentManager.has_method(original_name):
			#EquipmentManager.call(original_name)
		#else:
			#print("there's no method called ", original_name)
		#var tree = get_tree()
		#players_in_group = tree.get_nodes_in_group("player")
		#pick_up_weapon()

#FUNGSI UNTUK MENGANMBIL SENJATA
func pick_up_weapon():
	for player in players_in_group:
		if player.has_method("display_weapon"):
			var original_string = self.name
			var original_name = set_original_weapon_name(original_string)
			var weapon_icon = get_file_name()
			player.display_weapon(weapon_icon, original_name)
		else:
			print("Node tidak memiliki metode 'some_method'")


#GETTER SETTER SPRITE NAME
func set_sprite_name():
	if sprite and sprite.texture:
		var texture = sprite.texture
		var texture_path = texture.get_path()
		
		file_name = texture_path.get_file()
		
		print("Texture file name: %s" % file_name)
	else:
		print("Sprite2D atau texture tidak ditemukan.")
	return file_name
	

func get_file_name() -> String:
	return file_name

func set_original_weapon_name(original_string: String):
	var cleaned_string
	var reg_exp = RegEx.new()
	reg_exp.compile("\\d+$")  # Ekspresi reguler untuk mencocokkan angka di akhir string
	var match = reg_exp.search(original_string)
	if match:
	# Ambil posisi akhir dari bagian yang cocok
		var match_end_position = match.get_string().length()
		cleaned_string = original_string.substr(0, original_string.length() - match_end_position)
	else:
		cleaned_string = original_string
		print(cleaned_string)
	return cleaned_string

# Fungsi untuk membuat ID berdasarkan nama dan urutan spawn
func generate_id_from_spawn() -> String:
	return str(self.name) + "_" + str(spawn_index)


func _on_area_2d_body_exited(body: Node2D) -> void:
	can_pick_up = false
	banner.visible = false

func drop_existing_weapon():
	for player in players_in_group:
		if player.has_method("drop_equipment"):
			player.drop_equipment()
		else:
			print("Node tidak memiliki metode 'some_method'")


func _on_drop_area_2d_body_entered(body: Node2D) -> void:
	pass
	if body.name == "novice_bow":
		print("halo ini bow")
		body.global_position.x += 100
	elif body.name == "dull_sword":
		if body != self: 
			body.global_position.x += 100

func is_on_floor():
	var raycast = $RayCast2D
	return raycast.is_colliding()and raycast.get_collider().is_in_group("ground")


func _on_drop_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
