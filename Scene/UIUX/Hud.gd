class_name CharacterSheet
extends CanvasLayer

@onready var hp_progress_bar = %HPProgressBar
@onready var mana_progress_bar = $ManaProgressBar
@onready var player = $"../Player"
@onready var bag_btn = $BagBtn 
@onready var character_sheet = $CharacterSheet 


# Called when the node enters the scene tree for the first time.
func _ready():
	hp_progress_bar.update(player)
	mana_progress_bar.update(player)
	print(self.player)
	handle_connecting_signal()
	set_process(false)
	pass
	 # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_bag_pressed() -> void:
	character_sheet.visible = true
	
func handle_connecting_signal() -> void:
	bag_btn.button_down.connect(on_bag_pressed)
