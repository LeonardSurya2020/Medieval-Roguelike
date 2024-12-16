extends Node2D
class_name Banner

@export var sprite_icon_path: String
@export var weapon_name: String
@onready var sword_sprt: Sprite2D = $sword_sprt
@onready var attack_label: Label = $attack_label
@onready var crit_label: Label = $crit_label
@onready var passive_label: Label = $passive_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var new_texture = ResourceLoader.load(sprite_icon_path)
	#sword_sprt.texture = new_texture
	#var method = "set_"+ weapon_name + "_stats"
	#if EquipmentManager.has_method(method):
		#EquipmentManager.call(method)
		#var attack = EquipmentManager.attack
		#var crit_chance = EquipmentManager.crit_chances
		#var crit_precentages = str(crit_chance * 100) + "%"
		#var crit_damage = EquipmentManager.crit_dmg
		#var crit_damage_precentages = str(crit_damage * 100) + "%"
		#
		#var label_attack_display = "Att : " + str(attack) + "(" + str(crit_damage) + ")"
		#attack_label.text = label_attack_display
		#crit_label.text = "Crit : " + str(crit_precentages)
		#
	#else:
		#print("there's no method called ", weapon_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_banner(name_sprite, path):
	weapon_name = name_sprite
	sprite_icon_path = path

func set_full():
	var new_texture = ResourceLoader.load(sprite_icon_path)
	sword_sprt.texture = new_texture
	var method = "set_"+ weapon_name + "_stats"
	if EquipmentManager.has_method(method):
		EquipmentManager.call(method)
		var attack = EquipmentManager.attack
		var crit_chance = EquipmentManager.crit_chances
		var crit_precentages = str(crit_chance * 100) + "%"
		var crit_damage = EquipmentManager.crit_dmg
		var crit_damage_precentages = str(crit_damage * 100) + "%"
		
		var label_attack_display = "Att : " + str(attack) + "(" + str(crit_damage) + ")"
		attack_label.text = label_attack_display
		crit_label.text = "Crit : " + str(crit_precentages)
		
	else:
		print("there's no method called ", weapon_name)
