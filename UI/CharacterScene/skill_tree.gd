extends Control

@export var player:Player
@onready var skill_button = $skillButton
@onready var skill_button1 = $skillButton/skillButton
@onready var skill_button2 = $skillButton/skillButton/skillButton




# Called when the node enters the scene tree for the first time.
func _ready():
	#et_child(4).player = player
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	skill_button.player = player
	skill_button1.player = player
	skill_button2.player = player
	pass
