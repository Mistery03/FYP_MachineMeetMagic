extends Node2D

@export var creatureManager:CreatureManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await get_tree().create_timer(3).timeout
	if creatureManager.getCreatureList().size() <= 0:
		queue_free()
