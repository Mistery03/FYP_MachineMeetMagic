extends Control

@export var player:Player
@onready var machine_button = $machineButton
@onready var machine_button1 = $machineButton/machineButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	machine_button.player = player
	machine_button1.player = player
	
	
