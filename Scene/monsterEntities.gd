class_name CreatureManager
extends Node

@export var player:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	for entity in get_children():
		entity.player = player
		
func init(player):
	for entity in get_children():
		entity.player = player

