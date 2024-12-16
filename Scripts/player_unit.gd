extends Node
class_name PlayerUnit

#handle player status
var hp: float = 100
var melee_attack:float = 5
var defend:float = 10
var range_attack:float = 3
var magic_attack:float = 3

var total_damage: float
var player : Player

var bonus_melee_attack : float = 0
var bonus_range_attack : float = 0
var bonus_magic_attack : float = 0

var skill_damage: float

func _ready() -> void:
	SaveLoad.player_data["bonus_damage"] = {
		"melee_attack" : bonus_melee_attack,
		"range_attack" : bonus_range_attack,
		"magic_attack" : bonus_magic_attack
	}

func add_damage(amount:float):
	
	melee_attack += amount
	total_damage = melee_attack
	print("totalnya ", total_damage)
	
func get_damage():
	return melee_attack

func deal_damage():
	print("ini fungsi untuk memberikan damage ke musuh")

func add_bonus_damage(weapon_name : String, base_dmg_increase : float):
	if SaveLoad.first_slot.size() > 0:
		var weapon_type = SaveLoad.first_slot[weapon_name]["weapon_type"]
		
		if weapon_type == "sword":
			bonus_melee_attack += base_dmg_increase
			SaveLoad.player_data["bonus_damage"] = {
				"melee_attack" : bonus_melee_attack,
				"range_attack" : bonus_range_attack,
				"magic_attack" : bonus_magic_attack
			}

func special_skill():
	pass

func special_skill_damage(weapon_type : String, damage_amount: float):
	if weapon_type == "courage":
		skill_damage += damage_amount
		melee_attack += skill_damage
		return melee_attack
	elif weapon_type == "melee_magic":
		skill_damage += damage_amount
		melee_attack += skill_damage
		return melee_attack
	elif weapon_type == "magic":
		skill_damage += damage_amount
		magic_attack += skill_damage
		return magic_attack
	elif weapon_type == "courage":
		skill_damage += damage_amount
		range_attack += skill_damage
		return range_attack
	
func reset_skill_damage():
	melee_attack -= skill_damage

#func get_damage():
	#print("ini fungsi jika terkena damage")

func reset_damage(amount : float):
	melee_attack -= amount
	
func death():
	player.is_alive = false
