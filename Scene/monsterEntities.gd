extends Node

@export var player:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	for entity in get_children():
		entity.player = player



