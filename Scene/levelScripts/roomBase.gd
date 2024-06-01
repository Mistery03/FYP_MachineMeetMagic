class_name Room
extends Node2D

@export_category("Room Settings")
@export var PK_roomID:int = 128
@export var roomID:int
@export var roomNum:int = 0
@export_category("Player")
@export var player:Player

func setPlayer(player:Player):
	self.player = player

func spawnObjects():
	pass
	
func spawnEnemies():
	pass

func spawnBoss():
	pass

func placePlayer():
	pass
