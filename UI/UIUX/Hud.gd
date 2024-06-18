class_name CharacterSheet
extends Control

@onready var hp_progress_bar = %HPProgressBar
@onready var mana_progress_bar = $ManaProgressBar
@onready var stamina_progress_bar = $StaminaProgressBar
@export var player : Player
@onready var character_sheet = $CharacterSheet 


# Called when the node enters the scene tree for the first time.
func _ready():
	hp_progress_bar.init(player)
	mana_progress_bar.init(player)
	stamina_progress_bar.init(player)
	set_process(false)
	pass
	 # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

	



