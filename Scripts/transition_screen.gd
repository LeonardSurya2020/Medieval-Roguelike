extends CanvasLayer
class_name  transition_screen
@export var color_rect: ColorRect
@export var animation_player: AnimationPlayer

signal on_transition_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = false
	
func transition_black():
	color_rect.visible = true
	animation_player.play("fade_to_black")

func transition_normal():
	color_rect.visible = true
	animation_player.play("fade_to_normal")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black":
		animation_player.play("fade_to_normal")
		on_transition_finished.emit()
	elif anim_name == "fade_to_normal":
		on_transition_finished.emit()
		color_rect.visible = false
