extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var speed : int = 50
@onready var attack_hit_box: Area2D = $"../../AttackHitBox"
@onready var enemy_attack_hit_box: CollisionShape2D = $"../../AttackHitBox/EnemyAttackHitBox"
@export var animation_player: AnimationPlayer
@export var sprite_2d: Sprite2D
var player: CharacterBody2D
var can_attack = true
const ZERO = 0
@export var collision_shape_2d: CollisionShape2D
@export var attack_interval: Timer

@export var direction_minus_one: float
@export var direction_one: float

var attack_is_start : bool
var radius_awal
func _ready() -> void:
		var shapes = collision_shape_2d.shape
		radius_awal = shapes.radius

func on_process(delta: float):
	pass

func on_physics_process(delta: float):
	var direction : int
	print("can attack = ", can_attack)
	print(player)
	if player:
		#if character_body_2d.global_position > player.global_position:
			#animated_sprite_2d.flip_h = true
			#attack_hit_box.position.x + direction_one
			#direction = -1
		#elif character_body_2d.global_position < player.global_position:
			#animated_sprite_2d.flip_h = false
			#attack_hit_box.position.x + direction_minus_one
			#direction = 1
		if can_attack:
			var attack_chance = randi_range(1,10)
			enemy_attack(attack_chance)
		character_body_2d.move_and_slide()
		character_body_2d.velocity.x = 0

func enter():
	#set_physics_process(true)
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0 and players[0] is CharacterBody2D:
		player = players[0] as CharacterBody2D
		
		print("this is player from attack state", player)
	else:
		print("Player node not found in group 'Player'")

func exit():
	sprite_2d.visible = false
	collision_shape_2d.shape.radius = radius_awal
	#set_physics_process(false)

func enemy_attack(attack_chance : int):
	if attack_chance == 2:
		if collision_shape_2d.shape.radius == radius_awal:
			#memperbesar radius attackphase untuk sementara
			collision_shape_2d.shape.radius = radius_awal + (radius_awal * 20)
			#animated_sprite_2d.play("Charging")
			animation_player.play("Attack")
			can_attack = false
			


#func _on_animated_sprite_2d_animation_finished() -> void:
	#if animated_sprite_2d.animation == "Charging":
		#print("charging selesai")
		#can_attack = false
		#animated_sprite_2d.play("Attack")
		#attack_hit_box.monitoring = true
		#slime_attack_hit_box.disabled = false
		#
	#elif animated_sprite_2d.animation == "Attack":
		#print("attack selesai")
		#can_attack = true
		#attack_hit_box.monitoring = false
		#slime_attack_hit_box.disabled = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		collision_shape_2d.shape.radius = 0
		#attack_is_start = false
		attack_interval.start()
		can_attack = true
		attack_hit_box.monitoring = false
		enemy_attack_hit_box.disabled = true




func _on_attack_interval_timeout() -> void:
	collision_shape_2d.shape.radius = radius_awal
	print("attack interval selesai")
	attack_interval.stop()
