class_name GameMaterial
extends Node2D

@export var itemData:MaterialData
@export var amount:int

@onready var sprite = $Sprite
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var pickup_sfx = $pickupSFX


func _ready():
	sprite.texture = itemData.texture
	#amount = itemData.amount

func _on_area_2d_body_entered(body):
	if body is Player:
		pickup_sfx.play()
		body.inventory_manager.insert(self,amount)
		visible = false
		await pickup_sfx.finished
		queue_free()
