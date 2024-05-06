class_name Extractor
extends Machine

@export var extractorUI:Control

@onready var animation = $Animation

# Called when the node enters the scene tree for the first time.
func _ready():
	print("test")
	animation.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
