extends CharacterBody2D

var speed : int = 35000
var direction : int
var grav = 10

var enemy_position_y
var enemy_position_x
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var timer: Timer
var timeout = false
var weapon_from = "bow"
var damage
var player
var a
var direction_ys
var direction_xs
var can_bend = true
# NOTE : PAKE TIMER UNTUK APPLY GRAVITY

func _ready() -> void:
	a = true
	print("enemy pospos ", enemy_position_y)
	print("enemy posposs ", enemy_position_x)
	var current_scene = get_tree().current_scene
	print("current scene = ", current_scene)
	player = current_scene.get_node("Player")
	
	if enemy_position_x != null and enemy_position_y != null:
		direction_ys = enemy_position_y - position.y
		direction_xs = enemy_position_x - position.x
	#if enemy_position_y != position.y:
		#rotate_to_target_y()
	
	#player = get_tree().current_scene.get_node("Player")
	#if SaveLoad.first_slot.size() > 0:
		#var weapon_name = SaveLoad.first_slot["weapon_name"]
		#var weapon_type = SaveLoad.first_slot[weapon_name]["weapon_type"]
		#if weapon_type == weapon_from:
			#var dmg = SaveLoad.first_slot[weapon_name]["str"]
			#damage = dmg
			#
	#elif SaveLoad.save_data.has("first_slot") and SaveLoad.save_data["first_slot"].size() > 0:
		#var weapon_name = SaveLoad.save_data["first_slot"]["weapon_name"]
		#var weapon_type = SaveLoad.save_data["first_slot"][weapon_name]["weapon_type"]
		#if weapon_type == weapon_from:
			#var dmg = SaveLoad.save_data["first_slot"][weapon_name]["str"]
			#damage = dmg
		


func _physics_process(delta: float) -> void:
	if is_on_ground():
		queue_free()
	else :
		if direction == -1:
			sprite_2d.flip_h = false
			print("kondisi ", sprite_2d.flip_h)
		else :
			sprite_2d.flip_h = false
		if enemy_position_y != null && enemy_position_x != null:
			var distance = Vector2(direction_xs, direction_ys).length()
			print("distance ", distance)
			var enemy_position = Vector2(enemy_position_x, enemy_position_y)
			print("player_position x ", player.position.x)
			print("player_position x enemy ", enemy_position.x)
			
			var y_distance = int(player.position.x) - int(enemy_position.x)
			
			if y_distance > 0 and y_distance < 11 or y_distance < -10 and y_distance < 0:
				if int(player.position.x) > int(enemy_position.x) or  int(player.position.x) < int(enemy_position.x):
						
					if enemy_position_y < position.y and direction == 1 and enemy_position_x > position.x:
						# Hitung arah berdasarkan sumbu Y saja
						var direction_y = sign(enemy_position_y - position.y)
						var direction_x = sign(enemy_position_x - position.x)
						
						var d = Vector2(direction_xs, direction_ys).normalized()
						
						velocity = d * 400
						# Gerakkan panah hanya di sumbu Y
						#position.x = direction_ys * delta
						#position.y = direction_xs * delta
						#velocity.y = direction_ys * 80 * delta
						#velocity.x = direction * 100 * delta
					elif enemy_position_y < position.y and direction == -1 and enemy_position_x < position.x:
						# Hitung arah berdasarkan sumbu Y saja
						var direction_y = sign(enemy_position_y - position.y)
						var direction_x = sign(enemy_position_x - position.x)
						
						var d = Vector2(direction_xs, direction_ys).normalized()
						
						velocity = d * 400
						# Gerakkan panah hanya di sumbu Y
						#position.x = direction_ys * delta
						#position.y = direction_xs * delta
						#velocity.y = direction_ys * 80 * delta
						#velocity.x = direction * 100 * delta
					
					elif enemy_position_y >= position.y and direction == 1 and enemy_position_x > position.x:
						# Hitung arah berdasarkan sumbu Y saja
						var direction_y = sign(enemy_position_y - position.y)
						var direction_x = sign(enemy_position_x - position.x)
						
						var d = Vector2(direction_xs, direction_ys).normalized()
						
						velocity = d * 400
						# Gerakkan panah hanya di sumbu Y
						#position.x = direction_ys * delta
						#position.y = direction_xs * delta
						#velocity.y = direction_ys * 80 * delta
						#velocity.x = direction * 100 * delta
					elif enemy_position_y >= position.y and direction == -1 and enemy_position_x < position.x:
						# Hitung arah berdasarkan sumbu Y saja
						var direction_y = sign(enemy_position_y - position.y)
						var direction_x = sign(enemy_position_x - position.x)
						
						var d = Vector2(direction_xs, direction_ys).normalized()
						
						velocity = d * 400
						# Gerakkan panah hanya di sumbu Y
						#position.x = direction_ys * delta
						#position.y = direction_xs * delta
						#velocity.y = direction_ys * 80 * delta
						#velocity.x = direction * 100 * delta
					else:
						velocity.x = direction * speed * delta
				else:
					velocity.x = direction * speed * delta
					
			else:
				velocity.x = direction * speed * delta
		else:
			velocity.x = direction * speed * delta
			
			if timeout == true:
				velocity.y += 2 * grav
			#velocity = Vector2(direction_x * speed , direction_y * 6000) * delta

		
		rotation = velocity.angle()
		
		move_and_slide()

func _on_timer_timeout() -> void:
	print("timeout")
	timeout = true
	timer.stop()
	
func get_damages():
	var damage = player.get_damages()
	return damage

func is_on_ground():
	var raycast = $RayCast2D
	return raycast.is_colliding()and raycast.get_collider().is_in_group("ground")

func is_hit_enemy():
	var raycast = $RayCast2D
	return raycast.is_colliding()and raycast.get_collider().is_in_group("Enemy")
func rotate_to_target_y():
	if enemy_position_y != null:
		if enemy_position_y > position.y:
			rotation = deg_to_rad(20)  # Mengarah ke bawah
		else:
			rotation = deg_to_rad(-20)  # Mengarah ke atas

func on_hit():
	var hit = true
	return hit
