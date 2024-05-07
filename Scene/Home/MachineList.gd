extends Node

var player:Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if get_child_count() <= 0:
		return
	
	for machine in get_children():
		machine.player = player
