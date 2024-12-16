extends Area2D

@onready var e_button: Sprite2D = $EButton
@onready var bubble_text: Sprite2D = $BubbleText
@onready var bubble_text_label: Label = $BubbleText/bubbleTextLabel

var npc_area: bool = false
var current_char = 0
var visible_speed = 0.05
var animating = false
var npc_name
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	npc_name = self.name
	bubble_text_label.visible_characters = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if npc_area == true:
		if Input.is_action_just_pressed("interact") and not animating:
			 # get npc name
			if GlobalNpcInteraction.has_method(self.name):
				var npc_dialog = GlobalNpcInteraction.call(npc_name) #get random text from GlobalNPCInteract Singleton
				print("this is dialog from npc_interact script" , npc_dialog)
				bubble_text_label.text = npc_dialog
				
				start_text_animation() #starting text animation
				print("hello")
				bubble_text.visible = true
				e_button.visible = false
			else:
				return
	
	if animating:
		if current_char < bubble_text_label.text.length():
			current_char += visible_speed
			bubble_text_label.visible_characters = int(current_char)
		else:
			animating = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		e_button.visible = true
		print("Welcome Choosen one")
		npc_area = true


func _on_body_dwarf_entered(body: Node2D) -> void:
		if body is Player and npc_name == "Dwarf":
			e_button.visible = true
			print("Welcome Choosen one")
			npc_area = true


func start_text_animation():
	current_char= 0
	bubble_text_label.visible_characters = 0
	animating = true

func _on_body_exited(body: Node2D) -> void:
	e_button.visible = false
	bubble_text.visible = false
	npc_area = false
	bubble_text_label.visible_ratio = 0
