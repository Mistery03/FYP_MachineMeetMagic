extends Node

@export var save:HomeSaveData
# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		node.material_holder = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(save.collected)
	for node in get_children():
		if save.collected.size() > 0:
			for index in len(save.collected):
				if save.collected[index]== "T"+str(index):
					node.queue_free()
