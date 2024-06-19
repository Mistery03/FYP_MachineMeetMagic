class_name CharacterSheet
extends Control

@onready var hp_progress_bar = %HPProgressBar
@onready var mana_progress_bar = $ManaProgressBar
@onready var stamina_progress_bar = $StaminaProgressBar
@export var player : Player



# Called when the node enters the scene tree for the first time.
func _ready():
	hp_progress_bar.init(player)
	mana_progress_bar.init(player)
	stamina_progress_bar.init(player)
	 # Replace with function body.



	



