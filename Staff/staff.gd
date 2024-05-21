class_name Staff
extends Node2D

@export var originalPos:Vector2 = Vector2(10,0)
@export var customAnimation:AnimationPlayer
@onready var animation = $Animation

var isEquipped:bool
var mousePos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#position = originalPos
	#customAnimation.play("RESET")



