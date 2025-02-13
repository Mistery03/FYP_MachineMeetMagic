extends Node2D

@export var materials:Materials

func _ready():
	var instance = materials.scene.instantiate()
	add_child(instance)

func _on_area_2d_body_entered(body):
	if body.has_method("on_item_picked_up"):
		body.on_item_picked_up(materials)
		queue_free()

