extends Control

@export var actionInput:String
@export var texture:Texture2D
@export var player:Player

@onready var texture_rect = $border/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = texture



	
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_action_pressed(actionInput.to_upper()) and !texture_rect.visible:
			texture_rect.visible = true
			player.isStaffEquipped = true
		elif event.is_action_pressed(actionInput.to_upper()) and texture_rect.visible:
			texture_rect.visible = false
			player.isStaffEquipped = false
