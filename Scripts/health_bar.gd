extends ProgressBar

@export var damage_bar: ProgressBar
@onready var timer: Timer = $Timer

var health = 0 : set = _set_health
# Called when the node enters the scene tree for the first time.

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health < prev_health:
		timer.start()
	else :
		damage_bar.value = health

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health


func _on_timer_timeout() -> void:
	damage_bar.value = health
