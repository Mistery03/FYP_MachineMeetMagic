class_name CharacterSheet
extends Control

@export var player : Player

@export var hp_progress_bar:Control
@onready var mana_progress_bar = $ManaProgressBar
@onready var stamina_progress_bar = $StaminaProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	hp_progress_bar.init(player,player.playerData.MaxHealth,player.currHealth)
	mana_progress_bar.init(player)
	stamina_progress_bar.init(player)







