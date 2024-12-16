extends Node2D
class_name AttackList
@onready var muzzle: Marker2D = $"../muzzle"

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@export var player : CharacterBody2D
#@export var muzzle : Marker2D

var enemy_positionY
var enemy_positionX
var arrow = preload("res://Scenes/range_weapons/arrow.tscn")
var fireball = preload("res://Scenes/magic_weapons/fire_ball.tscn")


var projectile_type
#var muzzle_position
var animation_playing = false
var time_to_check
func _ready() -> void:
	pass
	#muzzle_position = muzzle.position

func _physics_process(delta: float) -> void:
	#print("muzzle_position ", muzzle.global_position)
	#print("p pos ", enemy_position)
	if animation_playing :
		var current_time = animation_player.current_animation_position
		if current_time >= time_to_check:
			match projectile_type:
				"arrow":
					spawn_arrow()
				"fireBall":
					spawn_fireBall()
			animation_playing = false  # Matikan pemeriksaan setelah mencapai waktu yang diinginkan

func bow():
	
	
	player.can_attack = false
	player.attacking = true
	animation_player.play("Bow_attack")
	projectile_type = "arrow"
	time_to_check = 0.3667
	animation_playing = true
	

func spawn_arrow():
	
	# mengatur posisi muzzle
	muzzle.position.x = player.position.x
	#muzzle.position.x = player.position.x + 50
	muzzle.position.y = player.position.y - 10
	
	if player.animated_sprite.flip_h == true:
		muzzle.position.x = player.position.x - 50
		
	#membuat instance bow
	var arrow_instance = arrow.instantiate() as CharacterBody2D
	arrow_instance.global_position = muzzle.position
	
	if player.animated_sprite.flip_h == true:
		arrow_instance.direction = -1
	else:
		arrow_instance.direction = 1
		print("arrow : ",  arrow_instance.global_position)
		
	if enemy_positionY != null and enemy_positionX != null:
		arrow_instance.enemy_position_y = enemy_positionY
		arrow_instance.enemy_position_x = enemy_positionX
		print("arrow_enemy " , arrow_instance.enemy_position_y)
	# menambahkan instance bow ke scene
	var current_scene = get_tree().current_scene
	current_scene.add_child(arrow_instance)

func sword():
	player.jump_fall_floor = true
	player.is_jump = false
	player.jump_attack = true
	player.animation_player.stop()
	player.timer.stop()
	attack_animation()
	player.attacking = true
	player.combo_timer.start()



func magic():
	player.can_attack = false
	player.attacking = true
	animation_player.play("Magic_attack")
	projectile_type = "fireBall"
	time_to_check = 0.2333
	animation_playing = true

func spawn_fireBall():
	# mengatur posisi muzzle
	muzzle.position.x = player.position.x
	#muzzle.position.x = player.position.x + 50
	muzzle.position.y = player.position.y - 10
	
	if player.animated_sprite.flip_h == true:
		muzzle.position.x = player.position.x - 50
		
	#membuat instance bow
	var fireball_instance = fireball.instantiate() as CharacterBody2D
	
	fireball_instance.global_position = muzzle.position
	
	if player.animated_sprite.flip_h == true:
		fireball_instance.direction = -1
	else:
		fireball_instance.direction = 1
		print("arrow : ",  fireball_instance.global_position)
	# menambahkan instance bow ke scene
	var current_scene = get_tree().current_scene
	current_scene.add_child(fireball_instance)


func attack_animation():
	match  player.attack_index:
		0:
			animation_player.play("Attack_phase_1")
			player.sword_attack_area.monitoring = true
			player.sword_sprt.visible = false
			player.velocity.x = player.direction * player.SPEED * 0
		1:
			animation_player.play("Attack_phase_2")
			player.sword_attack_area.monitoring = true
			player.sword_sprt.visible = false
			player.velocity.x = player.direction * player.SPEED * 0
		2:
			animation_player.play("Attack_phase_3")
			player.sword_attack_area.monitoring = true
			player.sword_sprt.visible = false
			player.can_attack = false
			player.velocity.x = player.direction * player.SPEED * 0
			
	player.attack_index = (player.attack_index + 1) % player.max_combo

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bow_attack":
		player.attacking = false
		player.can_attack = true
		player.jump_attack = false
		player.jump_fall_floor = false
		
	elif anim_name == "Magic_attack":
		player.attacking = false
		player.can_attack = true
		player.jump_attack = false
		player.jump_fall_floor = false
		
	elif anim_name == "Attack_phase_1":
		player.sword_attack_area.monitoring = false
		player.sword_attack_collision.disabled = true
		player.sword_sprt.visible = true
		player.attacking = false
		player.can_attack = true
		player.jump_attack = false
		player.jump_fall_floor = false
		
	elif anim_name == "Attack_phase_2":
		player.sword_attack_area.monitoring = false
		player.sword_attack_collision.disabled = true
		player.sword_sprt.visible = true
		player.attacking = false
		player.can_attack = true
		player.jump_attack = false
		player.jump_fall_floor = false
		
	elif anim_name == "Attack_phase_3":
		player.sword_attack_area.monitoring = false
		player.sword_attack_collision.disabled = true
		player.sword_sprt.visible = true
		player.attacking = false
		player.jump_attack = false
		player.can_attack = true
		player.jump_fall_floor = false
