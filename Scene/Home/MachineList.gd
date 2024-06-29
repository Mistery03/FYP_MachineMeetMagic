extends Node

var player:Player
var count =0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if get_child_count() <= 0:
		return
	for machine in get_children():
		machine.player = player
		
func spawnMachine(player:Player):
	for machine in player.machineSave.machine_list:
		var machineIntance = machine.machineInstance.instantiate()
		machineIntance.global_position = machine.machineGlobalPos
		add_child(machineIntance)
