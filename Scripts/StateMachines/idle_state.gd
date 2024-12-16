extends NodeState

@export var character_body_2d: CharacterBody2D
#@export var animated_sprite_2d: AnimatedSprite2D
@export var slow_down_speed: int = 1000
@export var animation_player: AnimationPlayer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_process(delta: float):
	pass

func on_physics_process(delta: float):
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed * delta)
	character_body_2d.velocity.x = 0
	#animated_sprite_2d.play("Idle")
	animation_player.play("Idle")
	character_body_2d.move_and_slide()

func enter():
	pass

func exit():
	pass
