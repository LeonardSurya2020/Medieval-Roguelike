extends CharacterBody2D

class_name Player

const SPEED = 250.0
const JUMP_VELOCITY = -400.0


@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var vfx: AnimatedSprite2D = $VFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_attack_collision: CollisionShape2D = $Sword_attack_area/sword_attack_collision
@export var health_bar: ProgressBar
@onready var timer: Timer = $Timer
@onready var hit_timer: Timer = $Hit_timer
@export var character_position: CharacterBody2D
var player_unit : PlayerUnit
var enemy : slime
var enemy_node
#Handle attack combo
@onready var sword_attack_area: Area2D = $Sword_attack_area
@export var attack_list: Node2D
var attacking = false
var attack_index = 0
var max_combo = 3
var combo_timer = Timer.new()
var attack_cooldown = 0.5
var can_attack = true
var direction
var jump_attack = false

var is_alive = true

var player_position
var player_x = 0
var player_y = 0
var player = Player

# Handle Jump
var is_jump = false
var can_jump_midair = true
var can_double_jump = false
var double_jump_enabled = true
var after_jump = false
var jump_fall_floor = false
var b = false
@export var climbing = false

var weapon_equiped = false

# Handle Display Weapon
@onready var sword_sprt: Sprite2D = $inventory/Sword_sprt
@onready var bow_sprt: Sprite2D = $inventory/Bow_sprt
@onready var magic_b_sprt: Sprite2D = $inventory/MagicB_sprt

# Handle Weapon Display
#var sword_sprt
var load_data = false

func _ready() -> void:
	enemy = slime.new()
	print("isi save data : ", SaveLoad.save_data)
	print("size : ",  SaveLoad.first_slot.size())
	HealthManager.max_hp = 100
	health_bar.init_health(HealthManager.max_hp)
	# Buat dan tambahkan timer ke node
	player_unit = PlayerUnit.new()
	player_unit.player = self
	sword_attack_area.monitoring = false
	sword_attack_collision.disabled = true
	add_child(combo_timer)
	combo_timer.wait_time = attack_cooldown
	combo_timer.one_shot = true
	combo_timer.connect("timeout", Callable(self, "_on_combo_timeout"))
	
	if  SaveLoad.first_slot.size() > 0:
		var dir = SaveLoad.first_slot["path"]
		var weapon_name = SaveLoad.first_slot["weapon_name"]
		print("dir slot 1: ", dir)
		load_weapon_on_load(dir, weapon_name)
		weapon_equiped = true
	elif SaveLoad.save_data.has("first_slot") and SaveLoad.save_data["first_slot"].size() > 0:
		var dir = SaveLoad.save_data["first_slot"]["path"]
		var weapon_name = SaveLoad.save_data["first_slot"]["weapon_name"]
		print("weapon name = ", weapon_name)
		print("dir slot 1 save data: ", dir)
		weapon_equiped = true
		load_data = true
		load_weapon_on_load(dir, weapon_name)

	else :
		print("tidak ada senjata dalam save file")
	

func _process(delta: float) -> void:
	if weapon_equiped == true:
		if Input.is_action_just_pressed("attack"):
			if can_attack :
				if SaveLoad.first_slot.size() > 0:
					var weapon_name = SaveLoad.first_slot["weapon_name"]
					var weapon_type = SaveLoad.first_slot[weapon_name]["weapon_type"]
					if attack_list.has_method(weapon_type):
						jump_fall_floor = true
						is_jump = false
						attacking = true
						animation_player.stop()
						timer.stop()
						attack_list.call(weapon_type)
					else :
						print("method yang dicari tidak ada")
					#attack_action()
				elif SaveLoad.save_data.has("first_slot") and SaveLoad.save_data["first_slot"].size() > 0:
					var weapon_name = SaveLoad.save_data["first_slot"]["weapon_name"]
					var weapon_type = SaveLoad.save_data["first_slot"][weapon_name]["weapon_type"]
					if attack_list.has_method(weapon_type):
						jump_fall_floor = true
						is_jump = false
						attacking = true
						animation_player.stop()
						timer.stop()
						attack_list.call(weapon_type)
					else :
						print("method yang dicari tidak ada")
	else :
		print("tidak ada senjata")
	
	if Input.is_action_just_pressed("drop_item"):
		drop_equipment()


func _physics_process(delta: float) -> void:
	#print(sword_attack_area.monitoring)
	if enemy_node != null:
		var enemy_postion_y = enemy_node.position.y
		var enemy_postion_x = enemy_node.position.x
		attack_list.enemy_positionY = enemy_postion_y
		attack_list.enemy_positionX = enemy_postion_x
	print("attacking = ", attacking)
	if is_alive == true:
		
		
		#HANDLE ROPE CLIMBING
		if climbing == false and is_on_floor():
			velocity += get_gravity() * delta
			
		elif climbing == true:
			if Input.is_action_pressed("ui_up"):
				velocity.y = -SPEED
			elif Input.is_action_pressed("ui_down"):
				velocity.y = SPEED	
			else : 
				velocity = get_gravity() * 0
			
				
		# Add the gravity.
		if not is_on_floor() and not climbing:
			velocity += get_gravity() * delta
			
		# HANDLE FUNGSI DAN ANIMASI JUMP
		if Input.is_action_just_pressed("ui_accept"):
			var timer_on_first_jump = false
			if is_on_floor():
				if Input.is_action_pressed("ui_down"):
					#print("hi from button down")
					position.y += 1
				else :
					# Jump pertama
					velocity.y = JUMP_VELOCITY
					is_jump = true
					jump_fall_floor = true
					timer_on_first_jump = true
					can_double_jump = true
					print("can jump", can_double_jump)
					if jump_attack == false:
						timer.start()
					
					
			elif can_double_jump and double_jump_enabled:
				# Double jump
				jump_fall_floor = true
				if jump_attack == false:
					timer.start()
				#print("ini double")
				velocity.y = JUMP_VELOCITY
				can_double_jump = false
			
				
		if Input.is_action_just_pressed("ui_accept") and can_jump_midair == true:
			if not is_on_floor():
				velocity.y = JUMP_VELOCITY
				can_jump_midair = false
				is_jump = true
				jump_fall_floor = true
				timer.start()
				
		
		#MENGATUR ANIMASI BERDASARKAN DIRECTION (RUN, IDLE)
		direction = Input.get_axis("move_left", "move_right")
		
		if direction > 0:
			animated_sprite.flip_h = false
			sword_attack_collision.position.x = 0
		elif direction < 0:
			animated_sprite.flip_h = true
			sword_attack_collision.position.x = -82
		if !attacking and after_jump == false:
			if direction == 0:
				animation_player.play("Idle")
			else:
				animation_player.play("Running")
		
		#JIKA DILANTAI
		if is_on_floor():
			jump_fall_floor = false
			b = false
			#print("ini di lantai")
			sprite_2d.visible = true
			double_jump_enabled = true
			can_jump_midair = true
			after_jump = false

		if is_jump == true and not is_on_floor():
			if jump_attack == false:
				#animated_sprite.play()
				sprite_2d.visible = false
				animation_player.play("Jump")
				#print("jump")
			
		elif jump_fall_floor == false and not is_on_floor():
			#print("after jump")
			animation_player.play("Jump_fall_floor")
		
		if not attacking:
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = 0
		
		if b == true:
			if animated_sprite.flip_h == true:
				velocity.x = -1 * SPEED + 50
			elif  animated_sprite.flip_h == false:
				velocity.x = 1 * SPEED + 50

	move_and_slide()

#func attack_action():
	#if can_attack:
		##print("attacking berjalan")
		#var overlapping = sword_attack_area.get_overlapping_areas()
		#for area in overlapping:
			#var parent = area.get_parent()
			#print(parent.name)
		#jump_fall_floor = true
		#is_jump = false
		#animation_player.stop()
		#timer.stop()
		#attack_animation()
		#attacking = true
		#combo_timer.start()

#func attack_animation():
	#match  attack_index:
		#0:
			#animation_player.play("Attack_phase_1")
			#sword_attack_area.monitoring = true
			#sword_sprt.visible = false
			#velocity.x = direction * SPEED * 0
		#1:
			#animation_player.play("Attack_phase_2")
			#sword_attack_area.monitoring = true
			#sword_sprt.visible = false
			#velocity.x = direction * SPEED * 0
		#2:
			#animation_player.play("Attack_phase_3")
			#sword_attack_area.monitoring = true
			#sword_sprt.visible = false
			#can_attack = false
			#velocity.x = direction * SPEED * 0
			#
	#attack_index = (attack_index + 1) % max_combo


		
#func _on_animated_sprite_2d_animation_finished() -> void:
	#if animated_sprite.animation == "Attack_phase_1":
		#sword_attack_area.monitoring = false
		#sword_attack_collision.disabled = true
		#attacking = false
		#can_attack = true
	#elif animated_sprite.animation == "Attack_phase_2":
		#sword_attack_area.monitoring = false
		#sword_attack_collision.disabled = true
		#attacking = false
		#can_attack = true
	#elif animated_sprite.animation == "Attack_phase_3":
		#sword_attack_area.monitoring = false
		#sword_attack_collision.disabled = true
		#attacking = false
		#can_attack = true
		
#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "Attack_phase_1":
		#sword_attack_area.monitoring = false
		#sword_attack_collision.disabled = true
		#sword_sprt.visible = true
		#attacking = false
		#can_attack = true
		#jump_fall_floor = false
	#elif anim_name == "Attack_phase_2":
		#sword_attack_area.monitoring = false
		#sword_attack_collision.disabled = true
		#sword_sprt.visible = true
		#attacking = false
		#can_attack = true
		#jump_fall_floor = false
	#elif anim_name == "Attack_phase_3":
		#sword_attack_area.monitoring = false
		#sword_attack_collision.disabled = true
		#sword_sprt.visible = true
		#attacking = false
		#can_attack = true
		#jump_fall_floor = false

func _on_combo_timeout():
	attack_index = 0  # Reset combo jika timeout terjadi
	jump_fall_floor = false
	
func dead():
	pass


#func _on_hurt_box_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Enemy"):
		#set_physics_process(false)
		#animation_player.play("Hit")
		#var enemy_name = body.name
		#var original_name = set_original_enemy_name(enemy_name)
		#GlobalEnemyUnit.call(original_name.to_lower())
		#var enemy_damage = GlobalEnemyUnit.call("get_damage")
		#HealthManager.decrease_health(enemy_damage)
		#print("enemy entered")
		#health_bar.health = HealthManager.current_hp
		#print("hp player setelah terkena damage, ", HealthManager.current_hp)


# jika terkena are serang musuh
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_attack_hitbox"):
		set_physics_process(false)
		set_process(false)
		animation_player.play("Hit")
		hit_timer.start()
		var enemy_name = area.get_parent().name
		var original_name = set_original_enemy_name(enemy_name)
		GlobalEnemyUnit.call(original_name.to_lower())
		var enemy_damage = GlobalEnemyUnit.call("get_damage")
		HealthManager.decrease_health(enemy_damage)
		health_bar.health = HealthManager.current_hp
		print("hp player setelah terkena damage, ", HealthManager.current_hp)

func set_original_enemy_name(original_string: String):
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



func _on_timer_timeout() -> void:
	
	after_jump = true
	after_jumping()
	timer.stop()

func after_jumping():
	animation_player.play("Jump_fall")
	is_jump = false


func _on_hit_timer_timeout() -> void:
		set_physics_process(true)
		set_process(true)
		sword_attack_area.monitoring = false
		sword_attack_collision.disabled = true
		attacking = false
		can_attack = true
		hit_timer.stop()
		


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("top"):
		b = true

func display_weapon(weapon_name: String, original_weapon_name: String):
	#sword_sprt.visible = true
	EquipmentDisplayManager.set_weapon_display(weapon_name)
	var dir_path = EquipmentDisplayManager.get_weapon_display()
	weapon_equiped = true
	#sword_sprt = get_node("inventory/Sword_sprt")
	#var weapon_type
	#if SaveLoad.first_slot[original_weapon_name]["weapon_type"]:
		#weapon_type = SaveLoad.first_slot[original_weapon_name]["weapon_type"]

	if sword_sprt and sword_sprt is Sprite2D:
		#print("ini slot 1")
		var new_texture = ResourceLoader.load(dir_path)
		SaveLoad.first_slot["path"] = dir_path
		sword_sprt.texture = new_texture
		sword_sprt.visible = true
		EquipmentDisplayManager.slot_1_full = true
		print(EquipmentDisplayManager.slot_1_full)
		#player_unit.melee_attack += SaveLoad.first_slot[original_weapon_name]["str"]
		var new_amount = SaveLoad.first_slot[original_weapon_name]["str"]
		player_unit.add_damage(new_amount)
		print("kekuatan player sekarang = ", player_unit.melee_attack)
		

func drop_equipment():
	#var slot1_is_null = false
	if SaveLoad.save_data.has("first_slot") and SaveLoad.save_data["first_slot"].size() > 0 or SaveLoad.first_slot.size() > 0:
		#sword_sprt = get_node("inventory/sword_sprt")
		if sword_sprt and sword_sprt is Sprite2D:
			var new_texture = null
			sword_sprt.texture = new_texture
			var weapon_name
			
			if SaveLoad.first_slot.size() > 0:
				weapon_name = SaveLoad.first_slot["weapon_name"]
			elif SaveLoad.save_data["first_slot"].size() > 0:
				weapon_name = SaveLoad.save_data["first_slot"]["weapon_name"]
			print("weapon name : ", weapon_name)
			
			var dir
			if SaveLoad.first_slot.size() > 0:
				dir = SaveLoad.first_slot[weapon_name]["scene_path"]
			elif SaveLoad.save_data["first_slot"].size() > 0:
				dir = SaveLoad.save_data["first_slot"][weapon_name]["scene_path"]
				
			print("weapon_scene_path : ", dir)
			var DROPPED_WEAPON_SCENE_PATH = dir
			 # Muat scene yang ingin ditambahkan
			if dir != null:
				var dropped_weapon_scene = ResourceLoader.load(dir)
				print("packed_scene : ", dropped_weapon_scene)
			 # Buat instance dari scene
				var dropped_weapon_instance = dropped_weapon_scene.instantiate()
				
				if SaveLoad.first_slot.size() > 0:
					dropped_weapon_instance.name = SaveLoad.first_slot["original_string"]
					var weapon_damage = SaveLoad.first_slot[weapon_name]["str"]
					player_unit.reset_damage(weapon_damage)
					print("kekuatan player menjadi : ", player_unit.melee_attack)
					
				elif SaveLoad.save_data["first_slot"].size() > 0:
					dropped_weapon_instance.name = SaveLoad.save_data["first_slot"]["original_string"]
					var weapon_damage = SaveLoad.save_data["first_slot"][weapon_name]["str"]
					player_unit.reset_damage(weapon_damage)
					print("kekuatan player menjadi : ", player_unit.melee_attack)
				
				dropped_weapon_instance.show()
				#Pastikan senjata tidak memiliki parent
				if dropped_weapon_instance.get_parent() != null:
					dropped_weapon_instance.queue_free()
					print("Existing weapon instance removed.")
				var x = self.position.x
				print("posisi player = ", x)
				dropped_weapon_instance.position = Vector2(x, self.position.y)
				print("weapon position", dropped_weapon_instance.position)
				
				EquipmentDisplayManager.slot_1_full = false
				EquipmentManager.slot_1_not_full = true
				
				SaveLoad.first_slot = {}
				SaveLoad.save_data["first_slot"] = {}
				weapon_equiped = false
				 # Tambahkan instance ke scene saat ini
				var current_scene = get_tree().current_scene
				if current_scene:
					print("Adding weapon to scene: ", current_scene.name)
					current_scene.add_child(dropped_weapon_instance)
				else:
					print("Current scene not found.")
		else :
			print("no sword")
	else :
		print("no equipment")

func load_weapon_on_load(dir_path: String, weapon_name: String):
	if sword_sprt and sword_sprt is Sprite2D:
		var new_texture = ResourceLoader.load(dir_path)
		sword_sprt.texture = new_texture
		sword_sprt.visible = true

		var new_amount = SaveLoad.save_data["first_slot"][weapon_name]["str"]
		player_unit.add_damage(new_amount)
		print("kekuatan player sekarang = ", player_unit.melee_attack)

func get_damages():
	return player_unit.get_damage()

## Memberikan Damage ke Enemy dengan Melee weapon
func _on_sword_attack_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurt_box") and area.get_parent().has_method("take_damage"):
		var node = area.get_parent() as Node
		var is_alive = node.is_alive
		print("is_alive musuh ", is_alive)
		if is_alive:
			node.take_damage( player_unit.melee_attack)




func _on_enemy_detection_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_area"):
		print("keluarr_masuk")
		enemy_node = area.get_parent() as Node
	elif area.is_in_group("blind_spot"):
		print("keluarr_masuk_blind")
		enemy_node = null




func _on_enemy_detection_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy_area"):
		print("keluarr")
		enemy_node = null
		attack_list.enemy_positionY = null
		attack_list.enemy_positionX = null
