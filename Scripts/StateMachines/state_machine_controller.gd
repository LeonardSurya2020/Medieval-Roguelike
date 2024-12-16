extends Node
class_name STMController
@export var node_finite_state_machine: NodeFiniteStateMachine
@export var node_attack_phase: NodeState


var is_alive = true

func _physics_process(delta: float) -> void:
	pass

func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if is_alive:
		if body.is_in_group("Player"):
			#print("hello from area2d enemies dengan nama ", get_parent().name)
			node_finite_state_machine.transition_to("attack")


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if is_alive:
		node_finite_state_machine.transition_to("Idle")


func _on_attackphase_body_entered(body: Node2D) -> void:
	if is_alive:
		if body.is_in_group("Player"):
			#print("hello from attackphase area2d")
			node_finite_state_machine.transition_to("attackphase")


func _on_attackphase_body_exited(body: Node2D) -> void:
	if is_alive:
		node_attack_phase.can_attack = true
		node_attack_phase.enemy_attack_hit_box.disabled = true
		node_attack_phase.attack_hit_box.monitoring = false

		node_finite_state_machine.transition_to("attack")
