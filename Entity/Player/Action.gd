extends State

@export var timer:Timer


@export var materialInstance:PackedScene 
@export var max_drop_items: int = 5 
var prevMouseTilePos = Vector2i(-1000,-1000)
var mouseTilePos
var materialDroppedData
var isDropped = false
var materialRes
var clickedPos

func enter() -> void:
	super()
	isDropped = false


func update(delta: float) -> void:
	moveComponent.axis = moveComponent.get_movement_direction()

	if moveComponent.axis:
		timer.stop()
		transitioned.emit("move")
		
	mouseTilePos = parent.levelTilemap.local_to_map(parent.mousePos)
	var parentPos = parent.levelTilemap.local_to_map(parent.position)
	var validLocation = parent.levelTilemap.get_surrounding_cells(mouseTilePos)
	materialDroppedData = parent.levelTilemap.get_cell_tile_data(4,mouseTilePos)

	for validPos in validLocation:
		if parentPos == validPos or parentPos == mouseTilePos:
			if materialDroppedData and parent.isStaffEquipped:
				if Input.is_action_just_pressed("ACTION"):
					parent.text_on_mouse.visible = false
					parent.staff.global_position = parent.levelTilemap.map_to_local(mouseTilePos) 
					parent.staff.customAnimation.play("CUTTING")
					parent.staff.z_index = 5
					timer.start()
					materialRes = materialDroppedData.get_custom_data("materialDropped")
					clickedPos = mouseTilePos
						
						#parent.staff.customAnimation.stop()
						#await parent.staff.customAnimation.animation_finished
	if isDropped:			
		transitioned.emit("idle")



func process_input(event)->void:
	if Input.is_action_just_pressed("EXIT"):
		transitioned.emit("idle")	




	

func dropMaterials()->bool:
	var num_items_to_drop = randi_range(1, max_drop_items)
	for i in range(num_items_to_drop):
		var instance = materialInstance.instantiate()
		instance.itemData = materialRes
		instance.amount = 1
		instance.position = parent.levelTilemap.map_to_local(clickedPos) + Vector2(randi_range(-5, 5), randi_range(-5, 5))  # Randomize position slightly
		instance.z_index = 10
		add_child(instance)
	
	return true	





func _on_timer_timeout():
	timer.stop()
	dropMaterials()
	parent.levelTilemap.erase_cell(4,clickedPos)
	parent.levelTilemap.erase_cell(5,clickedPos)
	isDropped= true
	parent.staff.global_position  = parent.global_position
	parent.staff.z_index = -1
