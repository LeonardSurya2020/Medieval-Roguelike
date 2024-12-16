extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var e_button: Sprite2D = $EButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		e_button.visible = true
		print("Welcome Choosen one")




func _on_body_exited(body: Node2D) -> void:
	e_button.visible = false
