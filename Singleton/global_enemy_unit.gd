extends Node

var enemy_max_hp: float = 0
var enemy_attack_damage: float = 0
var enemy_attack_defend: float = 0
var critical_damage: float = 0
var enemy_current_hp: float = 0

var max_hp
var current_hp
var attack
var defend
var crit

func slime():
	enemy_max_hp= 30
	enemy_attack_damage= 5
	enemy_attack_defend = 2
	critical_damage= 1
	enemy_current_hp = enemy_max_hp
	
	max_hp = enemy_max_hp
	current_hp = enemy_current_hp
	attack = enemy_attack_damage
	defend = enemy_attack_defend
	crit = critical_damage

func black_canine():
	enemy_max_hp= 80
	enemy_attack_damage= 6
	enemy_attack_defend = 4
	critical_damage= 2
	enemy_current_hp = enemy_max_hp
	
	max_hp = enemy_max_hp
	current_hp = enemy_current_hp
	attack = enemy_attack_damage
	defend = enemy_attack_defend
	crit = critical_damage
	
func get_max_hp():
	return max_hp
	
func get_current_hp():
	return current_hp

func get_damage():
	return attack

func get_defense():
	return defend

func get_crit():
	return crit
