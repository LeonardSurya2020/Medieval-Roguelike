extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var attack_hit_box : CollisionShape2D
@export var speed : int = 50
@export var animation_player: AnimationPlayer


var player: CharacterBody2D
@export var direction_minus_one: float
@export var direction_one: float

func on_process(delta: float):
	pass

func on_physics_process(delta: float):
	var direction : int
	print(player)
	if player:
		if character_body_2d.global_position > player.global_position:
			animated_sprite_2d.flip_h = true
			attack_hit_box.position.x = direction_minus_one
			direction = -1
			
		elif character_body_2d.global_position < player.global_position:
			animated_sprite_2d.flip_h = false
			attack_hit_box.position.x = direction_one
			direction = 1
		else :
			character_body_2d.velocity.x = clamp(0, -speed, speed)
		#animated_sprite_2d.play("Jump")
		animation_player.play("Run")
		attack_hit_box.disabled = true
		character_body_2d.velocity.x = direction * speed
		character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -speed, speed)
		character_body_2d.move_and_slide()
	else :
		print("berhenti")
		character_body_2d.velocity.x = clamp(0, -speed, speed)

func enter():
	#set_physics_process(true)
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0 and players[0] is CharacterBody2D:
		player = players[0] as CharacterBody2D
		print("this is player from attack state", player)
	else:
		print("Player node not found in group 'Player'")

func exit():
	pass
	#player = null
	#set_physics_process(false)
