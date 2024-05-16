class_name CharacterSheet
extends Control

@onready var hp_progress_bar = %HPProgressBar
@onready var mana_progress_bar = $ManaProgressBar
@export var player : Player
@onready var character_sheet = $CharacterSheet 


# Called when the node enters the scene tree for the first time.
func _ready():
	hp_progress_bar.update(player)
	mana_progress_bar.update(player)
	print(self.player)
	set_process(false)
	pass
	 # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_bag_pressed() -> void:
	character_sheet.visible = true
	



