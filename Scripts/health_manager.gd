extends Node

var max_hp : float = 100
var current_hp : float

var player_unit : PlayerUnit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_unit = PlayerUnit.new()
	max_hp = player_unit.hp
	current_hp = max_hp

func decrease_health(health_amount : float):
	current_hp -= health_amount
	if current_hp < 0:
		current_hp = 0
	print("decrease_health called")

func increase_health(health_amount: float):
	current_hp += health_amount
	
	if current_hp > max_hp:
		current_hp = max_hp
	
