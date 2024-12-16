extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not body.climbing:
			body.climbing = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		if body.climbing:
			body.climbing = false
