extends Node

var weapon_equip
var is_taken
var slot_1_not_full: bool = true
var slot_2_not_full: bool = true
var weapon_type: String
var attack
var crit_chances
var crit_dmg

func dull_sword():
	if is_taken && weapon_equip:

		if slot_1_not_full == true:
			SaveLoad.first_slot["weapon_name"] = "dull_sword"
			SaveLoad.first_slot["is_full"] = true
			SaveLoad.first_slot["dull_sword"] = {
				"name": "dull_sword",
				"str" : 5,
				"scene_path": "res://Scenes/melee_weapons/dull_sword.tscn",
				"is_taken": true,
				"weapon_type": "sword"
			}
			slot_1_not_full = false
			print("slot_1_full in equip manager : ", slot_1_not_full)
			print("Slo_1 is full")
			print("data insert: ", SaveLoad.first_slot)
			#
		#elif slot_2_not_full == true:
			#SaveLoad.second_slot["weapon_name"] = "dull_sword2"
			#SaveLoad.second_slot["is_full"] = true
			#SaveLoad.second_slot["dull_sword2"] = {
				#"name": "dull_sword",
				#"str" : 5,
				#"scene_path": "res://scenes/dull_sword.tscn",
				#"is_taken": true
			#}
			#slot_2_not_full = false
			#print("Slo_2 is full")
			#print("data insert: ", SaveLoad.second_slot)
	else:
		print("Slot is full")
		
func novice_bow():
	if is_taken && weapon_equip:

		if slot_1_not_full == true:
			SaveLoad.first_slot["weapon_name"] = "novice_bow"
			SaveLoad.first_slot["is_full"] = true
			SaveLoad.first_slot["novice_bow"] = {
				"name": "novice_bow",
				"str" : 4,
				"scene_path": "res://Scenes/range_weapons/novice_bow.tscn",
				"is_taken": true,
				"weapon_type": "bow"
			}
			slot_1_not_full = false
			print("slot_1_full in equip manager : ", slot_1_not_full)
			print("Slo_1 is full")
			print("data insert: ", SaveLoad.first_slot)
		else :
			print("slot is full")

func fireBall_spellbook():
	if is_taken && weapon_equip:
		if slot_1_not_full == true:
			SaveLoad.first_slot["weapon_name"] = "fireBall_spellbook"
			SaveLoad.first_slot["is_full"] = true
			SaveLoad.first_slot["fireBall_spellbook"] = {
				"name": "fireBall_spellbook",
				"str" : 4,
				"scene_path": "res://Scenes/magic_weapons/fireBall_spellbook.tscn",
				"is_taken": true,
				"weapon_type": "magic"
			}
			slot_1_not_full = false
			print("slot_1_full in equip manager : ", slot_1_not_full)
			print("Slo_1 is full")
			print("data insert: ", SaveLoad.first_slot)
		else :
			print("slot is full")


func set_dull_sword_stats():
	var att = 5
	var crit_damage = 2 * att
	var crit_chance = 0.2
	
	attack = att
	crit_dmg = crit_damage
	crit_chances = crit_chance

func set_novice_bow_stats():
	var att = 4
	var crit_damage = 2 * att
	var crit_chance = 0.2
	
	attack = att
	crit_dmg = crit_damage
	crit_chances = crit_chance

func set_fireBall_spellbook_stats():
	var att = 4
	var crit_damage = 2 * att
	var crit_chance = 0.2
	
	attack = att
	crit_dmg = crit_damage
	crit_chances = crit_chance
