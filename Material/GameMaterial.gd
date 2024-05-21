class_name GameMaterial
extends Node2D

@export var itemData:MaterialData
@export var amount:int

@onready var sprite = $Sprite


func _ready():
	sprite.texture = itemData.texture
	amount = itemData.amount

func _on_area_2d_body_entered(body):
	if body is Player:
		body.inventory_manager.insert(self,amount)
		queue_free()
