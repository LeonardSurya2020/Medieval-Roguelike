extends CharacterBody2D
class_name slime
var max_hp
var defense
var damage
var current_hp
#var player_unit : PlayerUnit
var enemy_unit : EnemyUnit


@export var node_finite_state_machine: NodeFiniteStateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var collision_shape: CollisionShape2D
@onready var health_bar: ProgressBar = $HealthBar
@export var animation_player: AnimationPlayer
@onready var attack_area_2d: Area2D = $AttackArea2D
@onready var attackphase: Area2D = $attackphase
@onready var hurt_box: Area2D = $HurtBox
@onready var attack_hit_box: Area2D = $AttackHitBox
@onready var slime_attack_hit_box: CollisionShape2D = $AttackHitBox/EnemyAttackHitBox
@onready var hurt_box_collision_shape_2d: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var attack_phase_collision_shape_2d: CollisionShape2D = $attackphase/CollisionShape2D
@onready var attack_collision_shape_2d: CollisionShape2D = $AttackArea2D/CollisionShape2D
@onready var top_area: Area2D = $Top_area
@onready var top_area_collision_shape_2d: CollisionShape2D = $Top_area/Top_area_CollisionShape2D
@onready var hit_animation: AnimationPlayer = $Hit_animation

@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var enemys: EnemyUnit
var ignore_collision: bool = false
var collision
var is_alive = true
var node


func _ready() -> void:
	sprite_2d.visible = false
	slime_attack_hit_box.disabled = true
	#Set enemy status berdasarkan jenis/nama enemynya
	GlobalEnemyUnit.slime()
	max_hp = GlobalEnemyUnit.get_max_hp()
	current_hp = max_hp
	defense = GlobalEnemyUnit.get_defense()
	damage = GlobalEnemyUnit.get_damage()
	health_bar.init_health(max_hp)
	print("enemy max hp", GlobalEnemyUnit.get_max_hp())
	
	print("current hp ", current_hp)
	
	
#HURT BOX ENEMY
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if is_alive:
		if area.is_in_group("Attack_area") and area.get_parent().has_method("get_damages"):
			#print("attack area entered at hurtbox")
			node = area.get_parent() as Node
			var damage = node.get_damages()
			print("damage = ", damage)
			take_damage(damage)

#Fungsi untuk memberikan damage pada enemy
func take_damage(damage_amount : float):

	var damage_taken = damage_amount
	print("damage taken = ", damage_taken)
	#Menghitung keseluruhan damage berdasarkan status enemy
	var dmg_overall = damage_taken - defense
	current_hp = current_hp - dmg_overall
	hit_animation.play("hit")
	if current_hp < 0:
		
		#Mematikan fungsi state machine enemy jika mati
		node_finite_state_machine.dead_function()
		current_hp = 0
		dead()
	health_bar.health = current_hp
	print("hp setelah terkena damage ", current_hp)

func dead():
	#queue_free()
	is_alive = false
	timer_2.stop()
	timer.stop()
	#Mengubah collision mask agar tidak bertabrakan dengan collision player
	$".".collision_mask &= ~1
	$".".collision_layer &= ~(1 << 0)
	print("collision mask ", $".".collision_mask)
	# Hapus layer 3
	$".".collision_layer &= ~(1 << 2)  # Menghapus layer 3 (1 << 2 = 4)
	# Aktifkan layer 10
	$".".collision_layer |= (1 << 9)  # Menambahkan layer 10 (1 << 9 = 512)
	
	top_area.collision_layer &= ~(1 << 0)
	top_area.collision_mask &= ~1
	attack_hit_box.collision_layer &= ~(1 << 0)
	attack_hit_box.collision_mask &= ~1
	
	#Mengubah speed dari enemy menjadi 0 sehingga enemy tidak bergerak ketika sudah mati
	velocity.x = 0
	health_bar.queue_free()
	
	#Mematikan semua fungsi Area2D ketika enemy mati
	attack_area_2d.monitoring = false
	attack_hit_box.monitoring = false
	attackphase.monitoring = false
	hurt_box.monitoring = false
	top_area.monitoring = false
	
	slime_attack_hit_box.disabled = true
	hurt_box_collision_shape_2d.disabled = true
	attack_phase_collision_shape_2d.disabled = true
	attack_collision_shape_2d.disabled = true
	top_area_collision_shape_2d.disabled = true
	
	attack_area_2d.queue_free()
	attack_hit_box.queue_free()
	attackphase.queue_free()
	hurt_box.queue_free()
	top_area.queue_free()
	#animated_sprite_2d.play("Idle")
	animation_player.play("Death")
	


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if is_alive == true:
		if body.is_in_group("Player"):
			#print("ini hurbox via body player")
			timer.start()


func _on_timer_timeout() -> void:
	$".".collision_mask &= ~1
	$".".collision_layer &= ~(1 << 0)
	#print("timer 1 timeout")
	timer_2.start()
	timer.stop()
	
func _on_hurt_box_body_exited(body: Node2D) -> void:
	pass

func _on_timer_2_timeout() -> void:
	$".".collision_layer |= (1 << 0)
	$".".collision_mask |= (1 << 0)
	#print("timer 2 timeout")
	timer_2.stop()
