extends CharacterBody2D

var speed : int = 35000
var direction : int
var grav = 10

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var timeout = false
var weapon_from = "bow"
var damage
var player

func _ready() -> void:
	var current_scene = get_tree().current_scene
	print("current scene = ", current_scene)
	player = current_scene.get_node("Player")


func _physics_process(delta: float) -> void:
	print("player : ", player)
	
	if is_on_ground():
		queue_free()
	else :
		if direction == -1:
			
			animated_sprite_2d.flip_h = false
		else :
			animated_sprite_2d.flip_h = false
		#move_local_x(direction * speed * delta)
		
		velocity.x = direction * speed * delta
		
		if timeout == true:
				velocity.y += 2 * grav
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
