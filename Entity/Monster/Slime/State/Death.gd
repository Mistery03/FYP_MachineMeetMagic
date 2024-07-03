extends State

@export_category("Material Setting")
@export var materialInstance:PackedScene
@export var max_drop_items: int = 5
@export var fuelData:MaterialData


func enter() -> void:
	super()
	parent.bossDied = true
	await animations.animation_finished
	dropMaterials()
	parent.queue_free()

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func dropMaterials()->bool:
	var num_items_to_drop = randi_range(1, max_drop_items)
	for i in range(num_items_to_drop):
		var instance = materialInstance.instantiate()
		instance.itemData = fuelData
		instance.amount = 1
		instance.global_position = parent.global_position + Vector2(randi_range(-5, 5), randi_range(-5, 5))  # Randomize position slightly
		instance.z_index = 10
		parent.localLevel.add_child(instance)
		print("Mat pos",instance.global_position)

	return true
